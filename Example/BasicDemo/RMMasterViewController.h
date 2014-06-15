//
//  RMMasterViewController.h
//  BasicDemo
//
//  Created by Rob MacEachern on 2014-06-15.
//  Copyright (c) 2014 Rob MacEachern. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RMDetailViewController;

#import <CoreData/CoreData.h>

@interface RMMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) RMDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
