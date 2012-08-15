//
//  PLBookTableViewCell.m
//  ProductList
//
//  Created by Bhaskar N on 13/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PLBookTableViewCell.h"

@implementation PLBookTableViewCell

@synthesize book_Title;
@synthesize book_Author;
@synthesize book_Price;
@synthesize book_Description;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	
    if (self)
	{
//        // Initialization code
//		self.book_Title = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 295, 20)] autorelease];
//		self.book_Title.backgroundColor = [UIColor clearColor];
//		self.book_Title.numberOfLines = 2;
//		[self.contentView addSubview:book_Title];
//		
//		self.book_Author = [[[UILabel alloc] initWithFrame:CGRectMake(10, 30, 200, 20)] autorelease];
//		self.book_Author.backgroundColor = [UIColor clearColor];
//				[self.contentView addSubview:book_Author];
//		
//		self.book_Price = [[[UILabel alloc] initWithFrame:CGRectMake(240, 30, 100, 20)] autorelease];
//		self.book_Price.backgroundColor = [UIColor clearColor];
//				[self.contentView addSubview:book_Price];
//		
//		self.book_Description = [[[UILabel alloc]initWithFrame:CGRectMake(10, 55, 295, 15)] autorelease];
//		self.book_Description.backgroundColor = [UIColor clearColor];
//		[self.contentView addSubview:book_Description];
    }
	
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
	[book_Title release];
	[book_Author release];
	[book_Price release];
	[book_Description release];
	[super dealloc];
}

@end