//
//  ViewController.m
//  RestaurantBash
//
//  Created by Divya on 5/20/14.
//  Copyright (c) 2014 Manulogix Pvt Ltd. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prefersStatusBarHidden];
    [self goToNextView];
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)goToNextView{
    dbManager = [DataBaseManager dataBaseManager];
    NSMutableArray *loginDetails = [[NSMutableArray alloc]init];
    [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM LoginDetails"] resultsArray:loginDetails];
    NSMutableArray *restDetails = [[NSMutableArray alloc]init];
    [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM RestaurantDetails"] resultsArray:restDetails];
    
    if ([loginDetails count]==0) {
        LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        CATransition* transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromBottom;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }else{
        NSString *CurrentUser = [[loginDetails valueForKey:@"CurrentUser"]objectAtIndex:0];
        if ([CurrentUser isEqualToString:@"OFF"]) {
            LoginViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            CATransition* transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionMoveIn;
            transition.subtype = kCATransitionFromBottom;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            [self.navigationController pushViewController:loginViewController animated:YES];
        }else if ([CurrentUser isEqualToString:@"ON"]){
            CATransition* transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionMoveIn;
            transition.subtype = kCATransitionFromLeft;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            RestaurantViewController *restaurantViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RestaurantViewController"];
            restaurantViewController.restauranta =restDetails;
            [self.navigationController pushViewController:restaurantViewController animated:YES];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

