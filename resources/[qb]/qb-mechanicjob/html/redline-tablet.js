(function () {
    'use strict';
    var RES = 'qb-mechanicjob';
    var DATA = null;

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

    function renderPaint() {
        var ct = content();
        ['primary', 'secondary'].forEach(function (section) {
            ct.appendChild(el('div', 'rme-section-title', section === 'primary' ? 'Primary Color' : 'Secondary Color'));
            optionGrid(ct, PAINT, function (p) {
                return { kind: 'paint', section: section, r: p.r, g: p.g, b: p.b };
            }, function (p) { return rgbCss(p); });
        });
    }

    function renderWheels() {
        var ct = content();
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
        ct.appendChild(el('div', 'rme-section-title', cat.label));
        optionGrid(ct, list, function (o) {
            return { kind: 'wheel', wheelType: cat.id, index: o.index };
        });
    }

    function renderSections(sections) {
        var ct = content();
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
        var g = el('div', 'rme-grid');
        [['Full Repair', 'fullrepair'], ['Restore Worn Parts', 'parts'], ['Clean Vehicle', 'clean']].forEach(function (row) {
            g.appendChild(makeCard(row[0], function (c) {
                post('rmeRepair', { kind: row[1] }, function () { flash(c); });
            }));
        });
        ct.appendChild(g);
    }

    function renderBill() {
        var ct = content();
        var wrap = el('div', 'rme-bill');
        wrap.appendChild(el('div', 'rme-section-title', 'Invoice the nearest customer'));
        var input = el('input', 'rme-input');
        input.type = 'number';
        input.min = '1';
        input.placeholder = 'Amount ($)';
        var btn = el('button', 'rme-btn', 'Send Invoice');
        btn.addEventListener('click', function () {
            var amt = parseInt(input.value, 10);
            if (amt > 0) {
                post('rmeBill', { amount: amt });
                input.value = '';
            }
        });
        wrap.appendChild(input);
        wrap.appendChild(btn);
        wrap.appendChild(el('div', 'rme-bill-note', 'The customer must accept the invoice. Payment is deposited into the Redline society account.'));
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
            case 'paint': renderPaint(); break;
            case 'wheels': renderWheels(); break;
            case 'exterior': renderSections(DATA.exterior); break;
            case 'interior': renderSections(DATA.interior); break;
            case 'neon': renderNeon(); break;
            case 'xenon': renderXenon(); break;
            case 'smoke': renderSmoke(); break;
            case 'tint': optionGrid(content(), DATA.tint || [], function (o) { return { kind: 'tint', id: o.id }; }); break;
            case 'plate': optionGrid(content(), DATA.plate || [], function (o) { return { kind: 'plate', id: o.id }; }); break;
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
