//
//  AppDelegate.h
//  testAuthorize
//
//  Created by GIGIGUN on 14/12/2016.
//  Copyright © 2016 GIGIGUN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

