//
//  FavoritesCell.m
//  Amendments
//
//  Created by Alex Silva on 3/9/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import "FavoritesCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation FavoritesCell

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

-(void) setEditing: (BOOL)editing animated: (BOOL)animated
{
    [super setEditing: editing animated: animated];
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.2f;
    animation.type = kCATransitionFade;
    
    //redraw the subviews (and animate)
    for( UIView *subview in self.contentView.subviews )
    {
        [subview.layer addAnimation: animation forKey: @"editingFade"];
        [subview setNeedsDisplay];
    }
}

-(void)awakeFromNib
{
    NSDictionary *dict = NSDictionaryOfVariableBindings(_articleTitle);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-22-[_articleTitle]-20-|" options:0 metrics:nil views:dict]];
}

@end
