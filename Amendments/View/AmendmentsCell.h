//
//  AmendmentsCell.h
//  Amendments
//
//  Created by Alex Silva on 2/28/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AmendmentsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *amendmentIcon;
@property (weak, nonatomic) IBOutlet UILabel *amendmentNumber;
@property (weak, nonatomic) IBOutlet UILabel *amendmentSubtitle;

@end
