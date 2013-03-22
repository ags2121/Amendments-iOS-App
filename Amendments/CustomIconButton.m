//
//  UIBarButtonItem+ImageItem.m
//  UIKitConvenience
//
//  Created by Eric Goldberg on 6/8/12.
//  Copyright (c) 2012 Eric Goldberg. All rights reserved.
//

#import "CustomIconButton.h"

@implementation UIBarButtonItem (CustomIconButton)

+(UIBarButtonItem *)barItemWithImage:(UIImage *)image showsTouchWhenHighlighted:(BOOL)val target:(id)target action:(SEL)action
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.showsTouchWhenHighlighted = val;
    button.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* item = [[self alloc] initWithCustomView:button];
    return item;
}

@end