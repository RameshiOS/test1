//
//  OrderDetailsSubViewController.h
//  RestaurantBash
//
//  Created by Manulogix on 30/09/14.
//  Copyright (c) 2014 Manulogix Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailsSubViewController : UIViewController{
    IBOutlet UIScrollView *orderDetailsScrollView;

}

@property(nonatomic,retain)NSArray *formattedOrderDetails;
@property(nonatomic,retain)NSArray *itemHeights;

-(IBAction)backBtnClicked:(id)sender;

@end
