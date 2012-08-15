//
//  PLMasterViewController.h
//  ProductList
//
//  Created by Bhaskar N on 13/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PLBOOK		@"PLBook"
#define PLMUSIC		@"PLMusic"
#define PLCAMERA	@"PLCamera"

@interface PLMasterViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
{
	NSCache 	*imageCache;
}

@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSMutableArray *books_array;
@property (nonatomic, retain) NSMutableArray *cameras_array;
@property (nonatomic, retain) NSMutableArray *songs_array;

@end