/*global cordova, module*/

/*
 Look at the last three arguments passed to the cordova.exec function.
 The first refers to 'FingScanner' feature (in plugin.xml), which maps to a specific class implementation
 The second requests the method to execute (e.g. 'networkScan' action, a method within the class)
 The third is an array of arguments containing the parameters, which an cbe taken from this function's
 definition.
 */

module.exports = {

    // ---- LIFECYCLE ----

    /**
     * Validates a license key, notifying results to the given completion handler.
     *
     * @param licenseKey        the key to validate
     * @param webHookToken      an optional token to be validated via web hook
     * @param successCallback   the handler of the notification event at method completion
     * @param errorCallback     the handler of the notification event at method failure
     */
    validateLicenseKey : function (licenseKey, webHookToken, successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "FingScanner", "validateLicenseKey", [licenseKey, webHookToken]);
    },

    /**
     * Inform the engine that the App is about to suspend, entering background mode.
     *
     * @param successCallback   the handler of the notification event at method completion
     * @param errorCallback     the handler of the notification event at method failure
     */
    willSuspend : function (successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "FingScanner", "willSuspend", []);
    },

    /**
     * Inform the engine that the App is about to resume, entering foreground mode.
     *
     * @param successCallback   the handler of the notification event at method completion
     * @param errorCallback     the handler of the notification event at method failure
     */
    willResume : function (successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "FingScanner", "willResume", []);
    },

    // ---- ACCOUNT MANAGEMENT ----

    /**
     * Attaches this FingKit instance to a specific account, based on the given profile.
     *
     * @param accountProfile    a map with profile options. It must contain at least an 'accountId' mapping
     * @param webHookToken      an optional token to be validated via web hook
     * @param successCallback   the handler of the notification event at method completion
     * @param errorCallback     the handler of the notification event at method failure
     */
    accountAttach : function (accountProfile, webHookToken, successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "FingScanner", "accountAttach", [accountProfile, webHookToken]);
    },

    /**
     * Returns a description of the account this FingKit instance is attached to, if any.
     *
     * @param successCallback   the handler of the notification event at method completion
     * @param errorCallback     the handler of the notification event at method failure
     */
    accountInfo : function (successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "FingScanner", "accountInfo", []);
    },

    /**
     * Detaches this FingKit instance from an account, if previously attached.
     *
     * @param successCallback   the handler of the notification event at method completion
     * @param errorCallback     the handler of the notification event at method failure
     */
    accountDetach : function (successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "FingScanner", "accountDetach", []);
    },

    // ---- NETWORK ----

    /**
     * Returns a description of the network this FingKit instance is attached to, if any.
     *
     * @param successCallback   the handler of the notification event at method completion
     * @param errorCallback     the handler of the notification event at method failure
     */
    networkInfo : function (successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "FingScanner", "networkInfo", []);
    },

    /**
     * Executes a scan, whose events will be notified to the given completion handler.
     *
     * @param scanOptions       a mapping of options. It may be empty and null, and default scan options will be used
     * @param successCallback   the handler of the notification event at method completion
     * @param errorCallback     the handler of the notification event at method failure
     */
    networkScan: function (scanOptions, successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "FingScanner", "networkScan", [scanOptions]);
    }
};
