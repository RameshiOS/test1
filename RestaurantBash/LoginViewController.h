//
//  LoginViewController.h
//  RBASH
//
//  Created by Divya on 2/7/14.
//  Copyright (c) 2014 Manulogix Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FAUtilities.h"
#import <QuartzCore/QuartzCore.h>
#import "WebServiceInterface.h"
#import <CoreLocation/CoreLocation.h>
#import "DataBaseManager.h"
#import "RestaurantViewController.h"
@interface LoginViewController : UIViewController<WebServiceInterfaceDelegate,UITextFieldDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>
{
   
    UIView *loginSubView;
    UIView *userView;
    UIView *pwdView;
    
    UILabel*userEmailLabel;
    UILabel*passwordLabel;
    
    UITextField *userNameField;
    UITextField *passwordField;
    
    UIFont *uFont;
    UIFont *pFont;

    NSString *uText;
    NSString *pText;
    NSAttributedString *uAttributedText;
    NSAttributedString *pAttributedText;
    
    CGFloat uWidth;
    CGFloat pWidth;
    CGRect uRect;
    CGRect pRect;
    CGSize uSize;
    CGSize pSize;
    
    NSDictionary *loginDictionary;
    NSDictionary *restDictionary;
    
    UIAlertView *alertView;
    
    UIButton *loginButton;
    NSString *uniqueIdentifier;

    DataBaseManager *dbManager;
    WebServiceInterface *webServiceInterface;
}
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (nonatomic, retain) NSString *latitudeString;
@property (nonatomic, retain) NSString *longitudeString;
@end
