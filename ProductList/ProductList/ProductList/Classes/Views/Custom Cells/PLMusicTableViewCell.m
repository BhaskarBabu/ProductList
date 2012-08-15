//
//  PLMusicTableViewCell.m
//  ProductList
//
//  Created by Bhaskar N on 13/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PLMusicTableViewCell.h"

@implementation PLMusicTableViewCell
@synthesize song_Title;
@synthesize song_Album;
@synthesize song_Artiste;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
	[song_Title release];
	[song_Album release];
	[song_Artiste release];
	[super dealloc];
}
@end
