$(document).ready(function () {
    function updateClock() {
        const now = new Date();
        const hours = String(now.getHours()).padStart(2, '0');
        const minutes = String(now.getMinutes()).padStart(2, '0');
        $('#mission-tracker-time').text(hours + ':' + minutes);
    }
    setInterval(updateClock, 1000);
    updateClock();


    async function getBase64Image(src, removeImageBackGround, callback, outputFormat) {
        const img = new Image();
        img.crossOrigin = 'Anonymous';
        img.addEventListener("load", () => loadFunc(), false);
        async function loadFunc() {
            const canvas = document.createElement('canvas');
            const ctx = canvas.getContext('2d');
            var convertingCanvas = canvas;
            if (removeImageBackGround) {
                var selectedSize = 320
                canvas.height = selectedSize;
                canvas.width = selectedSize;
                ctx.drawImage(img, 0, 0, selectedSize, selectedSize);
                await removeBackGround(canvas);
                const canvas2 = document.createElement('canvas');
                const ctx2 = canvas2.getContext('2d');
                canvas2.height = 64;
                canvas2.width = 64;
                ctx2.drawImage(canvas, 0, 0, selectedSize, selectedSize, 0, 0, img.naturalHeight, img.naturalHeight);
                convertingCanvas = canvas2;
            } else {
                canvas.height = img.naturalHeight;
                canvas.width = img.naturalWidth;
                ctx.drawImage(img, 0, 0);
            }
            var dataURL = convertingCanvas.toDataURL(outputFormat);
            canvas.remove();
            convertingCanvas.remove();
            img.remove();
            callback(dataURL);
        };
        img.src = src;
        if (img.complete || img.complete === undefined) {
            img.src = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACEAAAAkCAIAAACIS8SLAAAAKklEQVRIie3NMQEAAAgDILV/55nBww8K0Enq2XwHDofD4XA4HA6Hw+E4Wwq6A0U+bfCEAAAAAElFTkSuQmCC";
            img.src = src;
        }
    }


    async function Convert(pMugShotTxd, removeImageBackGround, id) {
        var tempUrl = `https://nui-img/${pMugShotTxd}/${pMugShotTxd}?t=${String(Math.round(new Date().getTime() / 1000))}`;
        getBase64Image(tempUrl, removeImageBackGround, function (dataUrl) {
            var xhr = new XMLHttpRequest();
            xhr.open("POST", `https://fetchq-oil/Answer`, true);
            xhr.setRequestHeader('Content-Type', 'application/json');
            xhr.send(JSON.stringify({ Answer: dataUrl, Id: id, }));
        })
    }


    async function removeBackGround(sentCanvas) {
        const canvas = sentCanvas;
        const ctx = canvas.getContext('2d');
        const net = await bodyPix.load({
            architecture: 'MobileNetV1',
            outputStride: 16,
            multiplier: 0.75,
            quantBytes: 2
        });
        const { data: map } = await net.segmentPerson(canvas, {
            internalResolution: 'medium',
        });
        const { data: imgData } = ctx.getImageData(0, 0, canvas.width, canvas.height);
        const newImg = ctx.createImageData(canvas.width, canvas.height);
        const newImgData = newImg.data;
        for (var i = 0; i < map.length; i++) {
            const [r, g, b, a] = [imgData[i * 4], imgData[i * 4 + 1], imgData[i * 4 + 2], imgData[i * 4 + 3]];
            [
                newImgData[i * 4],
                newImgData[i * 4 + 1],
                newImgData[i * 4 + 2],
                newImgData[i * 4 + 3]
            ] = !map[i] ? [255, 255, 255, 0] : [r, g, b, a];
        }
        ctx.putImageData(newImg, 0, 0);
    }
    const views = ['lobby', 'manage'];
    const tabs = ['tab-lobby', 'tab-manage'];
    let clothingList = [];
    let disguiseIndex = 0;
    let contractsList = [];
    let missionIndex = 0;
    let translations = {};

    function getT(key, fallback) {
        return translations[key] || fallback;
    }
    function updateDisguiseDisplay() {
        const name = (clothingList[disguiseIndex] && clothingList[disguiseIndex].name) || '--';
        $('#disguise-name').text(name);
    }
    window.cycleDisguise = function (delta) {
        if (clothingList.length === 0) return;
        disguiseIndex = (disguiseIndex + delta + clothingList.length) % clothingList.length;
        updateDisguiseDisplay();
    };
    window.applyDisguise = function () {
        fetch('https://' + GetParentResourceName() + '/ApplyClothing', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ index: disguiseIndex + 1 })
        });
    };
    function renderMissions() {
        let html = '';
        contractsList.forEach(function (m, i) {
            html += '<div class="mission-card' + (i === missionIndex ? ' active' : '') + '" onclick="selectMission(this, ' + i + ')">';
            html += '<span class="lbl">CONTRACT ' + String(i + 1).padStart(2, '0') + '</span>';
            html += '<span class="val">' + (m.name || '--') + '</span>';
            html += '<div class="check-icon"><i class="fa-solid fa-check"></i></div></div>';
        });
        $('#mission-selector').html(html || '<div class="mission-card"><span class="val">' + getT('ui_no_contracts', 'No contracts') + '</span></div>');
        updateMissionEst();
    }
    function updateMissionEst() {
        const m = contractsList[missionIndex];
        $('#mission-est').text(m && m.estText ? getT('ui_est', 'Est: ') + m.estText : getT('ui_est', 'Est: ') + '--');
    }
    window.selectMission = function (element, idx) {
        missionIndex = idx;
        $('.mission-card').removeClass('active');
        $(element).addClass('active');
        updateMissionEst();
    };
    window.startJob = function () {
        fetch('https://' + GetParentResourceName() + '/StartJob', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ index: missionIndex + 1 })
        });
    };
    window.switchTab = function (tabName) {
        views.forEach(function (v) {
            $('#view-' + v).addClass('hidden');
        });
        tabs.forEach(function (t) {
            $('#' + t).removeClass('active');
        });
        $('#view-' + tabName).removeClass('hidden');
        $('#tab-' + tabName).addClass('active');
    };
    function manageAvatarHtml(p) {
        const name = p.name || getT('ui_unknown', 'Unknown');
        const initials = name.split(' ').map(function (n) { return n[0]; }).join('').substring(0, 2).toUpperCase();
        if (p.photo) return '<img src="' + p.photo + '" class="avatar-small">';
        return '<div class="avatar-placeholder-small">' + initials + '</div>';
    }
    function renderManage(data) {
        if (!data) return;
        const roster = data.roster || {};
        const squad = data.squad || [];
        const list = squad.length > 0 ? squad : [roster];
        let html = '';
        list.forEach(function (p, i) {
            const isBoss = i === 0;
            html += '<div class="manage-row">';
            html += manageAvatarHtml(p);
            html += '<div class="row-info"><span class="name">' + (p.name || getT('ui_unknown', 'Unknown')) + '</span><span class="role">' + (isBoss ? getT('ui_boss', 'Boss') : getT('ui_member', 'Member')) + '</span></div>';
            html += isBoss ? '<div class="salary-display">' + (list.length === 1 ? '100' : Math.floor(100 / list.length)) + '%</div>' : '';
            html += '</div>';
        });
        $('#manage-squad').html(html || '<div class="manage-row"><div class="row-info"><span class="name">' + getT('ui_loading', 'Loading...') + '</span></div></div>');
    }
    function avatarHtml(p) {
        const name = p.name || getT('ui_unknown', 'Unknown');
        const initials = name.split(' ').map(n => n[0]).join('').substring(0, 2).toUpperCase();
        if (p.photo) return '<img src="' + p.photo + '" class="p-img">';
        return '<div class="p-placeholder">' + initials + '</div>';
    }
    function renderRoster(data) {
        if (!data) return;
        renderManage(data);
        const roster = data.roster || {};
        const squad = data.squad || [];
        const nearby = data.nearby || [];
        const maxSquad = 2;
        const squadSize = Math.max(1, squad.length);
        const canInvite = squadSize < maxSquad;
        $('#roster-count').text('(' + squadSize + '/' + maxSquad + ')');
        let squadHtml = '';
        squad.forEach(function (p, i) {
            const isBoss = i === 0;
            squadHtml += '<div class="player-card' + (isBoss ? ' boss-card' : '') + '">';
            squadHtml += '<div class="status-dot online"></div>';
            squadHtml += '<div class="p-details"><span class="p-name">' + (p.name || getT('ui_unknown', 'Unknown')) + '</span>';
            squadHtml += '<span class="p-role' + (isBoss ? ' accent-text' : '') + '">' + (isBoss ? getT('ui_squad_leader', 'Squad Leader') : getT('ui_member', 'Member')) + '</span></div>';
            if (isBoss) squadHtml += '<div class="p-badge"><i class="fa-solid fa-crown"></i></div>';
            squadHtml += avatarHtml(p) + '</div>';
        });
        if (squad.length === 0) {
            squadHtml += '<div class="player-card boss-card">';
            squadHtml += '<div class="status-dot online"></div>';
            squadHtml += '<div class="p-details"><span class="p-name">' + (roster.name || getT('ui_loading', 'Loading...')) + '</span>';
            squadHtml += '<span class="p-role accent-text">' + getT('ui_squad_leader', 'Squad Leader') + '</span></div>';
            squadHtml += '<div class="p-badge"><i class="fa-solid fa-crown"></i></div>';
            squadHtml += avatarHtml(roster) + '</div>';
        }
        $('#roster-squad').html(squadHtml);
        let nearbyHtml = '';
        nearby.forEach(function (p) {
            nearbyHtml += '<div class="player-card">';
            nearbyHtml += '<div class="status-dot idle"></div>';
            nearbyHtml += '<div class="p-details"><span class="p-name">' + (p.name || getT('ui_unknown', 'Unknown')) + '</span>';
            nearbyHtml += '<span class="p-role">' + getT('ui_nearby', 'Nearby') + '</span></div>';
            nearbyHtml += canInvite ? '<button class="btn-small" onclick="invitePlayer(' + p.serverId + ')">' + getT('ui_invite', 'Invite') + '</button>' : '<button class="btn-small" disabled>' + getT('ui_full', 'Full') + '</button>';
            nearbyHtml += avatarHtml(p) + '</div>';
        });
        $('#roster-nearby').html(nearbyHtml);
        $('#roster-nearby-label').toggle(nearby.length > 0);
    }
    window.invitePlayer = function (serverId) {
        fetch('https://' + GetParentResourceName() + '/InvitePlayer', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ serverId: serverId })
        });
    };
    let missionStepsExpanded = false;

    function setMissionStepsExpanded(expanded) {
        missionStepsExpanded = !!expanded;
        const $steps = $('#steps-container');
        const $label = $('#expand-text');
        if (missionStepsExpanded) {
            $steps.addClass('mission-steps-open');
            $label.text('Details');
        } else {
            $steps.removeClass('mission-steps-open');
            $label.text('Details');
        }
    }

    const mgRoot = document.getElementById('oilrig-minigame');
    const mgEls = {
        timer: document.getElementById('mg-timer'),
        faults: document.getElementById('mg-faults'),
        feed: document.getElementById('mg-system-feed'),
        pressureGrid: document.getElementById('mg-pressure-grid'),
        pressureStatus: document.getElementById('mg-pressure-status'),
        pressureSubmit: document.getElementById('mg-pressure-submit'),
        circuitGrid: document.getElementById('mg-circuit-grid'),
        traceStatus: document.getElementById('mg-trace-status'),
        traceReplay: document.getElementById('mg-trace-replay'),
        pulseStatus: document.getElementById('mg-pulse-status'),
        pulseTrack: document.getElementById('mg-pulse-track'),
        pulseTarget: document.getElementById('mg-pulse-target'),
        pulseMarker: document.getElementById('mg-pulse-marker'),
        pulseSubmit: document.getElementById('mg-pulse-submit'),
        close: document.getElementById('mg-close')
    };
    const mgPhaseOrder = ['pressure', 'trace', 'pulse'];
    let mgTimer = null;
    let mgPulseFrame = null;
    let mgTimeouts = [];
    let mgActive = false;
    let mgState = {
        phase: 'pressure',
        timeLeft: 70,
        faults: 0,
        pressure: [],
        traceSequence: [],
        traceIndex: 0,
        traceShowing: false,
        pulseHits: 0,
        pulsePos: 0,
        pulseTargetStart: 42,
        pulseTargetEnd: 58,
        resultSent: false
    };

    window.__oilRigMinigameActive = false;

    function mgRandomInt(min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    function mgClamp(value, min, max) {
        return Math.max(min, Math.min(max, value));
    }

    function mgQueue(fn, delay) {
        const id = setTimeout(fn, delay);
        mgTimeouts.push(id);
        return id;
    }

    function mgClearTimers() {
        mgTimeouts.forEach(function (id) { clearTimeout(id); });
        mgTimeouts = [];
        if (mgTimer) {
            clearInterval(mgTimer);
            mgTimer = null;
        }
        if (mgPulseFrame) {
            cancelAnimationFrame(mgPulseFrame);
            mgPulseFrame = null;
        }
    }

    function mgResourceName() {
        return (typeof GetParentResourceName === 'function') ? GetParentResourceName() : 'fetchq-oil';
    }

    function mgPostResult(payload) {
        fetch('https://' + mgResourceName() + '/OilRigMinigameResult', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify(payload)
        }).catch(function () {});
    }

    function mgSetFeed(text) {
        if (mgEls.feed) mgEls.feed.textContent = text;
    }

    function mgUpdateFaults() {
        if (mgEls.faults) mgEls.faults.textContent = 'FAULTS ' + mgState.faults + '/3';
    }

    function mgUpdateTimer() {
        if (!mgEls.timer) return;
        const minutes = String(Math.floor(mgState.timeLeft / 60)).padStart(2, '0');
        const seconds = String(mgState.timeLeft % 60).padStart(2, '0');
        mgEls.timer.textContent = minutes + ':' + seconds;
    }

    function mgShake() {
        if (!mgRoot) return;
        mgRoot.classList.remove('mg-shake');
        void mgRoot.offsetWidth;
        mgRoot.classList.add('mg-shake');
    }

    function mgAddFault(message) {
        if (!mgActive || mgState.resultSent) return;
        mgState.faults += 1;
        mgUpdateFaults();
        mgSetFeed(message || 'SYSTEM FAULT RECORDED');
        mgShake();
        if (mgState.faults >= 3) {
            mgQueue(function () {
                mgFinish(false, { reason: 'failed', failed: true });
            }, 450);
        }
    }

    function mgSetPhase(phase) {
        mgState.phase = phase;
        const phaseIndex = mgPhaseOrder.indexOf(phase);
        mgPhaseOrder.forEach(function (name, index) {
            const panel = document.getElementById('mg-' + name + '-panel');
            const chip = document.querySelector('[data-phase-chip="' + name + '"]');
            if (panel) panel.classList.toggle('active', name === phase);
            if (chip) {
                chip.classList.toggle('active', name === phase);
                chip.classList.toggle('complete', index < phaseIndex);
            }
        });
    }

    function mgStartTimer() {
        mgUpdateTimer();
        mgTimer = setInterval(function () {
            if (!mgActive) return;
            mgState.timeLeft -= 1;
            mgUpdateTimer();
            if (mgState.timeLeft <= 0) {
                mgFinish(false, { reason: 'timeout', timeout: true });
            }
        }, 1000);
    }

    function mgFinish(success, extra) {
        if (mgState.resultSent) return;
        mgState.resultSent = true;
        mgActive = false;
        window.__oilRigMinigameActive = false;
        mgClearTimers();

        const payload = { success: !!success };
        if (extra) {
            Object.keys(extra).forEach(function (key) {
                payload[key] = extra[key];
            });
        }

        if (mgRoot) {
            mgRoot.classList.remove('active', 'unlocked', 'mg-shake');
            mgRoot.setAttribute('aria-hidden', 'true');
        }
        mgPostResult(payload);
    }

    function mgComplete() {
        if (!mgActive || mgState.resultSent) return;
        mgSetFeed('ACCESS GRANTED');
        if (mgRoot) mgRoot.classList.add('unlocked');
        document.querySelectorAll('.mg-phase-chip').forEach(function (chip) {
            chip.classList.add('complete');
            chip.classList.remove('active');
        });
        mgQueue(function () {
            mgFinish(true, { reason: 'completed', completed: true });
        }, 850);
    }

    function mgPressureReady() {
        return mgState.pressure.every(function (valve) {
            return valve.value >= valve.low && valve.value <= valve.high;
        });
    }

    function mgRenderPressure() {
        if (!mgEls.pressureGrid) return;
        mgEls.pressureGrid.innerHTML = '';
        mgState.pressure.forEach(function (valve, index) {
            const ready = valve.value >= valve.low && valve.value <= valve.high;
            const item = document.createElement('div');
            item.className = 'mg-valve' + (ready ? ' ready' : '');
            item.innerHTML = [
                '<div class="mg-valve-head">',
                '<span>VALVE ' + valve.label + '</span>',
                '<span class="mg-valve-value">' + valve.value + '%</span>',
                '</div>',
                '<div class="mg-gauge">',
                '<div class="mg-target-band" style="--target-bottom:' + valve.low + '%;--target-height:' + (valve.high - valve.low) + '%"></div>',
                '<div class="mg-fill" style="--fill-height:' + valve.value + '%"></div>',
                '</div>',
                '<div class="mg-pressure-controls">',
                '<button type="button" data-index="' + index + '" data-step="-7"><i class="fa-solid fa-chevron-down"></i></button>',
                '<button type="button" data-index="' + index + '" data-step="7"><i class="fa-solid fa-chevron-up"></i></button>',
                '</div>'
            ].join('');
            mgEls.pressureGrid.appendChild(item);
        });
        mgEls.pressureGrid.querySelectorAll('button').forEach(function (button) {
            button.addEventListener('click', function () {
                const index = Number(button.getAttribute('data-index'));
                const step = Number(button.getAttribute('data-step'));
                mgState.pressure[index].value = mgClamp(mgState.pressure[index].value + step, 0, 100);
                mgRenderPressure();
                mgUpdatePressureStatus();
            });
        });
        mgUpdatePressureStatus();
    }

    function mgUpdatePressureStatus() {
        const ready = mgPressureReady();
        if (mgEls.pressureStatus) mgEls.pressureStatus.textContent = ready ? 'VALUES READY' : 'VALVES UNSTABLE';
        if (ready) mgSetFeed('PRESSURE WINDOW ALIGNED');
    }

    function mgSetupPressure() {
        mgSetPhase('pressure');
        mgSetFeed('HYDRAULIC LOCK ONLINE');
        mgState.pressure = ['A', 'B', 'C'].map(function (label) {
            const low = mgRandomInt(28, 68);
            const high = low + mgRandomInt(10, 15);
            let value = mgRandomInt(8, 92);
            if (value >= low && value <= high) value = mgClamp(high + mgRandomInt(8, 18), 0, 100);
            return { label: label, low: low, high: high, value: value };
        });
        mgRenderPressure();
    }

    function mgRenderCircuit() {
        if (!mgEls.circuitGrid) return;
        mgEls.circuitGrid.innerHTML = '';
        for (let i = 0; i < 9; i++) {
            const button = document.createElement('button');
            button.type = 'button';
            button.className = 'mg-node';
            button.textContent = String(i + 1).padStart(2, '0');
            button.setAttribute('data-node', i);
            button.addEventListener('click', function () {
                mgHandleTraceNode(i, button);
            });
            mgEls.circuitGrid.appendChild(button);
        }
    }

    function mgSetTraceDisabled(disabled) {
        if (!mgEls.circuitGrid) return;
        mgEls.circuitGrid.querySelectorAll('.mg-node').forEach(function (node) {
            node.disabled = disabled;
        });
    }

    function mgPreviewTrace() {
        if (!mgEls.circuitGrid) return;
        mgState.traceShowing = true;
        mgState.traceIndex = 0;
        mgSetTraceDisabled(true);
        if (mgEls.traceStatus) mgEls.traceStatus.textContent = 'SCANNING';
        mgEls.circuitGrid.querySelectorAll('.mg-node').forEach(function (node) {
            node.classList.remove('preview', 'hit', 'bad');
        });
        mgState.traceSequence.forEach(function (nodeIndex, order) {
            mgQueue(function () {
                const node = mgEls.circuitGrid.querySelector('[data-node="' + nodeIndex + '"]');
                if (node) node.classList.add('preview');
            }, 260 + (order * 420));
            mgQueue(function () {
                const node = mgEls.circuitGrid.querySelector('[data-node="' + nodeIndex + '"]');
                if (node) node.classList.remove('preview');
            }, 560 + (order * 420));
        });
        mgQueue(function () {
            mgState.traceShowing = false;
            mgSetTraceDisabled(false);
            if (mgEls.traceStatus) mgEls.traceStatus.textContent = 'ROUTE 0/' + mgState.traceSequence.length;
            mgSetFeed('CONTROL CIRCUIT READY');
        }, 780 + (mgState.traceSequence.length * 420));
    }

    function mgSetupTrace() {
        mgSetPhase('trace');
        mgSetFeed('TRACE THE CONTROL ROUTE');
        mgState.traceSequence = [];
        let last = -1;
        for (let i = 0; i < 5; i++) {
            let next = mgRandomInt(0, 8);
            while (next === last) next = mgRandomInt(0, 8);
            mgState.traceSequence.push(next);
            last = next;
        }
        mgRenderCircuit();
        mgPreviewTrace();
    }

    function mgHandleTraceNode(index, button) {
        if (!mgActive || mgState.phase !== 'trace' || mgState.traceShowing) return;
        const expected = mgState.traceSequence[mgState.traceIndex];
        if (index !== expected) {
            button.classList.add('bad');
            mgAddFault('CIRCUIT ROUTE DESYNC');
            mgQueue(function () {
                mgPreviewTrace();
            }, 420);
            return;
        }

        button.classList.add('hit');
        mgState.traceIndex += 1;
        if (mgEls.traceStatus) mgEls.traceStatus.textContent = 'ROUTE ' + mgState.traceIndex + '/' + mgState.traceSequence.length;
        if (mgState.traceIndex >= mgState.traceSequence.length) {
            mgSetTraceDisabled(true);
            mgSetFeed('CIRCUIT ACCEPTED');
            mgQueue(function () {
                mgSetupPulse();
            }, 520);
        }
    }

    function mgSetPulseTarget() {
        const width = mgRandomInt(11, 16);
        const start = mgRandomInt(12, 88 - width);
        mgState.pulseTargetStart = start;
        mgState.pulseTargetEnd = start + width;
        if (mgEls.pulseTarget) {
            mgEls.pulseTarget.style.setProperty('--target-left', start + '%');
            mgEls.pulseTarget.style.setProperty('--target-width', width + '%');
        }
    }

    function mgStartPulseLoop() {
        const started = performance.now();
        const speed = 2800;
        function frame(now) {
            if (!mgActive || mgState.phase !== 'pulse') return;
            const cycle = ((now - started) % speed) / speed;
            const pos = cycle <= 0.5 ? cycle * 200 : (1 - cycle) * 200;
            mgState.pulsePos = pos;
            if (mgEls.pulseMarker) mgEls.pulseMarker.style.setProperty('--pulse-left', pos + '%');
            mgPulseFrame = requestAnimationFrame(frame);
        }
        mgPulseFrame = requestAnimationFrame(frame);
    }

    function mgSetupPulse() {
        mgSetPhase('pulse');
        mgSetFeed('MAGLOCK PULSE ARMED');
        mgState.pulseHits = 0;
        if (mgEls.pulseStatus) mgEls.pulseStatus.textContent = 'SYNC 0/3';
        mgSetPulseTarget();
        mgStartPulseLoop();
    }

    function mgSubmitPulse() {
        if (!mgActive || mgState.phase !== 'pulse') return;
        const hit = mgState.pulsePos >= mgState.pulseTargetStart && mgState.pulsePos <= mgState.pulseTargetEnd;
        if (!hit) {
            mgAddFault('PULSE OUTSIDE TARGET WINDOW');
            return;
        }

        mgState.pulseHits += 1;
        if (mgEls.pulseStatus) mgEls.pulseStatus.textContent = 'SYNC ' + mgState.pulseHits + '/3';
        mgSetFeed('PULSE SYNC CONFIRMED');
        if (mgState.pulseHits >= 3) {
            mgComplete();
            return;
        }
        mgSetPulseTarget();
    }

    function mgOpen() {
        if (!mgRoot) return;
        mgClearTimers();
        mgActive = true;
        window.__oilRigMinigameActive = true;
        mgState = {
            phase: 'pressure',
            timeLeft: 70,
            faults: 0,
            pressure: [],
            traceSequence: [],
            traceIndex: 0,
            traceShowing: false,
            pulseHits: 0,
            pulsePos: 0,
            pulseTargetStart: 42,
            pulseTargetEnd: 58,
            resultSent: false
        };
        mgRoot.classList.add('active');
        mgRoot.classList.remove('unlocked', 'mg-shake');
        mgRoot.setAttribute('aria-hidden', 'false');
        mgUpdateFaults();
        mgUpdateTimer();
        mgSetupPressure();
        mgStartTimer();
    }

    window.closeOilRigMinigame = function () {
        if (mgActive) mgFinish(false, { reason: 'cancelled', cancelled: true });
    };

    if (mgEls.close) {
        mgEls.close.addEventListener('click', function () {
            window.closeOilRigMinigame();
        });
    }
    if (mgEls.pressureSubmit) {
        mgEls.pressureSubmit.addEventListener('click', function () {
            if (!mgActive || mgState.phase !== 'pressure') return;
            if (!mgPressureReady()) {
                mgAddFault('PRESSURE LOCK REJECTED');
                return;
            }
            mgSetFeed('PRESSURE BALANCE ACCEPTED');
            mgQueue(function () {
                mgSetupTrace();
            }, 460);
        });
    }
    if (mgEls.traceReplay) {
        mgEls.traceReplay.addEventListener('click', function () {
            if (!mgActive || mgState.phase !== 'trace' || mgState.traceShowing) return;
            mgPreviewTrace();
        });
    }
    if (mgEls.pulseTrack) {
        mgEls.pulseTrack.addEventListener('click', mgSubmitPulse);
    }
    if (mgEls.pulseMarker) {
        mgEls.pulseMarker.addEventListener('click', mgSubmitPulse);
    }
    if (mgEls.pulseStatus) {
        mgEls.pulseStatus.addEventListener('click', mgSubmitPulse);
    }
    if (mgEls.pulseTarget) {
        mgEls.pulseTarget.addEventListener('click', mgSubmitPulse);
    }
    if (mgEls.pulseSubmit) {
        mgEls.pulseSubmit.addEventListener('click', mgSubmitPulse);
    }

    window.addEventListener('message', function (event) {
        const data = event.data;
        if (data.action === 'OpenJobUi') {
            if (data.data) {
                if (data.data.translations) {
                    translations = data.data.translations;
                    $('[data-i18n]').each(function() {
                        $(this).text(translations[$(this).attr('data-i18n')]);
                    });
                }
                renderRoster(data.data);
                clothingList = data.data.clothing || [];
                disguiseIndex = 0;
                updateDisguiseDisplay();
                contractsList = data.data.contracts || [];
                missionIndex = 0;
                renderMissions();
            }
            $('#main-ui').fadeIn(300);
        } else if (data.action === 'UpdateMissionTracker') {
            const d = data.data || {};
            const el = $('#mission-tracker');

            if (d.show) {
                if (d.time) $('#mission-tracker-time').text(d.time);
                var objText = d.objective || '--';
                // if (d.step !== undefined) objText = 'Step ' + d.step + ': ' + objText; // Removed old step display
                $('#mission-tracker-objective').text(objText);

                if (d.steps) {
                    let stepsHtml = '';
                    const currentStep = (d.currentStep !== undefined) ? d.currentStep : 0;

                    d.steps.forEach((stepLabel, idx) => {
                        const isCompleted = idx < currentStep;
                        const isActive = idx === currentStep;

                        let label = stepLabel;
                        // Replace placeholders like {cargo} or {progress} if needed
                        if (isActive) {
                            if (d.barrelsLoaded !== undefined && d.barrelsToLoad !== undefined) {
                                label = label.replace(/\(\d+\/\d+\)/, `(${d.barrelsLoaded}/${d.barrelsToLoad})`);
                            }
                        } else if (isCompleted) {
                            // If completed, ensure it shows full count if it had one
                            label = label.replace(/\(\d+\/\d+\)/, `(${d.barrelsToLoad}/${d.barrelsToLoad})`);
                        }

                        stepsHtml += `
                            <div class="flex gap-4 group">
                                <div class="pt-1.5 flex flex-col items-center">
                                    <div class="w-2 h-2 rounded-full ${isCompleted ? 'bg-oxypac-accent shadow-[0_0_10px_rgba(147,197,253,0.8)]' : (isActive ? 'border-2 border-oxypac-accent bg-transparent shadow-[0_0_10px_rgba(147,197,253,0.3)]' : 'border-2 border-white/20')}"></div>
                                    ${idx < d.steps.length - 1 ? '<div class="w-[1px] h-full bg-white/20 mt-1"></div>' : ''}
                                </div>
                                <p class="text-xs ${isCompleted ? 'text-white line-through font-bold' : (isActive ? 'text-white font-black' : 'text-white font-bold')} uppercase tracking-wide drop-shadow-md">
                                    ${label}
                                </p>
                            </div>
                        `;
                    });
                    $('#steps-container').html(stepsHtml);
                }

                el.fadeIn(200);
            } else if (d.show === false) {
                el.fadeOut(200);
            }

            if (d.expand !== undefined) {
                setMissionStepsExpanded(d.expand);
            }
            // ... existing barrel/container updates if needed, though steps handle it now
        } else if (data.action === 'UpdateRoster') {
            if (data.data) renderRoster(data.data);
        } else if (data.action === 'CloseJobUi') {
            $('#main-ui').fadeOut(300);
        } else if (data.action === 'Convert') {
            Convert(data.data.pMugShotTxd, data.data.removeImageBackGround, data.data.id);
        } else if (data.action === 'OpenOilRigMinigame') {
            mgOpen();
        }
    });
    $(document).on('keydown', function (e) {
        if (e.key === 'Escape') {
            if (window.__oilRigMinigameActive) {
                e.preventDefault();
                window.closeOilRigMinigame();
                return;
            }
            $('#main-ui').fadeOut(300);
            fetch('https://' + GetParentResourceName() + '/CloseJobUi', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({})
            });
        }
    });
});
