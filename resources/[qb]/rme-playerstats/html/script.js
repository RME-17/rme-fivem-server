const $ = (id) => document.getElementById(id);

function render(d) {
    if (!d) return;
    const skills = (d.skills || []).map((s) => `
        <div class='skill'>
            <div class='srow'>
                <span class='sicon'>${s.icon || ''}</span>
                <span class='sname'>${s.label}</span>
                <span class='slvl'>Lv ${s.level}</span>
            </div>
            <div class='bar'><div class='fill' style='width:${s.pct}%'></div></div>
            <div class='ssub'>${s.sub || ''} &middot; ${s.pct}% to next level</div>
        </div>
    `).join('');
    $('skills').innerHTML = skills;

    const ov = (d.overview || []).map((o) => `
        <div class='ov'><span class='ovl'>${o.label}</span><span class='ovv'>${o.value}</span></div>
    `).join('');
    $('overview').innerHTML = ov;
}

window.addEventListener('message', (e) => {
    const m = e.data || {};
    if (m.action === 'open' || m.action === 'update') {
        render(m.data);
        $('wrap').classList.remove('hidden');
    } else if (m.action === 'close') {
        $('wrap').classList.add('hidden');
    }
});
