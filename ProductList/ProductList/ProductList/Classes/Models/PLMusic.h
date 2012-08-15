//
//  PLMusic.h
//  ProductList
//
//  Created by Bhaskar N on 15/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PLMusic : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * album;
@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSString * genre;

@end
