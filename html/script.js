let ButtonsData = [];
let Buttons = [];
let Button = [];

const closeMenu = () => {
    $.post(`https://${GetParentResourceName()}/closeMenu`);
    for (let i = 0; i < ButtonsData.length; i++) {
        $(".button").remove();
    };
    ButtonsData = [];
    Buttons = [];
    Button = [];
};

const drawButtons = (data) => {
    ButtonsData = data;
    for (let i = 0; i < ButtonsData.length; i++) {
        let header = ButtonsData[i].header;
        let message = ''

        if (ButtonsData[i].txt) {
            message = ButtonsData[i].txt
        }
        if (ButtonsData[i].text) {
            message = ButtonsData[i].text
        }

        let id = ButtonsData[i].id;
        let element;

        element = $(`
            <div class="button" id=` + id + `>
                <div class="header" id=` + id + `>` + header + `</div>
                <div class="text" id=` + id + `>` + message + `</div>
            </div>`);
        $('#buttons').append(element);
        Buttons[id] = element;
        if (ButtonsData[i].params) {
            Button[id] = ButtonsData[i].params
        };
    };
};

$(document).click(function (event) {
    let $target = $(event.target);
    if ($target.closest('.button').length && $('.button').is(":visible")) {
        let id = event.target.id;
        if (!Button[id]) return
        postData(id);
    }
});

const postData = (id) => {
    $.post(`https://${GetParentResourceName()}/clickedButton`, JSON.stringify(Button[id]));
    return closeMenu();
};

window.addEventListener("message", (event) => {
    const data = event.data;
    const infos = data.data;
    const action = data.action;
    switch (action) {
        case "OPEN_MENU":
            return drawButtons(infos);
        case "CLOSE_MENU":
            return closeMenu();
        default:
            return;
    };
});

document.onkeyup = function (event) {
    if (event.key == 'Escape') {
        closeMenu();
    };
};