//
//  UIViewController+ProgressSheet.m
//  ProductList
//
//  Created by Bhaskar N on 25/04/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIViewController+ProgressSheet.h"

const NSInteger kNonBlockCenterViewTag = 10003;

@implementation UIViewController (ProgressSheet)

- (void)startCenterAndNonBlockBusyViewWithTitle:(NSString *)inTitle needUserInteraction:(BOOL)isEnabled {
	
	id bgView = [self.view viewWithTag:kNonBlockCenterViewTag]; 
	if (bgView)	return;
	
	UIView *NonBlockCenterView = [self.view viewWithTag:kNonBlockCenterViewTag];
	if (NonBlockCenterView == nil) //if an activity indicator is already not in the view then create one and place it
	{
		CGSize blockerSize = CGSizeMake(150, 65);
        
        NSLog (@"self.view.frame: %f %f", self.view.frame.size.width, self.view.frame.size.height);
		
        float screenWidth = self.view.frame.size.width;
        float screenHeight = self.view.frame.size.height;
        
		NonBlockCenterView = [[UIView alloc] initWithFrame:CGRectMake( (screenWidth-blockerSize.width)/2, (screenHeight-blockerSize.height)/2, blockerSize.width, blockerSize.height)];
		
		NonBlockCenterView.backgroundColor = [UIColor colorWithRed:12.0/255 green:12.0/255 blue:12.0/255 alpha:0.8];
		NonBlockCenterView.layer.cornerRadius = 10.0;
		NonBlockCenterView.tag = kNonBlockCenterViewTag;		  
		
		float activityIndicatorWidth = 20.0;
		
		UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		activityIndicator.frame = CGRectMake(blockerSize.width/2-activityIndicatorWidth/2, 6, activityIndicatorWidth, activityIndicatorWidth);
		[activityIndicator startAnimating];
		[NonBlockCenterView addSubview:activityIndicator];
		[activityIndicator release];
        
		UILabel *label = [[UILabel alloc] init];
		label.font = [UIFont boldSystemFontOfSize:13.0];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor whiteColor];
		label.textAlignment = UITextAlignmentCenter;
		label.lineBreakMode = UILineBreakModeTailTruncation;
		label.numberOfLines = 2;
		label.text = inTitle;
		[label sizeToFit];
		
		CGSize titleSize = [self getTextSize:inTitle withFont:[UIFont boldSystemFontOfSize:13.0] andConstrainedToSize:CGSizeMake(blockerSize.width-20, blockerSize.height)];
		label.frame = CGRectMake(blockerSize.width/2 - titleSize.width/2, (blockerSize.height/2 - titleSize.height/2) + 8, titleSize.width, titleSize.height + 5);
		
		[NonBlockCenterView addSubview:label];
		[label release];
		
		[self.view setUserInteractionEnabled:isEnabled];
        
		[self.view addSubview:NonBlockCenterView];
		[NonBlockCenterView release];
	}
}

- (void)stopCenterAndNonBlockBusyViewWithTitle {
	
	id bgView = [self.view viewWithTag:kNonBlockCenterViewTag]; 
	if(bgView) {
		[self.view setUserInteractionEnabled:YES];
		[bgView removeFromSuperview];
	}
}

- (CGSize)getTextSize:(NSString *)aText withFont:(UIFont *)aFont andConstrainedToSize:(CGSize)aSize
{
	return [aText sizeWithFont:aFont constrainedToSize:aSize lineBreakMode:UILineBreakModeWordWrap];
}

@end