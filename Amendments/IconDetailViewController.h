//
//  IconDetailViewController.h
//  Amendments
//
//  Created by Alex Silva on 6/5/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IconDetailViewController;

@protocol IconDetailDelegate <NSObject>

-(void)iconDetailWillResign;

@end

@interface IconDetailViewController : UIViewController<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;

@property (nonatomic, weak) id <IconDetailDelegate> delegate;

@end
