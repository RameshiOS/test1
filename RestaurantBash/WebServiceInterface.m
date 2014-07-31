
//
//  WebServiceInterface.m
//  DDMForms
//
//  Created by Manulogix on 19/07/13.
//  Copyright (c) 2013 Manulogix. All rights reserved.
//

#import "WebServiceInterface.h"
#import "SBJson.h"

@interface WebServiceInterface ()

@property(nonatomic, strong) UIViewController    *wsiParentVC;
@property(nonatomic, strong) MBProgressHUD       *wsiActivityIndicator;
@end

@implementation WebServiceInterface
@synthesize receivedData= _recievedData;
@synthesize delegate;
@synthesize wsiParentVC;
@synthesize wsiActivityIndicator;

#pragma mark -
#pragma mark init Methods
-(id) initWithVC: (UIViewController *)parentVC {
    self = [super init];
    if(self) {
        self.wsiParentVC = parentVC; // DO NOT allocate as we should point only
        //        self.delegate    = (id)parentVC; // DO NOT allocate as we should point only
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }return self;
}

#pragma mark -
#pragma mark Progress Bar Hud

#pragma mark - Indicator APIs

-(void) releaseActivityIndicator {
    if (wsiActivityIndicator) {
        [wsiActivityIndicator removeFromSuperview];
        //        RELEASE_MEM(wsiActivityIndicator);
    }
}
- (void) myTask {
	sleep(REQUEST_TIMEOUT_INTERVAL);
}
- (void) hideIndicator {
    [wsiActivityIndicator setHidden:YES];
}
- (void) showIndicator {
    [self releaseActivityIndicator];
    wsiActivityIndicator             = [[MBProgressHUD alloc] initWithView:wsiParentVC.view];
    wsiActivityIndicator.minShowTime = 30.0f;
    wsiActivityIndicator.delegate    = self;
    wsiActivityIndicator.labelText   = @"Loading...";
    [wsiParentVC.view addSubview:wsiActivityIndicator];
    [wsiActivityIndicator showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

#pragma MBProgressHUD delegate methods
- (void) hudWasHidden:(MBProgressHUD *)hud {
	// Remove wsiActivityIndicator from screen when the wsiActivityIndicator was hidded
    [self releaseActivityIndicator];
}

#pragma mark -
#pragma mark Request Methods

-(void) sendRequest:(NSString *)postString PostJsonData:(NSData *)postData Req_Type:(NSString *)reqType Req_url:(NSString *)reqUrl{
    
    [self showIndicator];
    postReqString = postString;
    postReqData = postData;
    postReqType=reqType;
    postReqUrl = reqUrl;
    [self postRequest];
}

-(void)postRequest{
    NSString *postLength = [NSString stringWithFormat:@"%d", [postReqData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *poststring = [[NSString alloc]initWithData:postReqData encoding:NSUTF8StringEncoding];
    NSLog(@"postString:%@",poststring);
    NSLog(@"url : %@",postReqUrl);
    
    NSString *posturl = [NSString stringWithFormat:@"%@",postReqUrl];
    
    [request setURL:[NSURL URLWithString:posturl]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postReqData];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    [connection start];
}

///* this method might be calling more than one times according to incoming data size */
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    receivedData = data;
    
    NSString* dataString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"DataString:%@",dataString);
}

///* this method called to store cached response for this connection  */
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

///* if there is an error occured, this method will be called by connection */
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self hideIndicator];
    if (statusCode!=200) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                    message:[error localizedDescription]
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", @"")
                          otherButtonTitles:nil] show];
    }
}

///* if data is successfully received, this method will be called by connection */
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [NSThread sleepForTimeInterval:5.0];
    receivedData = [[NSMutableData alloc] init];
    NSHTTPURLResponse *httpResponse;
    httpResponse = (NSHTTPURLResponse *)response;
    statusCode = [httpResponse statusCode];
    NSLog(@"StatusCode:%d",statusCode);
    if (statusCode == 200) {
        
    }else{
        [FAUtilities showToastMessageAlert:STATUS_CODE_FAILED_ERROR];//needed
        [self hideIndicator];
    }
    
}
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
//    if([challenge.protectionSpace.host isEqualToString:@"192.168.137.11"]/*check if this is host you trust: */)
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
}
///* if data is finished loading, this method will be called by connection */
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    responseString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString:%@",responseString);
    
    NSString *myString = responseString;
    NSRange rangeValue = [myString rangeOfString:@"</html>" options:NSCaseInsensitiveSearch];
    
    if (rangeValue.length > 0){
        NSLog(@"string contain html tag!");
        [FAUtilities showToastMessageAlert:STATUS_CODE_FAILED_ERROR];//needed
        [self hideIndicator];

    }else {
        NSLog(@"string does not contain html tag!");
        if (IS_EMPTY(responseString)) {
        }else{
            [self doParse:receivedData];
        }
    }
    
}

#pragma mark -
#pragma mark Response Methods
-(void)doParse:(NSData *)data{
    NSDictionary *responseDict = [self parseJsonResponse:data];
    [self sendResponse:responseDict];
}

-(NSDictionary *) parseJsonResponse:(NSData *)response{
    
    NSString *respStr;
    respStr = responseString;
    NSData *respData = [respStr dataUsingEncoding:NSUTF8StringEncoding];
    respData = response;
    NSDictionary *rspDic = [self getJSONObjectFromData:respData];
    //    NSArray *rspAry = [self getJSONObjectFromData:respData];
    return rspDic;
}

-(id) getJSONObjectFromData:(NSData *)data {
    if ((!data) || ([data length] <=0)) return nil;
    
    if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
        //#if (__has_feature(objc_arc))
        NSString *dataInString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //#else
        //#endif
        return [dataInString JSONValue];
    } else {
        return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    }
    return nil;
}

-(void) sendResponse:(NSDictionary *)respDict{
    [self hideIndicator];
    [delegate getResponse:respDict type:postReqType];
}


- (void)viewDidLoad{
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
