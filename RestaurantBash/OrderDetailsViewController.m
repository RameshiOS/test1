//
//  OrderDetailsViewController.m
//  RestaurantBash
//
//  Created by Manulogix on 27/09/14.
//  Copyright (c) 2014 Manulogix Pvt Ltd. All rights reserved.
//

#import "OrderDetailsViewController.h"
#import "FAUtilities.h"
#import "OrderDetailsSubViewController.h"


#define MIN_ITEM_FOLDER_HEIGHT_IPAD  100
#define MIN_ITEM_FOLDER_HEIGHT_IPHONE  70


@interface OrderDetailsViewController ()

@end

@implementation OrderDetailsViewController
@synthesize orderDetailsDict;
@synthesize currentOrderStatus;
@synthesize currentOrderID;

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
    
    customerDetailsSubView.layer.borderWidth = 2;
    customerDetailsSubView.layer.borderColor = [[FAUtilities getUIColorObjectFromHexString:@"A2439D" alpha:1]CGColor];
    
    
    priceDetailsSubView.layer.borderWidth = 2;
    priceDetailsSubView.layer.borderColor = [[FAUtilities getUIColorObjectFromHexString:@"A2439D" alpha:1]CGColor];
    
    
    
    NSLog(@"orderDetailsDict %@",orderDetailsDict);
    
    NSDictionary *custDetails = [[orderDetailsDict objectForKey:@"customer_details"]objectAtIndex:0];
    NSDictionary *priceDetails = [[orderDetailsDict objectForKey:@"price_details"]objectAtIndex:0];

    
    custNameLabel.text = [custDetails objectForKey:@"name"];
    custPhoneLabel.text = [custDetails objectForKey:@"phone"];
    custEmailLabel.text = [custDetails objectForKey:@"email"];
    custAddressLabel.text = [custDetails objectForKey:@"address"];
    
    
    subTotalLabel.text = [priceDetails objectForKey:@"sub_total"];
    taxLabel.text = [priceDetails objectForKey:@"tax"];
    tipLabel.text = [priceDetails objectForKey:@"tip"];
    totalLabel.text = [priceDetails objectForKey:@"total"];

    
    formattedOrderDetails = [[NSMutableArray alloc]init];
    
    NSArray *orderDetails = [orderDetailsDict objectForKey:@"order_details"];
    
    for (int i=0; i<[orderDetails count]; i++) {
        NSDictionary *currentItem = [orderDetails objectAtIndex:i];
        [self formatItem:currentItem];
        
        
    }
    
    NSLog(@"formattedOrderDetails %@", formattedOrderDetails);
    
    
    itemHeights = [[NSMutableArray alloc]init];
    
    for (int i=0; i<[formattedOrderDetails count]; i++) {
        [self caluclateHeights:[formattedOrderDetails objectAtIndex:i]];
    }
    
    
    NSLog(@"item heights %@",itemHeights);

    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [self drawAttchmentsView];
   
    }else{
            
    }

    
    if ([currentOrderStatus isEqualToString:@"Submitted"]) {
        acceptBtn.hidden = NO;
        cancelBtn.hidden = NO;
    }else{
        acceptBtn.hidden = YES;
        cancelBtn.hidden = YES;
    }
    
    
//    statusArray = [[NSMutableArray alloc]init];
//    
//    [statusArray addObject:@"Submitted"];
//    [statusArray addObject:@"Accepted"];
//    [statusArray addObject:@"Cancelled"];
//    
//    
//    statusIDArray = [[NSMutableArray alloc]init];
//    [statusIDArray addObject:@"1"];
//    [statusIDArray addObject:@"2"];
//    [statusIDArray addObject:@"3"];
    
    
//    [statusBtn setTitle:currentOrderStatus forState:UIControlStateNormal];
    
    orderModeLabel.text = [priceDetails objectForKey:@"type_name"];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)formatItem:(NSDictionary *)item{
    
    NSLog(@"current Item %@", item);

    NSMutableDictionary *itemDict = [[NSMutableDictionary alloc]init];
    
    
    NSArray *itemModifiers = [item objectForKey:@"item_modifiers"];
    NSMutableArray *termpModofierNameArray = [[NSMutableArray alloc]init];
    
    for (int i=0; i<[itemModifiers count]; i++) {
        NSString *tempModifierName = [[itemModifiers objectAtIndex:i]objectForKey:@"modifier_name"];
        [termpModofierNameArray addObject:tempModifierName];
    }
    NSMutableArray *finalModifierAry = [[NSMutableArray alloc]init];
    [finalModifierAry addObjectsFromArray:[[NSSet setWithArray:termpModofierNameArray] allObjects]];
    NSLog(@"finalModifierAry %@",finalModifierAry);
    
    
    NSMutableArray *modifiersAry = [[NSMutableArray alloc]init];
    
    
    for (int i=0; i<[finalModifierAry count]; i++) {

        NSMutableDictionary *tempModifierDict = [[NSMutableDictionary alloc]init];
        
        NSString *finalModifierName = [finalModifierAry objectAtIndex:i];
        NSMutableArray *optionAry = [[NSMutableArray alloc]init];
        
        for (int j=0; j<[itemModifiers count]; j++) {
            NSDictionary *tempDict = [itemModifiers objectAtIndex:j];
            if ([[tempDict objectForKey:@"modifier_name"] isEqualToString:finalModifierName]) {
                [optionAry addObject:tempDict];
            }
        }
        
        
        [tempModifierDict setObject:finalModifierName forKey:@"modifier_name"];
        [tempModifierDict setObject:optionAry forKey:@"Options"];
        
        
        [modifiersAry addObject:tempModifierDict];
    }
    

    NSLog(@"modifiersAry %@", modifiersAry);
    
    
    [itemDict setObject:modifiersAry forKey:@"item_modifiers"];

    [itemDict setObject:[item objectForKey:@"category_name"] forKey:@"category_name"];
    [itemDict setObject:[item objectForKey:@"instructions"] forKey:@"instructions"];
    [itemDict setObject:[item objectForKey:@"item_name"] forKey:@"item_name"];
    [itemDict setObject:[item objectForKey:@"price"] forKey:@"price"];
    [itemDict setObject:[item objectForKey:@"quantity"] forKey:@"quantity"];
    [itemDict setObject:[item objectForKey:@"serving_name"] forKey:@"serving_name"];
    [itemDict setObject:[item objectForKey:@"serving_price"] forKey:@"serving_price"];
    
    
    [formattedOrderDetails addObject:itemDict];
    
    
}


-(void)caluclateHeights:(NSDictionary *)itemDict{
    
    NSLog(@"itemDict %@",itemDict);
    

    int itemFolderHeight;
    int modifierHeight;
    int optionHeight;
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        itemFolderHeight = MIN_ITEM_FOLDER_HEIGHT_IPAD;
        
        modifierHeight = 32;
        optionHeight = 32;
        
    }else{
        itemFolderHeight = MIN_ITEM_FOLDER_HEIGHT_IPHONE;
   
        modifierHeight = 22;
        optionHeight = 22;

    }
    
    
    
    NSLog(@" itemFolderHeight %d", itemFolderHeight);
    
    
    NSArray *itemModifiers = [itemDict objectForKey:@"item_modifiers"];
    
    int modifiersHeight = modifierHeight * [itemModifiers count];

    
    int optionsHeight= 0;
    
    for (int i=0; i<[itemModifiers count]; i++) {
        NSDictionary *tempModifier = [itemModifiers objectAtIndex:i];
        NSArray *optionsAry = [tempModifier objectForKey:@"Options"];
        optionsHeight = optionsHeight + (optionHeight* [optionsAry count]);
        
    }
    
    NSLog(@"optionsHeight %d",optionsHeight);
    
    
    float finalHeight = itemFolderHeight + modifiersHeight + optionsHeight;
    
    
    [itemHeights addObject:[NSString stringWithFormat:@"%f",finalHeight]];
    
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
        originX = 20;
        width = orderDetailsScrollView.frame.size.width - 40;
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
                originX =20;
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
        itemCategorySubViewFrame = CGRectMake(0, 0, rect.size.width, 50);
        itemNameFrame = CGRectMake(30, 0, rect.size.width-60, 25);
        itemCategoryFrame = CGRectMake(30, 25, rect.size.width-60, 25);

        itemServingTypeFrame = CGRectMake(8, itemCategorySubViewFrame.size.height +2 , rect.size.width-200, 30);
       
        itemServingQtyFrame = CGRectMake(itemServingTypeFrame.origin.x+ itemServingTypeFrame.size.width +2, itemServingTypeFrame.origin.y , 80, 30);
        
        itemServingPriceFrame  = CGRectMake(itemServingQtyFrame.origin.x+ itemServingQtyFrame.size.width +2, itemServingTypeFrame.origin.y , 100, 30);

        itemNameFont = [UIFont fontWithName:@"Verdana-Bold" size:22];
        itemCategoryFont = [UIFont fontWithName:@"Verdana-Bold" size:18];
        
        itemServingFont = [UIFont fontWithName:@"Verdana" size:18];
        
        itemModifierFont = [UIFont fontWithName:@"Verdana-Bold" size:18];
        
        itemModifierOptionFont = [UIFont fontWithName:@"Verdana" size:18];
        
    }else{
    
    
    }
    
    
    NSDictionary *tempDict = [formattedOrderDetails objectAtIndex:tag];

    UIView *itemCategorySubView = [[UIView alloc]initWithFrame:itemCategorySubViewFrame];
    itemCategorySubView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:@"A2439D" alpha:1];

    
    UILabel *itemNameLabel = [[UILabel alloc]initWithFrame:itemNameFrame];
    itemNameLabel.text = [tempDict objectForKey:@"item_name"];
    itemNameLabel.textAlignment = NSTextAlignmentCenter;
    itemNameLabel.font = itemNameFont;
    itemNameLabel.textColor = [UIColor whiteColor];
    
//    itemNameLabel.layer.borderColor = [[UIColor grayColor]CGColor];
//    itemNameLabel.layer.borderWidth = 2;
    
    UILabel *itemCategoryLabel = [[UILabel alloc]initWithFrame:itemCategoryFrame];
    itemCategoryLabel.text = [NSString stringWithFormat:@"(%@)",[tempDict objectForKey:@"category_name"]];
    itemCategoryLabel.textAlignment = NSTextAlignmentCenter;
    itemCategoryLabel.font = itemCategoryFont;
    itemCategoryLabel.textColor = [UIColor whiteColor];

//    itemCategoryLabel.layer.borderColor = [[UIColor grayColor]CGColor];
//    itemCategoryLabel.layer.borderWidth = 2;
    
    
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

    

//    servingTypeLabel.layer.borderColor = [[UIColor redColor]CGColor];
//    servingTypeLabel.layer.borderWidth = 2;
//
//    servingQtyLabel.layer.borderColor = [[UIColor redColor]CGColor];
//    servingQtyLabel.layer.borderWidth = 2;
//
//    servingPriceLabel.layer.borderColor = [[UIColor redColor]CGColor];
//    servingPriceLabel.layer.borderWidth = 2;

    
    
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
        categoryX       = 0;
        categoryY       = 0;
        categoryWidth   = 0;
        categoryHeight  = 0;
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
            optionWidth   = itemServingTypeFrame.size.width;
            optionHeight  = 30;
            
            optionPriceX = servingPriceLabel.frame.origin.x;
            optionPriceY = optionY;
            optionPriceWidth = 100;
            optionPriceHeight = 30;
            
        }else{
            optionX       = 0;
            optionY       = 0;
            optionWidth   = 0;
            optionHeight  = 0;
        }
        
        
        
        NSArray *itemModifierOptions = [itemModifiersDict objectForKey:@"Options"];
            for (int j=0; j<[itemModifierOptions count]; j++) {
               
                categoryY = optionY + 32;

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
                
                
                optionPriceY = optionPriceY +32;
                optionY = optionY + 32;
            

//                itemModifierOptionLabel.layer.borderWidth =2;
//                itemModifierOptionLabel.layer.borderColor = [[UIColor redColor]CGColor];
//
//                
//                itemModifierOptionPriceLabel.layer.borderColor = [[UIColor redColor]CGColor];
//                itemModifierOptionPriceLabel.layer.borderWidth = 2;

                [folderVIew addSubview:itemModifierOptionLabel];
                [folderVIew addSubview:itemModifierOptionPriceLabel];

            }
        
        
//        itemModifierLabel.layer.borderWidth =2;
//        itemModifierLabel.layer.borderColor = [[UIColor redColor]CGColor];
        
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


-(IBAction)statusBtnClicked:(id)sender{
   
    UIButton *button = (UIButton *)sender;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [self showPopOveBtn:button];
    }else{
        
    }
}



-(IBAction)viewOrderDetails:(id)sender{
    OrderDetailsSubViewController *ordersDetails = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderDetailsSubViewController"];
    
    ordersDetails.formattedOrderDetails = formattedOrderDetails;
    ordersDetails.itemHeights = itemHeights;
    
    [self presentViewController:ordersDetails animated:YES completion:nil];

}

-(void)showPopOveBtn:(UIButton *)button{
    
    listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    listTableView.delegate = self;
    listTableView.dataSource = self;
    
    UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    popoverView.backgroundColor = [UIColor whiteColor];
    [popoverView addSubview:listTableView];
    
    popoverContent = [[UIViewController alloc] init];
    
    
    popoverContent.view = popoverView;
    popoverContent.title = @"Select";
    
    popOverNavigationController = [[UINavigationController alloc] initWithRootViewController:popoverContent];
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissPopOverController:)];
	popOverNavigationController.navigationItem.rightBarButtonItem = doneButton;
    
    popOverNavigationController.navigationBar.tintColor = [FAUtilities getUIColorObjectFromHexString:@"#236198" alpha:1];
    popOverNavigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [FAUtilities getUIColorObjectFromHexString:@"#236198" alpha:1]};
    
    //    popoverContent.contentSizeForViewInPopover = CGSizeMake(300,500);
    popoverContent.preferredContentSize = CGSizeMake(200,200);
    
    
    popoverController = [[UIPopoverController alloc] initWithContentViewController:popOverNavigationController];
    CGRect popoverRect = [self.view convertRect:[button frame] fromView:[button superview]];
    popoverRect.size.width = MIN(popoverRect.size.width, 100) ;
    popoverController.delegate =self;
    popoverRect.origin.x  = popoverRect.origin.x;
    
    [popoverController presentPopoverFromRect:popoverRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];

}


#pragma mark
#pragma mark TableView Datasource
/* number of sections in form list record table */
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    
//    
//    return 1;
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return [statusArray count];
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//    }
//
//    cell.textLabel.text = [statusArray objectAtIndex:indexPath.row];
//    
//    if(indexPath.row == selectedIndex)
//    {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }
//    else
//    {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
//
//    
//    
//    UIView *bgColorView = [[UIView alloc] init];
//    bgColorView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:@"000000" alpha:0.3];
//    cell.selectedBackgroundView = bgColorView;
//    
//    return cell;
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
//    selectedIndex = indexPath.row;
//
//    currentOrderStatus = [statusArray objectAtIndex:indexPath.row];
//    currentStatusID = [statusIDArray objectAtIndex:indexPath.row];
//    
//    [statusBtn setTitle:currentOrderStatus forState:UIControlStateNormal];
//    
//    [listTableView reloadData];
//    [popoverController dismissPopoverAnimated:YES];
//    
//}
//
//
//
//-(IBAction)submitBtnClicked:(id)sender{
//    NSLog(@"current status %@ , current status ID %@", currentOrderStatus , currentStatusID);
//    
//    [self postRequest:UPDATE_ORDER_STATUS_REQ_TYPE];
//}


-(IBAction)acceptBtnClicked:(id)sender{
    currentStatusID = @"2";
    [self postRequest:UPDATE_ORDER_STATUS_REQ_TYPE];
}

-(IBAction)cancelBtnClicked:(id)sender{
    currentStatusID = @"3";
    [self postRequest:UPDATE_ORDER_STATUS_REQ_TYPE];
}



-(void)postRequest:(NSString *)reqType{
    
    NSString *finalReqUrl;
    NSMutableDictionary *test = [[NSMutableDictionary alloc]init];
    
    if ([reqType isEqualToString:UPDATE_ORDER_STATUS_REQ_TYPE]) {
        finalReqUrl = [NSString stringWithFormat:@"%@%@",BASE_REQ_URL,UPDATE_ORDER_STATUS_REQ_URL];

        [test setObject:currentOrderID forKey:@"OrderID"];
        [test setObject:currentStatusID forKey:@"StatusID"];
    }
    
    
    NSString *formattedBodyStr = [self jsonFormat:reqType withDictionary:test];
    NSString *dataInString = [NSString stringWithFormat: @"\"Data\":%@",formattedBodyStr];
    
    NSString *postDataInString = [NSString stringWithFormat:@"{\"Type\":\"%@\",%@}",reqType,dataInString];
    
    
    //    :{"Type":"Get customer online orders list","Data":{"cust_id":"10"}}
    
    NSData *postJsonData = [postDataInString dataUsingEncoding:NSUTF8StringEncoding];
    webServiceInterface = [[WebServiceInterface alloc]initWithVC:self];
    webServiceInterface.delegate =self;
    [webServiceInterface sendRequest:postDataInString PostJsonData:postJsonData Req_Type:reqType Req_url:finalReqUrl];
}


-(void)getResponse:(NSDictionary *)resp type:(NSString *)respType{
    if ([respType isEqualToString:UPDATE_ORDER_STATUS_REQ_TYPE]) {
        NSDictionary *statusDict = [resp objectForKey:@"Status"];
        
        NSString *status = [NSString stringWithFormat:@"%@",[statusDict objectForKey:@"status"]];
        NSString *statusDesc = [statusDict objectForKey:@"desc"];
        
        if ([status isEqualToString:@"1"]) {
//            NSArray *respAry = [resp objectForKey:@"Data"];
            [FAUtilities showAlert:@"Order status changed"];
            
            acceptBtn.hidden = YES;
            cancelBtn.hidden = YES;

            
        }else{
            [FAUtilities showAlert:statusDesc];
        }
    }
}


-(NSString*)jsonFormat:(NSString *)type withDictionary:(NSMutableDictionary *)formatDict{
    
    NSString *bodyStr;
    
    if ([type isEqualToString:UPDATE_ORDER_STATUS_REQ_TYPE]) {
        bodyStr =[NSString stringWithFormat: @"{\"order_id\":\"%@\",\"status_id\":\"%@\"}",[formatDict objectForKey:@"OrderID"],[formatDict objectForKey:@"StatusID"]];
    }
    
    return bodyStr;
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
