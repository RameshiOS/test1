//
//  OrdersViewController.h
//  RestaurantBash
//
//  Created by Manulogix on 26/09/14.
//  Copyright (c) 2014 Manulogix Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseManager.h"
#import "WebServiceInterface.h"

@interface OrdersViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,WebServiceInterfaceDelegate>{
    IBOutlet UITableView *ordersListView;

    NSArray *resultsArray;
    
    UILabel *labelView;
    UILabel *headerLabelView;
    
    
    NSMutableArray *tableColumns;
    NSMutableArray *tableColumnKeys;
    NSMutableArray *tableColumnWidths;
    
    
    
    
    DataBaseManager *dbManager;
    WebServiceInterface *webServiceInterface;
    
    
    UIFont *headerLabelFont;
    UIFont *cellLaebelFont;
    
    IBOutlet UIScrollView *myordersScrollView;
   
    
    int tableViewWidth;
    int tableViewHeight;

    
    int statusID;

    IBOutlet UISegmentedControl *segCntrl;
    
    int currentOrderID;
    
    
    NSString *currentOrderStatus;
    
}


-(IBAction)backBrnclicked:(id)sender;
-(IBAction)segmentValueChanged:(id)sender;


@end
