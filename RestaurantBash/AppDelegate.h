//
//  AppDelegate.h
//  RestaurantBash
//
//  Created by Divya on 5/20/14.
//  Copyright (c) 2014 Manulogix Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseManager.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UINavigationController *navigationController;
    DataBaseManager *dbManager;
}
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) UIWindow *window;

@end