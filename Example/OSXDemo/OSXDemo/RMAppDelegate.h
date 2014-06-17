//
//  RMAppDelegate.h
//  OSXDemo
//
//  Created by Rob MacEachern on 2014-06-16.
//  Copyright (c) 2014 Rob MacEachern. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RMAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

- (IBAction)saveAction:(id)sender;

@end
