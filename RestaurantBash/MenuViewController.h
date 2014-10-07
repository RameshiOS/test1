//
//  MenuViewController.h
//  RestaurantBash
//
//  Created by Manulogix on 26/09/14.
//  Copyright (c) 2014 Manulogix Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UITableView *menuTableView;
    NSMutableArray *menuListAry;

}

@end
