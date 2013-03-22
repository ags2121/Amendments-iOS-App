//
//  NewsFeedCell.m
//  Amendments
//
//  Created by Alex Silva on 3/2/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import "NewsFeedCell.h"

@implementation NewsFeedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //set background Image
        /*
        UIImageView *av = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
        av.backgroundColor = [UIColor clearColor];
        av.opaque = NO;
        av.image = [UIImage imageNamed:@"wood-panel_customCellBG"];
        self.backgroundView = av;
         */
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
