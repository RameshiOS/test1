//
//  MenuViewController.m
//  RestaurantBash
//
//  Created by Manulogix on 26/09/14.
//  Copyright (c) 2014 Manulogix Pvt Ltd. All rights reserved.
//

#import "MenuViewController.h"
#import "FAUtilities.h"
#import "OrdersViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

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
    menuListAry = [[NSMutableArray alloc]init];

    [menuListAry addObject:@"Online Orders"];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            self.view.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBg_L.png"]];
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            self.view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBg_P.png"]];
        }

    }else{
        if ([UIScreen mainScreen].bounds.size.height == 568) {  // iphone 4 inch
            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphoneBg_320x568.png"]];
        }else{// iphone 3.5 inch
            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphoneBg_320x480.png"]];
        }
    }
    
    
    menuTableView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:@"EAD7E9" alpha:1];
    
    // Do any additional setup after loading the view.
}



#pragma mark
#pragma mark TableView Datasource
/* number of sections in form list record table */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

/* number of rows in form list record table based on records saved in database */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [menuListAry count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [menuTableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
    }
    cell.textLabel.text = [menuListAry objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    
    UIFont *cellFont ;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        cellFont =[UIFont fontWithName:@"Thonburi" size:26];
    }else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        cellFont =[UIFont fontWithName:@"Thonburi" size:18];
    }
    
    
    
    cell.textLabel.font = cellFont;
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:@"000000" alpha:0.3];
    cell.selectedBackgroundView = bgColorView;
    
    //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    NSString *selectedValue = [menuListAry objectAtIndex:indexPath.row];
    
    if ([selectedValue isEqualToString:@"Online Orders"]) {
        OrdersViewController *orders = [self.storyboard instantiateViewControllerWithIdentifier:@"OrdersViewController"];
        [self presentViewController:orders animated:YES completion:nil];
    
    }


}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            self.view.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBg_L.png"]];
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            self.view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"viewBg_P.png"]];
        }
        
    }else{
        if ([UIScreen mainScreen].bounds.size.height == 568) {  // iphone 4 inch
            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphoneBg_320x568.png"]];
        }else{// iphone 3.5 inch
            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphoneBg_320x480.png"]];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
