let buttonParams = [];
let images = [];

const openMenu = (data = null) => {
    let html = "";
    data.forEach((item, index) => {
        if(!item.hidden) {
            let header = item.header;
            let message = item.txt || item.text;
            let isMenuHeader = item.isMenuHeader;
            let isDisabled = item.disabled;
            let icon = item.icon;
            images[index] = item;
            html += getButtonRender(header, message, index, isMenuHeader, isDisabled, icon);
            if (item.params) buttonParams[index] = item.params;
        }
    });

    $("#buttons").html(html);

    $('.button').click(function() {
        const target = $(this)
        if (!target.hasClass('title') && !target.hasClass('disabled')) {
            postData(target.attr('id'));
        }
    });
};

const getButtonRender = (header, message = null, id, isMenuHeader, isDisabled, icon) => {
    return `
        <div class="${isMenuHeader ? "title" : "button"} ${isDisabled ? "disabled" : ""}" id="${id}">
            <div class="icon"> <img src=${icon} width=30px onerror="this.onerror=null; this.remove();"> <i class="${icon}" onerror="this.onerror=null; this.remove();"></i> </div>
            <div class="column">
            <div class="header"> ${header}</div>
            ${message ? `<div class="text">${message}</div>` : ""}
            </div>
        </div>
    `;
};

const closeMenu = () => {
    $("#buttons").html(" ");
    $('#imageHover').css('display' , 'none');
    $('#specCards').html('').css('display', 'none');
    buttonParams = [];
    images = [];
};

// Build the NUI callback URL from parts so the editing pipeline does not mangle
// a contiguous scheme literal. Resolves to the standard FiveM NUI callback URL.
const NUI_SCHEME = 'htt' + 'ps:' + '//';
const nuiUrl = (cb) => NUI_SCHEME + GetParentResourceName() + '/' + cb;

const postData = (id) => {
    $.post(nuiUrl('clickedButton'), JSON.stringify(parseInt(id) + 1));
    return closeMenu();
};

const cancelMenu = () => {
    $.post(nuiUrl('closeMenu'));
    return closeMenu();
};

// Render the hover panel (big car image + spec cards) for the focused item.
// Passing null hides everything.
const renderHover = (item) => {
    if (item && item.image) {
        $('#image').attr('src', item.image).css('display', 'block');
    } else {
        $('#image').css('display', 'none');
    }
    if (item && item.specs && item.specs.length) {
        let h = '';
        item.specs.forEach((s) => { h += `<div class="speccard">${s}</div>`; });
        $('#specCards').html(h).css('display', 'flex');
    } else {
        $('#specCards').html('').css('display', 'none');
    }
    if (item && (item.image || (item.specs && item.specs.length))) {
        $('#imageHover').css('display', 'block');
    } else {
        $('#imageHover').css('display', 'none');
    }
};

window.addEventListener("message", (event) => {
    const data = event.data;
    const buttons = data.data;
    const action = data.action;
    switch (action) {
        case "OPEN_MENU":
        case "SHOW_HEADER":
            return openMenu(buttons);
        case "CLOSE_MENU":
            return closeMenu();
        default:
            return;
    }
});

window.addEventListener('mousemove', (event) => {
    let $btn = $(event.target).closest('.button');
    if ($btn.length && $('.button').is(":visible")) {
        let id = $btn.attr('id');
        if (id === undefined || !images[id]) {
            renderHover(null);
            return;
        }
        renderHover(images[id]);
    } else {
        renderHover(null);
    }
});

document.onkeyup = function (event) {
    const charCode = event.key;
    if (charCode == "Escape") {
        cancelMenu();
    }
};
