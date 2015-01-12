//
//  TTModeHueConnecting.h
//  Turn Touch App
//
//  Created by Samuel Clay on 1/9/15.
//  Copyright (c) 2015 Turn Touch. All rights reserved.
//

#import "TTOptionsDetailViewController.h"

@interface TTModeHueConnecting : TTOptionsDetailViewController

@property (nonatomic) IBOutlet NSTextField *progressMessage;

- (void)setConnectingWithMessage:(NSString*)message;

@end
