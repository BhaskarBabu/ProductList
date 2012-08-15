//
//  PLMasterViewController.m
//  ProductList
//
//  Created by Bhaskar N on 13/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PLMasterViewController.h"
#import "PLDetailViewController.h"
#import "JSONKit.h"
#import "PLBookTableViewCell.h"
#import "PLCameraTableViewCell.h"
#import "PLMusicTableViewCell.h"
#import "PLCoreDataManager.h"
#import "PLBook.h"
#import "PLMusic.h"
#import "PLCamera.h"
#import "UIViewController+ProgressSheet.h"
#import <objc/runtime.h>

#define COREDATA_MANAGER	[PLCoreDataManager sharedManager]

@interface PLMasterViewController (Private)
- (void)tableViewCellIsPreparingForReuse:(NSNotification *)notification;
@end

static char * const kIndexPathAssociationKey = "cell_indexPath";

#define kProductURL @"http://www.kaverisoft.com/careers/assignments/iphone/a1.php"

@implementation PLMasterViewController

@synthesize responseData;
@synthesize books_array, songs_array, cameras_array;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
    if (self)
	{
		self.title = NSLocalizedString(@"Products", @"Products");
		
		NSMutableArray *booksArray = [[NSMutableArray alloc] init];
		self.books_array = booksArray;
		[booksArray release];
		
		NSMutableArray *camerasArray = [[NSMutableArray alloc] init];
		self.cameras_array = camerasArray;
		[camerasArray release];

		NSMutableArray *songsArray = [[NSMutableArray alloc] init];
		self.songs_array = songsArray;
		[songsArray release];
		
		self.responseData = [[[NSMutableData alloc] init] autorelease];
		
		imageCache = [[NSCache alloc] init];
		[imageCache setName:@"ImageCache"];
    }
	
    return self;
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
	
	UIBarButtonItem *refreshBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshProductList:)];
	self.navigationItem.rightBarButtonItem = refreshBtn;
	[refreshBtn release];
	
		// Register for our table view cell notification
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(tableViewCellIsPreparingForReuse:)
												 name:kPrepareForReuseNotification
											   object:nil];
	
	[self reloadProducts];	
}

- (void)viewDidUnload
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark - Action Methods

- (void) refreshProductList:(id)sender
{
	[self startCenterAndNonBlockBusyViewWithTitle:@"Refreshing..." needUserInteraction:NO];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:kProductURL]];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
	[connection start];
	[connection release];
}

#pragma mark -
#pragma mark - TableView delegate/datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger numOfRows = 0;
	
	if (section == 0)
	{
		numOfRows = [books_array count];
	}
	else if (section == 1)
	{
		numOfRows = [cameras_array count];
	}
	else if (section == 2)
	{
		numOfRows = [songs_array count];
	}	
	
	return numOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
	if (indexPath.section == 0)
	{		
		PLBookTableViewCell *bookCell = (PLBookTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (bookCell == nil) {
			bookCell =  (PLBookTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PLBookTableViewCell class]) owner:nil options:nil] objectAtIndex:0];
			[bookCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			bookCell.book_Title.font = [UIFont boldSystemFontOfSize:18];
			bookCell.book_Description.font = [UIFont systemFontOfSize:12.0];
		}

		PLBook *bookObj = [books_array objectAtIndex:indexPath.row];
		bookCell.book_Title.text = bookObj.title;
		bookCell.book_Author.text = bookObj.authors;
		bookCell.book_Price.text = bookObj.price;
		bookCell.book_Description.text = bookObj.desc;
		
		return bookCell;
	}
	else if (indexPath.section == 1)
	{
		PLCameraTableViewCell *cameraCell = (PLCameraTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cameraCell == nil) {
			cameraCell =  (PLCameraTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PLCameraTableViewCell class]) owner:nil options:nil] objectAtIndex:0];
			[cameraCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];					
			cameraCell.camera_Modal.font = [UIFont boldSystemFontOfSize:16];
		}

		PLCamera *cameraObj = [cameras_array objectAtIndex:indexPath.row];
		cameraCell.camera_Modal.text = cameraObj.model;
		cameraCell.camera_Make.text = cameraObj.make;
		cameraCell.camera_Price.text = cameraObj.price;
		
		NSString *cameraImageURLString = cameraObj.imageURL;
		
		UIImage *image = cameraObj.image;
		if (image) {
			[[cameraCell imageView] setImage:image];
		} else {    
			dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
			
			objc_setAssociatedObject(cameraCell, kIndexPathAssociationKey, indexPath, OBJC_ASSOCIATION_RETAIN);
			
			dispatch_async(queue, ^{
				NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:cameraImageURLString]];
				
				UIImage *image = [[UIImage alloc] initWithData:imageData];
				
				dispatch_async(dispatch_get_main_queue(), ^{
					NSIndexPath *cellIndexPath =
					(NSIndexPath *)objc_getAssociatedObject(cameraCell, kIndexPathAssociationKey);
					
					if ([indexPath isEqual:cellIndexPath] && image) {
						[[cameraCell imageView] setImage:image];
						
						[imageCache setObject:image forKey:cameraImageURLString];
						cameraObj.image = image;
						[COREDATA_MANAGER saveModelContext];
					
						[image release];
						
						[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];						
					}
				});
			});
		}
		
		return cameraCell;
	}
	else if (indexPath.section == 2)
	{
		PLMusicTableViewCell *songsCell = (PLMusicTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (songsCell == nil) {
			songsCell =  (PLMusicTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PLMusicTableViewCell class]) owner:nil options:nil] objectAtIndex:0];
			[songsCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			songsCell.song_Title.font = [UIFont boldSystemFontOfSize:16];			
		}
		
		PLMusic *musicObj = [songs_array objectAtIndex:indexPath.row];
		songsCell.song_Title.text = musicObj.title;
		songsCell.song_Album.text = musicObj.album;
		songsCell.song_Artiste.text = musicObj.artist;
		
		return songsCell;
	}
	
	return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;  
{
	NSArray *titles = [NSArray arrayWithObjects:@"BOOKS",@"CAMERAS",@"SONGS",nil];
	return [titles objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) {
		
		PLBook *bookObj = [books_array objectAtIndex:indexPath.row];
		
		PLDetailViewController *detailViewController = [[PLDetailViewController alloc] initWithNibName:@"PLDetailViewController" bundle:[NSBundle mainBundle]];
		[detailViewController setProductType:eBookType];		
		[detailViewController setDetailItem:bookObj];
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];		
	}
	
	if (indexPath.section == 1) {
		
		PLCamera *cameraObj = [cameras_array objectAtIndex:indexPath.row];
		
		PLDetailViewController *detailViewController = [[PLDetailViewController alloc] initWithNibName:@"PLDetailViewController" bundle:[NSBundle mainBundle]];
		[detailViewController setProductType:eCameraType];		
		[detailViewController setDetailItem:cameraObj];
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];
	}
	
	if (indexPath.section == 2) {
		
		PLMusic *musicObj = [songs_array objectAtIndex:indexPath.row];
		
		PLDetailViewController *detailViewController = [[PLDetailViewController alloc] initWithNibName:@"PLDetailViewController" bundle:[NSBundle mainBundle]];
		[detailViewController setProductType:eMusicType];		
		[detailViewController setDetailItem:musicObj];
		[self.navigationController pushViewController:detailViewController animated:YES];
		[detailViewController release];		
	}
}

#pragma mark -
#pragma mark - Instance Methods

- (void)parseResponseString:(NSString *) jsonString
{
	[COREDATA_MANAGER deleteAllObjectsFromEntity:PLBOOK];
	[COREDATA_MANAGER deleteAllObjectsFromEntity:PLCAMERA];
	[COREDATA_MANAGER deleteAllObjectsFromEntity:PLMUSIC];
	
	NSArray *parsedArray = [[NSArray alloc] initWithArray:[jsonString objectFromJSONString]];
	for (NSDictionary *parsedDict in parsedArray) {
		if ([parsedDict objectForKey:kBook]) {
			
			NSDictionary *bookDict = [parsedDict objectForKey:kBook];
			
			PLBook *book = [COREDATA_MANAGER getNewObjectForEntity:PLBOOK];
			book.authors = [bookDict objectForKey:kAuthors];
			book.desc = [bookDict objectForKey:kDescription];
			book.bookId = [[bookDict objectForKey:kId] stringValue];
			book.price = [[bookDict objectForKey:kPrice] stringValue];
			book.title = [bookDict objectForKey:kTitle];
		}		
		else if ([parsedDict objectForKey:kCamera]) {			
			
			NSDictionary *cameraDict = [parsedDict objectForKey:kCamera];
			
			PLCamera *camera = [COREDATA_MANAGER getNewObjectForEntity:PLCAMERA];
			camera.make = [cameraDict objectForKey:kMake];
			camera.model = [cameraDict objectForKey:kModel];
			camera.imageURL = [cameraDict objectForKey:kPicture];
			camera.price = [[cameraDict objectForKey:kPrice] stringValue];			
		}
		else if ([parsedDict objectForKey:kMusic]) {
			
			NSDictionary *musicDict = [parsedDict objectForKey:kMusic];
			
			PLMusic *music = [COREDATA_MANAGER getNewObjectForEntity:PLMUSIC];
			music.album = [musicDict objectForKey:kAlbum];
			music.artist = [musicDict objectForKey:kArtist];
			music.genre = [musicDict objectForKey:kGenre];
			music.title = [musicDict objectForKey:kTitle];
		}
	}
	[parsedArray release];
	
	[COREDATA_MANAGER saveModelContext];
	
	[self reloadProducts];	
}

- (void) reloadProducts
{
	dispatch_queue_t parsingQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(parsingQueue, ^{
		
		self.books_array = [NSMutableArray arrayWithArray:[COREDATA_MANAGER objectsFromEntity:PLBOOK]];
		self.cameras_array = [NSMutableArray arrayWithArray:[COREDATA_MANAGER objectsFromEntity:PLCAMERA]];
		self.songs_array = [NSMutableArray arrayWithArray:[COREDATA_MANAGER objectsFromEntity:PLMUSIC]];
		
        dispatch_async(dispatch_get_main_queue(), ^{
			[self.tableView reloadData];
			[self stopCenterAndNonBlockBusyViewWithTitle];	
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });			
    });
}

#pragma mark -
#pragma mark - Notification Observer Methods

- (void)tableViewCellIsPreparingForReuse:(NSNotification *)notification
{
	if ([[notification object] isKindOfClass:[PLCameraTableViewCell class]]) {
		PLCameraTableViewCell *cell = (PLCameraTableViewCell *)[notification object];
		
		objc_setAssociatedObject(cell, kIndexPathAssociationKey, nil, OBJC_ASSOCIATION_RETAIN);
		
		[[cell imageView] setImage:nil];
	}
}

#pragma mark -
#pragma mark - NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

- (void)connction:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [connection release];
    NSString *errorString = [[NSString alloc]initWithFormat:@"Fetch Failed : %@",[error localizedDescription]];
    NSLog(@"%@",errorString);
	[errorString release];
	[self stopCenterAndNonBlockBusyViewWithTitle];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[self parseResponseString:responseString];
	[responseString release];
}

#pragma mark -
#pragma mark - Dealloc

- (void)dealloc
{
	self.books_array = nil;
	self.cameras_array = nil;
	self.songs_array = nil;
	self.responseData = nil;
	
	if (imageCache) {
		[imageCache release];
	}
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
    [super dealloc];
}

@end