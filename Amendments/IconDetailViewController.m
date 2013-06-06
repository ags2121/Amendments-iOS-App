//
//  IconDetailViewController.m
//  Amendments
//
//  Created by Alex Silva on 6/5/13.
//  Copyright (c) 2013 Alex Silva. All rights reserved.
//

#import "IconDetailViewController.h"

@interface IconDetailViewController ()

@end

@implementation IconDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSLog(@"detail vc loaded");
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
    tapGesture.delegate = self;
    [self.detailImageView addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)imageViewTapped:(UITapGestureRecognizer*)tap
{
    [self.delegate iconDetailWillResign];
}

@end
