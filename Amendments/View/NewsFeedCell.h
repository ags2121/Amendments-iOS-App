//
//  NewsFeedCell.h
//  Amendments
//
//  Created by Alex Silva on 3/2/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsFeedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *articleTitle;
@property (weak, nonatomic) IBOutlet UILabel *articlePublication;
@property (weak, nonatomic) IBOutlet UILabel *articleDate;

@end
