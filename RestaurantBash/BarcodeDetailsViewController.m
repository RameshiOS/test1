//
//  BarcodeDetailsViewController.m
//  RBASH
//
//  Created by Divya on 2/3/14.
//  Copyright (c) 2014 Manulogix Pvt Ltd. All rights reserved.
//

#import "BarcodeDetailsViewController.h"

@interface BarcodeDetailsViewController ()

@end

@implementation BarcodeDetailsViewController
@synthesize restDetails,restId,barcodeVal,currentRestName;
@synthesize latitudeString;
@synthesize longitudeString;
@synthesize rest_Id;
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
    
    currentRestNameLabel  = [[UILabel alloc] init];
    currentRestNameLabel.textColor = [UIColor colorWithRed:84.0f/255.0f green:24.0f/255.0f blue:78.0f/255.0f alpha:1.0];
    currentRestNameLabel.backgroundColor=[UIColor clearColor];
    currentRestNameLabel.userInteractionEnabled=NO;
    currentRestNameLabel.textAlignment = NSTextAlignmentRight;
    
    if ((currentRestName == (id)[NSNull null])||(currentRestName.length==0)||(currentRestName==nil)) {
        currentRestNameLabel.text =@"----------";
    }else{
        currentRestNameLabel.text =currentRestName;
    }
    currentRestNameLabel.numberOfLines=0;
    currentRestNameLabel.adjustsFontSizeToFitWidth = YES;//autoshrink the label text in fixed width
    currentRestNameLabel.minimumScaleFactor=0.5;
    [currentRestNameLabel sizeToFit];
    
    messageLabel = [[UILabel alloc] init];
    messageLabel.textColor = [UIColor colorWithRed:247.0f/255.0f green:60.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    messageLabel.userInteractionEnabled=NO;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines=0;
    messageLabel.adjustsFontSizeToFitWidth = YES;//autoshrink the label text in fixed width
    messageLabel.minimumScaleFactor=0.5;
    [messageLabel sizeToFit];
    
    dealDetailsView = [[UIView alloc] init];
    dealDetailsView.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:215.0f/255.0f blue:233.0f/255.0f alpha:1.0];
    
    barcodeDetailsView = [[UIView alloc] init];
    barcodeDetailsView.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:215.0f/255.0f blue:233.0f/255.0f alpha:1.0];
    
    dealDetailsLabel = [[UILabel alloc] init];
    dealDetailsLabel.textColor = [UIColor whiteColor];
    dealDetailsLabel.backgroundColor=[UIColor colorWithRed:164.0f/255.0f green:78.0f/255.0f blue:156.0f/255.0f alpha:1.0];
    dealDetailsLabel.userInteractionEnabled=NO;
    dealDetailsLabel.textAlignment = NSTextAlignmentCenter;
    dealDetailsLabel.text= @"Deal Details";
    [dealDetailsView addSubview:dealDetailsLabel];
    
    barcodeDetailsLabel = [[UILabel alloc] init];
    barcodeDetailsLabel.textColor = [UIColor whiteColor];
    barcodeDetailsLabel.backgroundColor=[UIColor colorWithRed:164.0f/255.0f green:78.0f/255.0f blue:156.0f/255.0f alpha:1.0];
    barcodeDetailsLabel.userInteractionEnabled=NO;
    barcodeDetailsLabel.textAlignment = NSTextAlignmentCenter;
    barcodeDetailsLabel.text= @"Barcode Details";
    barcodeImageView = [[UIImageView alloc]init];
    
    barcodeLabel = [[UILabel alloc] init];
    barcodeLabel.textColor = [UIColor blackColor];
    barcodeLabel.backgroundColor=[UIColor clearColor];
    barcodeLabel.userInteractionEnabled=NO;
    barcodeLabel.textAlignment = NSTextAlignmentCenter;
    
    buyerNameLabel = [[UILabel alloc] init];
    buyerNameLabel.textColor = [UIColor blackColor];
    buyerNameLabel.backgroundColor=[UIColor clearColor];
    buyerNameLabel.userInteractionEnabled=NO;
    buyerNameLabel.textAlignment = NSTextAlignmentRight;
    buyerNameLabel.text= @"Buyer Name:";
    
    buyerNameVal = [[UILabel alloc] init];
    buyerNameVal.textColor = [UIColor blackColor];
    buyerNameVal.backgroundColor=[UIColor clearColor];
    buyerNameVal.userInteractionEnabled=NO;
    buyerNameVal.textAlignment = NSTextAlignmentLeft;
    
    emailLabel = [[UILabel alloc] init];
    emailLabel.textColor = [UIColor blackColor];
    emailLabel.backgroundColor=[UIColor clearColor];
    emailLabel.userInteractionEnabled=NO;
    emailLabel.textAlignment = NSTextAlignmentRight;
    emailLabel.text= @"Email:";
    
    emailVal = [[UILabel alloc] init];
    emailVal.textColor = [UIColor blackColor];
    emailVal.backgroundColor=[UIColor clearColor];
    emailVal.userInteractionEnabled=NO;
    emailVal.textAlignment = NSTextAlignmentLeft;
    
    datePurchasedLabel = [[UILabel alloc] init];
    datePurchasedLabel.textColor = [UIColor blackColor];
    datePurchasedLabel.backgroundColor=[UIColor clearColor];
    datePurchasedLabel.userInteractionEnabled=NO;
    datePurchasedLabel.textAlignment = NSTextAlignmentRight;
    datePurchasedLabel.text= @"Date Purchased:";
    
    datePurchasedVal = [[UILabel alloc] init];
    datePurchasedVal.textColor = [UIColor blackColor];
    datePurchasedVal.backgroundColor=[UIColor clearColor];
    datePurchasedVal.userInteractionEnabled=NO;
    datePurchasedVal.textAlignment = NSTextAlignmentLeft;
    
    statusLabel = [[UILabel alloc] init];
    statusLabel.textColor = [UIColor blackColor];
    statusLabel.backgroundColor=[UIColor clearColor];
    statusLabel.userInteractionEnabled=NO;
    statusLabel.textAlignment = NSTextAlignmentRight;
    statusLabel.text= @"Status:";
    
    statusVal = [[UILabel alloc] init];
    statusVal.textColor = [UIColor blackColor];
    statusVal.backgroundColor=[UIColor clearColor];
    statusVal.userInteractionEnabled=NO;
    statusVal.textAlignment = NSTextAlignmentLeft;
    
    giftedToLabel = [[UILabel alloc] init];
    giftedToLabel.textColor = [UIColor blackColor];
    giftedToLabel.backgroundColor=[UIColor clearColor];
    giftedToLabel.userInteractionEnabled=NO;
    giftedToLabel.textAlignment = NSTextAlignmentRight;
    giftedToLabel.text= @"Gifted To:";
    
    giftedToVal = [[UILabel alloc] init];
    giftedToVal.textColor = [UIColor blackColor];
    giftedToVal.backgroundColor=[UIColor clearColor];
    giftedToVal.userInteractionEnabled=NO;
    giftedToVal.textAlignment = NSTextAlignmentLeft;
    
    giftedOnLabel = [[UILabel alloc] init];
    giftedOnLabel.textColor = [UIColor blackColor];
    giftedOnLabel.backgroundColor=[UIColor clearColor];
    giftedOnLabel.userInteractionEnabled=NO;
    giftedOnLabel.textAlignment = NSTextAlignmentRight;
    giftedOnLabel.text= @"Gifted On:";
    
    giftedOnVal = [[UILabel alloc] init];
    giftedOnVal.textColor = [UIColor blackColor];
    giftedOnVal.backgroundColor=[UIColor clearColor];
    giftedOnVal.userInteractionEnabled=NO;
    giftedOnVal.textAlignment = NSTextAlignmentLeft;
    
    restNameLabel = [[UILabel alloc] init];
    restNameLabel.textColor = [UIColor blackColor];
    restNameLabel.backgroundColor=[UIColor clearColor];
    restNameLabel.userInteractionEnabled=NO;
    restNameLabel.textAlignment = NSTextAlignmentLeft;
    
    restAddressLabel = [[UILabel alloc] init];
    restAddressLabel.textColor = [UIColor blackColor];
    restAddressLabel.backgroundColor=[UIColor clearColor];
    restAddressLabel.userInteractionEnabled=NO;
    restAddressLabel.textAlignment = NSTextAlignmentLeft;
    
    dealNameLabel = [[UILabel alloc] init];
    dealNameLabel.textColor = [UIColor blackColor];
    dealNameLabel.backgroundColor=[UIColor clearColor];
    dealNameLabel.userInteractionEnabled=NO;
    dealNameLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:25.0f];
    dealNameLabel.textAlignment = NSTextAlignmentLeft;
    
    valueLabel = [[UILabel alloc] init];
    valueLabel.textColor = [UIColor blackColor];
    valueLabel.backgroundColor=[UIColor clearColor];
    valueLabel.userInteractionEnabled=NO;
    valueLabel.textAlignment = NSTextAlignmentRight;
    valueLabel.text =@"VALUE $";
    
    costLabel = [[UILabel alloc] init];
    costLabel.textColor = [UIColor blackColor];
    costLabel.backgroundColor=[UIColor clearColor];
    costLabel.userInteractionEnabled=NO;
    costLabel.textAlignment = NSTextAlignmentRight;
    costLabel.text =@"COST $";
    
    saveLabel = [[UILabel alloc] init];
    saveLabel.textColor = [UIColor blackColor];
    saveLabel.backgroundColor=[UIColor clearColor];
    saveLabel.userInteractionEnabled=NO;
    saveLabel.textAlignment = NSTextAlignmentRight;
    saveLabel.text =@"SAVE $";
    
    valueLabelVal = [[UILabel alloc] init];
    valueLabelVal.textColor = [UIColor blackColor];
    valueLabelVal.backgroundColor=[UIColor clearColor];
    valueLabelVal.userInteractionEnabled=NO;
    valueLabelVal.textAlignment = NSTextAlignmentRight;
    
    costLabelVal = [[UILabel alloc] init];
    costLabelVal.textColor = [UIColor blackColor];
    costLabelVal.backgroundColor=[UIColor clearColor];
    costLabelVal.userInteractionEnabled=NO;
    costLabelVal.textAlignment = NSTextAlignmentRight;
    
    saveLabelVal = [[UILabel alloc] init];
    saveLabelVal.textColor = [UIColor blackColor];
    saveLabelVal.backgroundColor=[UIColor clearColor];
    saveLabelVal.userInteractionEnabled=NO;
    saveLabelVal.textAlignment = NSTextAlignmentRight;

    
    redeemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [redeemButton addTarget:self action:@selector(redeemButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [redeemButton setBackgroundImage:[UIImage imageNamed:@"purple_Normal.png"] forState:UIControlStateNormal];
    [redeemButton setBackgroundImage:[UIImage imageNamed:@"orange_Normal.png"] forState:UIControlStateSelected];
    [redeemButton setBackgroundImage:[UIImage imageNamed:@"orange_Normal.png"] forState:UIControlStateHighlighted];
    [redeemButton setTitle:@"Redeem" forState:UIControlStateNormal];
    [redeemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"purple_Normal.png"] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"orange_Normal.png"] forState:UIControlStateSelected];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"orange_Normal.png"] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if ([restDetails count]>0) {
        NSString *rest_gifted_date,*rest_gifted_to,*rest_purchasedDate,*rest_status,*rest_firstName,*rest_LastName,*rest_email,*rest_dealName,*rest_originalPrice,*rest_offerPrice,*rest_restName,*rest_restID,*rest_address,*rest_city,*rest_state,*rest_zip;
        
        NSString *rest_redeemed_date;
        
        NSDictionary *rest_Dict =
        restDetails;
        if ([[rest_Dict allKeys] containsObject:@"gifted_date"]) {
            rest_gifted_date= [rest_Dict objectForKey:@"gifted_date"];
            NSLog(@"contains giftedDate Key");
        }else{
        }
        if ([[rest_Dict allKeys] containsObject:@"gifted_to"]) {
            rest_gifted_to= [rest_Dict objectForKey:@"gifted_to"];
            NSLog(@"contains gifted to Key");
        }else{
        }
        if ([[rest_Dict allKeys] containsObject:@"purchased_date"]) {
            rest_purchasedDate= [restDetails valueForKey:@"purchased_date"];
            NSLog(@"contains purchasedDate Key");
        }else{
        }
        
        rest_redeemed_date = [restDetails valueForKey:@"redeem_date"];
        
        
        if ([[rest_Dict allKeys] containsObject:@"status"]) {
            rest_status= [rest_Dict objectForKey:@"status"];
            NSLog(@"contains status Key");
        }else{
        }if ([[rest_Dict allKeys] containsObject:@"first_name"]) {
            rest_firstName= [rest_Dict objectForKey:@"first_name"];
            NSLog(@"contains firstName Key");
        }else{
        }if ([[rest_Dict allKeys] containsObject:@"last_name"]) {
            rest_LastName= [rest_Dict objectForKey:@"last_name"];
            NSLog(@"contains LastName Key");
        }else{
        }if ([[rest_Dict allKeys] containsObject:@"email"]) {
            rest_email=[rest_Dict objectForKey:@"email"];
            NSLog(@"contains email Key");
        }else{
        }if ([[rest_Dict allKeys] containsObject:@"deal_name"]) {
            rest_dealName=[rest_Dict objectForKey:@"deal_name"];
            NSLog(@"contains dealName Key");
        }else{
        }if ([[rest_Dict allKeys] containsObject:@"original_price"]) {
            rest_originalPrice=[rest_Dict objectForKey:@"original_price"];
            NSLog(@"contains originalPrice Key");
        }else{
        }if ([[rest_Dict allKeys] containsObject:@"offer_price"]) {
            rest_offerPrice=[rest_Dict objectForKey:@"offer_price"];
            NSLog(@"contains offerPrice Key");
        }else{
        }if ([[rest_Dict allKeys] containsObject:@"res_name"]) {
            rest_restName=[rest_Dict objectForKey:@"res_name"];
            NSLog(@"contains restName Key");
        }else{
        }if ([[rest_Dict allKeys] containsObject:@"res_id"]) {
            rest_restID=[rest_Dict objectForKey:@"res_id"];
            NSLog(@"contains restID Key");
        }else{
        }if ([[rest_Dict allKeys] containsObject:@"address"]) {
            rest_address=[rest_Dict objectForKey:@"address"];
            NSLog(@"contains address Key");
        }else{
        }if ([[rest_Dict allKeys] containsObject:@"city"]) {
            rest_city=[rest_Dict objectForKey:@"city"];
            NSLog(@"contains city Key");
        }else{
        }if ([[rest_Dict allKeys] containsObject:@"state"]) {
            rest_state=[rest_Dict objectForKey:@"state"];
            NSLog(@"contains state Key");
        }else{
        }
        
        if ([[rest_Dict allKeys] containsObject:@"zip"]) {
            rest_zip=[rest_Dict objectForKey:@"zip"];
            NSLog(@"contains zip Key");
        }else{
        }
        
        giftedOnValStr =rest_gifted_date;
        giftedToValStr =rest_gifted_to;
        subscriptionDateStr =rest_purchasedDate;
        redeemedDate =rest_redeemed_date;
        statusStr =rest_status;
        firstNameStr =rest_firstName;
        lastNameStr =rest_LastName;
        emailStr =rest_email;
        dealNameStr = rest_dealName;
        valueStr = rest_originalPrice;
        costStr = rest_offerPrice;
        restNameStr = rest_restName;
        rest_Id = rest_restID;
//        rest_Id = [NSString stringWithFormat:@"%@",rest_restID];

        NSString *tempStr;
        NSLog(@"selected_Id:%@",restId);
        NSLog(@"current_rest_id:%@",rest_Id);
        
//        if ((rest_Id == (id)[NSNull null])||(rest_Id==nil)) {
        if ((rest_Id == (id)[NSNull null])||(rest_Id.length==0)||(rest_Id==nil)) {
            current_rest_Id =@"";
        }else{
            current_rest_Id =rest_Id;
        }
        
        if ((rest_address == (id)[NSNull null])||(rest_address.length==0)||(rest_address==nil)) {
            tempStr = @"";
        }else{
            tempStr = [NSString stringWithFormat:@"%@",rest_address];
            if ((rest_city == (id)[NSNull null])||(rest_city.length==0)||(rest_city==nil)) {
                rest_city = @"";
            }else{
                tempStr = [NSString stringWithFormat:@"%@,%@",tempStr,rest_city];
            }
            if ((rest_state == (id)[NSNull null])||(rest_state.length==0)||(rest_state==nil)) {
                rest_state = @"";
            }else{
                tempStr = [NSString stringWithFormat:@"%@,%@",tempStr,rest_state];
            }
            if ((rest_zip == (id)[NSNull null])||(rest_zip.length==0)||(rest_zip==nil)) {
                rest_zip = @"";
            }else{
                tempStr = [NSString stringWithFormat:@"%@,%@",tempStr,rest_zip];
            }
        }
        addressValStr = tempStr;
        NSLog(@"addressVal before spaces and next line%@",addressValStr);
        
        addressValStr = [addressValStr stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        NSLog(@"addressVal after spaces and next line%@",addressValStr);

    }
//    else{
//        [FAUtilities showToastMessageAlert:@"Restaurant details not found for this barcode"];
//    }
    
//    barcodeImageView.image = [UIImage imageNamed:@"barcode_vertical"];

    barcodeImageView.image = [UIImage imageNamed:@"qrcode.png"];

    
    
    if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){//
        [self potratit];
    }
    else if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
        [self landscape];
        self.view.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBg_L.png"]];
    }
    
    if ((addressValStr == (id)[NSNull null])||(addressValStr.length==0)||(addressValStr==nil)) {
        restAddressLabel.text =@"----------";
    }else{
        restAddressLabel.text =addressValStr;
    }
    if ((barcodeVal == (id)[NSNull null])||(barcodeVal.length==0)||(barcodeVal==nil)) {
        barcodeLabel.text =@"----------";
    }else{
        barcodeLabel.text = barcodeVal;
    }
    
    
    if ((valueStr == (id)[NSNull null])||(valueStr.length==0)||(valueStr==nil)) {
        valueLabelVal.text =[NSString stringWithFormat:@"%@",@"00.00"];
    }else{
        valueLabelVal.text =[NSString stringWithFormat:@"%@",valueStr];
    }
    
    if ((costStr == (id)[NSNull null])||(costStr.length==0)||(costStr==nil)) {
        costLabelVal.text =[NSString stringWithFormat:@"%@",@"00.00"];
    }else{
        costLabelVal.text =[NSString stringWithFormat:@"%@",costStr];
    }
    
    NSString *saveValStr= [NSString stringWithFormat:@"%d", [valueLabelVal.text intValue] - [costLabelVal.text intValue]];
    
    if ((saveValStr == (id)[NSNull null])||(saveValStr.length==0)||(saveValStr==nil)) {
        saveLabelVal.text =[NSString stringWithFormat:@"%@",@"00.00"];
    }else{
        saveLabelVal.text =[NSString stringWithFormat:@"%@.00",saveValStr];
    }
    
    if ((dealNameStr == (id)[NSNull null])||(dealNameStr.length==0)||(dealNameStr==nil)) {
        dealNameLabel.text =@"----------";
        
    }else{
        dealNameLabel.text =dealNameStr;
    }
  
    dealNameLabel.numberOfLines=0;
    dealNameLabel.adjustsFontSizeToFitWidth = YES;//autoshrink the label text in fixed width
    dealNameLabel.minimumScaleFactor=0.5;
    [dealNameLabel sizeToFit];

    
    if ((restNameStr == (id)[NSNull null])||(restNameStr.length==0)||(restNameStr==nil)) {
        restNameLabel.text =@"----------";
    }else{
        restNameLabel.text =restNameStr;
    }
    
    if ((subscriptionDateStr == (id)[NSNull null]) ||(subscriptionDateStr==nil) ||(subscriptionDateStr.length==0)||[subscriptionDateStr isEqualToString:@"0000-00-00"]) {
    }else{
        datePurchasedVal.text =subscriptionDateStr;
    }
    
    if ((statusStr == (id)[NSNull null]) ||(statusStr==nil) ||(statusStr.length==0)) {
    }else{
        statusVal.text =statusStr;
    }
    
    if ((firstNameStr == (id)[NSNull null])|| (firstNameStr==nil)||  (firstNameStr.length==0)){
        buyerNameVal.text =@"----------";
    }else{
        NSString *tempStr = firstNameStr;
        if ((lastNameStr == (id)[NSNull null]) || (lastNameStr==nil) || (lastNameStr.length==0)) {
            buyerNameVal.text =tempStr;
        }else{
            buyerNameStr = [NSString stringWithFormat:@"%@ %@",firstNameStr,lastNameStr];
            buyerNameVal.text =buyerNameStr;
        }
    }
    
    if ((emailStr == (id)[NSNull null]) ||(emailStr==nil) ||(emailStr.length==0)) {
        emailVal.text =@"----------";
    }else{
        emailVal.text =emailStr;
    }
    
    if ((giftedOnValStr == (id)[NSNull null]) ||(giftedOnValStr==nil) ||(giftedOnValStr.length==0)) {
    }else{
        giftedOnVal.text =giftedOnValStr;
    }
    
    if ((giftedToValStr == (id)[NSNull null]) ||(giftedToValStr==nil) ||(giftedToValStr.length==0)) {
    }else{
        giftedToVal.text =giftedToValStr;
    }
    
    [dealDetailsView addSubview:valueLabel];
    [dealDetailsView addSubview:costLabel];
    [dealDetailsView addSubview:saveLabel];
    [dealDetailsView addSubview:restAddressLabel];
    
    [dealDetailsView addSubview:dealNameLabel];
    [dealDetailsView addSubview:restNameLabel];
    
    [dealDetailsView addSubview:valueLabelVal];
    [dealDetailsView addSubview:costLabelVal];
    [dealDetailsView addSubview:saveLabelVal];
    [self.view addSubview:currentRestNameLabel];
    
    [self.view addSubview:dealDetailsView];
    [barcodeDetailsView addSubview:barcodeDetailsLabel];
    [barcodeDetailsView addSubview:barcodeImageView];
    [barcodeDetailsView addSubview:barcodeLabel];
    
    [barcodeDetailsView addSubview:buyerNameLabel];
    [barcodeDetailsView addSubview:buyerNameVal];
    
    [barcodeDetailsView addSubview:emailLabel];
    [barcodeDetailsView addSubview:emailVal];
    
    
    [barcodeDetailsView addSubview:statusLabel];
    [barcodeDetailsView addSubview:statusVal];
    
    
    if (addPoDateLabel == YES) {
        [barcodeDetailsView addSubview:datePurchasedLabel];
        [barcodeDetailsView addSubview:datePurchasedVal];
    }
    if(addGitedOnLabel == YES){
        [barcodeDetailsView addSubview:giftedOnLabel];
        [barcodeDetailsView addSubview:giftedOnVal];
        
    }
    if(addGitedToLabel == YES){
        [barcodeDetailsView addSubview:giftedToLabel];
        [barcodeDetailsView addSubview:giftedToVal];
    }
    
    [self.view addSubview:barcodeDetailsView];
    
    if ([statusStr isEqualToString:@"Redeemed"] || [statusStr  isEqualToString:@"Void"]||[statusStr isEqualToString:@"Refunded"]) {
        redeemButton.enabled = NO;
        [redeemButton setBackgroundImage:[UIImage imageNamed:@"disable_Btn.png"] forState:UIControlStateNormal];
    }
    
    if ([statusVal.text isEqualToString:@"Void"]) {
        if (((giftedToValStr == (id)[NSNull null]) ||(giftedToValStr==nil) ||(giftedToValStr.length==0)||[giftedToValStr isEqualToString:@"0000-00-00"])||((giftedOnValStr == (id)[NSNull null]) ||(giftedOnValStr==nil) ||(giftedOnValStr.length==0)||[giftedOnValStr isEqualToString:@"0000-00-00"])){
            messageLabel.text = [NSString stringWithFormat:@"This coupon has been voided because it was gifted."];
        }else{
            messageLabel.text = [NSString stringWithFormat:@"This coupon has been voided because it was gifted to %@ on %@.",giftedToValStr,giftedOnValStr];
        }
    }else if ([statusVal.text isEqualToString:@"Redeemed"]) {
        if (((redeemedDate == (id)[NSNull null]) ||(redeemedDate==nil) ||(redeemedDate.length==0)||[redeemedDate isEqualToString:@"0000-00-00"])){
            messageLabel.text = [NSString stringWithFormat:@"Coupon already redeemed."];
        }else{
            messageLabel.text = [NSString stringWithFormat:@"Coupon already redeemed on %@.",redeemedDate];
        }
    }else if ([statusVal.text isEqualToString:@"Refunded"]) {
        messageLabel.text = [NSString stringWithFormat:@"Coupon is invalid because it was refunded."];
    }
    if (current_rest_Id.length>0) {
        if ([current_rest_Id isEqualToString:restId]) {
        }else{
            messageLabel.text = [NSString stringWithFormat:@"This coupon is not valid in this restaurant."];
            redeemButton.enabled = NO;
            [redeemButton setBackgroundImage:[UIImage imageNamed:@"disable_Btn.png"] forState:UIControlStateNormal];
        }
    }
    
    [barcodeDetailsView addSubview:redeemButton];
    [barcodeDetailsView addSubview:cancelButton];
    [barcodeDetailsView addSubview:messageLabel];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        currentRestNameLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:24.0f];
        dealDetailsLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:35.0f];
        barcodeDetailsLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:35.0f];
        barcodeLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:16.0f];
        dealNameLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:25.0f];
        restNameLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
        restAddressLabel.font=[UIFont fontWithName:@"TrebuchetMS" size:20.0f];
        valueLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
        costLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
        saveLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
        valueLabelVal.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
        costLabelVal.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
        saveLabelVal.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
        buyerNameVal.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
        emailVal.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
        statusVal.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
        messageLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:19.0f];
        redeemButton.titleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
        cancelButton.titleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
        datePurchasedVal.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
        giftedToVal.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
        giftedOnVal.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
        buyerNameLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
        emailLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
        datePurchasedLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
        giftedToLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
        giftedOnLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
        statusLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
    }
    
    
}
-(void)potratit{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 768, 1024);
        
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBg_P.png"]];
        
        currentRestNameLabel.frame = CGRectMake(150,28,615,35.0);
        
        dealDetailsView.frame = CGRectMake(0.0f,124.3f,self.view.frame.size.width, 148.0f);
        dealDetailsLabel.frame = CGRectMake(0.0f,0.0f,dealDetailsView.frame.size.width,50.0f);
        
        barcodeDetailsView.frame = CGRectMake(0.0f,dealDetailsView.frame.origin.y+dealDetailsView.frame.size.height,self.view.frame.size.width, 623);
        barcodeDetailsLabel.frame = CGRectMake(0.0f, 0.0,barcodeDetailsView.frame.size.width,50.0f);
        barcodeImageView.frame = CGRectMake(650.0f-30,60+35,72.0f,72.0f);
        

//        barcodeImageView.frame = CGRectMake(650.0f,60,72.0f,215.0f);

        barcodeLabel.frame = CGRectMake(525.0f+20,167.0f,215.0f,30.0f);
//        barcodeLabel.frame = CGRectMake(525.0f,152.0f,215.0f,30.0f);
        
//        barcodeLabel.transform = CGAffineTransformMakeRotation(3.14/2);
        
        dealNameLabel.frame= CGRectMake(0.0f,dealDetailsLabel.frame.size.height,dealDetailsView.frame.size.width-170,30.0f);
        restNameLabel.frame= CGRectMake(0.0f,dealNameLabel.frame.origin.y+dealNameLabel.frame.size.height,dealDetailsView.frame.size.width-170,30.0f);
        restAddressLabel.frame=CGRectMake(0.0f,restNameLabel.frame.origin.y+restNameLabel.frame.size.height,dealDetailsView.frame.size.width-170,30.0f);
        
        valueLabel.frame = CGRectMake(dealNameLabel.frame.size.width+2,dealDetailsLabel.frame.size.height,80,30.0f);
        costLabel.frame = CGRectMake(restNameLabel.frame.size.width+2,valueLabel.frame.origin.y+valueLabel.frame.size.height,80,30.0f);
        saveLabel.frame = CGRectMake(restAddressLabel.frame.size.width+2,costLabel.frame.origin.y+costLabel.frame.size.height,80,30.0f);
        
        
        valueLabelVal.frame = CGRectMake(valueLabel.frame.origin.x+valueLabel.frame.size.width+2,dealDetailsLabel.frame.size.height,85,30.0f);
        costLabelVal.frame = CGRectMake(costLabel.frame.origin.x+costLabel.frame.size.width+2,valueLabelVal.frame.origin.y+valueLabelVal.frame.size.height,85,30.0f);
        saveLabelVal.frame = CGRectMake(saveLabel.frame.origin.x+saveLabel.frame.size.width+2,costLabelVal.frame.origin.y+costLabelVal.frame.size.height,85,30.0f);
        
        buyerNameLabel.frame = CGRectMake(2.0f,barcodeDetailsLabel.frame.origin.y+barcodeDetailsLabel.frame.size.height+40.0f,170.0f,30.0f);
        buyerNameVal.frame = CGRectMake(buyerNameLabel.frame.origin.x+buyerNameLabel.frame.size.width+2.0f,barcodeDetailsLabel.frame.origin.y+barcodeDetailsLabel.frame.size.height+40.0f,480,30.0f);
        
        emailLabel.frame = CGRectMake(2.0f,buyerNameLabel.frame.origin.y+buyerNameLabel.frame.size.height+2.0f,170.0f,30.0f);
        emailVal.frame = CGRectMake(emailLabel.frame.origin.x+emailLabel.frame.size.width+2.0f,buyerNameVal.frame.origin.y+buyerNameVal.frame.size.height+2.0f,480,30.0f);
        
        statusLabel.frame = CGRectMake(2.0f,emailLabel.frame.origin.y+emailLabel.frame.size.height+2.0f,170.0f,30.0f);
        statusVal.frame = CGRectMake(statusLabel.frame.origin.x+statusLabel.frame.size.width+2.0f,emailVal.frame.origin.y+emailVal.frame.size.height+2.0f,480,30.0f);
        
        UILabel *currentLastLabel = statusLabel;
        
        if ((subscriptionDateStr == (id)[NSNull null]) ||(subscriptionDateStr==nil) ||(subscriptionDateStr.length==0)||[subscriptionDateStr isEqualToString:@"0000-00-00"]) {
            addPoDateLabel = NO;
        }else{
            addPoDateLabel = YES;
            datePurchasedLabel.frame = CGRectMake(2.0f,currentLastLabel.frame.origin.y+currentLastLabel.frame.size.height+2.0f,170.0f,30.0f);
            datePurchasedVal.frame =CGRectMake(datePurchasedLabel.frame.origin.x+datePurchasedLabel.frame.size.width+2.0f,currentLastLabel.frame.origin.y+currentLastLabel.frame.size.height+2.0f,480,30.0f);
            currentLastLabel = datePurchasedVal;
        }
        
        if ((giftedToValStr == (id)[NSNull null]) ||(giftedToValStr==nil) ||(giftedToValStr.length==0)||[giftedToValStr isEqualToString:@"0000-00-00"]) {
            addGitedToLabel = NO;
        }else{
            addGitedToLabel = YES;
            giftedToLabel.frame = CGRectMake(2.0f,currentLastLabel.frame.origin.y+currentLastLabel.frame.size.height+2.0f,170.0f,30.0f);
            giftedToVal.frame = CGRectMake(giftedToLabel.frame.origin.x+giftedToLabel.frame.size.width+2.0f,currentLastLabel.frame.origin.y+currentLastLabel.frame.size.height+2.0f,480,30.0f);
            currentLastLabel = giftedToLabel;
            
        }
        
        if ((giftedOnValStr == (id)[NSNull null]) ||(giftedOnValStr==nil) ||(giftedOnValStr.length==0)||[giftedOnValStr isEqualToString:@"0000-00-00"]) {
            addGitedOnLabel = NO;
        }else{
            addGitedOnLabel = YES;
            
            giftedOnLabel.frame = CGRectMake(2.0f,currentLastLabel.frame.origin.y+currentLastLabel.frame.size.height+2.0f,170.0f,30.0f);
            giftedOnVal.frame = CGRectMake(giftedOnLabel.frame.origin.x+giftedOnLabel.frame.size.width+2.0f,currentLastLabel.frame.origin.y+currentLastLabel.frame.size.height+2.0f,480,30.0f);
            currentLastLabel = giftedOnLabel;
        }
        
        messageLabel.frame = CGRectMake(20, 270, 728, 100);
        redeemButton.frame =  CGRectMake(270,messageLabel.frame.origin.y + messageLabel.frame.size.height +10,100.0f,50.0f);
        cancelButton.frame = CGRectMake(380,messageLabel.frame.origin.y + messageLabel.frame.size.height +10,100.0f,50.0f);
    }else{
        currentRestNameLabel.frame = CGRectMake(90,28,228,24.0);
        currentRestNameLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:15.0f];
        
        dealDetailsView.frame = CGRectMake(0.0f,77.0f,self.view.frame.size.width, 84.0f);
        dealDetailsLabel.frame = CGRectMake(0.0f,0.0f,dealDetailsView.frame.size.width,30.0f);
        dealDetailsLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
        
        if ([UIScreen mainScreen].bounds.size.height == 568) {  // iphone 4 inch
            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphoneBg_320x568.png"]];
            barcodeDetailsView.frame = CGRectMake(0.0f,dealDetailsView.frame.origin.y+dealDetailsView.frame.size.height,self.view.frame.size.width, 325);
            
        }else{// iphone 3.5 inch
            barcodeDetailsView.frame = CGRectMake(0.0f,dealDetailsView.frame.origin.y+dealDetailsView.frame.size.height,self.view.frame.size.width, 237);
            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphoneBg_320x480.png"]];
        }
        
        barcodeDetailsLabel.frame = CGRectMake(0.0f, 0.0,barcodeDetailsView.frame.size.width,30.0f);
        barcodeDetailsLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:20.0f];
        
//        barcodeImageView.frame = CGRectMake(260.0f,32,52.0f,140.0f);
        barcodeImageView.frame = CGRectMake(260.0f-18,32+22,52.0f,52.0f);
      
//        barcodeLabel.frame = CGRectMake(179.0f,92,140.0f,20.0f);

        barcodeLabel.frame = CGRectMake(179.0f+20,116-10,140.0f,20.0f);

//        barcodeLabel.transform = CGAffineTransformMakeRotation(3.14/2);
        barcodeLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:10.0f];
        
        dealNameLabel.frame= CGRectMake(0.0f,dealDetailsLabel.frame.size.height,dealDetailsView.frame.size.width-85,20.0f);
        dealNameLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:12.0f];
        
        restNameLabel.frame= CGRectMake(0.0f,dealNameLabel.frame.origin.y+dealNameLabel.frame.size.height,dealDetailsView.frame.size.width-85,15.0f);
        restNameLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:10.0f];
        
        restAddressLabel.frame=CGRectMake(0.0f,restNameLabel.frame.origin.y+restNameLabel.frame.size.height,dealDetailsView.frame.size.width-85,15.0f);
        restAddressLabel.font=[UIFont fontWithName:@"TrebuchetMS" size:10.0f];
        
        valueLabel.frame = CGRectMake(dealNameLabel.frame.size.width+2,dealDetailsLabel.frame.size.height,40,15.0f);
        valueLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:10.0f];
        
        costLabel.frame = CGRectMake(restNameLabel.frame.size.width+2,valueLabel.frame.origin.y+valueLabel.frame.size.height,40,15.0f);
        costLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:10.0f];
        
        
        saveLabel.frame = CGRectMake(restAddressLabel.frame.size.width+2,costLabel.frame.origin.y+costLabel.frame.size.height,40,15.0f);
        saveLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:10.0f];
        
        
        valueLabelVal.frame = CGRectMake(valueLabel.frame.origin.x+valueLabel.frame.size.width,dealDetailsLabel.frame.size.height,42,15.0f);
        valueLabelVal.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:10.0f];
        
        costLabelVal.frame = CGRectMake(costLabel.frame.origin.x+costLabel.frame.size.width,valueLabelVal.frame.origin.y+valueLabelVal.frame.size.height,42,15.0f);
        costLabelVal.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:10.0f];
        
        
        saveLabelVal.frame = CGRectMake(saveLabel.frame.origin.x+saveLabel.frame.size.width,costLabelVal.frame.origin.y+costLabelVal.frame.size.height,42,15.0f);
        
        saveLabelVal.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:10.0f];
        
        
        buyerNameLabel.frame = CGRectMake(2.0f,barcodeDetailsLabel.frame.origin.y+barcodeDetailsLabel.frame.size.height+5.0f,80.0f,15.0f);
        buyerNameLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:10.0f];
        
        buyerNameVal.frame = CGRectMake(buyerNameLabel.frame.size.width+5.0f,barcodeDetailsLabel.frame.origin.y+barcodeDetailsLabel.frame.size.height+5.0f,155,15.0f);
        
        buyerNameVal.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:10.0f];
        
        
        emailLabel.frame = CGRectMake(2.0f,buyerNameLabel.frame.origin.y+buyerNameLabel.frame.size.height+2.0f,80.0f,15.0f);
        emailLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:10.0f];
        
        emailVal.frame = CGRectMake(emailLabel.frame.size.width+5.0f,buyerNameVal.frame.origin.y+buyerNameVal.frame.size.height+2.0f,155,15.0f);
        emailVal.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:10.0f];
        
        statusLabel.frame = CGRectMake(2.0f,emailLabel.frame.origin.y+emailLabel.frame.size.height+2.0f,80.0f,15.0f);
        statusLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:10.0f];
        
        statusVal.frame = CGRectMake(statusLabel.frame.size.width+5.0f,emailVal.frame.origin.y+emailVal.frame.size.height+2.0f,155,15.0f);
        statusVal.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:10.0f];
        
        
        UILabel *currentLastLabel = statusLabel;
        
        if ((subscriptionDateStr == (id)[NSNull null]) ||(subscriptionDateStr==nil) ||(subscriptionDateStr.length==0)||[subscriptionDateStr isEqualToString:@"0000-00-00"]) {
            addPoDateLabel = NO;
        }else{
            addPoDateLabel = YES;
            datePurchasedLabel.frame = CGRectMake(2.0f,currentLastLabel.frame.origin.y+currentLastLabel.frame.size.height+2.0f,80.0f,15.0f);
            datePurchasedLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:10.0f];
            
            datePurchasedVal.frame =CGRectMake(datePurchasedLabel.frame.size.width+5.0f,currentLastLabel.frame.origin.y+currentLastLabel.frame.size.height+2.0f,155,15.0f);
            currentLastLabel = datePurchasedVal;
            datePurchasedVal.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:10.0f];
            
        }
        
        if ((giftedToValStr == (id)[NSNull null]) ||(giftedToValStr==nil) ||(giftedToValStr.length==0)||[giftedToValStr isEqualToString:@"0000-00-00"]) {
            addGitedToLabel = NO;
        }else{
            addGitedToLabel = YES;
            giftedToLabel.frame = CGRectMake(2.0f,currentLastLabel.frame.origin.y+currentLastLabel.frame.size.height+2.0f,80.0f,15.0f);
            giftedToLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:10.0f];
            giftedOnLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:10.0f];
            
            giftedToVal.frame = CGRectMake(giftedToLabel.frame.size.width+5.0f,currentLastLabel.frame.origin.y+currentLastLabel.frame.size.height+2.0f,155,15.0f);
            currentLastLabel = giftedToLabel;
            giftedToVal.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:10.0f];
        }
        
        if ((giftedOnValStr == (id)[NSNull null]) ||(giftedOnValStr==nil) ||(giftedOnValStr.length==0)||[giftedOnValStr isEqualToString:@"0000-00-00"]) {
            addGitedOnLabel = NO;
        }else{
            addGitedOnLabel = YES;
            
            giftedOnLabel.frame = CGRectMake(2.0f,currentLastLabel.frame.origin.y+currentLastLabel.frame.size.height+2.0f,80.0f,15.0f);
            giftedOnVal.frame = CGRectMake(giftedOnLabel.frame.size.width+5.0f,currentLastLabel.frame.origin.y+currentLastLabel.frame.size.height+2.0f,155,15.0f);
            currentLastLabel = giftedOnLabel;
            giftedOnVal.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:10.0f];
            
        }
        
        
        
        messageLabel.frame = CGRectMake(10, 160, 300, 50);
        messageLabel.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:10.0f];
        
        
        redeemButton.frame =  CGRectMake(80,messageLabel.frame.origin.y + messageLabel.frame.size.height,70.0f,25.0f);
        cancelButton.frame = CGRectMake(170,messageLabel.frame.origin.y + messageLabel.frame.size.height,70.0f,25.0f);
        
        redeemButton.titleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:10.0f];
        cancelButton.titleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:10.0f];
    }
}


-(void)landscape{
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 1024, 768);
    self.view.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBg_L.png"]];
    currentRestNameLabel.frame = CGRectMake(150,28,870,35.0);
    
    dealDetailsView.frame = CGRectMake(0.0f,124.0f, self.view.frame.size.width, 148.0f);
    dealDetailsLabel.frame = CGRectMake(0.0f,0.0f,dealDetailsView.frame.size.width,50.0f);
    
    barcodeDetailsView.frame = CGRectMake(0.0f,dealDetailsView.frame.origin.y+dealDetailsView.frame.size.height, self.view.frame.size.width, 370);
    
    
    barcodeDetailsLabel.frame = CGRectMake(0.0f, 0.0,barcodeDetailsView.frame.size.width,50.0f);
    
//    barcodeImageView.frame = CGRectMake(850.0f,50,72.0f,215.0f);
    barcodeImageView.frame = CGRectMake(850.0f-30,60+35,72.0f,72.0f);

    
//    barcodeLabel.frame = CGRectMake(727.0f,143.0f,215.0f,30.0f);

    barcodeLabel.frame = CGRectMake(727.0f+20,167.0f,215.0f,30.0f);
    
    
//    barcodeLabel.transform = CGAffineTransformMakeRotation(3.14/2);
    
    dealNameLabel.frame= CGRectMake(0.0f,dealDetailsLabel.frame.size.height,dealDetailsView.frame.size.width-170,30.0f);
    restNameLabel.frame= CGRectMake(0.0f,dealNameLabel.frame.origin.y+dealNameLabel.frame.size.height,dealDetailsView.frame.size.width-170,30.0f);
    restAddressLabel.frame=CGRectMake(0.0f,restNameLabel.frame.origin.y+restNameLabel.frame.size.height,dealDetailsView.frame.size.width-170,30.0f);
    
    valueLabel.frame = CGRectMake(dealNameLabel.frame.size.width+2,dealDetailsLabel.frame.size.height,80,30.0f);
    costLabel.frame = CGRectMake(restNameLabel.frame.size.width+2,dealNameLabel.frame.origin.y+dealNameLabel.frame.size.height,80,30.0f);
    saveLabel.frame = CGRectMake(restAddressLabel.frame.size.width+2,restNameLabel.frame.origin.y+restNameLabel.frame.size.height,80,30.0f);
    
    
    valueLabelVal.frame = CGRectMake(valueLabel.frame.origin.x+valueLabel.frame.size.width+2,dealDetailsLabel.frame.size.height,85,30.0f);
    costLabelVal.frame = CGRectMake(costLabel.frame.origin.x+costLabel.frame.size.width+2,dealNameLabel.frame.origin.y+dealNameLabel.frame.size.height,85,30.0f);
    saveLabelVal.frame = CGRectMake(saveLabel.frame.origin.x+saveLabel.frame.size.width+2,restNameLabel.frame.origin.y+restNameLabel.frame.size.height,85,30.0f);
    
    buyerNameLabel.frame = CGRectMake(2.0f,barcodeDetailsLabel.frame.origin.y+barcodeDetailsLabel.frame.size.height+40.0f,170.0f,30.0f);
    buyerNameVal.frame = CGRectMake(buyerNameLabel.frame.origin.x+buyerNameLabel.frame.size.width+2.0f,barcodeDetailsLabel.frame.origin.y+barcodeDetailsLabel.frame.size.height+40.0f,740,30.0f);
    
    emailLabel.frame = CGRectMake(2.0f,buyerNameLabel.frame.origin.y+buyerNameLabel.frame.size.height+2.0f,170.0f,30.0f);
    emailVal.frame = CGRectMake(emailLabel.frame.origin.x+emailLabel.frame.size.width+2.0f,buyerNameVal.frame.origin.y+buyerNameVal.frame.size.height+2.0f,740,30.0f);
    
    statusLabel.frame = CGRectMake(2.0f,emailLabel.frame.origin.y+emailLabel.frame.size.height+2.0f,170.0f,30.0f);
    statusVal.frame = CGRectMake(statusLabel.frame.origin.x+statusLabel.frame.size.width+2.0f,emailLabel.frame.origin.y+emailLabel.frame.size.height+2.0f,740,30.0f);
    
    
    UILabel *currentLastLabel = statusLabel;
    
    if ((subscriptionDateStr == (id)[NSNull null]) ||(subscriptionDateStr==nil) ||(subscriptionDateStr.length==0)||[subscriptionDateStr isEqualToString:@"0000-00-00"]) {
        addPoDateLabel = NO;
    }else{
        addPoDateLabel = YES;
        datePurchasedLabel.frame = CGRectMake(2.0f,currentLastLabel.frame.origin.y+currentLastLabel.frame.size.height+2.0f,170.0f,30.0f);
        datePurchasedVal.frame =CGRectMake(datePurchasedLabel.frame.origin.x+datePurchasedLabel.frame.size.width+2.0f,currentLastLabel.frame.origin.y+currentLastLabel.frame.size.height+2.0f,740,30.0f);
        currentLastLabel = datePurchasedVal;
    }
    
    if ((giftedToValStr == (id)[NSNull null]) ||(giftedToValStr==nil) ||(giftedToValStr.length==0)||[giftedToValStr isEqualToString:@"0000-00-00"]) {
        addGitedToLabel = NO;
    }else{
        addGitedToLabel = YES;
        giftedToLabel.frame = CGRectMake(2.0f,currentLastLabel.frame.origin.y+currentLastLabel.frame.size.height+2.0f,170.0f,30.0f);
        giftedToVal.frame = CGRectMake(giftedToLabel.frame.origin.x+giftedToLabel.frame.size.width+2.0f,currentLastLabel.frame.origin.y+currentLastLabel.frame.size.height+2.0f,740,30.0f);
        currentLastLabel = giftedToLabel;
        
    }
    
    if ((giftedOnValStr == (id)[NSNull null]) ||(giftedOnValStr==nil) ||(giftedOnValStr.length==0)||[giftedOnValStr isEqualToString:@"0000-00-00"]) {
        addGitedOnLabel = NO;
    }else{
        addGitedOnLabel = YES;
        
        giftedOnLabel.frame = CGRectMake(2.0f,currentLastLabel.frame.origin.y+currentLastLabel.frame.size.height+2.0f,170.0f,30.0f);
        giftedOnVal.frame = CGRectMake(giftedOnLabel.frame.origin.x+giftedOnLabel.frame.size.width+2.0f,currentLastLabel.frame.origin.y+currentLastLabel.frame.size.height+2.0f,740,30.0f);
        currentLastLabel = giftedOnLabel;
    }
    
    messageLabel.frame = CGRectMake(20, currentLastLabel.frame.origin.y+currentLastLabel.frame.size.height +2, 984, 30);
    redeemButton.frame =  CGRectMake(400,messageLabel.frame.origin.y+messageLabel.frame.size.height+5 ,100.0f,50.0f);
    cancelButton.frame = CGRectMake(510,messageLabel.frame.origin.y+messageLabel.frame.size.height+5,100.0f,50.0f);
}


-(void)redeemButtonClicked:(id)sender{

    redeemButtonClicked=YES;
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    haveAlreadyReceivedCoordinates = NO;
    [self.locationManager startUpdatingLocation];
}

-(void)cancelButtonClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma  - Request
#pragma  - Request
-(void)postRequest:(NSString *)reqType{
    
    dbManager = [DataBaseManager dataBaseManager];
    NSMutableArray *loginDetails= [[NSMutableArray alloc]init];
    [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM LoginDetails"] resultsArray:loginDetails];
    NSDictionary *loginDict =[loginDetails objectAtIndex:0];
    NSString *localUserName = [loginDict objectForKey:@"UserName"];
    
    NSString *postDataInString = [self postFormatString:BARCODE_REDEEM_TYPE withUserEmail:localUserName];
    NSData *postJsonData = [postDataInString dataUsingEncoding:NSUTF8StringEncoding];
    webServiceInterface = [[WebServiceInterface alloc]initWithVC:self];
    webServiceInterface.delegate =self;
    [webServiceInterface sendRequest:postDataInString PostJsonData:postJsonData Req_Type:reqType Req_url:Barcode_Redeem_URL];
}

-(NSString*)postFormatString:(NSString *)type withUserEmail:(NSString *)userEmail{
    uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
    NSLog(@"UDID:: %@", uniqueIdentifier);
    NSString *bodyStr =[NSString stringWithFormat: @"{\"res_id\":\"%@\", \"barcode\":\"%@\", \"device_details\": {\"device_id\":\"%@\", \"lat\":\"%@\", \"long\":\"%@\"}}",restId, barcodeVal,uniqueIdentifier,latitudeString,longitudeString];
    return bodyStr;
}

-(void)getResponse:(NSDictionary *)resp type:(NSString *)respType{
    
    if ((resp == (id)[NSNull null]) ||(resp==nil)) {
    }else{
        
        NSString  *message;
        NSString  *status;
        if ([[resp allKeys] containsObject:@"message"]) {
            message= [resp valueForKey:@"message"];
            NSLog(@"contains message Key");
            // contains key
        }
        else if ([[resp allKeys] containsObject:@"status"]) {
            status = [resp valueForKey:@"status"];
            NSLog(@"contains status Key");
            // contains key
        }
        if ([status isEqualToString:@"failure"]) {
            if ((message == (id)[NSNull null])||(message.length==0)||(message==nil)) {
                [FAUtilities showToastMessageAlert:@"Unable to recieve message from server"];
            }else{
                if (IS_EMPTY(message)) {
                    [FAUtilities showToastMessageAlert:@"Unable to recieve deal details from server"];
                }else{
                    [FAUtilities showToastMessageAlert:message];
                }
            }
        }else{
            if ((message == (id)[NSNull null])||(message==nil)) {
            NSLog(@"null message:%@",message);
                }
            if ([statusVal.text isEqualToString:@"New"]){
                statusVal.text =@"Redeemed";
                messageLabel.text = [NSString stringWithFormat:@"%@",@"Coupon redeemed successfully."];
                messageLabel.textColor = [UIColor colorWithRed:0.0f/255.0f green:126.0f/255.0f blue:4.0f/255.0f alpha:1.0f];
                
            }else if ([statusVal.text isEqualToString:@"Gifted"]) {
                messageLabel.text = [NSString stringWithFormat:@"%@",@"Coupon redeemed successfully."];
                messageLabel.textColor = [UIColor colorWithRed:0.0f/255.0f green:126.0f/255.0f blue:4.0f/255.0f alpha:1.0f];
                statusVal.text =@"Redeemed";
            }
            if ([statusVal.text isEqualToString:@"Redeemed"]) {
                redeemButton.enabled = NO;
                [redeemButton setBackgroundImage:[UIImage imageNamed:@"disable_Btn.png"] forState:UIControlStateNormal];
            }
        }
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
    
    if (redeemButtonClicked==YES) {
        [self postRequest:BARCODE_REDEEM_TYPE];
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


#pragma - Orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration{
    
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
//    barcodeLabel.transform = CGAffineTransformMakeRotation(3.14);
    
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
    if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
        [self potratit];
    }else if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
        [self landscape];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
