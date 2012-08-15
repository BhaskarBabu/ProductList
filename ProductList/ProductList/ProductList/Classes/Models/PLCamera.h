//
//  PLCamera.h
//  ProductList
//
//  Created by Bhaskar N on 15/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface PLCamera : NSManagedObject

@property (nonatomic, retain) NSString * make;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) UIImage *image;

@end