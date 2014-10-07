//
//  OrderDetailsViewController.h
//  RestaurantBash
//
//  Created by Manulogix on 27/09/14.
//  Copyright (c) 2014 Manulogix Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceInterface.h"

@interface OrderDetailsViewController : UIViewController<WebServiceInterfaceDelegate>{
    IBOutlet UIView *customerDetailsSubView;
    IBOutlet UIView *priceDetailsSubView;
 
    // customer details
    
    
    IBOutlet UILabel *custNameLabel;
    IBOutlet UILabel *custPhoneLabel;
    IBOutlet UILabel *custEmailLabel;
    IBOutlet UILabel *custAddressLabel;
    
   // price details
    
    IBOutlet UILabel *subTotalLabel;
    IBOutlet UILabel *taxLabel;
    IBOutlet UILabel *tipLabel;
    IBOutlet UILabel *totalLabel;

    IBOutlet UILabel *orderModeLabel;

    
//    IBOutlet UIButton *statusBtn;
//    IBOutlet UIButton *submitBtn;
    
    
    NSMutableArray *formattedOrderDetails;
    
    
    NSMutableArray *itemHeights;
    
    
    IBOutlet UIScrollView *orderDetailsScrollView;

    
    UIViewController* popoverContent;
    UIPopoverController *popoverController;
    UINavigationController *popOverNavigationController;

//    NSMutableArray *statusArray;
//    NSMutableArray *statusIDArray;
    int selectedIndex;
    
    UITableView *listTableView;
    
    NSString *currentStatusID;
    
    WebServiceInterface *webServiceInterface;

    
    IBOutlet UIButton *acceptBtn;
    IBOutlet UIButton *cancelBtn;
    
    
    
}

@property(nonatomic,retain) NSDictionary *orderDetailsDict;
@property(nonatomic,retain) NSString *currentOrderStatus;
@property(nonatomic,retain) NSString *currentOrderID;


-(IBAction)backBtnClicked:(id)sender;
-(IBAction)statusBtnClicked:(id)sender;

//-(IBAction)submitBtnClicked:(id)sender;

-(IBAction)viewOrderDetails:(id)sender;

-(IBAction)acceptBtnClicked:(id)sender;
-(IBAction)cancelBtnClicked:(id)sender;





@end
