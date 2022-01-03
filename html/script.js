let buttonParams = [];

const openMenu = (data = null) => {
    let html = "";
    data.forEach((item, index) => {
        let header = item.header;
        let message = item.txt || item.text;
        let isMenuHeader = item.isMenuHeader;
        html += getButtonRender(header, message, index, isMenuHeader);
        if (item.params) buttonParams[index] = item.params;
    });

    $("#buttons").html(html);
};

const showHeader = (data = null) => {
    let html = "";
    data.forEach((item, index) => {
        let header = item.header;
        let message = item.txt || item.text;
        let isMenuHeader = item.isMenuHeader;
        html += getButtonRender(header, message, index, isMenuHeader);
        if (item.params) buttonParams[index] = item.params;
    });
    $("#buttons").html(html);
}

const getButtonRender = (header, message = null, id, isMenuHeader) => {
    if (message) {
        return `
            <div class="${
                isMenuHeader ? "title" : "button"
            }" data-btn-id="${id}">
                <div class="header">${header}</div>
                <div class="text">${message}</div>
            </div>
        `;
    } else {
        return `
            <div class="${
                isMenuHeader ? "title" : "button"
            }" data-btn-id="${id}">
                <div class="header">${header}</div>
            </div>
        `;
    }
};

const closeMenu = () => {
    $("#buttons").html(" ");
    buttonParams = [];
};

const postData = (id) => {
    $.post(`https://${GetParentResourceName()}/clickedButton`, JSON.stringify(id + 1));
    return closeMenu();
};

const cancelMenu = () => {
    $.post(`https://${GetParentResourceName()}/closeMenu`);
    return closeMenu();
};

$(document).click(function (event) {
    let target = $(event.target);
    if (target.closest(".button").length && $(".button").is(":visible")) {
        let btnId = $(event.target).closest(".button").data("btn-id");
        postData(btnId);
    }
});

window.addEventListener("message", (event) => {
    const data = event.data;
    const buttons = data.data;
    const action = data.action;
    switch (action) {
        case "OPEN_MENU":
            return openMenu(buttons);
        case "SHOW_HEADER":
            return showHeader(buttons);
        case "CLOSE_MENU":
            return closeMenu();
        default:
            return;
    }
});

document.onkeyup = function (event) {
    const charCode = event.key;
    if (charCode == "Escape") {
        cancelMenu();
    }
};
