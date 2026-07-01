(function () {
    'use strict';
    var RES = 'qb-mechanicjob';
    var DATA = null;
    var PRICES = {};
    var selectedKinds = {};

    var CATS = [
        { id: 'paint', label: 'Paint', icon: 'P' },
        { id: 'wheels', label: 'Wheels', icon: 'W' },
        { id: 'neon', label: 'Neon Kits', icon: 'N' },
        { id: 'smoke', label: 'Tire Smoke', icon: 'S' },
        { id: 'tint', label: 'Window Tint', icon: 'T' },
        { id: 'plate', label: 'Plate Style', icon: 'L' }
    ];

    function el(tag, cls, html) {
        var e = document.createElement(tag);
        if (cls) e.className = cls;
        if (html !== undefined) e.innerHTML = html;
        return e;
    }
    function root() { return document.getElementById('rmo-order'); }
    function content() { return document.getElementById('rmo-content'); }
    function rgbCss(o) { return 'rgb(' + o.r + ',' + o.g + ',' + o.b + ')'; }
    function hexCss(h) { return (String(h).charAt(0) === '#') ? h : ('#' + h); }

    function post(name, body, cb) {
        fetch('https://' + RES + '/' + name, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify(body || {})
        }).then(function (r) {
            return r.json().catch(function () { return null; });
        }).then(function (d) { if (cb) cb(d); }).catch(function () { if (cb) cb(null); });
    }

    // Single running total. A cosmetic CATEGORY is billed once (no per-click
    // amounts); turning a category off removes its price again.
    function setKind(kind, active) {
        if (!kind) return;
        if (active) selectedKinds[kind] = true;
        else delete selectedKinds[kind];
        renderTotal();
    }
    function computeTotal() {
        var t = 0;
        for (var k in selectedKinds) {
            if (selectedKinds.hasOwnProperty(k) && selectedKinds[k]) {
                t += (PRICES[k] || 0);
            }
        }
        return t;
    }
    function renderTotal() {
        var e = document.getElementById('rmo-total-amt');
        if (e) e.textContent = '$' + computeTotal();
    }

    function flash(card) {
        if (!card) return;
        card.classList.add('rmo-applied');
        setTimeout(function () { card.classList.remove('rmo-applied'); }, 500);
    }

    function selectOne(group, card) {
        if (!group) return;
        var cards = group.querySelectorAll('.rmo-card');
        for (var i = 0; i < cards.length; i++) cards[i].classList.remove('rmo-selected');
        if (card) card.classList.add('rmo-selected');
    }

    function makeCard(label, onClick, opt) {
        opt = opt || {};
        var c = el('div', 'rmo-card');
        if (opt.swatch) {
            var dot = el('span', 'rmo-swatch');
            dot.style.background = opt.swatch;
            c.appendChild(dot);
        }
        c.appendChild(el('span', 'rmo-card-label', label));
        if (opt.arrow) c.appendChild(el('span', 'rmo-arrow', '\u203A'));
        c.addEventListener('click', function () { if (onClick) onClick(c); });
        return c;
    }

    function renderPaint() {
        var ct = content();
        ['primary', 'secondary'].forEach(function (section) {
            ct.appendChild(el('div', 'rmo-section-title', section === 'primary' ? 'Primary Color' : 'Secondary Color'));
            (DATA.paint || []).forEach(function (grp) {
                ct.appendChild(el('div', 'rmo-group-title', grp.name));
                var g = el('div', 'rmo-grid');
                grp.colors.forEach(function (col) {
                    g.appendChild(makeCard(col.label, function (c) {
                        selectOne(g, c);
                        setKind('paint', true);
                        post('rmoPreview', { kind: 'paint', section: section, colorId: col.id, label: col.label }, function () { flash(c); });
                    }, { swatch: hexCss(col.hex) }));
                });
                ct.appendChild(g);
            });
        });
    }

    function renderWheels() {
        var ct = content();
        ct.appendChild(el('div', 'rmo-section-title', 'Wheel Types'));
        var g = el('div', 'rmo-grid');
        (DATA.wheelCats || []).forEach(function (cat) {
            g.appendChild(makeCard(cat.label, function () {
                post('rmoWheelList', { id: cat.id }, function (list) { renderWheelList(cat, list || []); });
            }, { arrow: true }));
        });
        ct.appendChild(g);
    }

    function renderWheelList(cat, list) {
        var ct = content();
        ct.innerHTML = '';
        var back = el('div', 'rmo-back', '\u2190 Back to wheel types');
        back.addEventListener('click', function () { selectCat('wheels'); });
        ct.appendChild(back);
        ct.appendChild(el('div', 'rmo-section-title', cat.label));
        var g = el('div', 'rmo-grid');
        list.forEach(function (o) {
            g.appendChild(makeCard(o.label, function (c) {
                selectOne(g, c);
                setKind('wheel', o.index !== -1);
                post('rmoPreview', { kind: 'wheel', wheelType: cat.id, index: o.index, label: cat.label + ' - ' + o.label }, function () { flash(c); });
            }));
        });
        ct.appendChild(g);
    }

    function renderSwatchList(kind, items, payloadFn, withOff, offLabel) {
        var ct = content();
        var g = el('div', 'rmo-grid');
        if (withOff) {
            g.appendChild(makeCard(offLabel || 'Off', function (c) {
                selectOne(g, c);
                setKind(kind, false);
                post('rmoPreview', payloadFn({ off: true }), function () { flash(c); });
            }));
        }
        items.forEach(function (o) {
            var sw = (o.r !== undefined) ? { swatch: rgbCss(o) } : undefined;
            g.appendChild(makeCard(o.label, function (c) {
                selectOne(g, c);
                setKind(kind, true);
                post('rmoPreview', payloadFn(o), function () { flash(c); });
            }, sw));
        });
        ct.appendChild(g);
    }

    function selectCat(id) {
        var nav = document.getElementById('rmo-nav');
        if (nav) {
            var btns = nav.querySelectorAll('.rmo-cat');
            for (var i = 0; i < btns.length; i++) {
                btns[i].classList.toggle('active', btns[i].getAttribute('data-cat') === id);
            }
        }
        var ct = content();
        if (ct) ct.innerHTML = '';
        switch (id) {
            case 'paint': renderPaint(); break;
            case 'wheels': renderWheels(); break;
            case 'neon': renderSwatchList('neon', DATA.neon || [], function (o) { return o.off ? { kind: 'neon', off: true } : { kind: 'neon', r: o.r, g: o.g, b: o.b, label: o.label }; }, true, 'Neons Off'); break;
            case 'smoke': renderSwatchList('smoke', DATA.smoke || [], function (o) { return o.off ? { kind: 'smoke', off: true } : { kind: 'smoke', r: o.r, g: o.g, b: o.b, label: o.label }; }, true, 'Smoke Off'); break;
            case 'tint': renderSwatchList('tint', DATA.tint || [], function (o) { return { kind: 'tint', id: o.id, label: o.label }; }, false); break;
            case 'plate': renderSwatchList('plate', DATA.plateStyles || [], function (o) { return { kind: 'plate', id: o.id, label: o.label }; }, false); break;
        }
    }

    function camBtn(dir, label) {
        var b = el('button', 'rmo-cam-btn', label);
        b.addEventListener('click', function () { post('rmoCam', { dir: dir }); });
        return b;
    }

    function buildShell() {
        var r = root();
        r.innerHTML = '';
        var panel = el('div', 'rmo-panel');

        var header = el('div', 'rmo-header');
        var brand = el('div', 'rmo-brand');
        brand.appendChild(el('span', 'rmo-brand-main', 'REDLINE'));
        brand.appendChild(el('span', 'rmo-brand-sub', 'MOTORSPORT \u00B7 ORDER BUILDER'));
        var veh = el('div', 'rmo-veh');
        veh.appendChild(el('div', 'rmo-veh-name', DATA.name || 'Vehicle'));
        veh.appendChild(el('div', 'rmo-veh-plate', 'PLATE \u00B7 ' + (DATA.plate || '')));
        header.appendChild(brand);
        header.appendChild(veh);

        var body = el('div', 'rmo-body');
        var nav = el('div', 'rmo-nav');
        nav.id = 'rmo-nav';
        CATS.forEach(function (c) {
            var b = el('button', 'rmo-cat');
            b.setAttribute('data-cat', c.id);
            b.innerHTML = '<span class="rmo-cat-ico">' + c.icon + '</span><span>' + c.label + '</span>';
            b.addEventListener('click', function () { selectCat(c.id); });
            nav.appendChild(b);
        });
        var ct = el('div', 'rmo-content');
        ct.id = 'rmo-content';
        body.appendChild(nav);
        body.appendChild(ct);

        var footer = el('div', 'rmo-footer');
        var cam = el('div', 'rmo-cam');
        cam.appendChild(el('span', 'rmo-cam-label', 'Camera'));
        cam.appendChild(camBtn('left', '\u2039'));
        cam.appendChild(camBtn('right', '\u203A'));
        cam.appendChild(camBtn('up', '\u25B2'));
        cam.appendChild(camBtn('down', '\u25BC'));
        cam.appendChild(camBtn('in', '+'));
        cam.appendChild(camBtn('out', '\u2212'));
        var actions = el('div', 'rmo-actions');
        var total = el('div', 'rmo-total');
        total.style.display = 'flex';
        total.style.alignItems = 'center';
        total.style.gap = '8px';
        total.style.marginRight = '16px';
        total.style.fontWeight = '700';
        total.style.color = '#fff';
        total.innerHTML = '<span style="opacity:.7;font-weight:500;letter-spacing:1px;">TOTAL</span><span id="rmo-total-amt" style="color:#ff3b3b;font-size:20px;">$0</span>';
        var cancel = el('button', 'rmo-btn rmo-btn-ghost', 'Cancel');
        cancel.addEventListener('click', function () { post('rmoClose', {}, function () { hide(); }); });
        var submit = el('button', 'rmo-btn rmo-btn-primary', 'Submit Order');
        submit.addEventListener('click', function () {
            post('rmoSubmit', {}, function (d) { if (d === 'ok' || d === null) hide(); });
        });
        actions.appendChild(total);
        actions.appendChild(cancel);
        actions.appendChild(submit);
        footer.appendChild(cam);
        footer.appendChild(actions);

        panel.appendChild(header);
        panel.appendChild(body);
        panel.appendChild(footer);
        r.appendChild(panel);
    }

    function show() { root().classList.remove('rmo-hidden'); }
    function hide() { root().classList.add('rmo-hidden'); }

    window.addEventListener('message', function (e) {
        var d = e.data || {};
        if (d.action === 'openRedlineOrder') {
            DATA = d.data || {};
            PRICES = DATA.prices || {};
            selectedKinds = {};
            buildShell();
            selectCat('paint');
            renderTotal();
            show();
        } else if (d.action === 'closeRedlineOrder') {
            hide();
        }
    });
})();
