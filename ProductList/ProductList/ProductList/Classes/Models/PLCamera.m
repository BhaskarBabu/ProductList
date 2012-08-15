//
//  PLCamera.m
//  ProductList
//
//  Created by Bhaskar N on 15/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PLCamera.h"
#import "UIImageToDataTransformer.h"

@implementation PLCamera

@dynamic make;
@dynamic model;
@dynamic imageURL;
@dynamic price;
@dynamic image;

+ (void)initialize
{
	if (self == [PLCamera class])
	{
		UIImageToDataTransformer *transformer = [[UIImageToDataTransformer alloc] init];
		[NSValueTransformer setValueTransformer:transformer forName:@"UIImageToDataTransformer"];
        [transformer release];
	}
}

@end