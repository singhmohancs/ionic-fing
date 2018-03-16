#import "FingScannerCDVPlugin.h"
#import <FingKit/FingKit.h>

@implementation FingScannerCDVPlugin

- (void) validateLicenseKey:(CDVInvokedUrlCommand*)command
{
    NSString *licenseKey = [[command arguments] objectAtIndex:0];
    NSString *token = [[command arguments] objectAtIndex:1];

    FingScanner *scanner = [FingScanner sharedInstance];
    [scanner validateLicenseKey:licenseKey withToken:token completion:^(NSString * _Nullable result, NSError * _Nullable error) {
        [self sendReply:command withResult:result orError:error isLast:YES];
    }];
}

- (void) willSuspend:(CDVInvokedUrlCommand*)command
{
    FingScanner *scanner = [FingScanner sharedInstance];
    [scanner willSuspend];
    [self sendReplyOk:command];
}

- (void) willResume:(CDVInvokedUrlCommand*)command
{
    FingScanner *scanner = [FingScanner sharedInstance];
    [scanner willResume];
    [self sendReplyOk:command];
}

- (void) accountAttach:(CDVInvokedUrlCommand*)command
{
    NSDictionary *profileMap = [[command arguments] objectAtIndex:0];
    NSString* accountId = [profileMap objectForKey:@"accountId"];

    FingAccountProfile *profile = [[FingAccountProfile alloc] init];
    profile.accountId = [profileMap objectForKey:@"accountId"];
    profile.accountFullName = [profileMap objectForKey:@"accountFullName"];
    profile.accountEmail = [profileMap objectForKey:@"accountEmail"];

    NSString *token = [[command arguments] objectAtIndex:1];

    FingScanner *scanner = [FingScanner sharedInstance];
    [scanner accountAttach:profile withToken:token completion:^(NSString * _Nullable result, NSError * _Nullable error) {
        [self sendReply:command withResult:result orError:error isLast:YES];
    }];
}

- (void) accountInfo:(CDVInvokedUrlCommand*)command
{
    FingScanner *scanner = [FingScanner sharedInstance];
    [scanner accountInfo:^(NSString * _Nullable result, NSError * _Nullable error) {
        [self sendReply:command withResult:result orError:error isLast:YES];
    }];
}

- (void) accountDetach:(CDVInvokedUrlCommand*)command
{
    FingScanner *scanner = [FingScanner sharedInstance];
    [scanner accountDetach:^(NSString * _Nullable result, NSError * _Nullable error) {
        [self sendReply:command withResult:result orError:error isLast:YES];
    }];
}

- (void) networkInfo:(CDVInvokedUrlCommand*)command
{
    FingScanner *scanner = [FingScanner sharedInstance];
    [scanner networkInfo:^(NSString * _Nullable result, NSError * _Nullable error) {
        [self sendReply:command withResult:result orError:error isLast:YES];
    }];
}

- (void) networkScan:(CDVInvokedUrlCommand*)command
{
    NSDictionary* optionsMap = [[command arguments] objectAtIndex:0];

    FingScanOptions *options = [FingScanOptions systemDefault];

    if ([self isOptionEnabled:optionsMap forKey:@"reverseDnsEnabled"]) {
        options.reverseDnsEnabled = YES;
    } else if ([self isOptionDisabled:optionsMap forKey:@"reverseDnsEnabled"]) {
        options.reverseDnsEnabled = NO;
    }

    if ([self isOptionEnabled:optionsMap forKey:@"upnpEnabled"]) {
        options.upnpEnabled = YES;
    } else if ([self isOptionDisabled:optionsMap forKey:@"upnpEnabled"]) {
        options.upnpEnabled = NO;
    }

    if ([self isOptionEnabled:optionsMap forKey:@"bonjourEnabled"]) {
        options.bonjourEnabled = YES;
    } else if ([self isOptionDisabled:optionsMap forKey:@"bonjourEnabled"]) {
        options.bonjourEnabled = NO;
    }

    if ([self isOptionEnabled:optionsMap forKey:@"netbiosEnabled"]) {
        options.netbiosEnabled = YES;
    } else if ([self isOptionDisabled:optionsMap forKey:@"netbiosEnabled"]) {
        options.netbiosEnabled = NO;
    }

    if ([self isOptionEnabled:optionsMap forKey:@"snmpEnabled"]) {
        options.snmpEnabled = YES;
    } else if ([self isOptionDisabled:optionsMap forKey:@"snmpEnabled"]) {
        options.snmpEnabled = NO;
    }

    NSString* maxNetworkSize = [optionsMap objectForKey:@"maxNetworkSize"];
    if (maxNetworkSize != nil && [maxNetworkSize intValue] != 0) {
        options.maxNetworkSize = [maxNetworkSize intValue];
    }

    NSString* resultLevelScanInProgress = [optionsMap objectForKey:@"resultLevelScanInProgress"];
    if ([@"none" isEqualToString:resultLevelScanInProgress]) {
        options.resultLevelScanInProgress = FingScanResultNone;
    } else if ([@"summary" isEqualToString:resultLevelScanInProgress]) {
        options.resultLevelScanInProgress = FingScanResultSummary;
    } else if ([@"full" isEqualToString:resultLevelScanInProgress]) {
        options.resultLevelScanInProgress = FingScanResultFull;
    }

    NSString* resultLevelScanCompleted = [optionsMap objectForKey:@"resultLevelScanCompleted"];
    if ([@"none" isEqualToString:resultLevelScanCompleted]) {
        options.resultLevelScanCompleted = FingScanResultNone;
    } else if ([@"summary" isEqualToString:resultLevelScanCompleted]) {
        options.resultLevelScanCompleted = FingScanResultSummary;
    } else if ([@"full" isEqualToString:resultLevelScanCompleted]) {
        options.resultLevelScanCompleted = FingScanResultFull;
    }

    NSString* outputFormat = [optionsMap objectForKey:@"outputFormat"];
    if (outputFormat != nil) {
        options.outputFormat = outputFormat;
    }

    FingScanner *scanner = [FingScanner sharedInstance];
    [scanner networkScan:options completion:^(NSString * _Nullable result, NSError * _Nullable error) {
        BOOL completed = NO;
        if (result != nil) {
            NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
            NSError *jsonError;
            id object = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONWritingPrettyPrinted
                                                          error:&jsonError];

            if (jsonError != nil && [object isKindOfClass:[NSDictionary class]])
            {
                if ([self isOptionEnabled:object forKey:@"completed"]) {
                    completed = YES;
                } else if ([self isOptionDisabled:object forKey:@"completed"]) {
                    completed = NO;
                } else {
                    // Parameter missing, assume not completed.
                }
            }
        }
        [self sendReply:command withResult:result orError:error isLast:completed];
    }];
}

- (BOOL) isOptionEnabled:(NSDictionary*) optionsMap forKey:(NSString *) key {
    NSString* option = [optionsMap objectForKey:key];
    return option != nil && [@"true" isEqualToString:option.lowercaseString];
}

- (BOOL) isOptionDisabled:(NSDictionary*) optionsMap forKey:(NSString *) key {
    NSString* option = [optionsMap objectForKey:key];
    return option != nil && [@"true" isEqualToString:option.lowercaseString];
}

- (void) sendReply:(CDVInvokedUrlCommand*)command
        withResult:(NSString *)result
           orError:(NSError *) error
            isLast:(BOOL)lastEvent
{
    if (error != nil) {
        NSString *errorMsg = [[error userInfo] objectForKey:NSLocalizedFailureReasonErrorKey];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                    messageAsString:errorMsg];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return;
    }

    if (result != nil) {
        CDVPluginResult* pluginResult = [CDVPluginResult
                                   resultWithStatus:CDVCommandStatus_OK
                                   messageAsString:result];
        if (!lastEvent) {
            [pluginResult setKeepCallbackAsBool:YES];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void) sendReplyOk:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = [CDVPluginResult
                                       resultWithStatus:CDVCommandStatus_OK
                                       messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end