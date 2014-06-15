//
//  RMDetailViewController.h
//  BasicDemo
//
//  Created by Rob MacEachern on 2014-06-15.
//  Copyright (c) 2014 Rob MacEachern. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
