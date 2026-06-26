/* Trucking company NUI */

const RES = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'trucking';
const IN_GAME = typeof GetParentResourceName === 'function';

const state = {
    data: null,
    tab: 'overview',
    contractsView: 'standard',
    timeOffset: 0,
    locale: {},        // active language table, sent by the client on open
};

const $ = (sel) => document.querySelector(sel);
const el = (html) => {
    const t = document.createElement('template');
    t.innerHTML = html.trim();
    return t.content.firstChild;
};

const LOGO_SVG = '<svg viewBox="0 0 24 24"><rect x="1" y="3" width="15" height="13" rx="1"/><path d="M16 8h4l3 3v5h-7V8z"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/></svg>';

/* ── helpers ─────────────────────────────────────────────────── */

const money = (n) => '$' + Math.floor(n ?? 0).toLocaleString('en-US');
const num = (n) => Math.floor(n ?? 0).toLocaleString('en-US');
const esc = (s) => String(s ?? '').replace(/[&<>"']/g, (c) =>
    ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));

/* ── i18n ────────────────────────────────────────────────────────
   t('ui.nav.fleet', 'Fleet', ...args) — looks the key up in the active
   language table sent by the client; falls back to the inline English
   default (so browser preview and any untranslated key still read right).
   {1}, {2}, ... are filled by the extra args, same syntax as Lua's L(). */
function t(key, def, ...args) {
    let s = key.split('.').reduce((o, k) => (o == null ? undefined : o[k]), state.locale);
    if (typeof s !== 'string') s = def != null ? def : key;
    if (args.length) s = s.replace(/\{(\d+)\}/g, (_, i) => (args[i - 1] != null ? args[i - 1] : `{${i}}`));
    return s;
}

/* Apply translations to the static markup in index.html. Elements carry
   data-i18n="key" (textContent) or data-i18n-ph="key" (placeholder); the
   existing English text/placeholder is used as the fallback default. */
function applyI18n(root = document) {
    root.querySelectorAll('[data-i18n]').forEach((el) => {
        el.textContent = t(el.dataset.i18n, el.textContent.trim());
    });
    root.querySelectorAll('[data-i18n-ph]').forEach((el) => {
        el.placeholder = t(el.dataset.i18nPh, el.placeholder);
    });
}

function post(action, args = []) {
    if (!IN_GAME) return Promise.resolve(mockAction(action, args));
    return fetch(`https://${RES}/${action}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ args }),
    }).then((r) => r.json()).catch(() => ({}));
}

function toast(msg, type = 'info') {
    const t = el(`<div class="toast ${type}">${esc(msg)}</div>`);
    $('#toast-root').appendChild(t);
    setTimeout(() => t.remove(), 4200);
}

/* Most server callbacks return either {error} or a full payload. */
function handleResult(res) {
    if (!res) return false;
    if (res.error) { toast(res.error, 'error'); return false; }
    if (res.company) { state.data = res; syncTimeOffset(); renderAll(); }
    return true;
}

function syncTimeOffset() {
    if (state.data?.serverTime) {
        state.timeOffset = state.data.serverTime - Math.floor(Date.now() / 1000);
    }
}

/* ── crew permissions ────────────────────────────────────────── */

function isOwner() {
    return (state.data?.viewer?.role ?? 'owner') === 'owner';
}

function can(perm) {
    const v = state.data?.viewer;
    if (!v || v.role === 'owner') return true;
    return v.perms?.[perm] === true;
}

/* disabled-button attributes + tooltip for a missing permission */
function permGate(perm) {
    return can(perm) ? '' : 'disabled title="You don\'t have this permission"';
}

function serverNow() {
    return Math.floor(Date.now() / 1000) + state.timeOffset;
}

function closeUI() {
    $('#app').classList.add('hidden');
    post('close');
}

/* ── NUI lifecycle ───────────────────────────────────────────── */

window.addEventListener('message', (e) => {
    const { action, data, locale } = e.data || {};
    if (locale) { state.locale = locale; applyI18n(); }
    if (action === 'open') {
        state.data = data;
        syncTimeOffset();
        $('#app').classList.remove('hidden');
        $('#admin-screen').classList.add('hidden');
        applyI18n();
        if (data.needsCompany) {
            $('#create-screen').classList.remove('hidden');
            $('#main').classList.add('hidden');
            $('#create-cost').textContent = money(data.creationCost);
        } else {
            $('#create-screen').classList.add('hidden');
            $('#main').classList.remove('hidden');
            renderAll();
        }
    } else if (action === 'update') {
        if (data && data.company) { state.data = data; syncTimeOffset(); renderAll(); }
    } else if (action === 'openAdmin') {
        state.admin = { data, view: data.canLoc ? 'locations' : 'companies', placed: null };
        showAdminScreen();
    } else if (action === 'locPlaced') {
        if (!state.admin) state.admin = { data: { canLoc: true, regions: ['city', 'county', 'state', 'premium'] }, view: 'locations' };
        state.admin.placed = data;
        state.admin.view = 'form';
        state.admin.formRegion = state.admin.formRegion || 'city';
        showAdminScreen();
    } else if (action === 'locPlaceCancelled') {
        // cancelling a re-place while editing keeps you in the form (with the
        // existing coords); a cancelled new placement returns to the list
        if (state.admin) state.admin.view = state.admin.editing ? 'form' : 'locations';
        showAdminScreen();
    } else if (action === 'placePreview') {
        $('#app').classList.add('hidden');
        $('#place-overlay').classList.add('hidden');
        $('#place-confirm').classList.remove('hidden');
    } else if (action === 'placeStart') {
        $('#app').classList.add('hidden');
        $('#place-confirm').classList.add('hidden');
        $('#place-overlay').classList.remove('hidden', 'ready');
    } else if (action === 'placeUpdate') {
        updatePlaceHud(data);
    } else if (action === 'placeEnd') {
        $('#place-overlay').classList.add('hidden');
        $('#place-confirm').classList.add('hidden');
    } else if (action === 'close') {
        $('#app').classList.add('hidden');
        closeModal();
    }
});

window.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
        if ($('#modal-root').firstChild) closeModal();
        else closeUI();
    }
});

/* ── company creation ────────────────────────────────────────── */

$('#create-btn').addEventListener('click', async () => {
    const name = $('#create-name').value.trim();
    if (name.length < 3) return toast(t('ui.toast.name_short', 'Company name too short'), 'error');
    const res = await post('createCompany', [name]);
    if (handleResult(res)) {
        $('#create-screen').classList.add('hidden');
        $('#main').classList.remove('hidden');
        applyI18n();
        toast(t('ui.toast.created', 'Company created. Welcome to the haul!'), 'success');
    }
});

/* ── navigation ──────────────────────────────────────────────── */

$('#nav').addEventListener('click', (e) => {
    const btn = e.target.closest('button');
    if (!btn) return;
    state.tab = btn.dataset.tab;
    document.querySelectorAll('#nav button').forEach((b) => b.classList.toggle('active', b === btn));
    renderTab();
});

/* ── rendering ───────────────────────────────────────────────── */

function renderAll() {
    const c = state.data.company;
    $('#brand-name').textContent = c.name;
    $('#brand-rank').textContent = c.rank + (isOwner() ? '' : ' · ' + t('ui.operator', 'Operator'));
    $('#brand-logo').innerHTML = c.logo ? `<img src="${esc(c.logo)}" onerror="this.remove()">` : LOGO_SVG;
    $('#side-level').textContent = c.level;
    $('#side-xp').textContent = `${num(c.xp)} / ${num(c.xpNext)} XP`;
    $('#side-xpbar').style.width = Math.min(100, (c.xp / c.xpNext) * 100) + '%';
    $('#side-balance').textContent = money(c.balance);
    renderTab();
}

function renderTab() {
    const fns = {
        overview: renderOverview, contracts: renderContracts, drivers: renderDrivers,
        fleet: renderFleet, crew: renderCrew, upgrades: renderUpgrades, bank: renderBank,
        leaderboard: renderLeaderboard, settings: renderSettings,
    };
    (fns[state.tab] || renderOverview)();
}

/* ── overview ────────────────────────────────────────────────── */

function renderOverview() {
    const d = state.data, c = d.company;
    const job = d.activeJob
        ? `<div class="banner">
               <div class="grow"><b>${t('ui.ov.active', 'Active delivery')}${d.activeJob.illegal ? ` <span class="chip illegal">${t('ui.ct.illegal', 'Illegal')}</span>` : ''}</b><span class="banner-sub">${esc(job_str(d.activeJob))}</span></div>
               <button class="btn btn-danger btn-sm" onclick="cancelActiveJob()">${t('ui.ov.abandon', 'Abandon')}</button>
           </div>`
        : '';

    const tiers = d.tiers.map((ti) => `
        <div class="tier-item ${c.level >= ti.level ? 'unlocked' : 'locked'}">
            <div class="tier-lvl">LVL ${ti.level}</div>
            <div class="grow"><b>${esc(t('ui.tier_name.' + ti.level, ti.label))}</b>
                <span class="muted">&nbsp; ${ti.cargo.map((k) => esc(t('ui.cargo.' + k, k))).join(', ')} &middot; ${ti.maxDistance >= 999 ? t('ui.ov.unlimited', 'unlimited range') : t('ui.ov.up_to', 'up to {1} mi', ti.maxDistance)}</span>
            </div>
            <span class="tier-state">${c.level >= ti.level ? t('ui.ov.unlocked', 'Unlocked') : t('ui.ov.locked', 'Locked')}</span>
        </div>`).join('');

    $('#content').innerHTML = `
        <div class="page-head">
            <div>
                <h2>${t('ui.nav.overview', 'Overview')}</h2>
                <div class="sub">${esc(c.name)} &middot; ${esc(c.rank)} &middot; ${esc(c.tier)} ${t('ui.ov.tier', 'tier')}</div>
            </div>
        </div>
        ${job}
        <div class="stat-grid">
            <div class="stat-card"><div class="label">${t('ui.ov.stat_level', 'Company Level')}</div><div class="value accent">${c.level}</div></div>
            <div class="stat-card"><div class="label">${t('ui.ov.stat_xp', 'XP Progress')}</div><div class="value">${num(c.xp)} <span class="dim">/ ${num(c.xpNext)}</span></div></div>
            <div class="stat-card"><div class="label">${t('ui.company_funds', 'Company Funds')}</div><div class="value green">${money(c.balance)}</div></div>
            <div class="stat-card"><div class="label">${t('ui.ov.stat_revenue', 'Total Revenue')}</div><div class="value">${money(c.totalRevenue)}</div></div>
            <div class="stat-card"><div class="label">${t('ui.ov.stat_deliveries', 'Deliveries')}</div><div class="value">${num(c.totalDeliveries)}</div></div>
            <div class="stat-card"><div class="label">${t('ui.nav.drivers', 'Drivers')}</div><div class="value">${c.driverCount} <span class="dim">/ ${state.data.limits.driverCap}</span></div></div>
            <div class="stat-card"><div class="label">${t('ui.nav.fleet', 'Fleet')}</div><div class="value">${c.truckCount} <span class="dim">/ ${state.data.limits.fleetSize}</span></div></div>
            <div class="stat-card"><div class="label">${t('ui.ov.stat_route', 'Max Route')}</div><div class="value">${c.maxDistance >= 999 ? '&infin;' : c.maxDistance + ' mi'}</div></div>
        </div>
        <h3 class="section-title">${t('ui.ov.progression', 'Progression')}</h3>
        <div class="tier-track">${tiers}</div>`;
}

function job_str(j) {
    return t('ui.ov.job_str', '{1} to {2} ({3})', j.cargo, j.dropoff, money(j.reward));
}

async function cancelActiveJob() {
    const res = await post('cancelJob');
    if (res && res.ok) {
        toast(res.penalty > 0 ? t('ui.toast.abandoned', 'Contract abandoned. Penalty: {1}', money(res.penalty)) : t('ui.toast.released', 'Contract released — no penalty'), 'error');
        const fresh = await post('getData');
        if (fresh && fresh.company) { state.data = fresh; renderAll(); }
        else { state.data.activeJob = null; renderAll(); }
    } else if (res?.error) toast(res.error, 'error');
}

/* ── contracts ───────────────────────────────────────────────── */

function contractCard(c, actions, note) {
    const truck = c.ownerOp ? null : loanerFor(c);
    return `
        <div class="card contract cat-${c.cargo.category}">
            <div class="rig-thumb">
                ${truck ? `<img class="rig-img truck-img" src="img/trucks/${esc(truck.model)}.png" alt="" onerror="this.classList.add('img-missing')">` : ''}
                <img class="rig-img trailer-img" src="img/trailers/${esc(c.cargo.trailer)}.png" alt="" onerror="this.classList.add('img-missing')">
            </div>
            <div class="grow">
                <div class="card-title">
                    ${esc(t('ui.item.' + c.cargo.item, c.cargo.label))}
                    ${c.cargo.category !== 'basic' ? `<span class="chip ${c.cargo.category}">${esc(t('ui.cargo.' + c.cargo.category, c.cargo.categoryLabel))}</span>` : ''}
                    ${c.special ? `<span class="chip special">${t('ui.special.' + c.special, c.special)}</span>` : ''}
                    ${c.expedited ? `<span class="chip express">${t('ui.ct.timed', 'Time Sensitive')}</span>` : ''}
                </div>
                <div class="card-meta">
                    <span>${t('ui.ct.depot', 'Depot')} &rarr; <b>${esc(c.dropoff.name)}</b></span>
                    <span>${c.distance} mi</span>
                    <span>${num(c.cargo.weight)} kg</span>
                    ${c.timeLimit ? `<span>${t('ui.ct.min_limit', '{1} min limit', c.timeLimit)}</span>` : ''}
                    <span>${t('ui.ct.tier_rig', 'Tier {1} rig', c.cargo.class)}</span>
                    ${note ? `<span class="note">${note}</span>` : ''}
                </div>
            </div>
            <div class="reward">
                <div class="money">${money(c.reward)}</div>
                <div class="xp">+${num(c.xp)} XP</div>
            </div>
            ${actions}
        </div>`;
}

function renderContracts() {
    const d = state.data;
    const all = d.contracts || [];
    const bonusPct = Math.round((d.ownerOpBonusPct ?? 0.15) * 100);
    const view = state.contractsView;

    const standard = all.filter((c) => !c.ownerOp);
    const ownerOps = all.filter((c) => c.ownerOp);

    const gate = permGate('drive');
    const list = view === 'ownerop'
        ? ownerOps.map((c) => contractCard(c,
            `<button class="btn btn-primary btn-sm" ${gate} onclick="pickTruckForContract('${c.id}')">${t('ui.ct.accept', 'Accept')}</button>`,
            t('ui.ct.your_rig', 'Your rig &middot; +{1}% pay', bonusPct))).join('')
            || `<div class="empty">${t('ui.ct.empty_ownerop', 'No owner-operator loads right now. Check back after the board refreshes.')}</div>`
        : standard.map((c) => contractCard(c,
            `<button class="btn btn-primary btn-sm" ${gate} onclick="acceptContract('${c.id}')">${t('ui.ct.accept', 'Accept')}</button>`,
            t('ui.ct.depot_rig', 'Depot rig provided'))).join('')
            || `<div class="empty">${t('ui.ct.empty_standard', 'No contracts available. The board restocks automatically - check back soon.')}</div>`;

    $('#content').innerHTML = `
        <div class="page-head">
            <div>
                <h2>${t('ui.ct.title', 'Dispatch Board')}</h2>
                <div class="sub">${t('ui.ct.sub', 'Drive these yourself. Standard freight comes with a borrowed depot rig &mdash; owner-operator loads need your own truck.')}</div>
            </div>
            <div class="head-actions">
                <button class="btn btn-secondary btn-sm" ${d.dailyAvailable && can('drive') ? '' : 'disabled'} onclick="rollSpecial('daily')">${t('ui.ct.daily', 'Daily Contract')}</button>
                <button class="btn btn-secondary btn-sm" ${d.weeklyAvailable && can('drive') ? '' : 'disabled'} onclick="rollSpecial('weekly')">${t('ui.ct.weekly', 'Weekly Contract')}</button>
            </div>
        </div>
        <div class="seg">
            <button class="${view === 'standard' ? 'on' : ''}" onclick="setContractsView('standard')">
                ${t('ui.ct.standard', 'Standard Freight')} <span class="count">${standard.length}</span>
            </button>
            <button class="${view === 'ownerop' ? 'on' : ''}" onclick="setContractsView('ownerop')">
                ${t('ui.ct.ownerop', 'Owner Operator')} <span class="count">${ownerOps.length}</span><span class="bonus">+${bonusPct}%</span>
            </button>
        </div>
        <div class="card-list">${list}</div>`;
}

function setContractsView(view) {
    state.contractsView = view;
    renderContracts();
}

async function acceptContract(contractId) {
    closeModal();
    const res = await post('startJob', [contractId, 0]);
    if (res?.error) toast(res.error, 'error');
    /* on success the client script closes the NUI and spawns the loaner */
}

async function rollSpecial(kind) {
    if (handleResult(await post('rollSpecial', [kind]))) toast(t('ui.toast.special_added', 'Special contract added to dispatch!'), 'success');
}

function eligibleTrucks(contract) {
    return (state.data.trucks || []).map((tk) => {
        let why = null;
        if (tk.assignedTo) why = t('ui.why.assigned', 'assigned to {1}', tk.assignedTo);
        else if (tk.status !== 'garage') why = t('ui.why.unavailable', 'unavailable');
        else if (tk.health < 20) why = t('ui.why.needs_maint', 'needs maintenance');
        else if (tk.class < contract.cargo.class) why = t('ui.why.tier_low', 'tier too low');
        else if (tk.cargo < contract.cargo.weight) why = t('ui.why.cap_low', 'capacity too low');
        else if (tk.range < contract.distance) why = t('ui.why.range_short', 'range too short');
        return { truck: tk, why };
    });
}

const TRAILER_LABELS = {
    docktrailer: 'Container', armytanker: 'Tanker', tr4: 'Car Carrier',
    trailers3: 'Box Trailer', trflat: 'Flatbed',
};
function trailerLabelFor(model) { return t('ui.trailer.' + model, TRAILER_LABELS[model] || t('ui.ct.trailer', 'Trailer')); }

function rigImg(kind, model, alt) {
    return `<img class="rig-img" src="img/${kind}/${esc(model)}.png" alt="${esc(alt || model)}" onerror="this.classList.add('img-missing')">`;
}

/* server lends the cheapest rig that can carry the load (mirrors pickLoaner) */
function loanerFor(contract) {
    const shop = state.data.truckShop || [];
    let pick = null;
    for (const tk of shop) {
        if (tk.class >= contract.cargo.class && tk.cargo >= contract.cargo.weight
            && tk.range >= contract.distance && (!pick || tk.price < pick.price)) pick = tk;
    }
    return pick || shop[shop.length - 1] || null;
}

function pickTruckForContract(contractId) {
    const contract = (state.data.contracts || []).find((c) => c.id === contractId);
    if (!contract) return;
    const rows = eligibleTrucks(contract).map(({ truck: tk, why }) => `
        <div class="pick-item ${why ? 'disabled' : ''}" ${why ? '' : `onclick="startJob('${contractId}', ${tk.id})"`}>
            ${rigImg('trucks', tk.model, tk.label)}
            <div class="grow"><b>${esc(tk.label)}</b>
                <div class="muted">${t('ui.tier', 'Tier')} ${tk.class} &middot; ${num(tk.cargo)} kg &middot; ${tk.range >= 999 ? '&infin;' : tk.range} mi ${t('ui.range', 'range')} &middot; ${tk.health}% ${t('ui.condition', 'condition')}</div>
            </div>
            ${why ? `<span class="muted">${esc(why)}</span>` : `<span class="go">${t('ui.select', 'Select')} &rarr;</span>`}
        </div>`).join('') || `<div class="empty">${t('ui.ct.no_trucks', 'You own no trucks. Visit the Fleet tab.')}</div>`;

    showModal(`
        <h3>${t('ui.ct.select_truck', 'Select a truck')}</h3>
        <div class="muted">${esc(contract.cargo.label)} &middot; ${num(contract.cargo.weight)} kg &middot; ${t('ui.ct.needs_tier', 'needs tier {1}+ rig', contract.cargo.class)}</div>
        <div class="rig-card rig-card-wide">
            ${rigImg('trailers', contract.cargo.trailer, trailerLabelFor(contract.cargo.trailer))}
            <figcaption><span>${t('ui.ct.trailer', 'Trailer')}</span><b>${trailerLabelFor(contract.cargo.trailer)}</b></figcaption>
        </div>
        <div class="pick-list">${rows}</div>
        <div class="modal-actions"><button class="btn btn-ghost" onclick="closeModal()">${t('ui.cancel', 'Cancel')}</button></div>`);
}

async function startJob(contractId, truckId) {
    closeModal();
    const res = await post('startJob', [contractId, truckId]);
    if (res?.error) toast(res.error, 'error');
    /* on success the client script closes the NUI and spawns the truck */
}

/* ── drivers ─────────────────────────────────────────────────── */

/* tier badge + progress toward the next tier, from the driver's level */
function driverTier(dr) {
    const tiers = state.data.driverTiers || [];
    if (!tiers.length) return null;
    let idx = 0;
    tiers.forEach((t, i) => { if (dr.level >= t.minDriverLevel) idx = i; });
    const cur = tiers[idx], next = tiers[idx + 1];
    let pct = 100;
    if (next) {
        const span = next.minDriverLevel - cur.minDriverLevel;
        const through = (dr.level - cur.minDriverLevel) + Math.min(0.999, dr.xp / Math.max(1, dr.xpNext));
        pct = Math.max(2, Math.min(100, (through / span) * 100));
    }
    return { idx: idx + 1, label: cur.label, next: next?.label, pct };
}

function renderDrivers() {
    const d = state.data;
    const gate = permGate('drivers');

    const roster = (d.drivers || []).map((dr) => {
        const truck = dr.truckId ? (d.trucks || []).find((t) => t.id === dr.truckId) : null;
        const tier = driverTier(dr);
        const jobInfo = dr.job
            ? `<span class="chip status-driving">${t('ui.dr.hauling', 'hauling')}</span>`
            : dr.status === 'off'
                ? `<span class="chip status-off">${t('ui.dr.off_duty', 'off duty')}</span>`
                : `<span class="chip status-idle">${t('ui.dr.awaiting', 'awaiting load')}</span>`;
        const truckInfo = truck
            ? `<span>${t('ui.dr.rig', 'Rig')}: <b>${esc(truck.label)}</b> &middot; ${truck.health}% ${t('ui.condition', 'condition')}</span>`
            : `<span class="warn">${t('ui.dr.no_truck', 'No truck assigned')}</span>`;
        const eta = dr.job
            ? `<span>${esc(dr.job.cargo)} &rarr; ${esc(dr.job.dropoff)} &middot; ${t('ui.dr.done_in', 'done in')} <b class="eta" data-finish="${dr.job.finishAt}">...</b></span>`
            : !truck
                ? `<span class="muted">${t('ui.dr.assign_hint', 'Assign a fleet truck so this driver can haul.')}</span>`
                : dr.status === 'idle'
                    ? truck.health < 20
                        ? `<span class="bad">${t('ui.dr.needs_service', 'Truck needs servicing before the next load.')}</span>`
                        : `<span class="muted">${t('ui.dr.auto_hint', 'Dispatch assigns the next load automatically.')}</span>`
                    : '';
        const actions = dr.job
            ? `<button class="btn btn-secondary btn-sm" ${gate} onclick="recallDriver(${dr.id})">${t('ui.dr.recall', 'Recall')}</button>`
            : `<button class="btn btn-secondary btn-sm" ${gate} onclick="pickTruckForDriver(${dr.id})">${truck ? t('ui.dr.change_truck', 'Change Truck') : t('ui.dr.assign_truck', 'Assign Truck')}</button>
               <button class="btn ${dr.status === 'off' ? 'btn-primary' : 'btn-secondary'} btn-sm" ${(dr.status === 'off' && !truck) || !can('drivers') ? 'disabled' : ''} onclick="toggleDuty(${dr.id})">${dr.status === 'off' ? t('ui.dr.set_on', 'Set On Duty') : t('ui.dr.set_off', 'Take Off Duty')}</button>
               <button class="btn btn-danger btn-sm" ${gate} onclick="fireDriver(${dr.id})">${t('ui.dr.fire', 'Fire')}</button>`;
        const tierBar = tier
            ? `<span class="mini-bar">${tier.next ? `&rarr; ${tier.next}` : t('ui.dr.max_tier', 'Max tier')} <span class="bar"><span class="bar-fill gold" style="width:${tier.pct}%"></span></span></span>`
            : '';
        return `
        <div class="card">
            <div class="grow">
                <div class="card-title">${esc(dr.name)}
                    ${tier ? `<span class="chip tier-${tier.idx}">${esc(tier.label)}</span>` : ''}
                    ${jobInfo}
                </div>
                <div class="card-meta">
                    <span>${t('ui.level', 'Level')} <b>${dr.level}</b></span>
                    ${tierBar}
                    <span class="mini-bar">${t('ui.dr.skill', 'Skill')} <span class="bar"><span class="bar-fill blue" style="width:${dr.skill}%"></span></span> ${dr.skill}</span>
                    <span class="mini-bar">${t('ui.dr.reliability', 'Reliability')} <span class="bar"><span class="bar-fill green" style="width:${dr.reliability}%"></span></span> ${dr.reliability}</span>
                </div>
                <div class="card-meta">
                    ${truckInfo}
                    <span>${t('ui.dr.earnings', 'Earnings')}: <b>${money(dr.earnings)}</b></span>
                    <span>${t('ui.ov.stat_deliveries', 'Deliveries')}: <b>${num(dr.deliveries)}</b></span>
                    ${eta}
                </div>
            </div>
            <div class="actions">${actions}</div>
        </div>`;
    }).join('') || `<div class="empty">${t('ui.dr.empty_roster', 'No drivers hired yet. Recruit below to start earning passive income.')}</div>`;

    const cands = (d.candidates || []).map((c) => `
        <div class="card">
            <div class="grow">
                <div class="card-title">${esc(c.name)}
                    ${c.tier ? `<span class="chip tier-${c.tier}">${esc(c.tierLabel || '')}</span>` : ''}
                </div>
                <div class="card-meta">
                    <span class="mini-bar">${t('ui.dr.skill', 'Skill')} <span class="bar"><span class="bar-fill blue" style="width:${c.skill}%"></span></span> ${c.skill}</span>
                    <span class="mini-bar">${t('ui.dr.reliability', 'Reliability')} <span class="bar"><span class="bar-fill green" style="width:${c.reliability}%"></span></span> ${c.reliability}</span>
                </div>
            </div>
            <div class="reward"><div class="money">${money(c.hireCost)}</div></div>
            <button class="btn btn-primary btn-sm" ${gate} onclick="hireDriver('${c.tempId}')">${t('ui.dr.hire', 'Hire')}</button>
        </div>`).join('') || `<div class="empty">${t('ui.dr.no_candidates', 'No candidates right now. Check back later.')}</div>`;

    /* locked tier teasers */
    const lockedTiers = (d.driverTiers || [])
        .map((ti, i) => ({ ...ti, idx: i + 1 }))
        .filter((ti) => d.company.level < ti.minCompanyLevel)
        .map((ti) => `
        <div class="card locked-tier">
            <div class="grow">
                <div class="card-title"><span class="chip tier-${ti.idx}">${esc(ti.label)}</span> ${t('ui.dr.drivers_suffix', 'drivers')}</div>
                <div class="card-meta"><span class="muted">${t('ui.dr.tier_stats', 'Skill {1}-{2} &middot; reliability {3}-{4}', ti.skill[0], ti.skill[1], ti.reliability[0], ti.reliability[1])}</span></div>
            </div>
            <span class="lock-note">${t('ui.dr.unlocks', 'Unlocks at company level {1}', ti.minCompanyLevel)}</span>
        </div>`).join('');

    $('#content').innerHTML = `
        <div class="page-head">
            <div>
                <h2>${t('ui.nav.drivers', 'Drivers')}</h2>
                <div class="sub">${t('ui.dr.sub', 'Buy a truck in the Fleet tab and assign it &mdash; drivers only haul in their assigned rig. They keep a {1}% cut and run their own loads; your dispatch board is never touched.', Math.round((d.driverCutPct ?? 0.2) * 100))}</div>
            </div>
        </div>
        <h3 class="section-title">${t('ui.dr.roster', 'Roster')} <span class="count-tag">${(d.drivers || []).length} / ${d.limits.driverCap}</span></h3>
        <div class="card-list">${roster}</div>
        <h3 class="section-title">${t('ui.dr.recruitment', 'Recruitment')}</h3>
        <div class="card-list">${cands}${lockedTiers}</div>`;
    updateEtas();
}

function pickTruckForDriver(driverId) {
    const driver = (state.data.drivers || []).find((x) => x.id === driverId);
    if (!driver) return;
    const rows = (state.data.trucks || []).map((tk) => {
        let why = null;
        if (tk.id === driver.truckId) why = t('ui.dr.cur_truck', 'current truck');
        else if (tk.assignedTo) why = t('ui.dr.others_truck', "{1}'s truck", tk.assignedTo);
        else if (tk.status !== 'garage') why = t('ui.dr.out_delivery', 'out on your delivery');
        const service = tk.health < 20 ? ` &middot; <span class="bad">${t('ui.dr.needs_service_short', 'needs service')}</span>` : '';
        return `
        <div class="pick-item ${why ? 'disabled' : ''}" ${why ? '' : `onclick="assignTruck(${driver.id}, ${tk.id})"`}>
            <div class="grow"><b>${esc(tk.label)}</b>
                <div class="muted">${t('ui.tier', 'Tier')} ${tk.class} &middot; ${num(tk.cargo)} kg &middot; ${tk.range >= 999 ? '&infin;' : tk.range} mi ${t('ui.range', 'range')} &middot; ${tk.health}% ${t('ui.condition', 'condition')}${service}</div>
            </div>
            ${why ? `<span class="muted">${esc(why)}</span>` : `<span class="go">${t('ui.dr.assign_arrow', 'Assign')} &rarr;</span>`}
        </div>`;
    }).join('') || `<div class="empty">${t('ui.dr.no_trucks_buy', 'You own no trucks. Buy one in the Fleet tab first.')}</div>`;

    showModal(`
        <h3>${t('ui.dr.assign_to', 'Assign a truck to {1}', esc(driver.name))}</h3>
        <div class="muted">${t('ui.dr.assign_modal_sub', 'The driver hauls exclusively in this truck &mdash; it stays reserved for them until unassigned.')}</div>
        <div class="pick-list">${rows}</div>
        <div class="modal-actions">
            ${driver.truckId ? `<button class="btn btn-danger" onclick="assignTruck(${driver.id}, 0)">${t('ui.dr.unassign', 'Unassign')}</button>` : ''}
            <button class="btn btn-ghost" onclick="closeModal()">${t('ui.cancel', 'Cancel')}</button>
        </div>`);
}

async function assignTruck(driverId, truckId) {
    closeModal();
    if (handleResult(await post('assignTruck', [driverId, truckId]))) {
        toast(truckId ? t('ui.toast.truck_assigned', 'Truck assigned') : t('ui.toast.truck_unassigned', 'Truck unassigned'), 'success');
    }
}

async function hireDriver(tempId) { if (handleResult(await post('hireDriver', [tempId]))) toast(t('ui.toast.driver_hired', 'Driver hired! Assign them a truck to put them to work.'), 'success'); }
async function fireDriver(id) { if (handleResult(await post('fireDriver', [id]))) toast(t('ui.toast.driver_fired', 'Driver dismissed'), 'info'); }
async function recallDriver(id) { if (handleResult(await post('recallDriver', [id]))) toast(t('ui.toast.driver_recalled', 'Driver recalled (no payout, now off duty)'), 'info'); }
async function toggleDuty(id) { handleResult(await post('toggleDuty', [id])); }

/* live ETA countdowns */
setInterval(updateEtas, 1000);
function updateEtas() {
    document.querySelectorAll('.eta').forEach((e) => {
        const remaining = parseInt(e.dataset.finish, 10) - serverNow();
        if (remaining <= 0) { e.textContent = 'arriving...'; return; }
        const m = Math.floor(remaining / 60), s = remaining % 60;
        e.textContent = `${m}:${String(s).padStart(2, '0')}`;
    });
}

/* ── fleet ───────────────────────────────────────────────────── */

function renderFleet() {
    const d = state.data;
    const owned = (d.trucks || []).map((tk) => `
        <div class="card">
            <div class="grow">
                <div class="card-title">${esc(tk.label)}
                    <span class="chip status-${tk.status}">${t('ui.status.' + tk.status, tk.status)}</span>
                    ${tk.assignedTo ? `<span class="chip status-assigned">${t('ui.fl.driver', 'driver')}: ${esc(tk.assignedTo)}</span>` : ''}
                </div>
                <div class="card-meta">
                    <span>${t('ui.tier', 'Tier')} <b>${tk.class}</b></span>
                    <span>${t('ui.fl.cargo', 'Cargo')} <b>${num(tk.cargo)} kg</b></span>
                    <span>${t('ui.fl.range', 'Range')} <b>${tk.range >= 999 ? '&infin;' : tk.range + ' mi'}</b></span>
                    <span>${t('ui.fl.fuel', 'Fuel tank')} <b>${tk.fuel} L</b></span>
                    <span class="mini-bar">${t('ui.fl.condition', 'Condition')} <span class="bar"><span class="bar-fill ${tk.health > 50 ? 'green' : 'red'}" style="width:${tk.health}%"></span></span> ${tk.health}%</span>
                </div>
            </div>
            <div class="actions">
                ${tk.status === 'roaming' ? `<span class="muted">${t('ui.fl.out_hint', 'Out — bring it back to the depot to store')}</span>` : ''}
                ${tk.status === 'garage' && !tk.assignedTo ? `<button class="btn btn-primary btn-sm" ${permGate('drive')} onclick="takeOutTruck(${tk.id})">${t('ui.fl.take_out', 'Take Out')}</button>` : ''}
                ${tk.health < 100 && tk.status === 'garage' ? `<button class="btn btn-secondary btn-sm" ${permGate('fleet')} onclick="repairTruck(${tk.id})">${t('ui.fl.service', 'Service {1}', money(tk.repairCost))}</button>` : ''}
                ${tk.status === 'garage' && !tk.assignedTo ? `<button class="btn btn-danger btn-sm" ${permGate('fleet')} onclick="sellTruck(${tk.id})">${t('ui.fl.sell', 'Sell {1}', money(tk.sellPrice))}</button>` : ''}
            </div>
        </div>`).join('') || `<div class="empty">${t('ui.fl.empty', 'Your garage is empty.')}</div>`;

    const shop = (d.truckShop || []).map((tk) => {
        const reqLevel = tk.level || 0;
        const locked = (d.company.level || 0) < reqLevel;
        return `
        <div class="shop-tile ${locked ? 'locked' : ''}">
            <img class="shop-img" src="img/trucks/${esc(tk.model)}.png" alt="" onerror="this.classList.add('img-missing')">
            <div class="shop-rows">
                <div class="shop-row"><span class="lbl">${t('ui.ct.truck', 'Truck')}</span><span class="val">${esc(tk.label)}</span></div>
                <div class="shop-row"><span class="lbl">${t('ui.tier', 'Tier')}</span><span class="val">${tk.class}</span></div>
                <div class="shop-row"><span class="lbl">${t('ui.fl.cargo', 'Cargo')}</span><span class="val">${num(tk.cargo)} kg</span></div>
                <div class="shop-row"><span class="lbl">${t('ui.fl.range', 'Range')}</span><span class="val">${tk.range >= 999 ? '&infin;' : tk.range + ' mi'}</span></div>
                <div class="shop-row"><span class="lbl">${t('ui.dr.reliability', 'Reliability')}</span><span class="val">${tk.reliability}</span></div>
                <div class="shop-row"><span class="lbl">${t('ui.fl.maintenance', 'Maintenance')}</span><span class="val">${money(tk.maintenance)}</span></div>
                <div class="shop-row price-row"><span class="lbl">${t('ui.fl.price', 'Price')}</span><span class="val">${money(tk.price)}</span></div>
            </div>
            ${locked
                ? `<button class="btn btn-secondary btn-sm" disabled>${t('ui.fl.req_level', 'Requires level {1}', reqLevel)}</button>`
                : `<button class="btn btn-primary btn-sm" ${permGate('fleet')} onclick="buyTruck('${tk.model}')">${t('ui.fl.buy', 'Buy')}</button>`}
        </div>`;
    }).join('');

    $('#content').innerHTML = `
        <div class="page-head">
            <div>
                <h2>${t('ui.nav.fleet', 'Fleet')}</h2>
                <div class="sub">${t('ui.fl.sub', 'Bigger trucks unlock heavier cargo, longer routes and better payouts. Assign a truck to a driver to put it to work for you.')}</div>
            </div>
        </div>
        <h3 class="section-title">${t('ui.fl.garage', 'Your Garage')} <span class="count-tag">${(d.trucks || []).length} / ${d.limits.fleetSize}</span></h3>
        <div class="card-list">${owned}</div>
        <h3 class="section-title">${t('ui.fl.dealership', 'Dealership')}</h3>
        <div class="shop-grid">${shop}</div>`;
}

async function takeOutTruck(id) {
    const res = await post('takeOutTruck', [id]);
    if (res?.error) toast(res.error, 'error');
    /* on success the client closes the NUI and spawns the truck at the depot */
}

async function buyTruck(model) { if (handleResult(await post('buyTruck', [model]))) toast(t('ui.toast.truck_bought', 'Truck purchased!'), 'success'); }
async function sellTruck(id) { if (handleResult(await post('sellTruck', [id]))) toast(t('ui.toast.truck_sold', 'Truck sold'), 'info'); }
async function repairTruck(id) { if (handleResult(await post('repairTruck', [id]))) toast(t('ui.toast.truck_serviced', 'Truck serviced'), 'success'); }

/* ── crew ────────────────────────────────────────────────────── */

function permLabels() {
    return {
        drive: t('ui.cr.perm_drive', 'Haul contracts'),
        bank: t('ui.cr.perm_bank', 'Withdraw funds'),
        drivers: t('ui.cr.perm_drivers', 'Manage drivers'),
        fleet: t('ui.cr.perm_fleet', 'Manage fleet'),
        upgrades: t('ui.cr.perm_upgrades', 'Buy upgrades'),
    };
}

function renderCrew() {
    const d = state.data;
    const crew = d.crew || { members: [], maxMembers: 0 };
    const owner = isOwner();
    const operators = crew.members.filter((m) => m.role !== 'owner');
    const PERM = permLabels();

    const rows = crew.members.map((m) => {
        const isOwnerRow = m.role === 'owner';
        const perms = isOwnerRow
            ? `<div class="card-meta"><span class="muted">${t('ui.cr.founder', 'Founder &middot; full access')}</span></div>`
            : `<div class="perm-row">${Object.keys(PERM).map((k) => {
                const on = m.perms?.[k] === true;
                return `<button class="perm ${on ? 'on' : ''}" ${owner ? `onclick="setPerm('${m.cid}','${k}',${!on})"` : 'disabled'}>${PERM[k]}</button>`;
            }).join('')}</div>`;
        return `
        <div class="card">
            <div class="grow">
                <div class="card-title">${esc(m.name)}
                    <span class="chip ${isOwnerRow ? 'role-owner' : 'role-operator'}">${t('ui.role.' + m.role, m.role)}</span>
                </div>
                ${perms}
            </div>
            ${!isOwnerRow && owner ? `<button class="btn btn-danger btn-sm" onclick="removeMember('${m.cid}')">${t('ui.cr.remove', 'Remove')}</button>` : ''}
        </div>`;
    }).join('');

    const footer = owner
        ? `<h3 class="section-title">${t('ui.cr.invite_title', 'Invite an operator')}</h3>
           <div class="card invite-card">
               <div class="grow">
                   <div class="card-meta"><span class="muted">${t('ui.cr.invite_sub', 'The player must be online and not part of another trucking company. Click the permission chips on a member to toggle what they can do.')}</span></div>
                   <div class="bank-form" style="margin-top:10px">
                       <input id="invite-id" type="number" min="1" placeholder="${t('ui.cr.server_id', 'Server ID')}">
                       <button class="btn btn-primary btn-sm" onclick="inviteMember()">${t('ui.cr.invite', 'Invite')}</button>
                   </div>
               </div>
           </div>`
        : `<h3 class="section-title">${t('ui.cr.membership', 'Membership')}</h3>
           <div class="card">
               <div class="grow"><div class="card-meta"><span class="muted">${t('ui.cr.member_sub', "You're an operator at {1}. The owner controls your permissions.", esc(d.company.name))}</span></div></div>
               <button class="btn btn-danger btn-sm" onclick="leaveCompany()">${t('ui.cr.leave', 'Leave Company')}</button>
           </div>`;

    $('#content').innerHTML = `
        <div class="page-head">
            <div>
                <h2>${t('ui.nav.crew', 'Crew')}</h2>
                <div class="sub">${t('ui.cr.sub', "Run the company with friends. Hierarchy: operator &rarr; owner &mdash; the owner sets each operator's permissions.")}</div>
            </div>
        </div>
        <h3 class="section-title">${t('ui.cr.members', 'Members')} <span class="count-tag">${operators.length} / ${crew.maxMembers} ${t('ui.cr.operators', 'operators')}</span></h3>
        <div class="card-list">${rows}</div>
        ${footer}`;
}

async function inviteMember() {
    const id = parseInt($('#invite-id').value, 10);
    if (!id || id <= 0) return toast(t('ui.toast.enter_id', 'Enter a server ID'), 'error');
    if (handleResult(await post('addMember', [id]))) toast(t('ui.toast.operator_added', 'Operator added to the crew!'), 'success');
}

async function removeMember(cid) {
    if (handleResult(await post('removeMember', [cid]))) toast(t('ui.toast.member_removed', 'Member removed'), 'info');
}

async function setPerm(cid, perm, value) {
    handleResult(await post('setMemberPerm', [cid, perm, value]));
}

async function leaveCompany() {
    const res = await post('leaveCompany');
    if (res?.error) return toast(res.error, 'error');
    if (res?.left) $('#app').classList.add('hidden');
}

/* ── upgrades ────────────────────────────────────────────────── */

function renderUpgrades() {
    const points = state.data.company.skillPoints || 0;
    const cards = (state.data.upgrades || []).map((u) => {
        const pips = Array.from({ length: u.maxLevel }, (_, i) =>
            `<div class="pip ${i < u.level ? 'on' : ''}"></div>`).join('');
        const tooPoor = u.nextCost != null && points < u.nextCost;
        let action;
        if (!u.nextCost) {
            action = `<span class="maxed">${t('ui.up.maxed', 'Maxed')}</span>`;
        } else if (tooPoor) {
            action = `<span class="lock-note">${t('ui.up.cost_sp', '{1} SP', u.nextCost)}</span>`;
        } else {
            action = `<button class="btn btn-primary btn-sm" ${permGate('upgrades')} onclick="buyUpgrade('${u.key}')">${t('ui.up.upgrade_sp', 'Upgrade ({1} SP)', u.nextCost)}</button>`;
        }
        return `
        <div class="upgrade-card ${tooPoor ? 'locked' : ''}">
            <h4>${t('ui.up.label_' + u.key, u.label)}</h4>
            <p>${t('ui.up.desc_' + u.key, u.description)}</p>
            <div class="pips">${pips}</div>
            <div class="upgrade-foot">
                <span class="muted">${t('ui.level', 'Level')} ${u.level} / ${u.maxLevel}</span>
                ${action}
            </div>
        </div>`;
    }).join('');

    $('#content').innerHTML = `
        <div class="page-head">
            <div>
                <h2>${t('ui.nav.upgrades', 'Upgrades')}</h2>
                <div class="sub">${t('ui.up.sub_sp', 'Earn one skill point each company level and spend it on upgrades.')}</div>
            </div>
            <div class="head-actions"><div class="sp-badge">${t('ui.up.points', 'Skill Points')}: <b>${points}</b></div></div>
        </div>
        <div class="upgrade-grid">${cards}</div>`;
}

async function buyUpgrade(key) { if (handleResult(await post('buyUpgrade', [key]))) toast(t('ui.toast.upgrade_bought', 'Upgrade purchased!'), 'success'); }

/* ── bank ────────────────────────────────────────────────────── */

function renderBank() {
    const d = state.data;
    const totalIn = d.company.totalIn || 0;
    const totalOut = d.company.totalOut || 0;
    const net = totalIn - totalOut;
    const rows = (d.transactions || []).map((tx) => {
        const date = new Date(tx.time * 1000);
        return `<tr>
            <td class="muted">${date.toLocaleDateString()} ${date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</td>
            <td>${esc(tx.note || tx.type)}</td>
            <td class="tx-amount ${tx.amount >= 0 ? 'pos' : 'neg'}">${tx.amount >= 0 ? '+' : ''}${money(tx.amount)}</td>
        </tr>`;
    }).join('') || `<tr><td class="muted" colspan="3">${t('ui.bk.no_tx', 'No transactions yet.')}</td></tr>`;

    $('#content').innerHTML = `
        <div class="page-head">
            <div>
                <h2>${t('ui.bk.title', 'Company Bank')}</h2>
                <div class="sub">${t('ui.bk.sub', 'All delivery income lands here. Withdraw to your personal cash or bank account.')}</div>
            </div>
        </div>
        <div class="bank-grid">
            <div class="bank-panel">
                <h3>${t('ui.bk.balance', 'Balance')}</h3>
                <div class="bank-balance">${money(d.company.balance)}</div>
                <div class="bank-stats">
                    <div class="bank-stat"><span>${t('ui.bk.earned', 'Earned all-time')}</span><b class="pos">+${money(totalIn)}</b></div>
                    <div class="bank-stat"><span>${t('ui.bk.spent', 'Spent &amp; lost all-time')}</span><b class="neg">-${money(totalOut)}</b></div>
                    <div class="bank-stat net"><span>${t('ui.bk.net', 'Net profit')}</span><b class="${net >= 0 ? 'pos' : 'neg'}">${net >= 0 ? '+' : '-'}${money(Math.abs(net))}</b></div>
                </div>
                <h3>${t('ui.bk.deposit', 'Deposit')}</h3>
                <div class="bank-form">
                    <input id="dep-amount" type="number" min="1" placeholder="${t('ui.bk.amount', 'Amount')}">
                    <button class="btn btn-secondary btn-sm" onclick="bankMove('deposit','cash')">${t('ui.bk.from_cash', 'From Cash')}</button>
                    <button class="btn btn-secondary btn-sm" onclick="bankMove('deposit','bank')">${t('ui.bk.from_bank', 'From Bank')}</button>
                </div>
                <h3 class="spaced">${t('ui.bk.withdraw', 'Withdraw')}</h3>
                <div class="bank-form">
                    <input id="wd-amount" type="number" min="1" placeholder="${t('ui.bk.amount', 'Amount')}" ${can('bank') ? '' : 'disabled'}>
                    <button class="btn btn-primary btn-sm" ${permGate('bank')} onclick="bankMove('withdraw','cash')">${t('ui.bk.to_cash', 'To Cash')}</button>
                    <button class="btn btn-primary btn-sm" ${permGate('bank')} onclick="bankMove('withdraw','bank')">${t('ui.bk.to_bank', 'To Bank')}</button>
                </div>
            </div>
            <div class="bank-panel">
                <h3>${t('ui.bk.history', 'Transaction History')}</h3>
                <table class="tx-table"><tbody>${rows}</tbody></table>
            </div>
        </div>`;
}

async function bankMove(kind, account) {
    const input = $(kind === 'deposit' ? '#dep-amount' : '#wd-amount');
    const amount = parseInt(input.value, 10);
    if (!amount || amount <= 0) return toast(t('ui.toast.valid_amount', 'Enter a valid amount'), 'error');
    if (handleResult(await post(kind, [amount, account]))) {
        toast(kind === 'deposit' ? t('ui.toast.deposited', 'Deposited {1}', money(amount)) : t('ui.toast.withdrew', 'Withdrew {1}', money(amount)), 'success');
    }
}

/* ── leaderboard ─────────────────────────────────────────────── */

async function renderLeaderboard() {
    $('#content').innerHTML = `
        <div class="page-head"><div><h2>${t('ui.nav.leaderboard', 'Rankings')}</h2><div class="sub">${t('ui.lb.loading', 'Loading...')}</div></div></div>`;
    const lb = await post('getLeaderboard');
    if (!lb || lb.error) return;

    const panel = (title, rows, fmt) => `
        <div class="lb-panel"><h3>${title}</h3>
            ${rows.length ? rows.map((r, i) => `
                <div class="lb-row"><span class="lb-pos p${i + 1}">${i + 1}</span>
                    <span class="grow">${esc(fmt.name(r))}</span>
                    <span class="lb-val">${fmt.val(r)}</span>
                </div>`).join('') : `<div class="muted">${t('ui.lb.no_data', 'No data yet')}</div>`}
        </div>`;

    $('#content').innerHTML = `
        <div class="page-head">
            <div>
                <h2>${t('ui.nav.leaderboard', 'Rankings')}</h2>
                <div class="sub">${t('ui.lb.sub', 'The biggest logistics operations on the server.')}</div>
            </div>
        </div>
        <div class="lb-grid">
            ${panel(t('ui.lb.level', 'Highest Company Level'), lb.level || [], { name: (r) => r.name, val: (r) => 'Lvl ' + r.level })}
            ${panel(t('ui.lb.revenue', 'Most Revenue'), lb.revenue || [], { name: (r) => r.name, val: (r) => money(r.total_revenue) })}
            ${panel(t('ui.lb.deliveries', 'Most Deliveries'), lb.deliveries || [], { name: (r) => r.name, val: (r) => num(r.total_deliveries) })}
            ${panel(t('ui.lb.fleet', 'Largest Fleet'), lb.fleet || [], { name: (r) => r.name, val: (r) => r.fleet + ' ' + t('ui.lb.trucks', 'trucks') })}
            ${panel(t('ui.lb.drivers', 'Best Drivers'), lb.drivers || [], { name: (r) => `${r.driver} (${r.company})`, val: (r) => 'Lvl ' + r.level })}
        </div>`;
}

/* ── settings ────────────────────────────────────────────────── */

function renderSettings() {
    const c = state.data.company;
    if (!isOwner()) {
        $('#content').innerHTML = `
            <div class="page-head">
                <div>
                    <h2>${t('ui.nav.settings', 'Settings')}</h2>
                    <div class="sub">${t('ui.st.sub', 'Branding and identity.')}</div>
                </div>
            </div>
            <div class="empty">${t('ui.st.owner_only', 'Only the company owner can change the name and logo.')}</div>`;
        return;
    }
    $('#content').innerHTML = `
        <div class="page-head">
            <div>
                <h2>${t('ui.nav.settings', 'Settings')}</h2>
                <div class="sub">${t('ui.st.sub', 'Branding and identity.')}</div>
            </div>
        </div>
        <div class="settings-panel">
            <h3>${t('ui.st.company_name', 'Company Name')}</h3>
            <p>${t('ui.st.rename_cost', 'Rebranding costs $2,500 from company funds.')}</p>
            <div class="row">
                <input id="set-name" type="text" maxlength="28" value="${esc(c.name)}">
                <button class="btn btn-primary btn-sm" onclick="saveName()">${t('ui.st.rename', 'Rename')}</button>
            </div>
        </div>
        <div class="settings-panel">
            <h3>${t('ui.st.company_logo', 'Company Logo')}</h3>
            <p>${t('ui.st.logo_desc', 'Direct https:// image URL, shown in the menu sidebar.')}</p>
            <div class="row">
                <input id="set-logo" type="text" placeholder="https://..." value="${esc(c.logo || '')}">
                <button class="btn btn-primary btn-sm" onclick="saveLogo()">${t('ui.st.save', 'Save')}</button>
            </div>
        </div>
        <div class="settings-panel danger">
            <h3>${t('ui.st.danger', 'Danger Zone')}</h3>
            <p>${t('ui.st.delete_desc', 'Permanently delete {1}. The balance, trucks, drivers and crew are all lost &mdash; nothing is refunded and there is no undo.', esc(c.name))}</p>
            <button class="btn btn-danger btn-sm" onclick="confirmDeleteCompany()">${t('ui.st.delete', 'Delete Company')}</button>
        </div>`;
}

function confirmDeleteCompany() {
    const name = state.data.company.name;
    showModal(`
        <h3>${t('ui.st.del_title', 'Delete {1}?', esc(name))}</h3>
        <div class="muted">${t('ui.st.del_sub', 'This wipes the company, its balance, trucks, drivers and crew. No refunds, no undo. Type the company name to confirm.')}</div>
        <input id="del-confirm" class="modal-input" type="text" placeholder="${esc(name)}" autocomplete="off">
        <div class="modal-actions">
            <button class="btn btn-ghost" onclick="closeModal()">${t('ui.cancel', 'Cancel')}</button>
            <button class="btn btn-danger" onclick="doDeleteCompany()">${t('ui.st.del_forever', 'Delete Forever')}</button>
        </div>`);
    $('#del-confirm')?.focus();
}

async function doDeleteCompany() {
    const typed = $('#del-confirm').value.trim();
    if (typed !== state.data.company.name) {
        return toast(t('ui.toast.confirm_name', 'Type the exact company name to confirm'), 'error');
    }
    closeModal();
    const res = await post('deleteCompany', [typed]);
    if (res?.error) return toast(res.error, 'error');
    if (res?.deleted) $('#app').classList.add('hidden');
}

async function saveName() {
    if (handleResult(await post('renameCompany', [$('#set-name').value.trim()]))) toast(t('ui.toast.renamed', 'Company renamed'), 'success');
}
async function saveLogo() {
    if (handleResult(await post('setLogo', [$('#set-logo').value.trim()]))) toast(t('ui.toast.logo_updated', 'Logo updated'), 'success');
}

/* ── admin UI (/truckingadmin, /truckingloc) ─────────────────── */

const REGION_HINTS = {
    city: 'Level 0+', county: 'Level 5+',
    state: 'Level 10+', premium: 'Level 20+',
};
const TRUCK_SVG = '<svg viewBox="0 0 24 24"><rect x="1" y="3" width="15" height="13" rx="1"/><path d="M16 8h4l3 3v5h-7V8z"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/></svg>';

function showAdminScreen() {
    $('#app').classList.remove('hidden');
    $('#create-screen').classList.add('hidden');
    $('#main').classList.add('hidden');
    $('#admin-screen').classList.remove('hidden');
    renderAdmin();
}

/* live values from the fly-cam placement loop (client/admin.lua) */
function updatePlaceHud(d) {
    if (!d) return;
    const o = $('#place-overlay');
    o.classList.remove('hidden');
    $('#pl-fov').textContent = Math.round(d.fov ?? 70);
    $('#pl-speed').textContent = 'x' + (d.speed ?? 1).toFixed(2);
    $('#pl-arrow').textContent = Math.round(d.heading ?? 0) + '°';
    const h = d.height ?? 0;
    $('#pl-height').textContent = (h >= 0 ? '+' : '') + h.toFixed(2);
    o.classList.toggle('ready', !!d.found);
    $('#pl-status').textContent = d.found
        ? t('ui.place.ready', 'Ready to place — set the back-in arrow, then press Enter')
        : t('ui.place.aim', 'Aim at the ground to place the marker');
}

function renderAdmin() {
    const a = state.admin;
    if (!a) return;
    const d = a.data || {};

    const tabs = [];
    if (d.canLoc) tabs.push({ key: 'locations', label: t('ui.admin.tab_locations', 'Delivery Locations') });
    if (d.canCompanies) tabs.push({ key: 'companies', label: t('ui.admin.tab_companies', 'Companies') });
    const tabBar = tabs.length > 1 && a.view !== 'form'
        ? `<div class="seg admin-tabs">${tabs.map((tb) =>
            `<button class="${a.view === tb.key ? 'on' : ''}" onclick="adminTab('${tb.key}')">${tb.label}</button>`).join('')}</div>`
        : '';

    let body = '';
    if (a.view === 'form') body = adminFormHtml();
    else if (a.view === 'companies') body = adminCompaniesHtml();
    else body = adminLocationsHtml();

    $('#admin-screen').innerHTML = `
        <div class="admin-panel">
            <div class="hazard"></div>
            <div class="admin-head">
                <div class="admin-title">
                    <div class="admin-icon">${TRUCK_SVG}</div>
                    <div>
                        <h2>${t('ui.admin.title', 'Freight Authority')}</h2>
                        <div class="sub">${t('ui.admin.subtitle', 'Server administration')}</div>
                    </div>
                </div>
                <button class="btn btn-ghost" onclick="closeUI()">${t('ui.close', 'Close — ESC')}</button>
            </div>
            ${tabBar}
            <div class="admin-body">${body}</div>
        </div>`;

    if (a.view === 'form') $('#loc-name')?.focus();
}

function adminTab(view) {
    state.admin.view = view;
    renderAdmin();
}

/* ── locations tab ── */

function adminLocationsHtml() {
    const d = state.admin.data;
    const regions = d.regions || ['city', 'county', 'state', 'premium'];
    const groups = regions.map((region) => {
        const locs = (d.locations || []).filter((l) => l.region === region);
        const rows = locs.map((l) => `
            <div class="loc-row">
                <span class="grow">
                    <span class="loc-name">${esc(l.name)}
                        ${l.cargo && l.cargo.length ? `<span class="chip special">${esc(l.cargo.map((k) => t('ui.cargo.' + k, k)).join(', '))}</span>` : ''}
                        ${l.warning ? `<span class="chip warn-chip">${esc(l.warning)}</span>` : ''}
                    </span>
                    <span class="loc-coords">&#128205; ${coordStr(l)}</span>
                </span>
                <span class="muted">${t('ui.admin.from_depot', '{1} mi from depot', l.miles)}</span>
                <button class="btn btn-secondary btn-sm" onclick="locEdit('${l.region}', ${l.index})">${t('ui.admin.edit', 'Edit')}</button>
                <button class="btn btn-danger btn-sm" onclick="locRemove('${l.region}', ${l.index})">${t('ui.cr.remove', 'Remove')}</button>
            </div>`).join('') || `<div class="muted" style="padding:6px 2px">${t('ui.admin.no_locations', 'No locations yet.')}</div>`;
        return `
        <div class="loc-group">
            <h3>${region} <span class="muted">&middot; ${REGION_HINTS[region] || ''} ${t('ui.admin.routes', 'routes')} &middot; ${locs.length}</span></h3>
            ${rows}
        </div>`;
    }).join('');

    return `
        <div class="place-cta">
            <div class="grow">
                <b>${t('ui.admin.place_title', 'Place a new delivery location')}</b>
                <div class="muted">${t('ui.admin.place_desc', "You'll enter a fly-cam: line the marker up with the yard, press ENTER to place it, then name it here.")}</div>
            </div>
            <button class="btn btn-primary btn-lg" onclick="adminStartPlace(true)">&#10133; ${t('ui.admin.place_btn', 'Place New Location')}</button>
        </div>
        <div class="loc-list">${groups}</div>`;
}

function coordStr(l) {
    if (!l.coords) return '';
    const c = l.coords;
    return `${c.x.toFixed(1)}, ${c.y.toFixed(1)}, ${c.z.toFixed(1)}${l.heading != null ? ` &middot; back-in ${Math.round(l.heading)}°` : ''}`;
}

/* open the placement form pre-filled to edit an existing location */
function locEdit(region, index) {
    const loc = (state.admin?.data?.locations || []).find((l) => l.region === region && l.index === index);
    if (!loc) return;
    const a = state.admin;
    a.editing = { region, index };
    a.placed = loc.coords ? { x: loc.coords.x, y: loc.coords.y, z: loc.coords.z, heading: loc.heading } : a.placed;
    a.formRegion = region;
    a.formCargo = (loc.cargo || []).slice();
    a.formName = loc.name;
    a.view = 'form';
    renderAdmin();
}

/* `fresh` = starting a brand-new location (clear any edit context);
   omitted = re-placing the marker from inside the form (keep context) */
function adminStartPlace(fresh) {
    const a = state.admin;
    let tp = null;
    if (a) {
        if (fresh) { a.editing = null; a.formName = ''; a.formCargo = []; a.placed = null; }
        else {
            if (document.querySelector('#loc-name')) a.formName = document.querySelector('#loc-name').value;
            // re-placing: start the fly-cam at the existing point; when editing,
            // show the current marker and ask to confirm before moving it
            if (a.placed) tp = { x: a.placed.x, y: a.placed.y, z: a.placed.z, heading: a.placed.heading, confirm: !!a.editing };
        }
    }
    $('#app').classList.add('hidden');
    postRaw('locStartPlace', tp || {});
}

/* ── placement form (after the marker is set) ── */

function adminFormHtml() {
    const a = state.admin;
    const p = a.placed || { x: 0, y: 0, z: 0 };
    const regions = (a.data?.regions) || ['city', 'county', 'state', 'premium'];
    const cards = regions.map((r) => `
        <div class="region-card ${a.formRegion === r ? 'on' : ''}" onclick="adminFormRegion('${r}')">
            <b>${r}</b>
            <span>${REGION_HINTS[r] || ''} ${t('ui.admin.routes', 'routes')}</span>
        </div>`).join('');

    const sel = a.formCargo || [];
    const cargoChips = `
        <button class="perm ${sel.length === 0 ? 'on' : ''}" onclick="adminFormCargo(null)">${t('ui.admin.any_cargo', 'Any cargo')}</button>
        ${(a.data?.cargoTypes || []).map((ct) => `
            <button class="perm ${sel.includes(ct.key) ? 'on' : ''}" onclick="adminFormCargo('${ct.key}')">${esc(t('ui.cargo.' + ct.key, ct.label))}</button>`).join('')}`;

    return `
        <div class="form-wrap">
            <h3 class="form-title">${a.editing ? t('ui.admin.edit_title', 'Edit drop-off') : t('ui.admin.new_title', 'Name the new drop-off')}</h3>
            <div class="coords-chip">&#128205; ${p.x.toFixed(1)}, ${p.y.toFixed(1)}, ${p.z.toFixed(1)}${p.heading != null ? ` &middot; ${t('ui.admin.backin', 'back-in')} ${Math.round(p.heading)}&deg;` : ''}</div>
            <input id="loc-name" type="text" maxlength="40" placeholder="${t('ui.admin.name_ph', 'Location name (e.g. Paleto Sawmill Dock)')}" value="${esc(a.formName || '')}" autocomplete="off">
            <div class="region-grid">${cards}</div>
            <h3 class="form-title form-spaced">${t('ui.admin.accepted_cargo', 'Accepted cargo')}</h3>
            <div class="muted form-hint">${t('ui.admin.cargo_hint', 'Dispatch only sends matching loads here. Leave "Any cargo" on unless this yard should be special.')}</div>
            <div class="perm-row">${cargoChips}</div>
            <div class="form-actions">
                <button class="btn btn-ghost" onclick="adminDiscard()">${t('ui.admin.discard', 'Discard')}</button>
                <button class="btn btn-secondary" onclick="adminStartPlace()">${t('ui.admin.replace', 'Re-place Marker')}</button>
                <button class="btn btn-primary" onclick="adminSaveLoc()">${t('ui.admin.save_loc', 'Save Location')}</button>
            </div>
        </div>`;
}

function adminFormRegion(r) {
    state.admin.formRegion = r;
    // keep the typed name across the re-render
    const typed = $('#loc-name')?.value;
    renderAdmin();
    if (typed != null) $('#loc-name').value = typed;
}

function adminFormCargo(key) {
    const a = state.admin;
    if (!key) {
        a.formCargo = [];                 // "Any cargo"
    } else {
        const sel = a.formCargo || [];
        a.formCargo = sel.includes(key) ? sel.filter((k) => k !== key) : [...sel, key];
    }
    // keep the typed name across the re-render
    const typed = $('#loc-name')?.value;
    renderAdmin();
    if (typed != null) $('#loc-name').value = typed;
}

function adminDiscard() {
    state.admin.placed = null;
    state.admin.editing = null;
    state.admin.formName = '';
    state.admin.formCargo = [];
    state.admin.view = 'locations';
    renderAdmin();
}

async function adminSaveLoc() {
    const a = state.admin;
    const name = $('#loc-name').value.trim();
    if (name.length < 3) return toast(t('ui.admin.name_short', 'Name too short'), 'error');
    if (!a.placed) return toast(t('ui.admin.no_marker', 'No marker placed'), 'error');

    const res = a.editing
        ? await postRaw('locEdit', {
            region: a.editing.region, index: a.editing.index,
            name, newRegion: a.formRegion || 'city', cargo: a.formCargo || [], ...a.placed,
        })
        : await postRaw('locAdd', {
            name, region: a.formRegion || 'city', cargo: a.formCargo || [], ...a.placed,
        });
    if (!res) return;
    if (res.error) return toast(res.error, 'error');
    if (res.savedToFile === false) toast(t('ui.admin.save_fail', 'Saved, but locations.lua could not be written!'), 'error');
    else toast(a.editing ? t('ui.admin.loc_updated', 'Location updated') : t('ui.admin.loc_saved', 'Location saved to locations.lua'), 'success');
    if (res.warning) toast(t('ui.admin.warn_skip', 'Heads up: dispatch will skip this point - {1}', res.warning), 'error');
    a.data.locations = res.locations;
    a.data.regions = res.regions || a.data.regions;
    a.placed = null;
    a.formCargo = [];
    a.formName = '';
    a.editing = null;
    a.view = 'locations';
    renderAdmin();
}

async function locRemove(region, index) {
    const res = await postRaw('locRemove', { region, index });
    if (!res) return;
    if (res.error) return toast(res.error, 'error');
    toast(t('ui.admin.loc_removed', 'Location removed'), 'info');
    state.admin.data.locations = res.locations;
    renderAdmin();
}

/* ── companies tab ── */

function adminCompaniesHtml() {
    const rows = (state.admin.data.companies || []).map((c) => `
        <div class="loc-row company-row">
            <div class="grow">
                <b>${esc(c.name)}</b> <span class="muted">&middot; ${esc(c.owner)}</span>
                <div class="muted">${t('ui.admin.co_meta', 'Lvl {1} &middot; {2} &middot; {3} drivers &middot; {4} trucks &middot; {5} crew &middot; {6} deliveries', c.level, money(c.balance), c.drivers, c.trucks, c.members, num(c.deliveries))}</div>
            </div>
            <button class="btn btn-secondary btn-sm" onclick="adminCompanyPrompt('${c.cid}', 'setlevel')">${t('ui.admin.btn_level', 'Level')}</button>
            <button class="btn btn-secondary btn-sm" onclick="adminCompanyPrompt('${c.cid}', 'addmoney')">${t('ui.admin.btn_money', 'Money')}</button>
            <button class="btn btn-secondary btn-sm" onclick="adminCompanyPrompt('${c.cid}', 'addxp')">${t('ui.admin.btn_xp', 'XP')}</button>
            <button class="btn btn-danger btn-sm" onclick="adminCompanyReset('${c.cid}')">${t('ui.admin.btn_reset', 'Reset')}</button>
        </div>`).join('') || `<div class="empty">${t('ui.admin.no_companies', 'No companies founded yet.')}</div>`;

    return `<div class="loc-list">${rows}</div>`;
}

/* look the name up by id rather than inlining it into onclick handlers */
function adminCompanyName(cid) {
    const c = (state.admin?.data?.companies || []).find((x) => x.cid === cid);
    return c ? c.name : 'company';
}

function adminCompanyPrompt(cid, action) {
    const labels = {
        setlevel: (n) => t('ui.admin.prompt_setlevel', 'Set level for {1}', n),
        addmoney: (n) => t('ui.admin.prompt_addmoney', 'Add money to {1} (negative allowed)', n),
        addxp: (n) => t('ui.admin.prompt_addxp', 'Add XP to {1}', n),
    };
    showModal(`
        <h3>${esc((labels[action] || ((n) => n))(adminCompanyName(cid)))}</h3>
        <input id="admin-value" class="modal-input" type="number" placeholder="${t('ui.admin.value_ph', 'Value')}" autocomplete="off">
        <div class="modal-actions">
            <button class="btn btn-ghost" onclick="closeModal()">${t('ui.cancel', 'Cancel')}</button>
            <button class="btn btn-primary" onclick="adminCompanyApply('${cid}', '${action}')">${t('ui.admin.apply', 'Apply')}</button>
        </div>`);
    $('#admin-value')?.focus();
}

async function adminCompanyApply(cid, action) {
    const value = parseInt($('#admin-value').value, 10);
    if (isNaN(value)) return toast(t('ui.admin.enter_value', 'Enter a value'), 'error');
    closeModal();
    const res = await postRaw('adminCompanyAction', { cid, action, value });
    if (!res) return;
    if (res.error) return toast(res.error, 'error');
    toast(t('ui.admin.done', 'Done'), 'success');
    state.admin.data.companies = res.companies;
    renderAdmin();
}

function adminCompanyReset(cid) {
    showModal(`
        <h3>${t('ui.admin.del_title', 'Delete {1}?', esc(adminCompanyName(cid)))}</h3>
        <div class="muted">${t('ui.admin.del_sub', 'This wipes the company, its drivers, trucks, crew and balance. There is no undo.')}</div>
        <div class="modal-actions">
            <button class="btn btn-ghost" onclick="closeModal()">${t('ui.cancel', 'Cancel')}</button>
            <button class="btn btn-danger" onclick="adminCompanyDoReset('${cid}')">${t('ui.admin.del_btn', 'Delete Company')}</button>
        </div>`);
}

async function adminCompanyDoReset(cid) {
    closeModal();
    const res = await postRaw('adminCompanyAction', { cid, action: 'reset', value: 0 });
    if (!res) return;
    if (res.error) return toast(res.error, 'error');
    toast(t('ui.admin.company_deleted', 'Company deleted'), 'info');
    state.admin.data.companies = res.companies;
    renderAdmin();
}

/* these callbacks take named fields (not the args array) */
function postRaw(action, body) {
    if (!IN_GAME) return Promise.resolve(mockAdminAction(action, body));
    return fetch(`https://${RES}/${action}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body),
    }).then((r) => r.json()).catch(() => ({}));
}

/* browser preview support for the admin UI */
const mockAdminData = {
    canLoc: true,
    canCompanies: true,
    regions: ['city', 'county', 'state', 'premium'],
    cargoTypes: [
        { key: 'basic', label: 'Basic Cargo', minLevel: 0 },
        { key: 'fragile', label: 'Fragile Cargo', minLevel: 8 },
        { key: 'valuable', label: 'Valuable Cargo', minLevel: 12 },
    ],
    locations: [
        { region: 'city', index: 1, name: 'Port of Los Santos', miles: 0.2, warning: 'too close to the depot - dispatch needs 0.3+ mi', coords: { x: 1208.8, y: -3025.1, z: 5.5 }, heading: 90 },
        { region: 'city', index: 2, name: 'LSIA Cargo Terminal', miles: 1.5, coords: { x: -1037.2, y: -2737.6, z: 20.2 }, heading: 240 },
        { region: 'county', index: 1, name: 'Sandy Shores Depot', miles: 4.8, coords: { x: 1697.3, y: 3279.8, z: 41.1 }, heading: 105 },
        { region: 'state', index: 1, name: 'Paleto Bay Market', miles: 6.2, coords: { x: -160.5, y: 6334.1, z: 31.6 }, heading: 315 },
        { region: 'premium', index: 1, name: 'Humane Labs', miles: 4.4, coords: { x: 3619.6, y: 3735.2, z: 28.7 }, heading: 200 },
    ],
    companies: [
        { cid: 'AAA111', name: 'Big Sur Logistics', owner: 'Cookie Face', level: 22, balance: 348230, drivers: 4, trucks: 5, members: 2, deliveries: 412 },
        { cid: 'BBB222', name: 'Paleto Freight Co', owner: 'Earl North', level: 9, balance: 52100, drivers: 1, trucks: 2, members: 0, deliveries: 96 },
    ],
};
function mockAdminAction(action, body) {
    if (action === 'locAdd') {
        const count = mockAdminData.locations.filter((l) => l.region === body.region).length;
        mockAdminData.locations.push({
            region: body.region, index: count + 1, name: body.name, miles: 2.1,
            cargo: body.cargo && body.cargo.length ? body.cargo : undefined,
            coords: { x: body.x, y: body.y, z: body.z }, heading: body.heading,
        });
        return { locations: mockAdminData.locations, regions: mockAdminData.regions, savedToFile: true };
    }
    if (action === 'locEdit') {
        const l = mockAdminData.locations.find((x) => x.region === body.region && x.index === body.index);
        if (l) {
            l.name = body.name;
            l.cargo = body.cargo && body.cargo.length ? body.cargo : undefined;
            l.coords = { x: body.x, y: body.y, z: body.z };
            l.heading = body.heading;
            l.region = body.newRegion || l.region;
        }
        return { locations: mockAdminData.locations, regions: mockAdminData.regions, savedToFile: true };
    }
    if (action === 'locRemove') {
        const i = mockAdminData.locations.findIndex((l) => l.region === body.region && l.index === body.index);
        if (i >= 0) mockAdminData.locations.splice(i, 1);
        return { locations: mockAdminData.locations, regions: mockAdminData.regions, savedToFile: true };
    }
    if (action === 'adminCompanyAction') {
        const c = mockAdminData.companies.find((x) => x.cid === body.cid);
        if (body.action === 'reset') {
            mockAdminData.companies = mockAdminData.companies.filter((x) => x.cid !== body.cid);
        } else if (c) {
            if (body.action === 'setlevel') c.level = body.value;
            if (body.action === 'addmoney') c.balance += body.value;
        }
        return { companies: mockAdminData.companies };
    }
    if (action === 'locStartPlace') {
        /* simulate the fly-cam round trip in the browser, HUD included */
        const fire = (a, data) => window.dispatchEvent(new MessageEvent('message', { data: { action: a, data } }));
        fire('placeStart');
        fire('placeUpdate', { fov: 50, speed: 1, heading: 253, height: 0, found: false });
        setTimeout(() => fire('placeUpdate', { fov: 50, speed: 1.5, heading: 270, height: 0.2, found: true }), 900);
        setTimeout(() => {
            fire('placeEnd');
            fire('locPlaced', { x: 1234.5, y: -3169.2, z: 5.9, heading: 270 });
        }, 2400);
        return {};
    }
    return state.data;
}

/* ── modal ───────────────────────────────────────────────────── */

function showModal(inner) {
    closeModal();
    const m = el(`<div class="modal-backdrop"><div class="modal">${inner}</div></div>`);
    m.addEventListener('click', (e) => { if (e.target === m) closeModal(); });
    $('#modal-root').appendChild(m);
}

function closeModal() {
    $('#modal-root').innerHTML = '';
}

/* ── browser preview mode (outside FiveM) ────────────────────── */

function mockAction(action) {
    if (action === 'deleteCompany') {
        return { ok: true, deleted: true };
    }
    if (action === 'getLeaderboard') {
        return {
            level: [{ name: 'Big Sur Logistics', level: 22, xp: 100 }, { name: 'Paleto Freight Co', level: 14, xp: 50 }],
            revenue: [{ name: 'Big Sur Logistics', total_revenue: 1391500 }],
            deliveries: [{ name: 'Big Sur Logistics', total_deliveries: 412 }],
            fleet: [{ name: 'Big Sur Logistics', fleet: 6 }],
            drivers: [{ driver: 'Rosa Castillo', company: 'Big Sur Logistics', level: 7, deliveries: 120, earnings: 88000 }],
        };
    }
    return state.data;
}

if (!IN_GAME) {
    state.data = {
        company: {
            name: 'Big Sur Logistics', logo: null, level: 7, xp: 1430, xpNext: 6620,
            rank: 'Regional Carrier', tier: 'Regional', maxDistance: 6,
            balance: 48230, totalDeliveries: 112, totalRevenue: 391500,
            totalIn: 431500, totalOut: 383270,
            driverCount: 2, truckCount: 3, skillPoints: 1,
        },
        limits: { fleetSize: 4, driverCap: 2 },
        tiers: [
            { level: 0, label: 'Local', cargo: ['basic'], maxDistance: 2 },
            { level: 5, label: 'Regional', cargo: ['basic', 'fragile'], maxDistance: 6 },
            { level: 10, label: 'Long Distance', cargo: ['basic', 'fragile', 'valuable'], maxDistance: 14 },
            { level: 15, label: 'Hazardous', cargo: ['basic', 'fragile', 'valuable'], maxDistance: 20 },
            { level: 20, label: 'Premium Long-Haul', cargo: ['basic', 'fragile', 'valuable'], maxDistance: 999 },
        ],
        viewer: { role: 'owner', perms: { drive: true, bank: true, drivers: true, fleet: true, upgrades: true } },
        crew: {
            maxMembers: 5,
            members: [
                { cid: 'OWNER1', name: 'Cookie Face', role: 'owner' },
                { cid: 'EMP1', name: 'Jimmy Hauls', role: 'operator', perms: { drive: true, bank: false, drivers: true, fleet: false, upgrades: false }, addedAt: 1 },
                { cid: 'EMP2', name: 'Lana Diesel', role: 'operator', perms: { drive: true, bank: false, drivers: false, fleet: false, upgrades: false }, addedAt: 2 },
            ],
        },
        driverTiers: [
            { label: 'Rookie', minCompanyLevel: 0, minDriverLevel: 1, skill: [25, 50], reliability: [30, 55], costMult: 1.0 },
            { label: 'Experienced', minCompanyLevel: 5, minDriverLevel: 4, skill: [45, 70], reliability: [50, 75], costMult: 1.6 },
            { label: 'Veteran', minCompanyLevel: 10, minDriverLevel: 7, skill: [60, 85], reliability: [65, 88], costMult: 2.4 },
            { label: 'Elite', minCompanyLevel: 18, minDriverLevel: 10, skill: [80, 98], reliability: [82, 98], costMult: 3.5 },
        ],
        upgrades: [
            { key: 'dispatch', label: 'Dispatch Center', description: 'More available contracts and better odds of premium freight.', level: 1, maxLevel: 5, nextCost: 1 },
            { key: 'express', label: 'Time-Sensitive Dispatch', description: 'Unlocks time-sensitive loads. They pay a bonus but must be delivered before the deadline.', level: 1, maxLevel: 5, nextCost: 1 },
            { key: 'fragile', label: 'Fragile Freight License', description: 'Unlocks fragile cargo contracts (glassware, ceramics, fine art). Damage is punished hard, so drive smoothly.', level: 1, maxLevel: 1, nextCost: null },
            { key: 'valuable', label: 'Valuable Freight License', description: 'Unlocks high-value cargo contracts (jewelry, gold, banknotes) for big payouts.', level: 0, maxLevel: 1, nextCost: 1 },
            { key: 'illegal', label: 'Smuggling Contacts', description: 'Unlocks illegal smuggling contracts. Big payouts, but deliveries can ping the police.', level: 0, maxLevel: 1, nextCost: 1 },
            { key: 'fuel', label: 'Fuel Contracts', description: 'Cuts fuel and operating costs across the fleet.', level: 0, maxLevel: 5, nextCost: 1 },
            { key: 'garage', label: 'Garage', description: 'Expands fleet size and driver capacity.', level: 2, maxLevel: 5, nextCost: 1 },
            { key: 'insurance', label: 'Insurance', description: 'Reduces damage penalties and failed contract losses.', level: 0, maxLevel: 5, nextCost: 1 },
            { key: 'training', label: 'Driver Training', description: 'Drivers earn more XP and finish jobs faster.', level: 3, maxLevel: 5, nextCost: 1 },
        ],
        drivers: [
            { id: 1, name: 'Rosa Castillo', level: 5, xp: 240, xpNext: 1341, skill: 72, reliability: 81, status: 'driving', truckId: 2, earnings: 38200, deliveries: 41, job: { cargo: 'Electronics', dropoff: 'Sandy Shores Depot', reward: 3400, finishAt: Math.floor(Date.now() / 1000) + 432, startedAt: 0 } },
            { id: 2, name: 'Earl Drummond', level: 1, xp: 80, xpNext: 120, skill: 44, reliability: 38, status: 'off', truckId: null, earnings: 4100, deliveries: 6, job: null },
            { id: 3, name: 'Nadia Larsen', level: 8, xp: 600, xpNext: 2715, skill: 58, reliability: 66, status: 'idle', truckId: 1, earnings: 12700, deliveries: 15, job: null },
        ],
        candidates: [
            { tempId: 'cand_1', name: 'Misha Petrov', tier: 2, tierLabel: 'Experienced', skill: 67, reliability: 74, hireCost: 15168 },
            { tempId: 'cand_2', name: 'Dana Brooks', tier: 1, tierLabel: 'Rookie', skill: 35, reliability: 55, hireCost: 6800 },
        ],
        trucks: [
            { id: 1, model: 'hauler', label: 'JoBuilt Hauler', class: 1, health: 84, status: 'garage', assignedTo: 'Nadia Larsen', cargo: 14000, range: 30, fuel: 190, reliability: 74, maintenance: 2400, repairCost: 384, sellPrice: 25410 },
            { id: 2, model: 'packer', label: 'MTL Packer', class: 2, health: 47, status: 'garage', assignedTo: 'Rosa Castillo', cargo: 22000, range: 65, fuel: 230, reliability: 82, maintenance: 3300, repairCost: 1749, sellPrice: 25850 },
            { id: 3, model: 'phantom', label: 'JoBuilt Phantom', class: 3, health: 95, status: 'out', assignedTo: null, cargo: 36000, range: 999, fuel: 270, reliability: 90, maintenance: 4300, repairCost: 215, sellPrice: 83600 },
        ],
        truckShop: [
            { model: 'hauler', label: 'JoBuilt Hauler', class: 1, level: 0, price: 55000, cargo: 14000, fuel: 190, reliability: 74, maintenance: 2400, range: 30 },
            { model: 'packer', label: 'MTL Packer', class: 2, level: 5, price: 100000, cargo: 22000, fuel: 230, reliability: 82, maintenance: 3300, range: 65 },
            { model: 'phantom', label: 'JoBuilt Phantom', class: 3, level: 10, price: 160000, cargo: 36000, fuel: 270, reliability: 90, maintenance: 4300, range: 999 },
        ],
        contracts: [
            { id: 'c1', dropoff: { name: 'Sandy Shores Depot' }, distance: 5.4, cargo: { category: 'basic', categoryLabel: 'Basic Cargo', label: 'Building Supplies', weight: 9100, class: 1, trailer: 'trflat' }, reward: 4830, xp: 152, timeLimit: null, special: null },
            { id: 'c2', dropoff: { name: 'La Mesa Industrial Park' }, distance: 1.8, cargo: { category: 'basic', categoryLabel: 'Basic Cargo', label: 'Food & Produce', weight: 4820, class: 1, trailer: 'trailers3' }, reward: 2150, xp: 66, timeLimit: 9, special: 'daily' },
            { id: 'c5', dropoff: { name: 'Port of Los Santos' }, distance: 0.9, cargo: { category: 'basic', categoryLabel: 'Basic Cargo', label: 'Furniture', weight: 6100, class: 1, trailer: 'trailers3' }, reward: 1620, xp: 51, timeLimit: null, special: null },
            { id: 'c6', dropoff: { name: 'Vinewood Plaza' }, distance: 3.7, cargo: { category: 'basic', categoryLabel: 'Basic Cargo', label: 'Furniture', weight: 6800, class: 1, trailer: 'trailers3' }, reward: 7400, xp: 210, timeLimit: 8, special: null, expedited: true },
            { id: 'c7', dropoff: { name: 'Rockford Hills Gallery' }, distance: 4.5, cargo: { category: 'fragile', categoryLabel: 'Fragile Cargo', label: 'Fine Art', weight: 3200, class: 2, trailer: 'trailers3', fragile: true }, reward: 9300, xp: 280, timeLimit: null, special: null },
            { id: 'c8', dropoff: { name: 'Pacific Standard Bank' }, distance: 6.1, cargo: { category: 'valuable', categoryLabel: 'Valuable Cargo', label: 'Gold Bullion', weight: 5400, class: 2, trailer: 'docktrailer' }, reward: 13200, xp: 360, timeLimit: null, special: null },
            { id: 'c3', dropoff: { name: 'You Tool Hardware' }, distance: 8.9, cargo: { category: 'valuable', categoryLabel: 'Valuable Cargo', label: 'Jewelry', weight: 3200, class: 2, trailer: 'trailers3' }, reward: 14770, xp: 410, timeLimit: null, special: null, ownerOp: true },
            { id: 'c4', dropoff: { name: 'Grapeseed Farms' }, distance: 4.2, cargo: { category: 'basic', categoryLabel: 'Basic Cargo', label: 'Building Supplies', weight: 9100, class: 1, trailer: 'trflat' }, reward: 4830, xp: 152, timeLimit: null, special: null, ownerOp: true },
        ],
        ownerOpBonusPct: 0.15,
        transactions: [
            { amount: 3400, type: 'ai_delivery', note: 'Rosa Castillo: Electronics -> Sandy Shores (success)', time: Math.floor(Date.now() / 1000) - 3600 },
            { amount: -1590, type: 'maintenance', note: 'Serviced JoBuilt Hauler', time: Math.floor(Date.now() / 1000) - 7400 },
            { amount: 4500, type: 'delivery', note: 'Electronics to Sandy Shores Depot', time: Math.floor(Date.now() / 1000) - 9000 },
        ],
        activeJob: null,
        dailyAvailable: true,
        weeklyAvailable: false,
        serverTime: Math.floor(Date.now() / 1000),
    };
    $('#app').classList.remove('hidden');
    $('#main').classList.remove('hidden');
    renderAll();
}
