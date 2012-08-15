//
//  PLCameraTableViewCell.h
//  ProductList
//
//  Created by Bhaskar N on 13/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kPrepareForReuseNotification;

@interface PLCameraTableViewCell : UITableViewCell
{
	
}

@property (retain, nonatomic) IBOutlet UIImageView *camera_Image;
@property (retain, nonatomic) IBOutlet UILabel *camera_Modal;
@property (retain, nonatomic) IBOutlet UILabel *camera_Make;
@property (retain, nonatomic) IBOutlet UILabel *camera_Price;

@end