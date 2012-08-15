//
//  PLMusicTableViewCell.h
//  ProductList
//
//  Created by Bhaskar N on 13/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLMusicTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *song_Title;
@property (retain, nonatomic) IBOutlet UILabel *song_Album;
@property (retain, nonatomic) IBOutlet UILabel *song_Artiste;

@end
