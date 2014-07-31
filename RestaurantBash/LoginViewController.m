//
//  LoginViewController.m
//  RBASH
//
//  Created by Divya on 2/7/14.
//  Copyright (c) 2014 Manulogix Pvt Ltd. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@end

@implementation LoginViewController
@synthesize latitudeString;
@synthesize longitudeString;
@synthesize currentLocation = _currentLocation;
static BOOL haveAlreadyReceivedCoordinates;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    loginSubView = [[UIView alloc] init];
    loginSubView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"gallery.png"]];
    loginSubView.layer.borderColor = [UIColor whiteColor].CGColor;
    loginSubView.layer.borderWidth =2.0f;
    loginSubView.layer.cornerRadius=8.0f;
    
    userEmailLabel = [[UILabel alloc] init];
    userEmailLabel.textColor = [UIColor whiteColor];
    userEmailLabel.text=@"UserEmail:";
    userEmailLabel.backgroundColor=[UIColor clearColor];
    userEmailLabel.userInteractionEnabled=NO;
    userEmailLabel.textAlignment = NSTextAlignmentRight;
    
    userNameField = [[UITextField alloc] init];
    userNameField.placeholder = @"<user-email>";
    userNameField.backgroundColor = [UIColor whiteColor];
    userNameField.layer.cornerRadius = 2.0;
    userNameField.layer.borderWidth = 1.0;
    userNameField.clipsToBounds      = YES;
    userNameField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    userNameField.clearButtonMode = YES;
    userNameField.delegate =self;
    userNameField.text = @"";
    userNameField.keyboardType = UIKeyboardTypeEmailAddress;
    userNameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    userView = [[UIView alloc] init];
    userNameField.leftView = userView;
    userNameField.leftViewMode = UITextFieldViewModeAlways;
    
    passwordLabel = [[UILabel alloc] init];
    passwordLabel.textColor = [UIColor whiteColor];
    passwordLabel.text=@"Password:";
    passwordLabel.backgroundColor=[UIColor clearColor];
    passwordLabel.userInteractionEnabled=NO;
    passwordLabel.lineBreakMode = NSLineBreakByWordWrapping;
    passwordLabel.textAlignment = NSTextAlignmentRight;
    
    passwordField = [[UITextField alloc] init];
    passwordField.secureTextEntry = YES;
    passwordField.placeholder = @"<password>";
    passwordField.backgroundColor = [UIColor whiteColor];
    passwordField.layer.cornerRadius = 2.0;
    passwordField.layer.borderWidth = 1.0;
    passwordField.clipsToBounds      = YES;
    passwordField.text = @"";
    passwordField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    passwordField.clearButtonMode = YES;
    passwordField.delegate =self;
    
    pwdView = [[UIView alloc] init];
    passwordField.leftView = pwdView;
    passwordField.leftViewMode = UITextFieldViewModeAlways;
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"purple_Normal.png"] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"orange_Normal.png"] forState:UIControlStateSelected];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"orange_Normal.png"] forState:UIControlStateHighlighted];
    [loginButton addTarget:self action:@selector(subLoginClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
      

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        userEmailLabel.font =[UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
        userView.frame=CGRectMake(0, 0, 10, 35);
        passwordLabel.font =[UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
        pwdView.frame=CGRectMake(0, 0, 10, 35);
        userNameField.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
        passwordField.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
        loginButton.titleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:30.0f];
    }else{
        userView.frame=CGRectMake(0, 0, 10, 25);
        pwdView.frame=CGRectMake(0, 0, 10, 25);
        userNameField.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:10.0f];
        passwordField.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:10.0f];
        loginButton.titleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:15.0f];
    }
    
    
    uText = userEmailLabel.text;
    uWidth = 101;
    uFont = userEmailLabel.font;
    uAttributedText =[[NSAttributedString alloc] initWithString:uText attributes:@{ NSFontAttributeName:uFont}];
    uRect = [uAttributedText boundingRectWithSize:(CGSize){uWidth, CGFLOAT_MAX}  options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    uSize = uRect.size;
    
    pText = userEmailLabel.text;
    pWidth = 101;
    pFont = userEmailLabel.font;
    pAttributedText =[[NSAttributedString alloc] initWithString:pText attributes:@{ NSFontAttributeName:pFont}];
    pRect = [pAttributedText boundingRectWithSize:(CGSize){pWidth, CGFLOAT_MAX}  options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    pSize = pRect.size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if(UIInterfaceOrientationIsLandscape (STATUSBAR_ORIENTATION)){//
            [self Landscape];
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            [self Potrait];
        }
        userEmailLabel.frame = CGRectMake(loginSubView.frame.size.width/15,loginSubView.frame.size.height/5,uSize.width, 40.0f);
        userNameField.frame= CGRectMake(userEmailLabel.frame.origin.x+userEmailLabel.frame.size.width,loginSubView.frame.size.height/5,loginSubView.frame.size.width-uSize.width-userEmailLabel.frame.origin.x*2, 40.0f);
        passwordLabel.frame = CGRectMake(loginSubView.frame.size.width/15,userEmailLabel.frame.origin.y+userEmailLabel.frame.size.height+2.0,pSize.width, 40.0f);
        passwordField.frame=CGRectMake(passwordLabel.frame.origin.x+passwordLabel.frame.size.width,userNameField.frame.origin.y+userNameField.frame.size.height+2.0,userNameField.frame.size.width, 40.0f);
        loginButton.frame = CGRectMake(loginSubView.frame.size.width/2.5, passwordField.frame.origin.y+passwordField.frame.size.height+10.0f,loginSubView.frame.size.width/5,45.0f);
    }
    else  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if ([UIScreen mainScreen].bounds.size.height == 568) {// iphone 4 inch
            self.view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"Login640x1136.png"]];
        }else{// iphone 3.5 inch
            self.view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"Login640x968.png"]];
        }
        loginSubView.frame = CGRectMake(self.view.frame.size.width/8,self.view.frame.size.height/2.5,self.view.frame.size.width-2*(self.view.frame.size.width/8), 103.0f);
        userNameField.frame= CGRectMake(10,10,loginSubView.frame.size.width-20,  25.0f);
        passwordField.frame=CGRectMake(10,userNameField.frame.origin.y+userNameField.frame.size.height+2.0,userNameField.frame.size.width,  25.0f);
        loginButton.frame = CGRectMake(loginSubView.frame.size.width/2.5,passwordField.frame.origin.y+ passwordField.frame.size.height+5.0,loginSubView.frame.size.width/5, 25.0f);
    }
    
    
    [loginSubView addSubview:userNameField];
    [loginSubView addSubview:userEmailLabel];
    [loginSubView addSubview:passwordField];
    [loginSubView addSubview:passwordLabel];
    [loginSubView addSubview:loginButton];
    [self.view addSubview:loginSubView];
}
-(void)Landscape{
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"LoginBg_L.png"]];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 1024, 768);
    loginSubView.frame = CGRectMake(self.view.frame.size.width/4,self.view.frame.size.height/3,self.view.frame.size.width-2*(self.view.frame.size.width/4), 225.0f);
}

-(void)Potrait{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LoginBg_P.png"]];
        loginSubView.frame = CGRectMake(self.view.frame.size.width/6,self.view.frame.size.height/2.5,self.view.frame.size.width-2*(self.view.frame.size.width/6), 225.0f);
    }
}

-(void)subLoginClicked:(id)sender{
    NSLog(@"loginClicked");
    if ([self isValidEmail:userNameField.text]) {
        if (IS_EMPTY(userNameField.text)) {
            [FAUtilities showToastMessageAlert:USER_EMPTY_EMAIL];
            return;
        } else if (IS_EMPTY(passwordField.text)) {
            [FAUtilities showToastMessageAlert:USER_EMPTY_PWD];
            return;
        }else{
            self.locationManager = [[CLLocationManager alloc] init];
            [self.locationManager setDelegate:self];
            haveAlreadyReceivedCoordinates = NO;
            [self.locationManager startUpdatingLocation];
            
        }
    }else{
        if (IS_EMPTY(userNameField.text)) {
            [FAUtilities showToastMessageAlert:USER_EMPTY_EMAIL];
            return;
        } else if (IS_EMPTY(passwordField.text)) {
            [FAUtilities showToastMessageAlert:USER_EMPTY_PWD];
           return;
        }
    }
}
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    dbManager = [DataBaseManager dataBaseManager];
    
    if(haveAlreadyReceivedCoordinates) {
        return;
    }
    
    haveAlreadyReceivedCoordinates = YES;
    _currentLocation = [self.locationManager location];
    
    CLLocationCoordinate2D currentCoordinates = newLocation.coordinate;
    longitudeString = [NSString stringWithFormat:@"%f", currentCoordinates.longitude];
    latitudeString = [NSString stringWithFormat:@"%f", currentCoordinates.latitude];
    
    if ([self isValidEmail:userNameField.text]) {
        NSMutableArray *loginDetails = [[NSMutableArray alloc]init];
        [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM LoginDetails"] resultsArray:loginDetails];
        
        if (IS_EMPTY(userNameField.text)) {
            [FAUtilities showToastMessageAlert:USER_EMPTY_EMAIL];
            return;
        } else if (IS_EMPTY(passwordField.text)) {
            [FAUtilities showToastMessageAlert:USER_EMPTY_PWD];
            return;
        }else{
            [self postRequest:LOGIN_TYPE_1];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.view endEditing:YES];

    if (error.code == kCLErrorDenied) {
        UIAlertView* locFailalertView = [[UIAlertView alloc]initWithTitle: @"" message: @"" delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil, nil];
        locFailalertView.title = @"Location Service Disabled";
        locFailalertView.message = @"Please go to settings and enable location service for RestaurantBash";
        [locFailalertView show];
    } else if(error.code ==  kCLErrorLocationUnknown){
        UIAlertView* locFailalertView = [[UIAlertView alloc] initWithTitle: @"" message: @"" delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil, nil];
        locFailalertView.title = @"Location";
        locFailalertView.message = @"Location service is unable to retrieve a location right away, Please wait";
        [locFailalertView show];
        
    } else{
        UIAlertView* locFailalertView = [[UIAlertView alloc] initWithTitle: @"" message: @"" delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil, nil];
        locFailalertView.title = @"Location Service Error";
        locFailalertView.message = @"Unable to retrieve location";
        [locFailalertView show];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    dbManager = [DataBaseManager dataBaseManager];
    
    NSMutableArray *loginDetails = [[NSMutableArray alloc]init];
    [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM LoginDetails"] resultsArray:loginDetails];
    
    if ([loginDetails count]==0) {
    }else{
        userNameField.text = [[loginDetails valueForKey:@"UserName"]objectAtIndex:0];
        passwordField.text = @"";
    }
    [self.navigationController setNavigationBarHidden:YES];
}

-(BOOL)isValidEmail:(NSString*)checkString{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
	NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

#pragma  - Request
-(void)postRequest:(NSString *)reqType{
    [self.view endEditing:YES];
    NSMutableDictionary *test = [[NSMutableDictionary alloc]init];
    [test setObject:userNameField.text forKey:@"Username"];
    [test setObject:passwordField.text forKey:@"Password"];
    
    NSString *postDataInString = [self postFormatString:reqType withDictionary:test];
    NSData *postJsonData = [postDataInString dataUsingEncoding:NSUTF8StringEncoding];
    webServiceInterface = [[WebServiceInterface alloc]initWithVC:self];
    webServiceInterface.delegate =self;
    [webServiceInterface sendRequest:postDataInString PostJsonData:postJsonData Req_Type:reqType Req_url:REQ_URL];
    
//    RestaurantViewController *restaurantViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RestaurantViewController"];
////    restaurantViewController.restauranta = restDetails;
//    [self.navigationController pushViewController:restaurantViewController animated:YES];

}

-(NSString*)postFormatString:(NSString *)type withDictionary:(NSMutableDictionary *)formatDict{
    NSString *isAttempt;
    if ([type isEqualToString:LOGIN_TYPE_1]) {
        isAttempt =@"TRUE";
    }
    uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
    NSLog(@"UDID:: %@", uniqueIdentifier);
    
    NSString *bodyStr =[NSString stringWithFormat: @"{\"bz_user_email\":\"%@\", \"bz_user_pwd\":\"%@\", \"is_first_time\":\"%@\",  \"device_details\": {\"device_id\":\"%@\", \"lat\":\"%@\", \"long\":\"%@\"}}",[formatDict valueForKey:@"Username"],[formatDict valueForKey:@"Password"],isAttempt,uniqueIdentifier,latitudeString,longitudeString];
    return bodyStr;
}

-(void)getResponse:(NSDictionary *)resp type:(NSString *)respType{
    
    if ((resp == (id)[NSNull null]) ||(resp==nil)) {
    }else{
        dbManager = [DataBaseManager dataBaseManager];
        NSString  *message;
        NSString  *status;
        NSArray *restaurantaAry;
        if ([[resp allKeys] containsObject:@"message"]) {
            message= [resp valueForKey:@"message"];
            NSLog(@"contains message Key");
        }else{
        }
        if ([[resp allKeys] containsObject:@"status"]) {
            status = [resp valueForKey:@"status"];
            NSLog(@"contains status Key");
        }else{
        }
        if ([[resp allKeys] containsObject:@"restaurants"]) {
            restaurantaAry = [resp valueForKey:@"restaurants"];
            NSLog(@"contains restaurantaAry Key");
        }else{
        }
        
        if ((status == (id)[NSNull null])||(status.length==0)||(status==nil)) {
        }else{
            if ([status isEqualToString:@"success"]) {
                if ((message == (id)[NSNull null])||(message==nil)) {
                    NSLog(@"null message:%@",message);
                }
                if ([respType isEqualToString:LOGIN_TYPE_1]) {
                    
                    NSString *loginquery = [NSString stringWithFormat:@"DELETE FROM LoginDetails"];
                    [dbManager execute:loginquery];
                    
                    NSString *query = [NSString stringWithFormat:@"DELETE FROM RestaurantDetails"];
                    [dbManager execute:query];
                    
                    [dbManager execute:[NSString stringWithFormat: @"INSERT INTO 'LoginDetails' (UserName, Password,CurrentUser)VALUES ('%@', '%@','ON')",userNameField.text,passwordField.text]];
                    
                    if ([restaurantaAry count]>0){
                        for (int i = 0; i<[restaurantaAry count]; i++) {
                            NSDictionary * restDict = [restaurantaAry objectAtIndex:i];
                            NSString *rest_id,*rest_name,*rest_phone,*rest_address,*rest_city,*rest_state,*rest_zip,*rest_contactName;
                            if ([[restDict allKeys] containsObject:@"res_id"]) {
                                rest_id= [restDict valueForKey:@"res_id"];
                            }else{
                            }if ([[restDict allKeys] containsObject:@"res_name"]) {
                                rest_name= [restDict valueForKey:@"res_name"];
                            }else{
                            }if ([[restDict allKeys] containsObject:@"phone"]) {
                                rest_phone= [restDict valueForKey:@"phone"];
                            }else{
                            }if ([[restDict allKeys] containsObject:@"address"]) {
                                rest_address= [restDict valueForKey:@"address"];
                            }else{
                            }if ([[restDict allKeys] containsObject:@"city"]) {
                                rest_city= [restDict valueForKey:@"city"];
                            }else{
                            }if ([[restDict allKeys] containsObject:@"state"]) {
                                rest_state= [restDict valueForKey:@"state"];
                            }else{
                            }if ([[restDict allKeys] containsObject:@"zip"]) {
                                rest_zip= [restDict valueForKey:@"zip"];
                            }else{
                            }if ([[restDict allKeys] containsObject:@"contact_name"]) {
                                rest_contactName= [restDict valueForKey:@"contact_name"];
                            }else{
                            }
                            [dbManager execute:[NSString stringWithFormat: @"INSERT INTO 'RestaurantDetails' (Rest_Id, Rest_Name,Rest_Phone,Rest_Address,Rest_City,Rest_State,Rest_Zip,Rest_ContactName)VALUES ('%@', '%@','%@', '%@', '%@','%@', '%@', '%@')",rest_id,rest_name,rest_phone,rest_address ,rest_city,rest_state ,rest_zip,rest_contactName]];
                        }
                    }
//                    else{
//                        [FAUtilities showToastMessageAlert:@"No restaurants found for this user."];
//                    }
                }
                
                NSMutableArray *restDetails = [[NSMutableArray alloc]init];
                [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM RestaurantDetails"] resultsArray:restDetails];
                
                RestaurantViewController *restaurantViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RestaurantViewController"];
                restaurantViewController.restauranta = restDetails;
                [self.navigationController pushViewController:restaurantViewController animated:YES];
            }else{
                passwordField.text=@"";
                if ((message == (id)[NSNull null])||(message.length==0)||(message==nil)) {
                    [FAUtilities showToastMessageAlert:@"Unable to recieve message from server"];
                }else{
                    if (IS_EMPTY(message)) {
                        [FAUtilities showToastMessageAlert:@"Unable to recieve restaurant details from server"];
                    }else{
                        [FAUtilities showToastMessageAlert:message];
                    }
                }
            }
        }
    }
}

#pragma - TextField
-(void) textFieldDidBeginEditing:(UITextField *)textField {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            [self animateTextField:textField up:YES];
        }
    }else{
        if ([UIScreen mainScreen].bounds.size.height == 568) {
            [self animateTextField:textField up:YES];
        }else{
            [self animateTextField:textField up:YES];
        }
    }
}

-(void) textFieldDidEndEditing:(UITextField *)textField {
    if(textField==userNameField){
        if ([self isValidEmail:userNameField.text]) {
		}else {
            if (IS_EMPTY(userNameField.text)) {
            }else{
                [FAUtilities showToastMessageAlert:INVALID_EMAIL];
                return;
            }
		}
	}
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            [self animateTextField:textField up:NO];
        }
    }else{
        if ([UIScreen mainScreen].bounds.size.height == 568) {
            [self animateTextField:textField up:NO];
        }else{
            [self animateTextField:textField up:NO];
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
/* method to range the characters in textfiled by max length */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    int newLength = [textField.text length] + [string length] - range.length;
    if (newLength == 1) {
        string = [string uppercaseString];
        if ([string isEqualToString:@" "]) {
            return NO;
        }
    }
    return YES;
}
- (void) animateTextField:(UITextField*)textField up:(BOOL)up {
    
    int movementDistance = 0;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if(textField == userNameField) movementDistance = 40;
        else if(textField == passwordField) movementDistance = 180;
    }else{
        if ([UIScreen mainScreen].bounds.size.height == 568) {
            if(textField == userNameField) movementDistance = 20;
            else if(textField == passwordField) movementDistance = 30;
        }else{
            if(textField == userNameField) movementDistance = 20;
            else if(textField == passwordField) movementDistance = 70;
        }
    }
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
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){//
            self.view.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"LoginBg_P.png"]];
            [self Potrait];
        }else if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            self.view.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"LoginBg_L.png"]];
            [self Landscape];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
