const pywalUtils = {
    updateSheet(win, _key) {
        if (win !== window) return;
        if (this.sss.sheetRegistered(this.ssUri, this.sss.USER_SHEET))
            this.sss.unregisterSheet(this.ssUri, this.sss.USER_SHEET);
        this.sss.loadAndRegisterSheet(this.ssUri, this.sss.USER_SHEET);
    },

    init() {
        console.log("script loaded, initializing");
        this.sss = Cc["@mozilla.org/content/style-sheet-service;1"].getService(Ci.nsIStyleSheetService);
        console.log("this.sss defined");
        this.ssUri = makeURI("chrome://userChrome/content/colors.css");
        console.log("this.ssURI defined");

        _ucUtils.registerHotkey(
            { id: "key_pywalCSS", modifiers: "accel", key: "H" },
            pywalUtils.updateSheet
        );
        console.log("hotkey defined");
        this.updateSheet(window);
    },
};

if (gBrowserInit.delayedStartupFinished) {
    console.log("init");
    pywalUtils.init();
    console.log("init end");
} else {
    let delayedListener = (subject, topic) => {
        if (topic == "browser-delayed-startup-finished" && subject == window) {
            Services.obs.removeObserver(delayedListener, topic);
            console.log("init");
            pywalUtils.init();
            console.log("init end");
        }
    };
    Services.obs.addObserver(delayedListener, "browser-delayed-startup-finished");
}

