const MainUI = Vue.createApp({
    data() {
        return {
            MenuHTML: "",
            MenuStyle: {
                "display": "none",
            },
        };
    },
    destroyed() {
        window.removeEventListener("message", this.messageListener);
        window.removeEventListener("mousedown", this.mouseListener);
        window.removeEventListener("keydown", this.keyListener);
    },
    mounted() {
        this.messageListener = window.addEventListener("message", (event) => {
            switch (event.data.action) {
                case 'OpenUI':
                    this.OpenUI();
                    break;
                case 'OpenFullUI':
                    this.OpenFullUI(event.data);
                    break;
                case 'OpenTooltip':
                    this.OpenTooltip(event.data);
                    break;
                case 'CloseMenuFull':
                    this.CloseMenuFull();
                    break;
                case 'CloseMenu':
                    this.CloseMenu(event.data);
                    break;
                case 'ReopenTooltip':
                    this.ReopenTooltip();
                    break;
            }
        });

        this.mouseListener = window.addEventListener("mousedown", (event) => {
            let element = event.target;
            if (element.className && (element.className === 'desc' || element.className === 'title')) {
                element = element.parentElement;
            }
            const split = element.id.split("-");
            if (split[0] === 'button' && event.button == 0) {
                this.CloseMenuFull();
                $.post(`https://${GetParentResourceName()}/SelectOption`, JSON.stringify(Number(split[1]) + 1));
            }
        });

        this.keyListener = window.addEventListener("keydown", (event) => {
            if (event.key == 'Escape' || event.key == 'Backspace') {
                this.CloseMenu();
                $.post(`https://${GetParentResourceName()}/CloseMenu`);
            }
        });
    },
    methods: {
        OpenUI() {
            this.MenuStyle["display"] = "flex";
            const elements = document.querySelectorAll(".button");
            elements.forEach(function(item) {
                item.style.display = "block";
            });
        },
        OpenFullUI(data) {
            this.MenuStyle["display"] = "flex";
            let TempMenu = "";
            const menuopt = data.menu.buttons;
            menuopt.forEach(function(item, index) {
                if (item.type == 'header') {
                    TempMenu += "<button id='button-" + index + "' class='buttonheader'><div class='main'>" + item.title + "</div><div class='desc'>" + item.description + "</div></button>";
                } else {
                    TempMenu += "<button id='button-" + index + "' class='button' style='display:block;'><div class='main'>" + item.title + "</div><div class='desc'>" + item.description + "</div></button>";
                }
            });
            this.MenuHTML = TempMenu;
        },
        OpenTooltip(data) {
            this.MenuStyle["display"] = "flex";
            let TempMenu = "";
            const menuopt = data.menu.buttons;
            menuopt.forEach(function(item, index) {
                if (item.type == 'header') {
                    TempMenu += "<button id='button-" + index + "' class='buttonheader'><div class='main'>" + item.title + "</div><div class='desc'>" + item.description + "</div></button>";
                } else {
                    TempMenu += "<button id='button-" + index + "' class='button' style='display:none;'><div class='main'>" + item.title + "</div><div class='desc'>" + item.description + "</div></button>";
                }
            });
            this.MenuHTML = TempMenu;
        },
        CloseMenuFull() {
            this.MenuStyle["display"] = "none";
            this.MenuHTML = "";
        },
        ReopenTooltip(data) {
            this.MenuStyle["display"] = "flex";
            let TempMenu = "";
            const menuopt = data.menu.buttons;
            menuopt.forEach(function(item, index) {
                if (item.type == 'header') {
                    TempMenu += "<button id='button-" + index + "' class='buttonheader'><div class='main'>" + item.title + "</div><div class='desc'>" + item.description + "</div></button>";
                } else if (item.type == 'button') {
                    TempMenu += "<button id='button-" + index + "' class='button' style='display:none;'><div class='main'>" + item.title + "</div><div class='desc'>" + item.description + "</div></button>";
                }
            });
            this.MenuHTML = TempMenu;
        },
        CloseMenu() {
            this.MenuStyle["display"] = "flex";
            const element = document.querySelectorAll('.button');
            element.forEach(function(item) {
                item.style.display = "none";
            });
        }
    }
})

MainUI.use(Quasar, {
    config: {
        loadingBar: { skipHijack: true }
    }
});
MainUI.mount("#ui-wrapper");