//
//  ViewController.h
//  RestaurantBash
//
//  Created by Divya on 5/20/14.
//  Copyright (c) 2014 Manulogix Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "DataBaseManager.h"
#import "RestaurantViewController.h"
@interface ViewController : UIViewController
{
    DataBaseManager *dbManager;
    NSDictionary *loginDictionary;
    NSDictionary *restDictionary;
}
@end
