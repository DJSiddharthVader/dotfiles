const pywalUtils = {
    updateSheet(win, _key) {
        if (win !== window) return;
        if (this.sss.sheetRegistered(this.ssUri, this.sss.USER_SHEET))
            this.sss.unregisterSheet(this.ssUri, this.sss.USER_SHEET);
        this.sss.loadAndRegisterSheet(this.ssUri, this.sss.USER_SHEET);
    },

    init() {
        this.sss = Cc["@mozilla.org/content/style-sheet-service;1"].getService(
            Ci.nsIStyleSheetService
        );
        this.ssUri = makeURI("chrome://userChrome/content/colors.css");

        _ucUtils.registerHotkey(
            { id: "key_pywalCSS", modifiers: "accel", key: "H" },
            pywalUtils.updateSheet
        );
        this.updateSheet(window);
    },
};

if (gBrowserInit.delayedStartupFinished) {
    pywalUtils.init();
} else {
    let delayedListener = (subject, topic) => {
        if (topic == "browser-delayed-startup-finished" && subject == window) {
            Services.obs.removeObserver(delayedListener, topic);
            pywalUtils.init();
        }
    };
    Services.obs.addObserver(delayedListener, "browser-delayed-startup-finished");
}
