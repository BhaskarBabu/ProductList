//
//  PLCameraTableViewCell.m
//  ProductList
//
//  Created by Bhaskar N on 13/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PLCameraTableViewCell.h"

@implementation PLCameraTableViewCell

@synthesize camera_Image;
@synthesize camera_Modal;
@synthesize camera_Make;
@synthesize camera_Price;

NSString *const kPrepareForReuseNotification = @"CameraTableViewCell_PrepareForReuse";

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
	{
		
    }
	
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	
	self.imageView.frame = CGRectMake(5.0, 2.0, 80.0, 80.0);
}

- (void)prepareForReuse
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kPrepareForReuseNotification object:self];
	
	[super prepareForReuse];
}

- (void)dealloc {
	[camera_Image release];
	[camera_Modal release];
	[camera_Make release];
	[camera_Price release];
	[super dealloc];
}

@end