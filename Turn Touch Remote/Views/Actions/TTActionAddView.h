//
//  TTActionAddView.h
//  Turn Touch Remote
//
//  Created by Samuel Clay on 12/17/15.
//  Copyright © 2015 Turn Touch. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TTAppDelegate.h"

@interface TTActionAddView : NSView {
    TTAppDelegate *appDelegate;
    TTChangeButtonView *addButton;
}

@end
