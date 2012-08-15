//
//  PLDetailViewController.h
//  ProductList
//
//  Created by Bhaskar N on 13/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
	eBookType,
	eCameraType,
	eMusicType
}KOProductType;

@interface PLDetailViewController : UIViewController
{
	
}

@property (nonatomic, assign) KOProductType productType;
@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *authorLabel;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;
@property (retain, nonatomic) IBOutlet UILabel *descLabel;
@property (retain, nonatomic) IBOutlet UILabel *displayDescLable;
@property (retain, nonatomic) IBOutlet UIImageView *displayImage;
@property (retain, nonatomic) IBOutlet UITextView *textView;
@property (retain, nonatomic) IBOutlet UILabel *displayAuthorLable;
@property (retain, nonatomic) IBOutlet UILabel *displayPriceLable;
@property (retain, nonatomic) IBOutlet UILabel *genreLable;
@property (retain, nonatomic) IBOutlet UILabel *displayGenreLable;




@property (retain, nonatomic) IBOutlet UILabel *displayTitleLable;
- (void) configureViewForBook;
- (void) configureViewForCamera;
- (void) configureViewForMusic;

@end