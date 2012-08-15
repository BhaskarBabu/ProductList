//
//  PLDetailViewController.m
//  ProductList
//
//  Created by Bhaskar N on 13/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PLDetailViewController.h"
#import "PLBook.h"
#import "PLCamera.h"
#import "PLMusic.h"

@interface PLDetailViewController ()
- (void)configureView;
@end

@implementation PLDetailViewController

@synthesize detailItem = _detailItem;
@synthesize productType = _productType;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize titleLabel = _titleLabel;
@synthesize authorLabel = _authorLabel;
@synthesize priceLabel = _priceLabel;
@synthesize descLabel = _descLabel;
@synthesize displayDescLable = _displayDescLable;
@synthesize displayImage = _displayImage;
@synthesize textView = _textView;
@synthesize displayAuthorLable = _displayAuthorLable;
@synthesize displayPriceLable = _displayPriceLable;
@synthesize displayTitleLable = _displayTitleLable;
@synthesize genreLable,displayGenreLable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        [_detailItem release]; 
        _detailItem = [newDetailItem retain]; 

        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

	if (self.detailItem)
	{
		switch (_productType)
		{
			case eBookType:
			{
				[self configureViewForBook];
				self.navigationItem.title = @"Book";
				break;				
			}
			case eCameraType:
			{
				[self configureViewForCamera];
				self.navigationItem.title = @"Camera";
				break;				
			}
			case eMusicType:
			{
				[self configureViewForMusic];
				self.navigationItem.title = @"Song";
				break;				
			}
				
			default:
				break;
		}		
	}
}

- (void) configureViewForBook
{
	PLBook *bookObj = (PLBook *)_detailItem;
	
	self.titleLabel.text = bookObj.title;
	self.authorLabel.text = bookObj.authors;
	self.textView.frame = CGRectMake(56, 172, 260, 118);
	self.textView.text = bookObj.desc;
	[self.view addSubview:_textView];
	self.priceLabel.font = [UIFont systemFontOfSize:16];
	self.priceLabel.text = bookObj.price;
	
	self.displayImage.hidden = YES;
	self.displayGenreLable.hidden = YES;
}

- (void) configureViewForCamera
{
	PLCamera *camObj = (PLCamera *)_detailItem;
	
	[self.displayTitleLable setText:@"Model"];
	[self.displayAuthorLable setText:@"Make"];
	self.titleLabel.font = [UIFont systemFontOfSize:16];
	self.titleLabel.text = camObj.model;
		self.authorLabel.font = [UIFont systemFontOfSize:16];
	self.authorLabel.text = camObj.make;
	self.priceLabel.font = [UIFont systemFontOfSize:16];
	self.priceLabel.text = camObj.price;
	
	UIImage *cameraImage = camObj.image;
	if (cameraImage) {
		self.displayImage.image = cameraImage;
	}
	else {
		dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
		dispatch_async(parsingQueue, ^{
			
			NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:camObj.imageURL]];
			UIImage *image = [[UIImage alloc] initWithData:imageData];
			dispatch_async(dispatch_get_main_queue(), ^{
				self.displayImage.image = image;
				[image release];
			});
		});
	}
	
	self.descLabel.hidden = YES;
	self.displayDescLable.hidden = YES;
	self.displayGenreLable.hidden = YES;
	self.textView.hidden = YES;
}

- (void) configureViewForMusic
{
	PLMusic *musicObj = (PLMusic *)_detailItem;
	
	self.titleLabel.text = musicObj.title;
	self.titleLabel.numberOfLines = 1;
	self.titleLabel.font = [UIFont systemFontOfSize:16];
	[self.displayAuthorLable setText:@"Album"];
	self.authorLabel.text = musicObj.album;
	self.authorLabel.font = [UIFont systemFontOfSize:16];
	[self.displayPriceLable setText:@"Artist"];
	self.priceLabel.font = [UIFont systemFontOfSize:16];
	self.priceLabel.text = musicObj.artist;
	self.displayGenreLable.frame = CGRectMake(80, 180, 50, 20);
	[self.displayDescLable setText:@"Genre"];
	self.displayGenreLable.font = [UIFont systemFontOfSize:16];
	self.displayGenreLable.text = musicObj.genre;
	[self.view addSubview:displayGenreLable];
	
	self.displayImage.hidden = YES;
	self.textView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.displayGenreLable.frame = CGRectMake(180, 180, 50, 20);

	[self.view addSubview:displayGenreLable];
	
	[self configureView];
}

- (void)viewDidUnload
{
    [self setTitleLabel:nil];
    [self setAuthorLabel:nil];
    [self setPriceLabel:nil];
    [self setDescLabel:nil];
    [self setDisplayImage:nil];
	
	[self setTextView:nil];
	[self setDisplayTitleLable:nil];
	[self setDisplayAuthorLable:nil];
	[self setDisplayPriceLable:nil];
	[self setDisplayDescLable:nil];
    [super viewDidUnload];	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - 
#pragma mark Dealloc

- (void)dealloc
{
	[_detailItem release];
	[_detailDescriptionLabel release];
    [_titleLabel release];
    [_authorLabel release];
    [_priceLabel release];
    [_descLabel release];
    [_displayImage release];
	
	[_textView release];
	[_displayTitleLable release];
	[_displayAuthorLable release];
	[_displayPriceLable release];
	[_displayDescLable release];
	
    [super dealloc];
}

@end