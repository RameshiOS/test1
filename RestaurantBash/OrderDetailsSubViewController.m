//
//  OrderDetailsSubViewController.m
//  RestaurantBash
//
//  Created by Manulogix on 30/09/14.
//  Copyright (c) 2014 Manulogix Pvt Ltd. All rights reserved.
//

#import "OrderDetailsSubViewController.h"
#import "FAUtilities.h"

@interface OrderDetailsSubViewController ()

@end

@implementation OrderDetailsSubViewController
@synthesize formattedOrderDetails;
@synthesize itemHeights;

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
    
    
    [self drawAttchmentsView];

    
    // Do any additional setup after loading the view.
}


- (void)drawAttchmentsView{
    
    CGFloat originX = 20;
    CGFloat originY = 0;
    CGFloat width = orderDetailsScrollView.frame.size.width - 40;
    CGFloat height = 0;
    CGFloat yGap = 8;
    
    for (UIView *view in orderDetailsScrollView.subviews) {
        [view removeFromSuperview];
    }
    int foldersContainEachRow = 1;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            foldersContainEachRow = 1;
        }
        
    }else{
        foldersContainEachRow = 1;
        originX = 2;
        width = orderDetailsScrollView.frame.size.width - 4;
    }
    
    
    for (int i=0; i<[formattedOrderDetails count]; i++) {
        
        height = [[itemHeights objectAtIndex:i] floatValue];
        
        UIView *folderView = [self createFolderViewForTag:i withFrame:CGRectMake(originX, originY, width, height)];
        folderView.layer.borderColor = [[FAUtilities getUIColorObjectFromHexString:@"A2439D" alpha:1]CGColor];
        folderView.layer.borderWidth = 2;
        
        
        [orderDetailsScrollView addSubview:folderView];
        
        int val = i+1;
        
        if(val%foldersContainEachRow != 0){
            //            originX += width+xGap;
        }
        else{
            originY += height+yGap;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                originX =20;
            }else{
                originX =2;
            }
        }
    }
    orderDetailsScrollView.contentSize = CGSizeMake(0, originY+height);
    
}


- (UIView*)createFolderViewForTag:(int)tag withFrame:(CGRect)rect{
    UIView *folderVIew = [[UIView alloc]initWithFrame:rect];
    
    
    CGRect itemCategorySubViewFrame;
    CGRect itemNameFrame;
    CGRect itemCategoryFrame;
    CGRect itemServingTypeFrame;
    CGRect itemServingQtyFrame;
    CGRect itemServingPriceFrame;
    
    UIFont *itemNameFont;
    UIFont *itemCategoryFont;
    UIFont *itemServingFont;
    UIFont *itemModifierFont;
    UIFont *itemModifierOptionFont;
    
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        itemCategorySubViewFrame = CGRectMake(0, 0, rect.size.width, 60);
        itemNameFrame = CGRectMake(0, 0, rect.size.width, 30);
        itemCategoryFrame = CGRectMake(0, 30, rect.size.width, 30);
        
        itemServingTypeFrame = CGRectMake(8, itemCategorySubViewFrame.size.height +2 , rect.size.width-200, 30);
        
        itemServingQtyFrame = CGRectMake(itemServingTypeFrame.origin.x+ itemServingTypeFrame.size.width +2, itemServingTypeFrame.origin.y , 80, 30);
        
        itemServingPriceFrame  = CGRectMake(itemServingQtyFrame.origin.x+ itemServingQtyFrame.size.width +2, itemServingTypeFrame.origin.y , 100, 30);
        
        itemNameFont = [UIFont fontWithName:@"Verdana" size:22];
        itemCategoryFont = [UIFont fontWithName:@"Verdana" size:20];
        
        itemServingFont = [UIFont fontWithName:@"Verdana" size:18];
        
        itemModifierFont = [UIFont fontWithName:@"Verdana-Bold" size:18];
        
        itemModifierOptionFont = [UIFont fontWithName:@"Verdana" size:18];
        
    }else{
        itemCategorySubViewFrame = CGRectMake(0, 0, rect.size.width, 40);
        itemNameFrame = CGRectMake(0, 0, rect.size.width, 20);
        itemCategoryFrame = CGRectMake(0, 20, rect.size.width, 20);
        
        itemServingTypeFrame = CGRectMake(2, itemCategorySubViewFrame.size.height +2 , rect.size.width-130, 20);
        
        itemServingQtyFrame = CGRectMake(itemServingTypeFrame.origin.x+ itemServingTypeFrame.size.width +2, itemServingTypeFrame.origin.y , 60, 20);
        
        itemServingPriceFrame  = CGRectMake(itemServingQtyFrame.origin.x+ itemServingQtyFrame.size.width +2, itemServingTypeFrame.origin.y , 60, 20);
        
        itemNameFont = [UIFont fontWithName:@"Verdana" size:16];
        itemCategoryFont = [UIFont fontWithName:@"Verdana" size:14];
        
        itemServingFont = [UIFont fontWithName:@"Verdana" size:12];
        
        itemModifierFont = [UIFont fontWithName:@"Verdana-Bold" size:12];
        
        itemModifierOptionFont = [UIFont fontWithName:@"Verdana" size:12];
        
    }
    
    
    NSDictionary *tempDict = [formattedOrderDetails objectAtIndex:tag];
    
    UIView *itemCategorySubView = [[UIView alloc]initWithFrame:itemCategorySubViewFrame];
    itemCategorySubView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:@"A2439D" alpha:1];
    
    
    UILabel *itemNameLabel = [[UILabel alloc]initWithFrame:itemNameFrame];
    itemNameLabel.text = [tempDict objectForKey:@"item_name"];
    itemNameLabel.textAlignment = NSTextAlignmentCenter;
    itemNameLabel.font = itemNameFont;
    itemNameLabel.textColor = [UIColor whiteColor];
    
    UILabel *itemCategoryLabel = [[UILabel alloc]initWithFrame:itemCategoryFrame];
    itemCategoryLabel.text = [NSString stringWithFormat:@"(%@)",[tempDict objectForKey:@"category_name"]];
    itemCategoryLabel.textAlignment = NSTextAlignmentCenter;
    itemCategoryLabel.font = itemCategoryFont;
    itemCategoryLabel.textColor = [UIColor whiteColor];
    
    
    [itemCategorySubView addSubview:itemNameLabel];
    [itemCategorySubView addSubview:itemCategoryLabel];
    
    
    UILabel *servingTypeLabel = [[UILabel alloc]initWithFrame:itemServingTypeFrame];
    servingTypeLabel.text = [tempDict objectForKey:@"serving_name"];
    servingTypeLabel.textAlignment = NSTextAlignmentLeft;
    servingTypeLabel.font = itemServingFont;
    
    
    
    UILabel *servingQtyLabel = [[UILabel alloc]initWithFrame:itemServingQtyFrame];
    servingQtyLabel.text = [NSString stringWithFormat:@"%@ Qty",[tempDict objectForKey:@"quantity"]];
    servingQtyLabel.textAlignment = NSTextAlignmentCenter;
    servingQtyLabel.font = itemServingFont;
    
    
    UILabel *servingPriceLabel = [[UILabel alloc]initWithFrame:itemServingPriceFrame];
    servingPriceLabel.text = [NSString stringWithFormat:@"$%@",[tempDict objectForKey:@"serving_price"]];
    servingPriceLabel.textAlignment = NSTextAlignmentRight;
    servingPriceLabel.font = itemServingFont;
    
    
    NSArray *itemModifiers = [tempDict objectForKey:@"item_modifiers"];
    
    int categoryX;
    int categoryY;
    int categoryWidth;
    int categoryHeight;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        categoryX       = 8;
        categoryY       = itemServingTypeFrame.origin.y+itemServingTypeFrame.size.height +2;
        categoryWidth   = itemServingTypeFrame.size.width;
        categoryHeight  = 30;
    }else{
        categoryX       = 2;
        categoryY       = itemServingTypeFrame.origin.y+itemServingTypeFrame.size.height +2;
        categoryWidth   = itemServingTypeFrame.size.width;
        categoryHeight  = 20;
    }
    
    
    
    for (int i=0; i<[itemModifiers count]; i++) {
        
        NSDictionary *itemModifiersDict  = [itemModifiers objectAtIndex:i];
        NSString *itemModifier = [itemModifiersDict objectForKey:@"modifier_name"];
        
        UILabel *itemModifierLabel = [[UILabel alloc]initWithFrame:CGRectMake(categoryX, categoryY, categoryWidth, categoryHeight)];
        itemModifierLabel.text = itemModifier;
        itemModifierLabel.font = itemModifierFont;
        
        
        int optionX;
        int optionY;
        int optionWidth;
        int optionHeight;
        
        int optionPriceX = 0;
        int optionPriceY =0;
        int optionPriceWidth = 0;
        int optionPriceHeight=0;
        
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            optionX       = 24;
            optionY       = itemModifierLabel.frame.origin.y+itemModifierLabel.frame.size.height +2;
            optionWidth   = itemServingTypeFrame.size.width+80;
            optionHeight  = 30;
            
            optionPriceX = servingPriceLabel.frame.origin.x;
            optionPriceY = optionY;
            optionPriceWidth = 100;
            optionPriceHeight = 30;
            
        }else{
            optionX       = 12;
            optionY       = itemModifierLabel.frame.origin.y+itemModifierLabel.frame.size.height +2;
            optionWidth   = itemServingTypeFrame.size.width+50;
            optionHeight  = 20;
            
            optionPriceX = servingPriceLabel.frame.origin.x;
            optionPriceY = optionY;
            optionPriceWidth = 60;
            optionPriceHeight = 20;

        }
        
        
        
        NSArray *itemModifierOptions = [itemModifiersDict objectForKey:@"Options"];
        for (int j=0; j<[itemModifierOptions count]; j++) {
            
            categoryY = optionY + 22;
            
            NSDictionary *itemModifierOptionsDict  = [itemModifierOptions objectAtIndex:j];
            NSString *itemModifierOptionName = [itemModifierOptionsDict objectForKey:@"option_name"];
            NSString *itemModifierOptionPrice = [itemModifierOptionsDict objectForKey:@"option_price"];
            
            
            
            UILabel *itemModifierOptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(optionX, optionY, optionWidth, optionHeight)];
            itemModifierOptionLabel.text = [NSString stringWithFormat:@"   %@",itemModifierOptionName];
            itemModifierOptionLabel.font = itemModifierOptionFont;
            
            UILabel *itemModifierOptionPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(optionPriceX, optionPriceY, optionPriceWidth, optionPriceHeight)];
            itemModifierOptionPriceLabel.text =[NSString stringWithFormat:@"$%@",itemModifierOptionPrice] ;
            itemModifierOptionPriceLabel.font = itemModifierOptionFont;
            itemModifierOptionPriceLabel.textAlignment = NSTextAlignmentRight;
            
            
            optionPriceY = optionPriceY +22;
            optionY = optionY + 22;
            
            
            
            //                itemModifierOptionPriceLabel.layer.borderColor = [[UIColor redColor]CGColor];
            //                itemModifierOptionPriceLabel.layer.borderWidth = 2;
            
            [folderVIew addSubview:itemModifierOptionLabel];
            [folderVIew addSubview:itemModifierOptionPriceLabel];
            
        }
        
        itemModifierLabel.layer.borderColor = [[UIColor redColor]CGColor];
        itemModifierLabel.layer.borderWidth = 2;

        
        [folderVIew addSubview:itemModifierLabel];
    }
    
    
    
    
    
    
    [folderVIew addSubview:servingTypeLabel];
    [folderVIew addSubview:servingQtyLabel];
    [folderVIew addSubview:servingPriceLabel];
    
    
    [folderVIew addSubview:itemCategorySubView];
    
    return folderVIew;
}


-(IBAction)backBtnClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
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
