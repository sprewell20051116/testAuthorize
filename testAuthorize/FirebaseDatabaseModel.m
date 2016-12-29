
//
//  FirebaseDatabaseModel.m
//  poetryapps
//
//  Created by GIGIGUN on 9/9/16.
//  Copyright © 2016 cc. All rights reserved.
//

#import "FirebaseDatabaseModel.h"


@interface FirebaseDatabaseModel()
@property(strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation FirebaseDatabaseModel

+ (instancetype) getInstance {
    static dispatch_once_t once;
    static FirebaseDatabaseModel *instance;
    dispatch_once(&once, ^{
        instance = [[FirebaseDatabaseModel alloc] init];
    });
    
    return instance;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        self.ref = [[FIRDatabase database] reference];
        // do more thing about init;
    }
    return self;
}

- (void) addRegisterDataWithRegisterIDString : (NSString *) registerString
                                     Success : (void (^)())success
                                     Failure : (void (^)(NSError *error))failure
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMdd-HHmmss"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    
    NSDictionary *userDic = @{@"userID" : [NSString stringWithFormat:@"%@", registerString],
                @"registerDate" : dateString,
                @"type" : @2}; //1 means facebook
    
    
    [[[_ref child:@"registerUsers"] childByAutoId] setValue:userDic
                         withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error) {
            failure(error);
        } else {
            success();
        }
    }];
    
}

- (void) retreiveRegisterDataByQueryIDString : (NSString*) IDString
                                     Success : (void (^) (FIRDataSnapshot * data)) success
                                     Failure : (void (^)(NSError *error)) failure
{
    
    [[[[_ref child:@"registerUsers"] queryOrderedByChild:@"userID"] queryEqualToValue:IDString] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"Snapshot: %@", snapshot);
        success(snapshot);
    }];
    
}

- (void) loginAsAnomymounSuccess : (void (^) (FIRUser * user)) success
                         Failure :(void (^)(NSError *error)) failure

{
    [[FIRAuth auth] signInAnonymouslyWithCompletion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if(error) {
            failure(error);
        } else {
            success(user);
        }
    }];

}

- (FIRUser *) getcurrentUser
{
    return [FIRAuth auth].currentUser;
}


- (void) deleteCurrentUserSuccess : (void (^) ()) success
                          Failure :(void (^)(NSError *error)) failure
{
    [[self getcurrentUser] deleteWithCompletion:^(NSError *_Nullable error) {
        if (error) {
            // An error happened.
            failure(error);
        } else {
            // Account deleted.
            success();
        
        }
    }];
}

//
//
//
//- (void) setDataWithDic : (NSDictionary*) DataDic
//                Success : (void (^)())success
//                Failure : (void (^)(NSError *error))failure
//{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"YYYYMMdd-HHmmss"];
//    NSString *DateString = [formatter stringFromDate:[NSDate date]];
//
//
//    [[[_ref child:@"emotionData"]
//      child:DateString] setValue:DataDic withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
//        if (error) {
//            failure(error);
//        } else {
//            success();
//        }
//    }];
//
//}
//
//
//
//- (void) readValue
//{
//    [[_ref child:@"notificationHistory"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
//
//        NSMutableArray *returnData = [NSMutableArray new];
//        
//        NSLog(@"snapshot = %@", snapshot);
//        NSLog(@"snapshot = %d", snapshot.childrenCount);
//        
//        for (FIRDataSnapshot* child in snapshot.children) {
//            NSLog(@"value = %@", child.value);
//            [returnData addObject:child.value];
//        }
//        
//        // ...
//    } withCancelBlock:^(NSError * _Nonnull error) {
//        NSLog(@"%@", error.localizedDescription);
//    }];
//}
//
//
//- (void) readNotificationHistoryWithSuccess : (void (^) (NSArray * HistoryData)) success
//                                    Failure : (void (^) (NSError * error)) failure
//{
//    [[_ref child:@"notificationHistory"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
//        
//        NSMutableArray *returnData = [NSMutableArray new];
//        
//        for (FIRDataSnapshot* child in snapshot.children) {
//            [returnData addObject:child.value];
//        }
//        success(returnData);
//        
//    } withCancelBlock:^(NSError * error) {
//        NSLog(@"%@", error.localizedDescription);
//        failure(error);
//    }];
//}





//-(NSDictionary *) setNotificationDicWithTitleString : (NSString *) titleString
//                                      andBodyString : (NSString *) bodyString
//{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"YYYYMMdd-HHmmss"];
//    NSString *DateString = [formatter stringFromDate:[NSDate date]];
//
//    return @{@"Date" : DateString,
//             @"Type" : @"Common",
//             @"Title" : titleString,
//             @"Body" : bodyString,
//             @"Photo" : @"",
//             @"Sound" : @"",
//             @"Video" : @""};
//
//}
//


@end
