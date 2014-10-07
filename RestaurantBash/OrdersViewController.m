//
//  OrdersViewController.m
//  RestaurantBash
//
//  Created by Manulogix on 26/09/14.
//  Copyright (c) 2014 Manulogix Pvt Ltd. All rights reserved.
//

#import "OrdersViewController.h"
#import "OrderDetailsViewController.h"

@interface OrdersViewController ()

@end

@implementation OrdersViewController

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
        
        headerLabelFont = [UIFont fontWithName:@"Thonburi-Bold" size:26];
        cellLaebelFont = [UIFont fontWithName:@"Verdana" size:22];

    }else{
        if ([UIScreen mainScreen].bounds.size.height == 568) {  // iphone 4 inch
            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphoneBg_320x568.png"]];
        }else{// iphone 3.5 inch
            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iphoneBg_320x480.png"]];
        }
        
        headerLabelFont = [UIFont fontWithName:@"Thonburi-Bold" size:16];
        cellLaebelFont = [UIFont fontWithName:@"Verdana" size:12];

    }
    
    
    
    tableColumns = [[NSMutableArray alloc]init];
    tableColumnKeys = [[NSMutableArray alloc]init];
    tableColumnWidths = [[NSMutableArray alloc]init];
    
    [tableColumns addObject:@"Order#"];
    [tableColumns addObject:@"Customer"];
    [tableColumns addObject:@"Phone"];
    [tableColumns addObject:@"Type"];
    [tableColumns addObject:@"Total($)"];
    [tableColumns addObject:@"Date"];

    [tableColumnKeys addObject:@"order_id"];
    [tableColumnKeys addObject:@"cust_name"];
    [tableColumnKeys addObject:@"phone"];
    [tableColumnKeys addObject:@"type"];
    [tableColumnKeys addObject:@"total"];
    [tableColumnKeys addObject:@"created_on"];

    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
    
        [tableColumnWidths addObject:@"126"];
        [tableColumnWidths addObject:@"254"];
        [tableColumnWidths addObject:@"254"];
        [tableColumnWidths addObject:@"126"];
        [tableColumnWidths addObject:@"126"];
        [tableColumnWidths addObject:@"254"];
        
        
    }else{
        [tableColumnWidths addObject:@"65"];
        [tableColumnWidths addObject:@"180"];
        [tableColumnWidths addObject:@"100"];
        [tableColumnWidths addObject:@"80"];
        [tableColumnWidths addObject:@"80"];
        [tableColumnWidths addObject:@"140"];

    }
    
    

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:24.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
        
        
        CGRect frame= segCntrl.frame;
        [segCntrl setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 150)];
        
        
        
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:segCntrl
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1
                                                                       constant:40];
        [segCntrl addConstraint:constraint];
        
        
        
    }else{
        [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:12.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    }

    statusID = 1;


    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated{
   
    
    [self postRequest:GET_ORDERS_LIST_REQ_TYPE];
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
//
//    }else{
    
        int width = 0;
        
        for (int i=0; i<[tableColumnWidths count]; i++) {
            NSString *tempcolumn = [tableColumnWidths objectAtIndex:i];
            width = width + [tempcolumn intValue]+2;
            
        }
        tableViewWidth = width;
        
        tableViewHeight = myordersScrollView.bounds.size.height;
    
    
    
    
    
    
    
//        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
//            tableViewHeight = 450;
//        }

    
    
    
        ordersListView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, tableViewWidth, tableViewHeight)];
        ordersListView.delegate = self;
        ordersListView.dataSource = self;

    
    
//        myordersScrollView.backgroundColor = [UIColor lightGrayColor];
//        myordersScrollView.layer.borderColor = [[UIColor greenColor]CGColor];
//        myordersScrollView.layer.borderWidth = 8;
    
    
    
    
        [myordersScrollView addSubview:ordersListView];
    
        myordersScrollView.contentSize = CGSizeMake(tableViewWidth, tableViewHeight);
        [self performSelector:@selector(methodName) withObject:nil afterDelay:0.5];
    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
//            myordersScrollView.contentSize = myordersScrollView.bounds.size;
//        }
//    }
    
    
//    }
    
//    4613599588
    
    
//    myordersScrollView.bounces = NO;

}

-(void)postRequest:(NSString *)reqType{
    
    NSString *finalReqUrl;
    NSMutableDictionary *test = [[NSMutableDictionary alloc]init];
    
    if ([reqType isEqualToString:GET_ORDERS_LIST_REQ_TYPE]) {
        finalReqUrl = [NSString stringWithFormat:@"%@%@",BASE_REQ_URL,GET_ORDERS_LIST_REQ_URL];
        
        NSMutableArray *loginArray = [[NSMutableArray alloc]init];
        
        dbManager = [DataBaseManager dataBaseManager];
        [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM LoginDetails "] resultsArray:loginArray];
        
        NSDictionary *curentLoginDict = [loginArray objectAtIndex:0];
        NSString *custID = [curentLoginDict objectForKey:@"UserID"];
        
        
        [test setObject:custID forKey:@"CustomerID"];
    }else if ([reqType isEqualToString:GET_ORDER_DETAILS_REQ_TYPE]){
        finalReqUrl = [NSString stringWithFormat:@"%@%@",BASE_REQ_URL,GET_ORDER_DETAILS_REQ_URL];
        [test setObject:[NSString stringWithFormat:@"%d",currentOrderID] forKey:@"OrderID"];
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


-(NSString*)jsonFormat:(NSString *)type withDictionary:(NSMutableDictionary *)formatDict{
    
    NSString *bodyStr;
    
    if ([type isEqualToString:GET_ORDERS_LIST_REQ_TYPE]) {
        bodyStr =[NSString stringWithFormat: @"{\"bz_user_id\":\"%@\",\"status_id\":\"%@\"}",[formatDict objectForKey:@"CustomerID"],[NSString stringWithFormat:@"%d",statusID]];
    }else if ([type isEqualToString:GET_ORDER_DETAILS_REQ_TYPE]){
        bodyStr =[NSString stringWithFormat: @"{\"order_id\":\"%@\"}",[formatDict objectForKey:@"OrderID"]];
    }
    
    return bodyStr;
}


-(void)getResponse:(NSDictionary *)resp type:(NSString *)respType{
    if ([respType isEqualToString:GET_ORDERS_LIST_REQ_TYPE]) {
        NSDictionary *statusDict = [resp objectForKey:@"Status"];
        
        NSString *status = [NSString stringWithFormat:@"%@",[statusDict objectForKey:@"status"]];
        NSString *statusDesc = [statusDict objectForKey:@"desc"];
        
        if ([status isEqualToString:@"1"]) {
            NSArray *respAry = [resp objectForKey:@"Data"];
            resultsArray = respAry;

            [ordersListView reloadData];
            
//            [self insertOrders:respAry];
        }else{
            resultsArray = [[NSMutableArray alloc]init];
            
            [ordersListView reloadData];
            
            [FAUtilities showAlert:statusDesc];
        }
    }else if ([respType isEqualToString:GET_ORDER_DETAILS_REQ_TYPE]) {
        NSDictionary *statusDict = [resp objectForKey:@"Status"];
        
        NSString *status = [NSString stringWithFormat:@"%@",[statusDict objectForKey:@"status"]];
        NSString *statusDesc = [statusDict objectForKey:@"desc"];
        
        if ([status isEqualToString:@"1"]) {
            NSDictionary *respDict = [resp objectForKey:@"Data"];
           
            
            OrderDetailsViewController *orderDetails = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderDetailsViewController"];
            orderDetails.orderDetailsDict = respDict;
            orderDetails.currentOrderStatus = currentOrderStatus;
            orderDetails.currentOrderID = [NSString stringWithFormat:@"%d",currentOrderID];
            [self presentViewController:orderDetails animated:YES completion:nil];

        }else{
            [FAUtilities showAlert:statusDesc];
        }
        
        
        
    }
}



-(void)methodName{
    myordersScrollView.contentSize = CGSizeMake(tableViewWidth, tableViewHeight);
}

#pragma mark
#pragma mark TableView Datasource
/* number of sections in form list record table */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    float cellWidth = ordersListView.bounds.size.width;
    
    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
//        tableColumnWidths = [[NSMutableArray alloc]init];
//        
//        int column1width = cellWidth*3/24-2;
//        int column2width = cellWidth*1/4-2;
//        int column3width = cellWidth*1/4-2;
//        int column4width = cellWidth*3/24-2;
//        int column5width = cellWidth*3/24-2;
//        int column6width = cellWidth*3/24-2;
//        
//        [tableColumnWidths addObject:[NSString stringWithFormat:@"%d",column1width]];
//        [tableColumnWidths addObject:[NSString stringWithFormat:@"%d",column2width]];
//        [tableColumnWidths addObject:[NSString stringWithFormat:@"%d",column3width]];
//        [tableColumnWidths addObject:[NSString stringWithFormat:@"%d",column4width]];
//        [tableColumnWidths addObject:[NSString stringWithFormat:@"%d",column5width]];
//        [tableColumnWidths addObject:[NSString stringWithFormat:@"%d",column6width]];
//        
//    }
    
    return [resultsArray count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        return 65;
    }else{
        return 45;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        return 65;
    }else{
        return 45;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    float cellWidth;
    
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        cellWidth = ordersListView.frame.size.width;
        
        
        
    }else{
        cellWidth = tableViewWidth;
        
    }
    
    //        float calColumnWidth = cellWidth/[tableColumns count];
    //        float columnWidth = calColumnWidth;
    
    CGFloat originX = 0.0f;
    CGFloat originY = 0.0f;
    CGFloat width = 0.0f;
    CGFloat height = 0.0f;
    UIView *headerView = [[UIView alloc] init];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            headerView.frame = CGRectMake(0, 0, ordersListView.frame.size.width, 65);
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            headerView.frame = CGRectMake(0, 0, ordersListView.frame.size.width, 65);
        }
        
        height = 65.0f;
    }else{
        headerView.frame = CGRectMake(0, 0, ordersListView.frame.size.width, 45);
        
        height = 45.0f;
    }
    
    for (int i=0; i<[tableColumns count]; i++) {
        
        NSString *widthVal = [tableColumnWidths objectAtIndex:i];
        
        width = [widthVal floatValue];
        
        headerLabelView = [[UILabel alloc]initWithFrame:CGRectMake(originX, originY, width, height)];
        headerLabelView.text = [tableColumns objectAtIndex:i];
        headerLabelView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:@"EF952A" alpha:1];
        headerLabelView.textColor = [UIColor whiteColor];
        headerLabelView.font=headerLabelFont;
        headerLabelView.numberOfLines=0;
        headerLabelView.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:headerLabelView];
        originX += width+2;
        headerLabelView.tag = 100+i;
    }
    return headerView;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSDictionary *currentDictionary = [[NSDictionary alloc]init];
    currentDictionary = [resultsArray objectAtIndex:indexPath.row];
    
    int columns = (int)[tableColumns count];
    
    [self tableViewCell:cell withColumns:columns withDictonary:currentDictionary];//creating number of cells with columns in table view cell
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:@"000000" alpha:0.3];
    cell.selectedBackgroundView = bgColorView;
    
    return cell;
}

-(void)tableViewCell:(UITableViewCell *) cell withColumns:(int)columns withDictonary:(NSDictionary *)dict{
    float cellWidth;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        cellWidth = ordersListView.frame.size.width;
    }else{
        cellWidth = tableViewWidth;
    }
    
    float cellHeight;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        cellHeight = 65;
    }else{
        cellHeight = 45;
    }
    
    
    //    float cellHeight = cell.frame.size.height;
    
    
    //    float calColumnWidth = cellWidth/columns;
    //    float columnWidth;
    
    NSMutableArray *values = [[NSMutableArray alloc]init];
    
    //    columnWidth = calColumnWidth;
    
    CGFloat originX = 0.0f;
    CGFloat originY = 0.0f;
    CGFloat width = 0.0f;
    CGFloat height = cellHeight;
    
    NSMutableArray *labelsArray = [[NSMutableArray alloc]init];
    
    for (int i=0 ; i<[tableColumnKeys count]; i++) {
        NSString *heading = [tableColumnKeys objectAtIndex:i];
        NSString *val = [dict objectForKey:heading];
        [values addObject:val];
    }
    
    for (int i=0; i<columns; i++) {
        //        width = columnWidth;
        
        
        width = [[tableColumnWidths objectAtIndex:i] floatValue];
        labelView = [self createLabelViewForTag:i withFrame:CGRectMake(originX, originY, width, height)];
        
        if([[tableColumns objectAtIndex:i] isEqualToString:@"Total($)"]){
            labelView.textAlignment = NSTextAlignmentRight;
        }
        
        
        for (UIView *subView in cell.contentView.subviews) {
            if (subView.tag == i) {
                [subView removeFromSuperview];
            }
        }
        
        [cell.contentView addSubview:labelView];
        
        originX += width+2;
        labelView.tag = i;
        [labelsArray addObject:labelView];
    }
    [self constructLabels:labelsArray WithValues:values WithHeadingTypes:tableColumns];
}





/* Method for constructing heading labels */
-(void)constructLabels:(NSArray *)LabelsArray WithValues:(NSArray *)ValuesArray WithHeadingTypes:(NSArray*)tableClmns{
    
    for (int i=0; i<[LabelsArray count]; i++) {
        //        NSString *currentColumn = [tableClmns objectAtIndex:i];
        
        UILabel *testLabel = [LabelsArray objectAtIndex:i];
        
        NSString *tempStr = [NSString stringWithFormat:@"%@",[ValuesArray objectAtIndex:i]];
        int contentLen = [tempStr length] * 13;
        NSMutableString *content = [[NSMutableString alloc]init];
        int labelWidth = testLabel.frame.size.width;
        int textLen = labelWidth/13;
        
        if (contentLen > labelWidth*2) {
            NSString *tempStr = [NSString stringWithFormat:@"%@",[ValuesArray objectAtIndex:i]];
            NSString *str = [tempStr substringToIndex:textLen];
            [content appendString:str];
            [content appendString:@"....."];
            testLabel.text = content;
        }else{
            //            if ([currentColumn isEqualToString:@"Total"]) {
            //                testLabel.text = [NSString stringWithFormat:@"$%@    ",[ValuesArray objectAtIndex:i]];
            //            }else{
            testLabel.text = [ValuesArray objectAtIndex:i];
            //            }
        }
    }
}


- (UILabel*)createLabelViewForTag:(int)tag withFrame:(CGRect)rect{
    
    UILabel *lblView = [[UILabel alloc]initWithFrame:rect];
    //    lblView.backgroundColor = [UIColor  colorWithRed:216.0/255.0 green:235.0/255.0 blue:248.0/255.0 alpha:1];
    
    lblView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:@"F9F4EB" alpha:1];
    lblView.text = @"";
    lblView.textAlignment = NSTextAlignmentCenter;
    lblView.textColor = [UIColor blackColor];
    lblView.font=cellLaebelFont;
    lblView.numberOfLines=0;
    lblView.lineBreakMode= NSLineBreakByWordWrapping;
    return lblView;
}



-(IBAction)backBrnclicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)segmentValueChanged:(id)sender{
    if (segCntrl.selectedSegmentIndex == 0) {
        statusID = 0;
    }else if (segCntrl.selectedSegmentIndex == 1) {
        statusID = 1;
    }else if (segCntrl.selectedSegmentIndex == 2) {
        statusID = 2;
    }else if (segCntrl.selectedSegmentIndex == 3) {
        statusID = 3;
    }
    
    NSLog(@"my bscroll view %f %f", myordersScrollView.bounds.size.height,myordersScrollView.bounds.size.width);
    
    [self postRequest:GET_ORDERS_LIST_REQ_TYPE];

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
    
    [ordersListView reloadData];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {

    
    NSDictionary *currentDict = [resultsArray objectAtIndex:indexPath.row];
    currentOrderID = [[currentDict objectForKey:@"order_id"] intValue];
    currentOrderStatus = [currentDict objectForKey:@"order_status"];
    
    [self postRequest:GET_ORDER_DETAILS_REQ_TYPE];

    
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
