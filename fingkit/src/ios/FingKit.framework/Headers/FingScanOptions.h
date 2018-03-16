//
//  FingScanOptions.h
//  FingEngine
//
//  Created by Marco De Angelis on 19/08/16.
//  Copyright © 2016 Domotz Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Enumerated value that indicates the source of Remote Config data. Data can come from
/// the Remote Config service, the DefaultConfig that is available when the app is first installed,
/// or a static initialized value if data is not available from the service or DefaultConfig.
typedef NS_ENUM(NSInteger, FingScanResultLevel) {
    FingScanResultNone,             /// Don't send any data.
    FingScanResultSummary,          /// Return only a summary of the scan.
    FingScanResultFull,             /// Full results of the scan.
};

@interface FingScanOptions : NSObject<NSCopying>

@property (nonatomic) BOOL reverseDnsEnabled;
@property (nonatomic) BOOL upnpEnabled;
@property (nonatomic) BOOL bonjourEnabled;
@property (nonatomic) BOOL netbiosEnabled;
@property (nonatomic) BOOL snmpEnabled;
@property (nonatomic) NSInteger maxNetworkSize;

@property (nonatomic) FingScanResultLevel resultLevelScanInProgress;
@property (nonatomic) FingScanResultLevel resultLevelScanCompleted;
@property (nonatomic, retain) NSString *outputFormat;

-(FingScanOptions *) copyOptions;
+(FingScanOptions *) systemDefault;

@end
