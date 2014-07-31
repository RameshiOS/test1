//
//  OverlayView.m
//  OverlayViewTester
//
//  Created by Jason Job on 09-12-10.
//  Copyright 2009 Jason Job. All rights reserved.
//

#import "OverlayView.h"


@implementation OverlayView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		// Clear the background of the overlay:
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
		
		// Load the image to show in the overlay:
//		UIImage *overlayGraphic = [UIImage imageNamed:@"overlay.png"];
//		UIImageView *overlayGraphicView = [[UIImageView alloc] initWithImage:overlayGraphic];
//		overlayGraphicView.frame = CGRectMake(12, 40, 520, 500);

        UIImage *overlayGraphic;
        UIImageView *overlayGraphicView = [[UIImageView alloc] init];
        
        
        
        /* for testing qr code */
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
//            overlayGraphic = [UIImage imageNamed:@"overlay.png"];
//            overlayGraphicView.frame = CGRectMake(12, 40, 520, 500);

            overlayGraphic = [UIImage imageNamed:@"overlay_square.png"];
            overlayGraphicView.frame = CGRectMake(0, 0, 540, 550);

        }else{
            if ([UIScreen mainScreen].bounds.size.height == 568) {
//                overlayGraphic = [UIImage imageNamed:@"overlay320x568.png"];

                overlayGraphic = [UIImage imageNamed:@"overlay_square.png"];

                overlayGraphicView.frame = CGRectMake(0,0, 320, 568-67);
                
                
            }else{
//                overlayGraphic = [UIImage imageNamed:@"overlay320x480.png"];
                
                overlayGraphic = [UIImage imageNamed:@"overlay_square.png"];

                overlayGraphicView.frame = CGRectMake(0,0, 320, 480-67);
                
            }
        }
        
        /* for testing qr code */
        
        overlayGraphicView.frame = CGRectMake(overlayGraphicView.frame.size.width *0.125, overlayGraphicView.frame.size.height*0.25, overlayGraphicView.frame.size.width*0.75, overlayGraphicView.frame.size.height*0.5); // for 2dbarcode with width
 
        

//        overlayGraphicView.frame = CGRectMake(0, 450, 760, 100);
        
//        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
////            overlayGraphicView.frame = CGRectMake(0, 206.25, 540, 550/4); // for bar code
//
////            overlayGraphicView.frame = CGRectMake(0, 137.5, 540, 275); // for 2dbarcode
//
//            overlayGraphicView.frame = CGRectMake(67.5, 137.5, 405, 275); // for 2dbarcode with width
//
//        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
//            //            overlayGraphicView.frame = CGRectMake(0, 0, 540, 550/2);
////            overlayGraphicView.frame = CGRectMake(0, 206.25, 540, 550/4);
//            
////            overlayGraphicView.frame = CGRectMake(0, 137.5, 540, 275); // for 2dbarcode
//           
//            overlayGraphicView.frame = CGRectMake(67.5, 137.5, 405, 275); // for 2dbarcode with width
//
//            
//        }

//        overlayGraphicView.layer.borderColor = [UIColor greenColor].CGColor;
//        overlayGraphicView.layer.borderWidth = 3.0f;

        
		[self addSubview:overlayGraphicView];
		overlayGraphicView.image=overlayGraphic;
        [overlayGraphicView release];
		
//		ScanButton *scanButton = [[ScanButton alloc] initWithFrame:CGRectMake(130, 320, 60, 30)];
		
		// Add a target action for the button:
//		[scanButton addTarget:self action:@selector(scanButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
//		[self addSubview:scanButton];
    }
    return self;
}

- (void) scanButtonTouchUpInside {
	UILabel *scanningLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 120, 30)];
	scanningLabel.backgroundColor = [UIColor clearColor];
	scanningLabel.font = [UIFont fontWithName:@"Courier" size: 18.0];
	scanningLabel.textColor = [UIColor redColor]; 
	scanningLabel.text = @"Scanning...";
	
	[self addSubview:scanningLabel];
	
	[self performSelector:@selector(clearLabel:) withObject:scanningLabel afterDelay:2];
	
	[scanningLabel release];
}

- (void)clearLabel:(UILabel *)label {
	label.text = @"";
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}


@end
