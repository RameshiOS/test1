//
//  BarcodeDetailsViewController.h
//  RBASH
//
//  Created by Divya on 2/3/14.
//  Copyright (c) 2014 Manulogix Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>
#import "FAUtilities.h"
#import <AVFoundation/AVAudioPlayer.h>
#import "OverlayView.h"
#import "WebServiceInterface.h"
#import <CoreLocation/CoreLocation.h>
#import "DataBaseManager.h"
@interface BarcodeDetailsViewController : UIViewController<WebServiceInterfaceDelegate,UITextFieldDelegate,UIScrollViewDelegate,CLLocationManagerDelegate>

{
    NSDictionary *restDetails;
    NSString *barcodeVal;
    NSString *restId;
    NSString *currentRestName;
    WebServiceInterface *webServiceInterface;
    BOOL firstTime;
    UIView *barcodeDetailsView;
    
    UILabel *buyerNameVal;
    UILabel *emailVal;
    UILabel *datePurchasedVal;
    UILabel *giftedToVal;
    UILabel *giftedOnVal;
    UILabel *statusVal;
    UILabel *dealNameVal;
    UILabel *valueLabelVal;
    UILabel *costLabelVal;
    UILabel *saveLabelVal;
    UILabel *currentRestNameLabel;
    
    DataBaseManager *dbManager;
    NSString *dealNameStr,*cityStr,*addressStr,*originalPriceStr,*phoneStr,*restNameStr,*stateStr,*zipStr,*giftedOnValStr,*giftedToValStr,*subscriptionDateStr,*statusStr,*firstNameStr,*lastNameStr,*emailStr,*buyerNameStr,*barcodeStr,*addressValStr;
    NSString *redeemedDate;
    
    BOOL redeemButtonClicked;
    
    UILabel *dealDetailsLabel;
    UILabel *barcodeDetailsLabel;
    
    UILabel *restNameLabel;
    UILabel *dealNameLabel;
    UILabel *restAddressLabel;
    UILabel *phoneLabel;
    
    UILabel *valueLabel;
    UILabel *costLabel;
    UILabel *saveLabel;
    
    UIImageView *barcodeImageView;
    UILabel *barcodeLabel;
    
    UILabel *buyerNameLabel;
    UILabel *emailLabel;
    UILabel *datePurchasedLabel;
    UILabel *statusLabel;
    UILabel *giftedToLabel;
    UILabel *giftedOnLabel;
    
    UILabel *messageLabel;
    UIButton *redeemButton,*cancelButton;
    UIView *dealDetailsView;
    
    BOOL addPoDateLabel;
    BOOL addGitedOnLabel;
    BOOL addGitedToLabel;
    
    NSArray *words;
    NSString *valueStr;
    NSString *costStr;
    NSString *saveStr;
    NSString *uniqueIdentifier;
    
    NSString *rest_Id;
    NSString *current_rest_Id;
}
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (nonatomic, retain) NSString *latitudeString;
@property (nonatomic, retain) NSString *longitudeString;
@property (nonatomic,retain)NSDictionary *restDetails;
@property (nonatomic,retain)NSString *barcodeVal;
@property (nonatomic,retain)NSString *restId;
@property (nonatomic,retain)NSString *rest_Id;

@property (nonatomic,retain)NSString *currentRestName;

@end
