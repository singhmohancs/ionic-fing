/*!
 *  FingScanner.h
 *  FingEngine
 *
 *  Created by Domotz on 18/08/16.
 *  Copyright © 2016 Domotz Ltd. All rights reserved.
 */


#ifndef FingScanner_h
#define FingScanner_h

#import "FingScanOptions.h"
#import "FingAccountProfile.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 * @typedef FingResultCallback
 * @brief The type of block invoked when events complete.
 *
 * @param result Optionally; the result, if any.
 * @param error Optionally; if an error occurs, this is the NSError object that describes the
 * problem. Set to nil otherwise.
 */
typedef void (^FingResultCallback)(NSString *_Nullable result, NSError *_Nullable error);

/*!
 * @brief The top level Fing Kit singleton that provides methods for scanning a network.
 */
@interface FingScanner : NSObject


#pragma mark ---- LIFECYCLE ----


/*!
 * @brief The singleton shared instance of a Fing Scanner.
 */
+ (FingScanner *)sharedInstance;

/*!
 * @brief Inform the engine that the App is about to suspend, entering background mode.
 */
-(void)willSuspend;

/*!
 * @brief Inform the engine that the App is about to resume, entering foreground mode.
 */
-(void)willResume;


#pragma mark ---- LICENSE VALIDATION ----

/*!
 * @brief Validates a license key, notifying results to the given completion handler.
 * 
 * @param key           the key to validate
 * @param token         an optional token to be validated via webhook
 * @param completion    the handler of the notification event at method completion.
 */
-(void) validateLicenseKey:(NSString *) key
                 withToken:(nullable NSString *) token
                completion:(nullable FingResultCallback) completion;

#pragma mark ---- ACCOUNT MANAGEMENT ----

/*!
 * @brief Attaches this FingKit instance to a specific account, based on the given profile.
 *
 * @param profile       the profile object of the account to attach to.
 * @param token         an optional token to be validated via webhook
 * @param completion    the handler of the notification event at method completion.
 */
-(void) accountAttach:(FingAccountProfile *) profile
            withToken:(nullable NSString *) token
           completion:(nullable FingResultCallback) completion;

/*!
 * @brief Returns a description of the account this FingKit instance is attached to, if any.
 *
 * @param completion    the handler of the notification event at method completion.
 */
-(void) accountInfo:(nullable FingResultCallback) completion;

/*!
 * @brief Detaches this FingKit instance from an account, if previously attached.
 *
 * @param completion    the handler of the notification event at method completion.
 */
-(void) accountDetach:(nullable FingResultCallback) completion;


#pragma mark ---- NETWORK ----

/*!
 * @brief Retrieves network details. A single event will be notified to the given completion handler.
 *
 * @param completion    the handler of the notification event at method completion.
 */
-(void)networkInfo:(nullable FingResultCallback)completion;

/*!
 * @brief Executes a scan, whose events will be notified to the given completion handler.
 *
 * @param options       the options to configure the scan procedure.
 * @param completion    the handler of the notification event at method completion.
 */
-(void)networkScan:(nullable FingScanOptions *)options
        completion:(nullable FingResultCallback)completion;

@end

NS_ASSUME_NONNULL_END

#endif /* FingScanner_h */
