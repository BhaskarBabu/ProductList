//
//  PLBook.h
//  ProductList
//
//  Created by Bhaskar N on 15/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PLBook : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * authors;
@property (nonatomic, retain) NSString * bookId;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * desc;

@end
