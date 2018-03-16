//
//  FingAccountProfile.h
//  FingEngine
//
//  Created by Marco De Angelis on 07/11/16.
//  Copyright © 2016 Domotz Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FingAccountProfile : NSObject<NSCopying>

@property (nonatomic, retain) NSString *accountId;
@property (nonatomic, retain) NSString *accountFullName;
@property (nonatomic, retain) NSString *accountEmail;

-(FingAccountProfile *) copyProfile;

@end
