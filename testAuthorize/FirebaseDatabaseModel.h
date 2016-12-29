//
//  FirebaseDatabaseModel.h
//  poetryapps
//
//  Created by GIGIGUN on 9/9/16.
//  Copyright © 2016 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Firebase;

@interface FirebaseDatabaseModel : NSObject
+ (instancetype) getInstance;

//
//-(NSDictionary *) setNotificationDicWithTitleString : (NSString *) titleString
//                                      andBodyString : (NSString *) bodyString;
//
//- (void) setNotificationDataWithDic : (NSDictionary*) NotificationDic
//                            Success : (void (^)())success
//                            Failure : (void (^)(NSError *error))failure;
//
//- (void) readValue;
//- (void) readNotificationHistoryWithSuccess : (void (^) (NSArray * HistoryData)) success
//                                    Failure : (void (^) (NSError * error)) failure;
//
//
//- (void) setDataWithDic : (NSDictionary*) DataDic
//                Success : (void (^)())success
//                Failure : (void (^)(NSError *error))failure;
//

- (void) addRegisterDataWithRegisterIDString : (NSString *) registerString
                                     Success : (void (^)())success
                                     Failure : (void (^)(NSError *error))failure;


- (void) retreiveRegisterDataByQueryIDString : (NSString*) IDString
                                     Success : (void (^) (FIRDataSnapshot * data)) success
                                     Failure : (void (^)(NSError *error)) failure;

- (void) loginAsAnomymounSuccess : (void (^) (FIRUser * user)) success
                         Failure :(void (^)(NSError *error)) failure;

- (FIRUser *) getcurrentUser;

- (void) deleteCurrentUserSuccess : (void (^) ()) success
                          Failure :(void (^)(NSError *error)) failure;

@end
