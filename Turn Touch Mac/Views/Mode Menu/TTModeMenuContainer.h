//
//  TTModeMenuContainer.h
//  Turn Touch Remote
//
//  Created by Samuel Clay on 4/28/14.
//  Copyright (c) 2014 Turn Touch. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TTMenuType.h"
#import "TTModeMenuCollectionView.h"
#import "TTModeMenuBordersView.h"
#import "TTAppDelegate.h"

@class TTAppDelegate;
@class TTModeMenuCollectionView;

@interface TTModeMenuContainer : NSView

@property (nonatomic, weak) TTAppDelegate *appDelegate;
@property (nonatomic) TTModeMenuCollectionView *collectionView;
@property (nonatomic) TTModeMenuBordersView *bordersView;

- (id)initWithType:(TTMenuType)_menuType;
- (void)toggleScrollbar:(BOOL)visible;
- (void)scrollToInspectingDirection;

@end
