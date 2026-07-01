(function () {
    'use strict';
    var RES = 'qb-mechanicjob';
    var DATA = null;

    // Inject styling for the Orders tab (keeps redline-tablet.css untouched).
    (function injectOrderCss() {
        var css = [
            '.rme-order{border:1px solid rgba(140,170,220,0.16);border-radius:14px;padding:12px 14px;margin-bottom:12px;background:rgba(255,255,255,0.03);}',
            '.rme-order.rme-order-match{border-color:rgba(110,170,255,0.55);box-shadow:0 0 18px rgba(61,123,255,0.18);background:rgba(61,123,255,0.08);}',
            '.rme-order-head{display:flex;justify-content:space-between;align-items:center;margin-bottom:8px;}',
            '.rme-order-veh{font-weight:700;font-size:13px;color:#eaf2ff;}',
            '.rme-order-cust{font-size:11px;color:#8fa6c9;}',
            '.rme-order-item{display:flex;justify-content:space-between;align-items:center;padding:7px 10px;border-radius:9px;background:rgba(255,255,255,0.03);margin-top:6px;font-size:12px;color:#dce7f7;}',
            '.rme-order-item-label{flex:1;}',
            '.rme-order-note{font-size:11px;color:#7e94b6;font-style:italic;}',
            '.rme-mini-btn{border:none;border-radius:8px;padding:6px 12px;font-size:12px;font-weight:700;cursor:pointer;color:#fff;background:linear-gradient(90deg,#3d7bff,#5a9bff);box-shadow:0 4px 14px rgba(61,123,255,0.35);}',
            '.rme-mini-btn:hover{filter:brightness(1.1);}',
            '.rme-order-cancel{border:1px solid rgba(255,120,120,0.4);background:rgba(255,90,90,0.12);color:#ffd9d9;border-radius:8px;padding:5px 10px;font-size:11px;font-weight:600;cursor:pointer;margin-top:8px;}',
            '.rme-order-cancel:hover{background:rgba(255,90,90,0.22);}'
        ].join('');
        var s = document.createElement('style');
        s.textContent = css;
        document.head.appendChild(s);
    })();

    var PAINT = [
        { label: 'Jet Black', r: 12, g: 12, b: 14 },
        { label: 'Pure White', r: 240, g: 244, b: 250 },
        { label: 'Redline Red', r: 200, g: 24, b: 36 },
        { label: 'Racing Blue', r: 28, g: 96, b: 220 },
        { label: 'Cyan Glow', r: 40, g: 190, b: 230 },
        { label: 'Sunset Orange', r: 240, g: 120, b: 30 },
        { label: 'Money Green', r: 30, g: 170, b: 90 },
        { label: 'Royal Purple', r: 120, g: 50, b: 200 },
        { label: 'Hot Pink', r: 235, g: 70, b: 160 },
        { label: 'Gold', r: 212, g: 175, b: 55 },
        { label: 'Gunmetal', r: 60, g: 70, b: 84 },
        { label: 'Silver', r: 170, g: 178, b: 188 }
    ];

    var CATS = [
        { id: 'diagnostics', label: 'Diagnostics', icon: 'D' },
        { id: 'orders', label: 'Orders', icon: 'O' },
        { id: 'paint', label: 'Paint', icon: 'P' },
        { id: 'wheels', label: 'Wheels', icon: 'W' },
        { id: 'exterior', label: 'Exterior', icon: 'E' },
        { id: 'interior', label: 'Interior', icon: 'I' },
        { id: 'neon', label: 'Neon Kits', icon: 'N' },
        { id: 'xenon', label: 'Headlights', icon: 'H' },
        { id: 'smoke', label: 'Tire Smoke', icon: 'S' },
        { id: 'tint', label: 'Window Tint', icon: 'T' },
        { id: 'plate', label: 'Plate Style', icon: 'L' },
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
    function rgbCss(o) { return 'rgb(' + o.r + ',' + o.g + ',' + o.b + ')'; }

    // Requirement note shown at the top of a cosmetic section, telling the member
    // which physical part they must carry (one is consumed per apply).
    function reqNote(kind) {
        if (!DATA || !DATA.requireItems) return null;
        var pi = DATA.partItems || {};
        var m = pi[kind];
        if (!m) return null;
        return el('div', 'rme-req-note', 'Requires 1x ' + m.label + ' in your inventory - one is consumed each time you apply an item here.');
    }
    function addReqNote(ct, kind) {
        var n = reqNote(kind);
        if (n) ct.appendChild(n);
    }

    function post(name, body, cb) {
        fetch('https://' + RES + '/' + name, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify(body || {})
        }).then(function (r) {
            return r.json().catch(function () { return null; });
        }).then(function (d) { if (cb) cb(d); }).catch(function () { if (cb) cb(null); });
    }

    function flash(card) {
        if (!card) return;
        card.classList.add('rme-applied');
        setTimeout(function () { card.classList.remove('rme-applied'); }, 600);
    }

    function makeCard(label, onClick, opt) {
        opt = opt || {};
        var c = el('div', 'rme-card');
        if (opt.swatch) {
            var dot = el('span', 'rme-swatch');
            dot.style.background = opt.swatch;
            c.appendChild(dot);
        }
        c.appendChild(el('span', 'rme-card-label', label));
        if (opt.arrow) c.appendChild(el('span', 'rme-arrow', '\u203A'));
        c.addEventListener('click', function () { if (onClick) onClick(c); });
        return c;
    }

    function optionGrid(target, options, payloadFn, swatchFn) {
        var g = el('div', 'rme-grid');
        options.forEach(function (o) {
            var sw = swatchFn ? swatchFn(o) : null;
            g.appendChild(makeCard(o.label, function (c) {
                post('rmeApply', payloadFn(o), function () { flash(c); });
            }, { swatch: sw }));
        });
        target.appendChild(g);
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
                head.appendChild(el('span', 'rme-order-veh', (o.vehName || 'Vehicle') + '  \u00B7  ' + o.plate));
                head.appendChild(el('span', 'rme-order-cust', o.customerName || ''));
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

    function renderPaint() {
        var ct = content();
        addReqNote(ct, 'paint');
        ['primary', 'secondary'].forEach(function (section) {
            ct.appendChild(el('div', 'rme-section-title', section === 'primary' ? 'Primary Color' : 'Secondary Color'));
            optionGrid(ct, PAINT, function (p) {
                return { kind: 'paint', section: section, r: p.r, g: p.g, b: p.b };
            }, function (p) { return rgbCss(p); });
        });
    }

    function renderWheels() {
        var ct = content();
        addReqNote(ct, 'wheel');
        ct.appendChild(el('div', 'rme-section-title', 'Wheel Types'));
        var g = el('div', 'rme-grid');
        (DATA.wheelCats || []).forEach(function (cat) {
            g.appendChild(makeCard(cat.label, function () {
                post('rmeWheelList', { id: cat.id }, function (list) {
                    renderWheelList(cat, list || []);
                });
            }, { arrow: true }));
        });
        ct.appendChild(g);
    }

    function renderWheelList(cat, list) {
        var ct = content();
        ct.innerHTML = '';
        var back = el('div', 'rme-back', '\u2190 Back to wheel types');
        back.addEventListener('click', function () { selectCat('wheels'); });
        ct.appendChild(back);
        addReqNote(ct, 'wheel');
        ct.appendChild(el('div', 'rme-section-title', cat.label));
        optionGrid(ct, list, function (o) {
            return { kind: 'wheel', wheelType: cat.id, index: o.index };
        });
    }

    function renderSections(sections) {
        var ct = content();
        addReqNote(ct, 'mod');
        if (!sections || sections.length === 0) {
            ct.appendChild(el('div', 'rme-bill-note', 'No options available for this vehicle.'));
            return;
        }
        sections.forEach(function (sec) {
            ct.appendChild(el('div', 'rme-section-title', sec.label));
            optionGrid(ct, sec.options, function (o) {
                return { kind: 'mod', modType: sec.modType, index: o.index, horn: !!sec.horn };
            });
        });
    }

    function renderNeon() {
        var ct = content();
        addReqNote(ct, 'neon');
        var g = el('div', 'rme-grid');
        g.appendChild(makeCard('Neons Off', function (c) { post('rmeApply', { kind: 'neon', off: true }, function () { flash(c); }); }));
        (DATA.neon || []).forEach(function (n) {
            g.appendChild(makeCard(n.label, function (c) {
                post('rmeApply', { kind: 'neon', r: n.r, g: n.g, b: n.b }, function () { flash(c); });
            }, { swatch: rgbCss(n) }));
        });
        ct.appendChild(g);
    }

    function renderSmoke() {
        var ct = content();
        addReqNote(ct, 'smoke');
        var g = el('div', 'rme-grid');
        g.appendChild(makeCard('Smoke Off', function (c) { post('rmeApply', { kind: 'smoke', off: true }, function () { flash(c); }); }));
        (DATA.smoke || []).forEach(function (s) {
            g.appendChild(makeCard(s.label, function (c) {
                post('rmeApply', { kind: 'smoke', r: s.r, g: s.g, b: s.b }, function () { flash(c); });
            }, { swatch: rgbCss(s) }));
        });
        ct.appendChild(g);
    }

    function renderXenon() {
        var ct = content();
        addReqNote(ct, 'xenon');
        var g = el('div', 'rme-grid');
        g.appendChild(makeCard('Xenon Off', function (c) { post('rmeApply', { kind: 'xenon', off: true }, function () { flash(c); }); }));
        (DATA.xenon || []).forEach(function (x) {
            g.appendChild(makeCard(x.label, function (c) {
                post('rmeApply', { kind: 'xenon', id: x.id }, function () { flash(c); });
            }));
        });
        ct.appendChild(g);
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
                post('rmeRepair', { kind: row[1] }, function () { flash(c); });
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
        wrap.appendChild(el('div', 'rme-bill-note', 'Enter the customer server ID (they can read it from the pause menu or a scoreboard). The customer must accept the invoice; payment is deposited into the Redline society account.'));
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
            case 'paint': renderPaint(); break;
            case 'wheels': renderWheels(); break;
            case 'exterior': renderSections(DATA.exterior); break;
            case 'interior': renderSections(DATA.interior); break;
            case 'neon': renderNeon(); break;
            case 'xenon': renderXenon(); break;
            case 'smoke': renderSmoke(); break;
            case 'tint': addReqNote(content(), 'tint'); optionGrid(content(), DATA.tint || [], function (o) { return { kind: 'tint', id: o.id }; }); break;
            case 'plate': addReqNote(content(), 'plate'); optionGrid(content(), DATA.plate || [], function (o) { return { kind: 'plate', id: o.id }; }); break;
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
