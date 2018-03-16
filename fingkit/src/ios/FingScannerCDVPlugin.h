#import <Cordova/CDV.h>

@interface FingScannerCDVPlugin : CDVPlugin

- (void) validateLicenseKey:(CDVInvokedUrlCommand*)command;
- (void) willSuspend:(CDVInvokedUrlCommand*)command;
- (void) willResume:(CDVInvokedUrlCommand*)command;
- (void) accountAttach:(CDVInvokedUrlCommand*)command;
- (void) accountInfo:(CDVInvokedUrlCommand*)command;
- (void) accountDetach:(CDVInvokedUrlCommand*)command;
- (void) networkInfo:(CDVInvokedUrlCommand*)command;
- (void) networkScan:(CDVInvokedUrlCommand*)command;

@end