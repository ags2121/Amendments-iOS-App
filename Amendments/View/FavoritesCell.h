//
//  FavoritesCell.h
//  Amendments
//
//  Created by Alex Silva on 3/9/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *articleTitle;
@property (weak, nonatomic) IBOutlet UILabel *articlePublication;

@property (weak, nonatomic) IBOutlet UILabel *articleDate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellLabelHSpaceConstraint;

@end
