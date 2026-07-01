(function () {
    'use strict';
    var RES = 'qb-mechanicjob';
    var DATA = null;

    // Styling for the Orders / History / Storage tabs (keeps the base css file
    // untouched).
    (function injectOrderCss() {
        var css = [
            '.rme-order{border:1px solid rgba(140,170,220,0.16);border-radius:14px;padding:12px 14px;margin-bottom:12px;background:rgba(255,255,255,0.03);}',
            '.rme-order.rme-order-match{border-color:rgba(110,170,255,0.55);box-shadow:0 0 18px rgba(61,123,255,0.18);background:rgba(61,123,255,0.08);}',
            '.rme-order-head{display:flex;justify-content:space-between;align-items:center;margin-bottom:8px;gap:10px;}',
            '.rme-order-veh{font-weight:700;font-size:13px;color:#eaf2ff;}',
            '.rme-order-cust{font-size:11px;color:#8fa6c9;}',
            '.rme-order-total{font-weight:800;font-size:15px;color:#ff6b6b;white-space:nowrap;}',
            '.rme-order-item{display:flex;justify-content:space-between;align-items:center;padding:7px 10px;border-radius:9px;background:rgba(255,255,255,0.03);margin-top:6px;font-size:12px;color:#dce7f7;}',
            '.rme-order-item-label{flex:1;}',
            '.rme-order-note{font-size:11px;color:#7e94b6;font-style:italic;}',
            '.rme-mini-btn{border:none;border-radius:8px;padding:6px 12px;font-size:12px;font-weight:700;cursor:pointer;color:#fff;background:linear-gradient(90deg,#3d7bff,#5a9bff);box-shadow:0 4px 14px rgba(61,123,255,0.35);}',
            '.rme-mini-btn:hover{filter:brightness(1.1);}',
            '.rme-order-cancel{border:1px solid rgba(255,120,120,0.4);background:rgba(255,90,90,0.12);color:#ffd9d9;border-radius:8px;padding:5px 10px;font-size:11px;font-weight:600;cursor:pointer;margin-top:8px;}',
            '.rme-order-cancel:hover{background:rgba(255,90,90,0.22);}',
            '.rme-storage{max-width:460px;}',
            '.rme-hist-time{font-size:11px;color:#7e94b6;margin-top:4px;}'
        ].join('');
        var s = document.createElement('style');
        s.textContent = css;
        document.head.appendChild(s);
    })();

    // Member tablet tabs: no cosmetic pickers -- members only see orders, the
    // history, the amounts, the shared parts storage, plus repair/clean and
    // manual billing. Customers choose cosmetics at the drive-in bay instead.
    var CATS = [
        { id: 'diagnostics', label: 'Diagnostics', icon: 'D' },
        { id: 'orders', label: 'Orders', icon: 'O' },
        { id: 'history', label: 'History', icon: 'H' },
        { id: 'storage', label: 'Storage', icon: 'B' },
        { id: 'repair', label: 'Repair & Clean', icon: 'R' },
        { id: 'bill', label: 'Bill Customer', icon: '$' }
    ];

    function el(tag, cls, html) {
        var e = document.createElement(tag);
        if (cls) e.className = cls;
        if (html !== undefined) e.innerHTML = html;
        return e;
    }

    function root() { return document.getElementById('rme-tablet'); }
    function content() { return document.getElementById('rme-content'); }

    function post(name, body, cb) {
        fetch('https://' + RES + '/' + name, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify(body || {})
        }).then(function (r) {
            return r.json().catch(function () { return null; });
        }).then(function (d) { if (cb) cb(d); }).catch(function () { if (cb) cb(null); });
    }

    function renderDiagnostics() {
        var ct = content();
        var d = DATA.diag || {};
        var wrap = el('div', 'rme-diag');
        var rows = [
            ['Engine', d.engine || 0],
            ['Body', d.body || 0],
            ['Fuel Tank', d.fuelTank || 0],
            ['Fuel Level', d.fuel || 0],
            ['Cleanliness', 100 - (d.dirt || 0)]
        ];
        (d.parts || []).forEach(function (p) { rows.push([p.label, p.pct]); });
        rows.forEach(function (row) {
            var label = row[0];
            var pct = Math.max(0, Math.min(100, row[1] || 0));
            var r = el('div', 'rme-bar-row');
            r.appendChild(el('div', 'rme-bar-label', label));
            var track = el('div', 'rme-bar-track');
            var fill = el('div', 'rme-bar-fill');
            fill.style.width = pct + '%';
            if (pct <= 25) fill.classList.add('low');
            else if (pct <= 50) fill.classList.add('mid');
            track.appendChild(fill);
            r.appendChild(track);
            r.appendChild(el('div', 'rme-bar-pct', pct + '%'));
            wrap.appendChild(r);
        });
        ct.appendChild(wrap);
    }

    function kindLabel(it) {
        var k = it.kind || 'item';
        var pre = k.charAt(0).toUpperCase() + k.slice(1);
        if (k === 'paint') pre = (it.section === 'secondary') ? 'Secondary Paint' : 'Primary Paint';
        else if (k === 'wheel') pre = 'Wheels';
        else if (k === 'smoke') pre = 'Tire Smoke';
        else if (k === 'tint') pre = 'Window Tint';
        else if (k === 'plate') pre = 'Plate';
        else if (k === 'neon') pre = 'Neon';
        return pre + (it.label ? (': ' + it.label) : '');
    }

    function renderOrders() {
        var ct = content();
        ct.appendChild(el('div', 'rme-section-title', 'Customer Orders'));
        var holder = el('div');
        holder.id = 'rme-orders-holder';
        ct.appendChild(holder);
        loadOrders();
    }

    function loadOrders() {
        post('rmeGetOrders', {}, function (res) {
            res = res || {};
            var plate = res.plate || '';
            var orders = res.orders || [];
            var holder = document.getElementById('rme-orders-holder');
            if (!holder) return;
            holder.innerHTML = '';
            if (orders.length === 0) {
                holder.appendChild(el('div', 'rme-bill-note', 'No open orders right now. Customers place orders at the drive-in bay.'));
                return;
            }
            orders.forEach(function (o) {
                var match = (o.plate === plate);
                var card = el('div', 'rme-order' + (match ? ' rme-order-match' : ''));
                var head = el('div', 'rme-order-head');
                var left = el('div');
                left.appendChild(el('div', 'rme-order-veh', (o.vehName || 'Vehicle') + '  \u00B7  ' + o.plate));
                left.appendChild(el('div', 'rme-order-cust', o.customerName || ''));
                head.appendChild(left);
                head.appendChild(el('span', 'rme-order-total', '$' + (o.total || 0)));
                card.appendChild(head);
                (o.items || []).forEach(function (it, idx) {
                    var row = el('div', 'rme-order-item');
                    row.appendChild(el('span', 'rme-order-item-label', kindLabel(it)));
                    if (match) {
                        var b = el('button', 'rme-mini-btn', 'Apply');
                        b.addEventListener('click', function () {
                            post('rmeOrderApply', { plate: o.plate, index: idx + 1, item: it }, function () { loadOrders(); });
                        });
                        row.appendChild(b);
                    } else {
                        row.appendChild(el('span', 'rme-order-note', 'connect to car'));
                    }
                    card.appendChild(row);
                });
                if (match) {
                    var cancel = el('button', 'rme-order-cancel', 'Cancel order');
                    cancel.addEventListener('click', function () {
                        post('rmeOrderCancel', { plate: o.plate }, function () { loadOrders(); });
                    });
                    card.appendChild(cancel);
                }
                holder.appendChild(card);
            });
        });
    }

    function renderHistory() {
        var ct = content();
        ct.appendChild(el('div', 'rme-section-title', 'Completed Orders'));
        var holder = el('div');
        holder.id = 'rme-history-holder';
        ct.appendChild(holder);
        loadHistory();
    }

    function loadHistory() {
        post('rmeGetHistory', {}, function (res) {
            res = res || {};
            var hist = res.history || [];
            var holder = document.getElementById('rme-history-holder');
            if (!holder) return;
            holder.innerHTML = '';
            if (hist.length === 0) {
                holder.appendChild(el('div', 'rme-bill-note', 'No completed orders yet. Finished orders and their totals show up here.'));
                return;
            }
            hist.forEach(function (h) {
                var card = el('div', 'rme-order');
                var head = el('div', 'rme-order-head');
                var left = el('div');
                left.appendChild(el('div', 'rme-order-veh', (h.vehName || 'Vehicle') + '  \u00B7  ' + (h.plate || '')));
                left.appendChild(el('div', 'rme-order-cust', h.customerName || ''));
                head.appendChild(left);
                head.appendChild(el('span', 'rme-order-total', '$' + (h.total || 0)));
                card.appendChild(head);
                holder.appendChild(card);
            });
        });
    }

    function renderStorage() {
        var ct = content();
        ct.appendChild(el('div', 'rme-section-title', 'Parts Storage'));
        var wrap = el('div', 'rme-storage');
        wrap.appendChild(el('div', 'rme-bill-note', 'Open the shared Redline parts storage. The boss stocks crafted spray cans and parts here and members draw from it to fulfil orders. Opening storage closes this tablet.'));
        var btn = el('button', 'rme-btn', 'Open Redline Storage');
        btn.addEventListener('click', function () {
            post('rmeStorage', {}, function () { hide(); });
        });
        wrap.appendChild(btn);
        ct.appendChild(wrap);
    }

    function renderRepair() {
        var ct = content();
        ct.appendChild(el('div', 'rme-section-title', 'Repair & Clean'));
        var defs = [
            ['Full Repair', 'fullrepair', 'Restores engine, body and fuel-tank health to 100%, fixes all visual crash damage and dents, and restores every tracked wear part. This is the full service - use it after a crash or heavy damage.'],
            ['Restore Worn Parts', 'parts', 'Restores only the tracked wear components (brakes, clutch, suspension, etc.) back to full. It does NOT touch body or engine crash damage - a lighter maintenance service.'],
            ['Clean Vehicle', 'clean', 'Washes off all dirt and dust so the car looks freshly detailed. Purely cosmetic - it does not repair anything.']
        ];
        var g = el('div', 'rme-grid');
        defs.forEach(function (row) {
            var c = el('div', 'rme-card rme-card-desc');
            var txt = el('div', 'rme-card-textwrap');
            txt.appendChild(el('div', 'rme-card-label', row[0]));
            txt.appendChild(el('div', 'rme-card-desc-text', row[2]));
            c.appendChild(txt);
            c.addEventListener('click', function () {
                post('rmeRepair', { kind: row[1] }, function () {
                    c.classList.add('rme-applied');
                    setTimeout(function () { c.classList.remove('rme-applied'); }, 600);
                });
            });
            g.appendChild(c);
        });
        ct.appendChild(g);
        ct.appendChild(el('div', 'rme-bill-note', 'Repair and clean actions are free and do not use any part items.'));
    }

    function renderBill() {
        var ct = content();
        var wrap = el('div', 'rme-bill');
        wrap.appendChild(el('div', 'rme-section-title', 'Bill a customer'));
        wrap.appendChild(el('div', 'rme-field-label', 'Customer player ID'));
        var idInput = el('input', 'rme-input');
        idInput.type = 'number';
        idInput.min = '1';
        idInput.placeholder = 'Player ID (server ID)';
        wrap.appendChild(idInput);
        wrap.appendChild(el('div', 'rme-field-label', 'Invoice amount'));
        var amtInput = el('input', 'rme-input');
        amtInput.type = 'number';
        amtInput.min = '1';
        amtInput.placeholder = 'Amount ($)';
        wrap.appendChild(amtInput);
        var btn = el('button', 'rme-btn', 'Send Invoice');
        btn.addEventListener('click', function () {
            var pid = parseInt(idInput.value, 10);
            var amt = parseInt(amtInput.value, 10);
            if (!pid || pid <= 0) return;
            if (!amt || amt <= 0) return;
            post('rmeBill', { target: pid, amount: amt });
            amtInput.value = '';
        });
        wrap.appendChild(btn);
        wrap.appendChild(el('div', 'rme-bill-note', 'Enter the customer server ID (they can read it from the pause menu or a scoreboard). The customer must accept the invoice; payment is deposited into the Redline society account. Use the total shown on the matching order.'));
        ct.appendChild(wrap);
    }

    function selectCat(id) {
        var nav = document.getElementById('rme-nav');
        if (nav) {
            var btns = nav.querySelectorAll('.rme-cat');
            for (var i = 0; i < btns.length; i++) {
                btns[i].classList.toggle('active', btns[i].getAttribute('data-cat') === id);
            }
        }
        var ct = content();
        if (ct) ct.innerHTML = '';
        switch (id) {
            case 'diagnostics': renderDiagnostics(); break;
            case 'orders': renderOrders(); break;
            case 'history': renderHistory(); break;
            case 'storage': renderStorage(); break;
            case 'repair': renderRepair(); break;
            case 'bill': renderBill(); break;
        }
    }

    function buildShell() {
        var r = root();
        r.innerHTML = '';
        var panel = el('div', 'rme-panel');

        var header = el('div', 'rme-header');
        var brand = el('div', 'rme-brand');
        brand.appendChild(el('span', 'rme-brand-main', 'REDLINE'));
        brand.appendChild(el('span', 'rme-brand-sub', 'MOTORSPORT'));
        var veh = el('div', 'rme-veh');
        veh.appendChild(el('div', 'rme-veh-name', DATA.name || 'Vehicle'));
        veh.appendChild(el('div', 'rme-veh-plate', 'PLATE \u00B7 ' + (DATA.plate || '')));
        var close = el('button', 'rme-close', '\u2715');
        close.addEventListener('click', function () { post('rmeClose', {}, function () { hide(); }); });
        header.appendChild(brand);
        header.appendChild(veh);
        header.appendChild(close);

        var body = el('div', 'rme-body');
        var nav = el('div', 'rme-nav');
        nav.id = 'rme-nav';
        CATS.forEach(function (c) {
            var b = el('button', 'rme-cat');
            b.setAttribute('data-cat', c.id);
            b.innerHTML = '<span class="rme-cat-ico">' + c.icon + '</span><span>' + c.label + '</span>';
            b.addEventListener('click', function () { selectCat(c.id); });
            nav.appendChild(b);
        });
        var ct = el('div', 'rme-content');
        ct.id = 'rme-content';
        body.appendChild(nav);
        body.appendChild(ct);

        panel.appendChild(header);
        panel.appendChild(body);
        r.appendChild(panel);
    }

    function show() { root().classList.remove('rme-hidden'); }
    function hide() { root().classList.add('rme-hidden'); }

    window.addEventListener('message', function (e) {
        var d = e.data || {};
        if (d.action === 'openRedlineTablet') {
            DATA = d.data || {};
            buildShell();
            selectCat('diagnostics');
            show();
        } else if (d.action === 'closeRedlineTablet') {
            hide();
        }
    });
})();
