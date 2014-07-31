//
//  RestaurantViewController.m
//  RBASH
//
//  Created by Divya on 1/31/14.
//  Copyright (c) 2014 Manulogix Pvt Ltd. All rights reserved.
//

#import "RestaurantViewController.h"
#import "FAUtilities.h"
@interface RestaurantViewController ()

@end

@implementation RestaurantViewController
@synthesize latitudeString;
@synthesize longitudeString;
@synthesize restauranta;
static BOOL haveAlreadyReceivedCoordinates;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    
    if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){//
        [self Potrait];
    }else if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
        [self Landscape];
    }
    [selectRestaurantSubview addSubview:retaurantHeader];
    [selectRestaurantSubview addSubview:restNameLabel];
    [selectRestaurantSubview addSubview:restAddressLabel];
    [selectRestaurantSubview addSubview:restContactNameLabel];
    [selectRestaurantSubview addSubview:restPhoneLabel];
    [selectRestaurantSubview addSubview:restEmailLabel];
    if ([restauranta count]>1) {
        [selectRestaurantSubview addSubview:settingsButton];
    }
    [selectRestaurantSubview addSubview:scanBarcodeBtn];
    [selectRestaurantSubview addSubview:enterBarcodeBtn];
    [self.view addSubview:selectRestaurantSubview];
    [self.view addSubview:logoutButton];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    chooseRestaurantButtonClicked=NO;
    
    dbManager = [DataBaseManager dataBaseManager];
    loginDetails= [[NSMutableArray alloc]init];
    [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM LoginDetails"] resultsArray:loginDetails];
    if ([loginDetails count] !=0) {
        loginDict =[loginDetails objectAtIndex:0];
    }
    
    barcodeNumberField = [[UITextField alloc] init];
    barcodeNumberField.placeholder = @"<barcode value>";
    barcodeNumberField.backgroundColor = [UIColor whiteColor];
    barcodeNumberField.layer.cornerRadius = 2.0;
    barcodeNumberField.layer.borderWidth = 1.0;
    barcodeNumberField.clipsToBounds      = YES;
    barcodeNumberField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    barcodeNumberField.clearButtonMode = YES;
    barcodeNumberField.delegate =self;
    barcodeNumberField.text = @"";
    barcodeNumberField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    barcodeNumberField.keyboardType = UIKeyboardTypeNumberPad;
    
    UIView *barcodeView = [[UIView alloc] init];
    barcodeView.frame = CGRectMake(0, 0, 10, 35);
    barcodeNumberField.leftView = barcodeView;
    barcodeNumberField.leftViewMode = UITextFieldViewModeAlways;
    
    logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutButton addTarget:self action:@selector(logoutButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
    [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutButton setBackgroundImage:[UIImage imageNamed:@"purple_Normal.png"] forState:UIControlStateNormal];
    [logoutButton setBackgroundImage:[UIImage imageNamed:@"orange_Normal.png"] forState:UIControlStateSelected];
    [logoutButton setBackgroundImage:[UIImage imageNamed:@"orange_Normal.png"] forState:UIControlStateHighlighted];
    
    goButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [goButton addTarget:self action:@selector(goButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [goButton setTitle:@"Go" forState:UIControlStateNormal];
    [goButton setTitleColor:[FAUtilities getUIColorObjectFromHexString:@"#8D318A" alpha:.9] forState:UIControlStateNormal];
    
    settingsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [settingsButton addTarget:self action:@selector(chooseRestaurantButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [settingsButton setBackgroundImage:[UIImage imageNamed:@"gear_wheel.png"] forState:UIControlStateNormal];
    
    restaurantListSubView = [[UIView alloc]init];
    restaurantListSubView.backgroundColor = [UIColor clearColor];
    
    selectRestaurantHeaderView = [[UIView alloc] init];
    selectRestaurantHeaderView.backgroundColor = [UIColor colorWithRed:164.0f/255.0f green:78.0f/255.0f blue:156.0f/255.0f alpha:1.0];
    
    selectRestaurantHeader = [[UILabel alloc] init];
    selectRestaurantHeader.textColor = [UIColor whiteColor];
    selectRestaurantHeader.backgroundColor=[UIColor colorWithRed:164.0f/255.0f green:78.0f/255.0f blue:156.0f/255.0f alpha:1.0];
    selectRestaurantHeader.userInteractionEnabled=NO;
    selectRestaurantHeader.textAlignment = NSTextAlignmentCenter;
    selectRestaurantHeader.text= @"Choose Restaurant";
    [selectRestaurantHeaderView addSubview:selectRestaurantHeader];
    
    restaurantCancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [restaurantCancelButton setBackgroundImage:[UIImage imageNamed:@"close_Button.png"] forState:UIControlStateNormal];
    [restaurantCancelButton addTarget:self action:@selector(restaurantCancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [selectRestaurantHeaderView addSubview:restaurantCancelButton];
    [restaurantListSubView addSubview:selectRestaurantHeaderView];
    
    selectRestaruantTableView = [[UITableView alloc]init];
    selectRestaruantTableView.backgroundColor = [UIColor colorWithRed:255/255.0f green:238/255.0f blue:219/255.0f alpha:1.0];
    selectRestaruantTableView.delegate =self;
    selectRestaruantTableView.dataSource =self;
    
    selectRestaurantSubview = [[UIView alloc] init];
    selectRestaurantSubview.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:215.0f/255.0f blue:233.0f/255.0f alpha:1.0];
    
    enterBarcodeSubView = [[UIView alloc] init];
    enterBarcodeSubView.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:238.0f/255.0f blue:219.0f/255.0f alpha:1.0];
    enterBarcodeSubView.hidden=NO;
    
    enterBarcodeHeaderView = [[UIView alloc] init];
    enterBarcodeHeaderView.backgroundColor = [UIColor colorWithRed:164.0f/255.0f green:78.0f/255.0f blue:156.0f/255.0f alpha:1.0];
    
    enterBarcodeHeader = [[UILabel alloc] init];
    enterBarcodeHeader.textColor = [UIColor whiteColor];
    enterBarcodeHeader.backgroundColor=[UIColor colorWithRed:164.0f/255.0f green:78.0f/255.0f blue:156.0f/255.0f alpha:1.0];
    enterBarcodeHeader.userInteractionEnabled=NO;
    enterBarcodeHeader.textAlignment = NSTextAlignmentCenter;
    enterBarcodeHeader.text= @"Enter Barcode Value";
    [enterBarcodeHeaderView addSubview:enterBarcodeHeader];
    
    enterBarcodeViewCancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [enterBarcodeViewCancelButton setBackgroundImage:[UIImage imageNamed:@"close_Button.png"] forState:UIControlStateNormal];
    [enterBarcodeViewCancelButton addTarget:self action:@selector(enterBarcodeViewCancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [enterBarcodeHeaderView addSubview:enterBarcodeViewCancelButton];
    [enterBarcodeSubView addSubview:enterBarcodeHeaderView];
    
    if ([restauranta count ]!= 0) {
        
        NSMutableDictionary *tempDict = [restauranta objectAtIndex:0];
        NSString *rest_address,*rest_city,*rest_state,*rest_zip,*rest_name,*rest_contactName,*rest_phone;
        if ((tempDict == (id)[NSNull null]) ||(tempDict==nil)) {
        }else{
            if ([[tempDict allKeys] containsObject:@"Rest_Address"]) {
                rest_address= [tempDict objectForKey:@"Rest_Address"];
                NSLog(@"contains address Key");
            }else{
            }
            if ([[tempDict allKeys] containsObject:@"Rest_City"]) {
                rest_city= [tempDict objectForKey:@"Rest_City"];
                NSLog(@"contains city Key");
            }else{
            }
            if ([[tempDict allKeys] containsObject:@"Rest_State"]) {
                rest_state= [tempDict objectForKey:@"Rest_State"];
                NSLog(@"contains state Key");
            }else{
            }
            if ([[tempDict allKeys] containsObject:@"Rest_Zip"]) {
                rest_zip= [tempDict objectForKey:@"Rest_Zip"];
                NSLog(@"contains zip Key");
            }else{
            }if ([[tempDict allKeys] containsObject:@"Rest_Name"]) {
                rest_name= [tempDict objectForKey:@"Rest_Name"];
                NSLog(@"contains name Key");
            }else{
            }if ([[tempDict allKeys] containsObject:@"Rest_ContactName"]) {
                rest_contactName= [tempDict objectForKey:@"Rest_ContactName"];
                NSLog(@"contains contactName Key");
            }else{
            }if ([[tempDict allKeys] containsObject:@"Rest_Phone"]) {
                rest_phone=[tempDict objectForKey:@"Rest_Phone"];
                NSLog(@"contains phone Key");
            }else{
            }
            addressVal = [NSString stringWithFormat:@"%@,%@,%@,%@",rest_address,rest_city,rest_state,rest_zip];
            NSLog(@"addressVal before spaces and next line%@",addressVal);
            
            addressVal = [addressVal stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
            NSLog(@"addressVal after spaces and next line%@",addressVal);
//            addressVal = [NSString stringWithFormat:@"%@,%@,%@,%@",rest_address,rest_city,rest_state,rest_zip];
        }
        retaurantHeader = [[UILabel alloc] init];
        retaurantHeader.textColor = [UIColor whiteColor];
        retaurantHeader.backgroundColor=[UIColor colorWithRed:164.0f/255.0f green:78.0f/255.0f blue:156.0f/255.0f alpha:1.0];
        retaurantHeader.userInteractionEnabled=NO;
        retaurantHeader.textAlignment = NSTextAlignmentCenter;
        retaurantHeader.text= @"Restaurant Details";
        
        restNameLabel = [[UILabel alloc] init];
        restNameLabel.textColor = [UIColor blackColor];
        restNameLabel.backgroundColor=[UIColor clearColor];
        restNameLabel.userInteractionEnabled=NO;
        restNameLabel.text=rest_name;
        restNameLabel.numberOfLines=0;
        restNameLabel.adjustsFontSizeToFitWidth = YES;
        restNameLabel.minimumScaleFactor=0.5;
        [restNameLabel sizeToFit];
        
        restAddressLabel = [[UILabel alloc] init];
        restAddressLabel.textColor = [UIColor blackColor];
        restAddressLabel.text=addressVal;
        restAddressLabel.backgroundColor=[UIColor clearColor];
        restAddressLabel.userInteractionEnabled=NO;
//        restAddressLabel.numberOfLines=0;
//        restAddressLabel.adjustsFontSizeToFitWidth = YES;
//        restAddressLabel.minimumScaleFactor=0.7;
//        [restAddressLabel sizeToFit];
        
        restContactNameLabel = [[UILabel alloc] init];
        restContactNameLabel.textColor = [UIColor blackColor];
        restContactNameLabel.backgroundColor=[UIColor clearColor];
        restContactNameLabel.userInteractionEnabled=NO;
        restContactNameLabel.text= rest_contactName;
        restContactNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        restContactNameLabel.numberOfLines = 2;
        
        restPhoneLabel = [[UILabel alloc] init];
        restPhoneLabel.textColor = [UIColor blackColor];
        restPhoneLabel.text=rest_phone;
        restPhoneLabel.backgroundColor=[UIColor clearColor];
        restPhoneLabel.userInteractionEnabled=NO;
        restPhoneLabel.lineBreakMode = NSLineBreakByWordWrapping;
        restPhoneLabel.numberOfLines = 2;
        
        restEmailLabel = [[UILabel alloc] init];
        restEmailLabel.textColor = [UIColor blackColor];
        if ([loginDetails count]>0) {
            restEmailLabel.text=[[loginDetails objectAtIndex:0] valueForKey:@"UserName"];
        }
        restEmailLabel.backgroundColor=[UIColor clearColor];
        restEmailLabel.userInteractionEnabled=NO;
       
    }else{
        [FAUtilities showToastMessageAlert:@"Restaurants not available for this user"];
    }
    scanBarcodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanBarcodeBtn addTarget:self action:@selector(scanBarcodeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scanBarcodeBtn setBackgroundImage:[UIImage imageNamed:@"purple_Normal.png"] forState:UIControlStateNormal];
    [scanBarcodeBtn setBackgroundImage:[UIImage imageNamed:@"orange_Normal.png"] forState:UIControlStateSelected];
    [scanBarcodeBtn setBackgroundImage:[UIImage imageNamed:@"orange_Normal.png"] forState:UIControlStateHighlighted];
    [scanBarcodeBtn setTitle:@"Scan Barcode" forState:UIControlStateNormal];
    [scanBarcodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    enterBarcodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [enterBarcodeBtn addTarget:self action:@selector(enterBarcodeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [enterBarcodeBtn setBackgroundImage:[UIImage imageNamed:@"purple_Normal.png"] forState:UIControlStateNormal];
    [enterBarcodeBtn setBackgroundImage:[UIImage imageNamed:@"orange_Normal.png"] forState:UIControlStateSelected];
    [enterBarcodeBtn setBackgroundImage:[UIImage imageNamed:@"orange_Normal.png"] forState:UIControlStateHighlighted];
    [enterBarcodeBtn setTitle:@"Enter Barcode" forState:UIControlStateNormal];
    [enterBarcodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [ZBarReaderViewController class];
    reader =[ZBarReaderViewController new];
    reader.readerDelegate = self;
    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology: ZBAR_CODE128 config: ZBAR_CFG_ENABLE to: 1];
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    OverlayView *overlay = [[OverlayView alloc] init];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        logoutButton.titleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
        retaurantHeader.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:35.0f];
        restNameLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:30.0f];
        restAddressLabel.font =[UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
        restContactNameLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
        restPhoneLabel.font =[UIFont fontWithName:@"TrebuchetMS" size:20.0f];
        restEmailLabel.font =[UIFont fontWithName:@"TrebuchetMS" size:20.0f];
        scanBarcodeBtn.titleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:40.0f];
        enterBarcodeBtn.titleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:40.0f];
        enterBarcodeHeader.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:35.0f];
        goButton.titleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:30.0f];
        selectRestaurantHeader.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:35.0f];
        barcodeNumberField.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
    }
    
    reader.cameraOverlayView = overlay;
    reader.extendedLayoutIncludesOpaqueBars = NO;//deprecated in 7 so replaced with this wantsFullScreenLayout
    reader.modalPresentationStyle = UIModalTransitionStyleCrossDissolve;
//    reader.readerView

//    reader.maxScanDimension = 1000;
    
}

-(void)scanBarcodeButtonClicked:(id)sender{

    [self.view endEditing:YES];
    if ([restauranta count] == 0) {
        [FAUtilities showToastMessageAlert:@"No restaurants found to scan barcode"];
    }else{
        readBarCodeButton = (UIButton*)sender;
        if (chooseRestaurantButtonClicked==YES) {
            [self restaurantCancelButtonClicked:nil];
        }
        if (enterBarcodeButtonClicked == YES) {
            [self enterBarcodeViewCancelButtonClicked:nil];
        }
        
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
//            reader.scanCrop = CGRectMake(0, 0.375, 1, 0.25); // x,y,w,h

//            reader.scanCrop = CGRectMake(0, 0.25, 1, 0.5); // x,y,w,h for 2d bar code

            reader.scanCrop = CGRectMake(0.125, 0.25, 0.75, 0.5); // x,y,w,h for 2d bar code with width

            
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
//            reader.scanCrop = CGRectMake(0.25, 0, 0.5, 1); // x,y,w,h

            reader.scanCrop = CGRectMake(0.25, 0.123, 0.5, 0.75); // x,y,w,h with width

        }

//        reader.view.layer.borderColor = [[UIColor greenColor] CGColor];
//        reader.view.layer.borderWidth = 4;
        
        
    
        
        
        [self presentViewController:reader animated:YES completion:nil];
    }
}

- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader withRetry: (BOOL) retry{
}
- (void)  imagePickerController: (UIImagePickerController*) picker didFinishPickingMediaWithInfo: (NSDictionary*) info{
    scanBarcodeButtonClicked = NO;
    SystemSoundID soundID;
    NSString *soundFile = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"wav"];
    NSURL *fileURL = [NSURL URLWithString:[soundFile stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    AudioServicesCreateSystemSoundID (CFBridgingRetain(fileURL), &soundID);
    AudioServicesPlaySystemSound(soundID);
    [reader dismissViewControllerAnimated:NO completion:nil];
    id <NSFastEnumeration> syms =[info objectForKey: ZBarReaderControllerResults];
    
    for(ZBarSymbol *sym in syms) {
        barcodeNumberField.text = sym.data;
        if (IS_EMPTY(barcodeNumberField.text)){
        }else{
            scanBarcodeButtonClicked = YES;
            self.locationManager = [[CLLocationManager alloc] init];
            [self.locationManager setDelegate:self];
            haveAlreadyReceivedCoordinates = NO;
            [self.locationManager startUpdatingLocation];
        }
    }
}

-(void)enterBarcodeViewCancelButtonClicked:(id)sender{
    enterBarcodeButtonClicked =NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:[self view]      cache:NO];
    [UIView commitAnimations];
    [enterBarcodeSubView removeFromSuperview];
}

-(void)goButtonClicked:(id)sender{
    
    goButtonClicked=NO;
    
    [self.view endEditing:YES];
    if (IS_EMPTY(barcodeNumberField.text)){
        [FAUtilities showToastMessageAlert:@"Please Enter Barcode"];
    }else{
        goButtonClicked=YES;
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDelegate:self];
        haveAlreadyReceivedCoordinates = NO;
        [self.locationManager startUpdatingLocation];
    }
}


#pragma  - Request
-(void)postRequest:(NSString *)reqType{
    NSString *postDataInString = [self postFormatString:BARCODE_SCAN_TYPE withBarcodeVal:barcodeNumberField.text];
    NSData *postJsonData = [postDataInString dataUsingEncoding:NSUTF8StringEncoding];
    webServiceInterface = [[WebServiceInterface alloc]initWithVC:self];
    webServiceInterface.delegate =self;
    [webServiceInterface sendRequest:postDataInString PostJsonData:postJsonData Req_Type:reqType Req_url:Barcode_Scan_URL];
}

-(NSString*)postFormatString:(NSString *)type withBarcodeVal:(NSString *)barcode{
    NSDictionary *rest_Dict =[restauranta objectAtIndex:0];
    NSString *rest_id;
    if ([[rest_Dict allKeys] containsObject:@"Rest_Id"]) {
        rest_id= [rest_Dict valueForKey:@"Rest_Id"];
        NSLog(@"contains rest_id Key");
    }else{
    }
    if (((selectedRest_Id == (id)[NSNull null])|| (selectedRest_Id==nil)||  (selectedRest_Id.length==0))) {
        selectedRest_Id =rest_id;
    }
    uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
    NSLog(@"UDID:: %@", uniqueIdentifier);
    NSString *bodyStr =[NSString stringWithFormat: @"{\"res_id\":\"%@\", \"barcode\":\"%@\", \"device_details\": {\"device_id\":\"%@\", \"lat\":\"%@\", \"long\":\"%@\"}}",selectedRest_Id,barcode,uniqueIdentifier,latitudeString,longitudeString];
    return bodyStr;
}

-(void)getResponse:(NSDictionary *)resp type:(NSString *)respType{
    
    if ((resp == (id)[NSNull null]) ||(resp==nil)) {
    }else{
        NSString  *message;
        NSString  *status;
        NSDictionary *restaurantDetailDict;
        if ([[resp allKeys] containsObject:@"message"]) {
            message= [resp valueForKey:@"message"];
            NSLog(@"contains message Key");
            // contains key
        }else{
        }if ([[resp allKeys] containsObject:@"status"]) {
            status = [resp valueForKey:@"status"];
            NSLog(@"contains status Key");
            // contains key
         }else{
         }if ([[resp allKeys] containsObject:@"details"]) {
            restaurantDetailDict = [resp valueForKey:@"details"];
            NSLog(@"contains restaurantDetailDict Key");
            // contains key
         }else{
         }

        if ((status == (id)[NSNull null])||(status.length==0)||(status==nil)) {
        }else{
            if ([status isEqualToString:@"success"]) {
                if ((message == (id)[NSNull null])||(message==nil)) {
                    NSLog(@"null message:%@",message);
                }
                BarcodeDetailsViewController *barcodeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BarcodeDetailsViewController"];
                if ((restaurantDetailDict == (id)[NSNull null]) ||(restaurantDetailDict==nil)) {
                    [FAUtilities showToastMessageAlert:@"Restaurant details not found for this barcode"];
                }else{
                    barcodeViewController.restDetails = restaurantDetailDict;
                }
                if ((barcodeNumberField.text == (id)[NSNull null])||(barcodeNumberField.text.length==0)||(barcodeNumberField.text==nil)) {
                    barcodeViewController.barcodeVal = @"";
                }else{
                    barcodeViewController.barcodeVal = barcodeNumberField.text;
                }
                
                if ((selectedRest_Id== (id)[NSNull null])||(selectedRest_Id.length==0)||(selectedRest_Id==nil)) {
                    barcodeViewController.restId = @"";
                }else{
                    barcodeViewController.restId = selectedRest_Id;
                }
                if ((restNameLabel.text== (id)[NSNull null])||(restNameLabel.text.length==0)||(restNameLabel.text==nil)) {
                    barcodeViewController.currentRestName =@"";
                }else{
                    barcodeViewController.currentRestName =restNameLabel.text;
                }
                [self.navigationController pushViewController:barcodeViewController animated:YES];
                
                [self enterBarcodeViewCancelButtonClicked:nil];
                barcodeNumberField.text=@"";
            }else{
                
                if ((message == (id)[NSNull null])||(message.length==0)||(message==nil)) {
                    [FAUtilities showToastMessageAlert:@"Unable to recieve message from server"];
                }else{
                    if (IS_EMPTY(message)) {
                        [FAUtilities showToastMessageAlert:@"Unable to recieve deal details from server"];
                    }else{
                        [FAUtilities showToastMessageAlert:message];
                    }
                }
                
            }
        }
    }
}

-(void)enterBarcodeButtonClicked:(id)sender{
    if ([restauranta count] == 0) {
        [FAUtilities showToastMessageAlert:@"No restaurants found to enter barcode"];
    }else{
        
        if (chooseRestaurantButtonClicked == YES) {
            [self restaurantCancelButtonClicked:nil];
        }
        
        
        if(enterBarcodeButtonClicked==NO){
            if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){//setting the form list table frame when returing back to the form list view
                [self barcodeLandscape];
                
            }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
                [self barcodePotrait];
                
            }
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                enterBarcodeViewCancelButton.frame= CGRectMake(0.0f,0.0f,40.0f,40.0f);
                
            }else{
                enterBarcodeViewCancelButton.frame= CGRectMake(0.0f,0.0f,20.0f,20.0f);
            }
            enterBarcodeSubView.hidden=NO;
            enterBarcodeSubView.layer.borderWidth = 1;
            enterBarcodeSubView.layer.borderColor = [UIColor blackColor].CGColor;
            [enterBarcodeSubView addSubview:goButton];
            [enterBarcodeSubView addSubview:barcodeNumberField];
            [self.view addSubview:enterBarcodeSubView];
            enterBarcodeButtonClicked =YES;
        }
    }
}

-(void)barcodePotrait{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        enterBarcodeSubView.frame = CGRectMake(72, 250, self.view.frame.size.width-144, 100);
        enterBarcodeHeaderView.frame = CGRectMake(0.0f,0.0f,enterBarcodeSubView.frame.size.width,40.0f);
        enterBarcodeHeader.frame= CGRectMake(enterBarcodeViewCancelButton.frame.origin.x + enterBarcodeViewCancelButton.frame.size.width+10.0f,6.0f,enterBarcodeSubView.frame.size.width-enterBarcodeViewCancelButton.frame.size.width-20.0,30.0f);
        barcodeNumberField.frame= CGRectMake(10.0f, 48.0f,enterBarcodeHeaderView.frame.size.width-70.0f, 40.0f);
        
        goButton.frame= CGRectMake(barcodeNumberField.frame.origin.x +barcodeNumberField.frame.size.width+5.0, 48.0f,50.0f, 40.0f);
    }else{
        enterBarcodeSubView.frame = CGRectMake(10, 150, self.view.frame.size.width-20, 50);
        enterBarcodeHeaderView.frame = CGRectMake(0.0f,0.0f,enterBarcodeSubView.frame.size.width,20.0f);
        enterBarcodeHeader.frame= CGRectMake(enterBarcodeViewCancelButton.frame.origin.x + enterBarcodeViewCancelButton.frame.size.width+10.0f,0.0f,enterBarcodeSubView.frame.size.width-enterBarcodeViewCancelButton.frame.size.width-20.0,20.0f);
        enterBarcodeHeader.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:15.0f];
        
        barcodeNumberField.frame= CGRectMake(5.0f,22.0f,enterBarcodeHeaderView.frame.size.width-50.0f, 25.0f);
        barcodeNumberField.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:15.0f];
        
        goButton.frame= CGRectMake(barcodeNumberField.frame.origin.x +barcodeNumberField.frame.size.width, 22.0f,50.0f, 25.0f);
        goButton.titleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:15.0f];
    }
}
-(void)barcodeLandscape{
    enterBarcodeSubView.frame = CGRectMake(185, 200,660,100);
    enterBarcodeHeaderView.frame = CGRectMake(0.0f,0.0f,enterBarcodeSubView.frame.size.width,40.0f);
    enterBarcodeHeader.frame= CGRectMake(enterBarcodeViewCancelButton.frame.origin.x + enterBarcodeViewCancelButton.frame.size.width+10.0f,6.0f,enterBarcodeSubView.frame.size.width-enterBarcodeViewCancelButton.frame.size.width-20.0,30.0f);
    barcodeNumberField.frame= CGRectMake(10.0f, 48.0f,enterBarcodeHeaderView.frame.size.width-70.0f, 40.0f);
    goButton.frame= CGRectMake(barcodeNumberField.frame.origin.x +barcodeNumberField.frame.size.width+5.0, 48.0f,50.0f, 40.0f);
}
-(void)Landscape{
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 1024, 768);
    selectRestaurantSubview.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y+125,self.view.frame.size.width,self.view.frame.size.height-255);
    [self drawAttachment];
    self.view.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBg_L.png"]];
}
-(void)Potrait{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        
        self.view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBg_P.png"]];
        selectRestaurantSubview.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y+124,self.view.frame.size.width,self.view.frame.size.height-252);
        [self drawAttachment];
        
    }else{
        if ([UIScreen mainScreen].bounds.size.height == 568) {  // iphone 4 inch
            selectRestaurantSubview.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y+77,self.view.frame.size.width,self.view.frame.size.height-159);
            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphoneBg_320x568.png"]];
            logoutButton.frame = CGRectMake(250,35, 60, 26.0);
            retaurantHeader.frame = CGRectMake(0,0,self.view.frame.size.width,30.0f);
        }else{// iphone 3.5 inch
            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphoneBg_320x480.png"]];
            selectRestaurantSubview.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y+80,self.view.frame.size.width,self.view.frame.size.height-162);
            logoutButton.frame = CGRectMake(250,38, 60, 26.0);
            retaurantHeader.frame = CGRectMake(0,0,self.view.frame.size.width,30.0f);
        }
        
        retaurantHeader.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:15.0f];
        logoutButton.titleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:15.0f];
        restNameLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:15.0f];
        restAddressLabel.font =[UIFont fontWithName:@"TrebuchetMS" size:10.0f];
        restContactNameLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:10.0f];
        restPhoneLabel.font =[UIFont fontWithName:@"TrebuchetMS" size:10.0f];
        restEmailLabel.font =[UIFont fontWithName:@"TrebuchetMS" size:10.0f];
        scanBarcodeBtn.titleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
        enterBarcodeBtn.titleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
        
        restNameLabel.frame = CGRectMake(self.view.frame.origin.x+2,retaurantHeader.frame.origin.y+retaurantHeader.frame.size.height+5.0f,self.view.frame.size.width-30.0f,20.0f);
        
        settingsButton.frame = CGRectMake(restNameLabel.frame.origin.x+restNameLabel.frame.size.width+5.0f,retaurantHeader.frame.origin.y+retaurantHeader.frame.size.height+5.0, 20.0, 20.0);
//        if (addressVal.length!=0) {
//
//        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:addressVal attributes:@{NSFontAttributeName: restAddressLabel.font }];
//        CGRect rect = [attributedText boundingRectWithSize:(CGSize){self.view.frame.size.width-2*restNameLabel.frame.origin.x, CGFLOAT_MAX}
//                                                   options:NSStringDrawingUsesLineFragmentOrigin
//                                                   context:nil];
//        CGSize size = rect.size;
//        size.height = ceilf(size.height);
//        size.width  = ceilf(size.width);
//        restAddressLabel.frame = CGRectMake(restNameLabel.frame.origin.x,restNameLabel.frame.origin.y+restNameLabel.frame.size.height,size.width,size.height);
//        }else{
//            restAddressLabel.frame = CGRectMake(restNameLabel.frame.origin.x,restNameLabel.frame.origin.y+restNameLabel.frame.size.height,self.view.frame.size.width-2*restNameLabel.frame.origin.x,20.0);
//
//        }
         restAddressLabel.frame = CGRectMake(restNameLabel.frame.origin.x,restNameLabel.frame.origin.y+restNameLabel.frame.size.height,self.view.frame.size.width-10,20);
        restContactNameLabel.frame =  CGRectMake(restAddressLabel.frame.origin.x,restAddressLabel.frame.origin.y+restAddressLabel.frame.size.height,self.view.frame.size.width-10,15.0);
        
        
        restPhoneLabel.frame =CGRectMake(restContactNameLabel.frame.origin.x,restContactNameLabel.frame.origin.y+restContactNameLabel.frame.size.height,self.view.frame.size.width-10,15.0);
        restEmailLabel.frame =CGRectMake(restPhoneLabel.frame.origin.x,restPhoneLabel.frame.origin.y+restPhoneLabel.frame.size.height,self.view.frame.size.width-10,25.0);
        

        
        scanBarcodeBtn.frame = CGRectMake(self.view.frame.origin.x+10.0,restEmailLabel.frame.origin.y+restEmailLabel.frame.size.height+10.0f,(self.view.frame.size.width-20), 40.0f);
        enterBarcodeBtn.frame = CGRectMake(self.view.frame.origin.x+10.0,scanBarcodeBtn.frame.origin.y+scanBarcodeBtn.frame.size.height+5.0f,(self.view.frame.size.width-20), 40.0f);
        
    }
}
-(void)drawAttachment{
    logoutButton.frame = CGRectMake(self.view.frame.origin.x+self.view.frame.size.width-140,self.view.frame.origin.y+45, 120, 40.0);
    retaurantHeader.frame = CGRectMake(selectRestaurantSubview.frame.origin.x,0,selectRestaurantSubview.frame.size.width,50.0f);
    restNameLabel.frame = CGRectMake(retaurantHeader.frame.origin.x+5,retaurantHeader.frame.origin.y+retaurantHeader.frame.size.height+5.0f,retaurantHeader.frame.size.width-10*(retaurantHeader.frame.origin.x+5),50.0f);
    settingsButton.frame = CGRectMake(restNameLabel.frame.origin.x+restNameLabel.frame.size.width+5.0f,restNameLabel.frame.size.height+15.0f, 30.0, 30.0);
//    if (addressVal.length!=0) {
//        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:addressVal attributes:@{NSFontAttributeName: restAddressLabel.font }];
//        CGRect rect = [attributedText boundingRectWithSize:(CGSize){self.view.frame.size.width-2*restNameLabel.frame.origin.x, CGFLOAT_MAX}
//                                                   options:NSStringDrawingUsesLineFragmentOrigin
//                                                   context:nil];
//        CGSize size = rect.size;
//        size.height = ceilf(size.height);
//        size.width  = ceilf(size.width);
//        restAddressLabel.frame = CGRectMake(restNameLabel.frame.origin.x,restNameLabel.frame.origin.y+restNameLabel.frame.size.height,size.width,size.height);
//
//    }else {
//        restAddressLabel.frame = CGRectMake(restNameLabel.frame.origin.x,restNameLabel.frame.origin.y+restNameLabel.frame.size.height+1.0,retaurantHeader.frame.size.width-2*(restNameLabel.frame.origin.x),30);
//  
//    }
    restAddressLabel.frame = CGRectMake(restNameLabel.frame.origin.x,restNameLabel.frame.origin.y+restNameLabel.frame.size.height,self.view.frame.size.width-10,20);

    restContactNameLabel.frame =  CGRectMake(restAddressLabel.frame.origin.x,restAddressLabel.frame.origin.y+restAddressLabel.frame.size.height+1.0,self.view.frame.size.width-10,20);
    restPhoneLabel.frame =CGRectMake(restContactNameLabel.frame.origin.x,restContactNameLabel.frame.origin.y+restContactNameLabel.frame.size.height+1.0,self.view.frame.size.width-10,20);
    
    restEmailLabel.frame =CGRectMake(restPhoneLabel.frame.origin.x,restPhoneLabel.frame.origin.y+restPhoneLabel.frame.size.height+1.0,self.view.frame.size.width-10,30);
    
    scanBarcodeBtn.frame = CGRectMake(self.view.frame.origin.x+10.0,restEmailLabel.frame.origin.y+restEmailLabel.frame.size.height+10.0f,(self.view.frame.size.width-20), 70.0f);
    enterBarcodeBtn.frame = CGRectMake(self.view.frame.origin.x+10.0,scanBarcodeBtn.frame.origin.y+scanBarcodeBtn.frame.size.height+5.0f,(self.view.frame.size.width-20), 70.0f);
}
-(void)selectRestPotrait{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        restaurantListSubView.frame = CGRectMake(72, 250, 623, 550);
        selectRestaruantTableView.frame= CGRectMake(0.0,40,restaurantListSubView.frame.size.width,508);
        selectRestaurantHeaderView.frame = CGRectMake(0.0f,0.0f,restaurantListSubView.frame.size.width,40.0f);
        selectRestaurantHeader.frame= CGRectMake(restaurantCancelButton.frame.origin.x + restaurantCancelButton.frame.size.width+10.0f,6.0f,restaurantListSubView.frame.size.width-restaurantCancelButton.frame.size.width-20.0,30.0f);
    }else{
        if ([UIScreen mainScreen].bounds.size.height == 568) {//4.0
            restaurantListSubView.frame = CGRectMake(10, 120, 300, 350);
            selectRestaruantTableView.frame= CGRectMake(0.0,20,restaurantListSubView.frame.size.width,330);
        }else{//3.5
            restaurantListSubView.frame = CGRectMake(10, 120, 300, 270);
            selectRestaruantTableView.frame= CGRectMake(0.0,20,restaurantListSubView.frame.size.width,250);
        }
        selectRestaurantHeaderView.frame = CGRectMake(0.0f,0.0f,restaurantListSubView.frame.size.width,20.0f);
        selectRestaurantHeader.frame= CGRectMake(restaurantCancelButton.frame.origin.x + restaurantCancelButton.frame.size.width+10.0f,0.0f,restaurantListSubView.frame.size.width-restaurantCancelButton.frame.size.width-20.0,20.0f);
        selectRestaurantHeader.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:15.0f];
    }
}
-(void)selectRestLandscape{
    //    CGRectMake(self.view.frame.size.width/4,self.view.frame.size.height/3,self.view.frame.size.width-2*(self.view.frame.size.width/4), 225.0f);
    restaurantListSubView.frame = CGRectMake(self.view.frame.size.width/6, self.view.frame.size.height/4,700,420);
    selectRestaurantHeaderView.frame = CGRectMake(0.0f,0.0f,restaurantListSubView.frame.size.width,40.0f);
    selectRestaurantHeader.frame= CGRectMake(restaurantCancelButton.frame.origin.x + restaurantCancelButton.frame.size.width+10.0f,6.0f,650,30.0f);
    selectRestaruantTableView.frame= CGRectMake(0.0,selectRestaurantHeaderView.frame.origin.y+selectRestaurantHeaderView.frame.size.height,restaurantListSubView.frame.size.width,380);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([restauranta count]>0) {
        return [restauranta count];
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        cell.textLabel.font = [UIFont fontWithName:@"TrebuchetMS" size:25.0];
        
    }else{
        cell.textLabel.font = [UIFont fontWithName:@"TrebuchetMS" size:12.0];
    }
    
    NSDictionary *tempDict;
    NSString *restName;
    if ([restauranta count]>0) {
        tempDict= [restauranta objectAtIndex:indexPath.row];
        restName =[tempDict objectForKey:@"Rest_Name"];
        if ((restName == (id)[NSNull null])||(restName.length==0)||(restName==nil)) {
            cell.textLabel.text = @"----------";
        }else{
            cell.textLabel.text = restName;
            //            cell.textLabel.numberOfLines=2;
            //            cell.textLabel.adjustsFontSizeToFitWidth = YES;//autoshrink the label text in fixed width
            //            cell.textLabel.minimumScaleFactor=0.5;
            //            [cell.textLabel sizeToFit];
        }
    }else{
        cell.textLabel.text = @"----------";
    }
    
    if(indexPath.row == selectedIndex)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.backgroundColor = [UIColor colorWithRed:255/255.0f green:238/255.0f blue:219/255.0f alpha:1.0];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *tempDict = [restauranta objectAtIndex:indexPath.row];
    NSString *rest_address,*rest_city,*rest_state,*rest_zip,*rest_name,*rest_contactName,*rest_phone,*rest_id;
    if ((tempDict == (id)[NSNull null]) ||(tempDict==nil)) {
    }else{
        if ([[tempDict allKeys] containsObject:@"Rest_Address"]) {
            rest_address= [tempDict objectForKey:@"Rest_Address"];
            NSLog(@"contains address Key");
        }else{
        }
        if ([[tempDict allKeys] containsObject:@"Rest_City"]) {
            rest_city= [tempDict objectForKey:@"Rest_City"];
            NSLog(@"contains city Key");
        }else{
        }
        if ([[tempDict allKeys] containsObject:@"Rest_State"]) {
            rest_state= [tempDict objectForKey:@"Rest_State"];
            NSLog(@"contains state Key");
        }else{
        }
        if ([[tempDict allKeys] containsObject:@"Rest_Zip"]) {
            rest_zip= [tempDict objectForKey:@"Rest_Zip"];
            NSLog(@"contains zip Key");
        }else{
        }if ([[tempDict allKeys] containsObject:@"Rest_Name"]) {
            rest_name= [tempDict objectForKey:@"Rest_Name"];
            NSLog(@"contains name Key");
        }else{
        }if ([[tempDict allKeys] containsObject:@"Rest_ContactName"]) {
            rest_contactName= [tempDict objectForKey:@"Rest_ContactName"];
            NSLog(@"contains contactName Key");
        }else{
        }if ([[tempDict allKeys] containsObject:@"Rest_Phone"]) {
            rest_phone=[tempDict objectForKey:@"Rest_Phone"];
            NSLog(@"contains phone Key");
        }else{
        }if ([[tempDict allKeys] containsObject:@"Rest_Id"]) {
            rest_id= [tempDict valueForKey:@"Rest_Id"];
            NSLog(@"contains rest_id Key");
        }else{
        }
        addressVal = [NSString stringWithFormat:@"%@,%@,%@,%@",rest_address,rest_city,rest_state,rest_zip];
        NSLog(@"addressVal before spaces and next line%@",addressVal);

        addressVal = [addressVal stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        NSLog(@"addressVal after spaces and next line%@",addressVal);
    }

    
    restNameLabel.text = rest_name;
    restContactNameLabel.text = rest_contactName;
    NSMutableArray* loginDetailsArray= [[NSMutableArray alloc]init];
    [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM LoginDetails"] resultsArray:loginDetailsArray];
    NSDictionary* loginDictionary =[loginDetailsArray objectAtIndex:0];
    restEmailLabel.text=[loginDictionary valueForKey:@"UserName"];
    restPhoneLabel.text = rest_phone;
    restAddressLabel.text =addressVal;
    selectedRest_Id = rest_id;
    selectedIndex = indexPath.row;
    [tableView reloadData];
    [self restaurantCancelButtonClicked:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return 44;
    }else{
        return 30;
    }
}


-(void)logoutButtonClicked:(id)sender{
    
//    [logoutButton setBackgroundImage:[UIImage imageNamed:@"Btn_Active.png"] forState:UIControlStateSelected];
//    [logoutButton setBackgroundImage:[UIImage imageNamed:@"Btn_Active.png"] forState:UIControlStateHighlighted];
    [logoutButton setBackgroundImage:[UIImage imageNamed:@"purple.png"]forState:UIControlStateNormal];
    [logoutButton setBackgroundImage:[UIImage imageNamed:@"orange.png"] forState:UIControlStateSelected];
    [logoutButton setBackgroundImage:[UIImage imageNamed:@"orange.png"] forState:UIControlStateHighlighted];
    //  dbManager = [DataBaseManager dataBaseManager];
    
    //  NSMutableArray *loginDetails = [[NSMutableArray alloc]init];
    //  [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM LoginDetails"] resultsArray:loginDetails];
    
    //   NSString *currentUser = [[loginDetails objectAtIndex:0] valueForKey:@"CurrentUser"];
    NSString *currentUser = [loginDict valueForKey:@"CurrentUser"];
    if ([currentUser isEqualToString:@"ON"]) {
        [dbManager execute:[NSString stringWithFormat:@"Update LoginDetails set CurrentUser ='%@'",@"OFF"]];
    }
    NSMutableArray *logoutDetails = [[NSMutableArray alloc]init];
    [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM LoginDetails"] resultsArray:logoutDetails];
    
    LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [UIView animateWithDuration:0.75 animations:^{[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [self.navigationController pushViewController:loginViewController animated:YES];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];}];
}
-(void)chooseRestaurantButtonClicked:(id)sender{
    
    if (enterBarcodeButtonClicked == YES) {
        [self enterBarcodeViewCancelButtonClicked:nil];
    }
    if (chooseRestaurantButtonClicked==NO) {
        
        restaurantListSubView.hidden =NO;
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){//setting the form list table frame when returing back to the form list view
            [self selectRestLandscape];
            
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            [self selectRestPotrait];
        }
        restaurantCancelButton.frame= CGRectMake(0.0f,0.0f,40.0f,40.0f);
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            restaurantCancelButton.frame= CGRectMake(restaurantCancelButton.frame.origin.x,restaurantCancelButton.frame.origin.y,restaurantCancelButton.frame.size.width/2,restaurantCancelButton.frame.size.height/2);
        }
        
        [restaurantListSubView addSubview:selectRestaruantTableView];
        restaurantListSubView.layer.borderWidth = 1;
        restaurantListSubView.layer.borderColor = [UIColor blackColor].CGColor;
        [self.view addSubview:restaurantListSubView];
        chooseRestaurantButtonClicked =YES;
    }
}
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    if(haveAlreadyReceivedCoordinates) {
        return;
    }
    haveAlreadyReceivedCoordinates = YES;
    _currentLocation = [self.locationManager location];
    
    CLLocationCoordinate2D currentCoordinates = newLocation.coordinate;
    
    longitudeString = [NSString stringWithFormat:@"%f", currentCoordinates.longitude];
    latitudeString = [NSString stringWithFormat:@"%f", currentCoordinates.latitude];
    
    if ((goButtonClicked==YES)||(scanBarcodeButtonClicked=YES)) {
        [self postRequest:BARCODE_SCAN_TYPE];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if (error.code == kCLErrorDenied) {
        
        UIAlertView* locFailalertView = [[UIAlertView alloc]
                                         initWithTitle: @"" message: @"" delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil, nil];
        locFailalertView.title = @"Location Service Disabled";
        locFailalertView.message = @"Please go to settings and enable location service for RestaurantBash";
        [locFailalertView show];
        
    } else if(error.code ==  kCLErrorLocationUnknown){
        UIAlertView* locFailalertView = [[UIAlertView alloc]
                                         initWithTitle: @"" message: @"" delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil, nil];
        locFailalertView.title = @"Location";
        locFailalertView.message = @"Location service is unable to retrieve a location right away, Please wait";
        [locFailalertView show];
        
    } else{
        UIAlertView* locFailalertView = [[UIAlertView alloc]
                                         initWithTitle: @"" message: @"" delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil, nil];
        locFailalertView.title = @"Location Service Error";
        locFailalertView.message = @"Unable to retrieve location";
        [locFailalertView show];
    }
}


-(void)restaurantCancelButtonClicked:(id)sender{
    chooseRestaurantButtonClicked =NO;
    [restaurantListSubView removeFromSuperview];
}

#pragma - TextField
-(void) textFieldDidBeginEditing:(UITextField *)textField {
    if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
        [self animateTextField:textField up:YES];
    }
}

-(void) textFieldDidEndEditing:(UITextField *)textField {
    
    if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
        [self animateTextField:textField up:NO];
    }
}

- (void) animateTextField:(UITextField*)textField up:(BOOL)up {
    
    int movementDistance = 0;
    if(textField == barcodeNumberField) movementDistance =60;
    float movementDuration = 0.3f; // tweak as needed
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"loginScreen" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

#pragma - Orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return YES;
        
    }
    else{
        return NO;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration{
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    
    [self.view endEditing:YES];
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
#if __IPHONE_OS_VERSION_MAX_ALLOWED == MP_IOS_7_0
    Class UIAlertManager = NSClassFromString(@"_UIAlertManager");
    UIAlertView *topMostAlert = [UIAlertManager performSelector:@selector(topMostAlert)];
    if(topMostAlert != nil) {
        [topMostAlert dismissWithClickedButtonIndex:0 animated:YES];
    }
#endif
    if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){//setting the form list table frame when returing back to the form list view
        [self barcodeLandscape];
    }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
        [self barcodePotrait];
    }
    if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){//setting the form list table frame when returing back to the form list view
        [self selectRestLandscape];
        
    }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
        [self selectRestPotrait];
    }
    if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){//
        [self Potrait];
    }else if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
        [self Landscape];
    }
    
    if ([self.presentedViewController isKindOfClass:[ZBarReaderViewController class]]){
        [reader dismissViewControllerAnimated:NO completion:nil];
        id sender = (id)readBarCodeButton;
        [self scanBarcodeButtonClicked:sender];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
