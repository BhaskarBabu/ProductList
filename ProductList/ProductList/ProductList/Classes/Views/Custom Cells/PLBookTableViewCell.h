//
//  PLBookTableViewCell.h
//  ProductList
//
//  Created by Bhaskar N on 13/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLBookTableViewCell : UITableViewCell
{
	
}

@property (retain, nonatomic) IBOutlet UILabel *book_Title;
@property (retain, nonatomic) IBOutlet UILabel *book_Author;
@property (retain, nonatomic) IBOutlet UILabel *book_Price;
@property (retain, nonatomic) IBOutlet UILabel *book_Description;

@end