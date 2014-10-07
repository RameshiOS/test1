//
//  RestaurantViewController.h
//  RBASH
//
//  Created by Divya on 1/31/14.
//  Copyright (c) 2014 Manulogix Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseManager.h"
#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>
#import "ZBarReaderViewController.h"
#import "FAUtilities.h"
#import <AVFoundation/AVAudioPlayer.h>
#import "OverlayView.h"
#import "WebServiceInterface.h"
#import <CoreLocation/CoreLocation.h>
#import "BarcodeDetailsViewController.h"
@interface RestaurantViewController : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,CLLocationManagerDelegate,ZBarReaderDelegate,UITextFieldDelegate,WebServiceInterfaceDelegate>
{
    
    UIButton *logoutButton;
//    UIButton *settingsButton;
    UIButton *goButton;
//    UIButton *scanBarcodeButton;
//    UIButton *enterBarcodeButton;
    UIButton *enterBarcodeViewCancelButton;
    UIButton *restaurantCancelButton;
    IBOutlet UIButton *chooseRestaurantButton;
//    UIButton *scanBarcodeBtn;
//    UIButton *enterBarcodeBtn;
    UIButton *readBarCodeButton;
    
    DataBaseManager *dbManager;
    ZBarReaderViewController *reader;
    WebServiceInterface *webServiceInterface;
    
    UIView *selectRestaurantHeaderView;
    UIView *enterBarcodeHeaderView;
    UIView *selectRestaurantSubview;
    UIView *enterBarcodeSubView;
    UIView *restaurantListSubView;

    UILabel *retaurantHeader;
    UILabel *enterBarcodeHeader;
    UILabel *selectRestaurantHeader;
    
    UITableView *selectRestaruantTableView;
   
    UILabel *restNameLabel;
    UILabel *restAddressLabel;
    UILabel *restContactNameLabel;
    UILabel *restPhoneLabel;
    UILabel *restEmailLabel;
    
    NSMutableArray *loginDetails;
    NSDictionary *loginDict;
    
    NSString *addressVal;
    UITextField *barcodeNumberField;
    
    BOOL chooseRestaurantButtonClicked;
    BOOL enterBarcodeButtonClicked;
    BOOL scanBarcodeButtonClicked;
    BOOL goButtonClicked;
    NSString *uniqueIdentifier;

    
    int selectedIndex;
    NSString *selectedRest_Id;
    NSArray *restauranta;
    
    
    IBOutlet UILabel *restaurantNameLabel;
    IBOutlet UILabel *restaurantAddressLabel;
    IBOutlet UILabel *restaurantOwnerNameLabel;
    IBOutlet UILabel *restaurantOwnerPhoneLabel;
    IBOutlet UILabel *restaurantOwnerEmailLabel;
    
    NSDictionary *currentRestaurantDict;
    
    NSString *emailID;
    
}

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (nonatomic, retain) NSString *latitudeString;
@property (nonatomic, retain) NSString *longitudeString;
@property (nonatomic ,retain) NSArray *restauranta;


-(IBAction)chooseRestaurantButtonClicked:(id)sender;
-(IBAction)enterBarcodeButtonClicked:(id)sender;
-(IBAction)scanBarcodeButtonClicked:(id)sender;
-(IBAction)logoutButtonClicked:(id)sender;

@end
