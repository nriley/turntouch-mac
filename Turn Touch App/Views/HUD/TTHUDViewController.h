//
//  TTHUDViewController.h
//  Turn Touch App
//
//  Created by Samuel Clay on 12/4/14.
//  Copyright (c) 2014 Turn Touch. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TTAppDelegate.h"
#import "TTHUDView.h"
#import "TTHUDWindow.h"

@interface TTHUDViewController : NSViewController <NSWindowDelegate> {
    TTAppDelegate *appDelegate;
    TTHUDWindow *hudWindow;
}

@property (nonatomic) IBOutlet TTHUDView *hudView;

- (IBAction)fadeIn:(id)sender;
- (IBAction)fadeOut:(id)sender;

@end
