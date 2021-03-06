//
//  IconDetailViewController.h
//  Amendments
/*
    Displays a larger, higher resolution image of the thumbnail icons in AllAmendmentsViewController, where it is instantiated and delegates to.
*/
//  Created by Alex Silva on 6/5/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IconDetailViewController;

@protocol IconDetailDelegate <NSObject>

-(void)iconDetailWillResign;

@end

@interface IconDetailViewController : UIViewController<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIImage *detailImage;
@property (nonatomic, weak) id <IconDetailDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;

@end
