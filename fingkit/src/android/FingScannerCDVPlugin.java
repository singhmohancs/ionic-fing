package com.fing.fingkit;

import org.apache.cordova.LOG;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import android.content.Context;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;

import com.overlook.android.fingkit.FingScanner;
import com.overlook.android.fingkit.FingScanOptions;
import com.overlook.android.fingkit.FingAccountProfile;

class FingScannerCDVCallback implements FingScanner.FingResultCallback {
    private CallbackContext callbackContext;

    public FingScannerCDVCallback(CallbackContext callbackContext) {
        this.callbackContext = callbackContext;
    }

    public void handle(String result, Exception error) {
        if (result == null) {
            error.printStackTrace();
            PluginResult pluginResult = new PluginResult(PluginResult.Status.ERROR, error.getMessage());
            this.callbackContext.sendPluginResult(pluginResult);
        } else {
            PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, result);
            pluginResult.setKeepCallback(true);
            this.callbackContext.sendPluginResult(pluginResult);
        }
    }
}

public class FingScannerCDVPlugin extends CordovaPlugin {

    @Override
    public boolean execute(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        final FingScanner scanner = FingScanner.getInstance();
        if (!scanner.isConnected()) {
            if (action.equals("validateLicenseKey")) {
                // Not connected. Connecting now...
                LOG.i("FingScannerCDVPlugin", "Not connected. Connecting now...");
                Context context = this.cordova.getActivity().getApplicationContext();
                scanner.connect(context, new FingScanner.FingResultCallback() {
                    @Override
                    public void handle(String s, Exception e) {
                        if (e == null) {
                            try {
                                doExecute(action, args, callbackContext);
                            } catch (JSONException je) {
                                je.printStackTrace();
                            }
                        } else {
                            // Send error to Cordova App that method cannot be executed
                            callbackContext.error("{\"error\": \"method cannot be executed\"}");
                        }
                    }
                });
                return true;
            } else {
                return false;
            }
        } else {
            // Already connected, handle received action
            return doExecute(action, args, callbackContext);
        }
    }

    public boolean doExecute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        FingScannerCDVCallback callback = new FingScannerCDVCallback(callbackContext);
        FingScanner fingScanner = FingScanner.getInstance();
        LOG.i("FingScannerCDVPlugin", "Received action " + action);

        if (action.equals("validateLicenseKey")) {
            String licenceKey = args.getString(0);
            String token = args.getString(1);
            fingScanner.validateLicenseKey(licenceKey, token, callback);
            return true;
        }

        if (action.equals("willSuspend")) {
            fingScanner.willSuspend(callback);
            return true;
        }

        if (action.equals("willResume")) {
            fingScanner.willResume(callback);
            return true;
        }

        if (action.equals("accountAttach")) {
            JSONObject profileMap = args.getJSONObject(0);
            String token = args.getString(1);
            String accountId = profileMap.getString("accountId");
            String accountFullName = profileMap.getString("accountFullName");
            String accountEmail = profileMap.getString("accountEmail");
            FingAccountProfile profile = new FingAccountProfile();
            profile.setAccountId(accountId);
            profile.setAccountFullName(accountFullName);
            profile.setAccountEmail(accountEmail);
            fingScanner.accountAttach(profile, token, callback);
            return true;
        }

        if (action.equals("accountInfo")) {
            fingScanner.accountInfo(callback);
            return true;
        }

        if (action.equals("accountDetach")) {
            fingScanner.accountDetach(callback);
            return true;
        }

        if (action.equals("networkInfo")) {
            fingScanner.networkInfo(callback);
            return true;
        }

        if (action.equals("networkScan")) {
            fingScanner.networkScan(FingScanOptions.systemDefault(), callback);
            return true;
        }

        return false;
    }

}