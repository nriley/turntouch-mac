//
//  TTModeOptionsTitle.h
//  Turn Touch App
//
//  Created by Samuel Clay on 12/27/13.
//  Copyright (c) 2013 Turn Touch. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TTAppDelegate.h"

@class TTAppDelegate;

@interface TTModeOptionsTitle : NSView {
    TTAppDelegate *appDelegate;
    NSDictionary *titleAttributes;
    NSDictionary *descriptionAttributes;
}

@end
