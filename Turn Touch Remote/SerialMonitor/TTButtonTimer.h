//
//  TTButtonTimer.h
//  Turn Touch Remote
//
//  Created by Samuel Clay on 11/1/13.
//  Copyright (c) 2013 Turn Touch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTAppDelegate.h"
#import "TTModeMap.h"
#import "TTButtonState.h"

@class TTAppDelegate;

typedef enum {
    PRESS_ACTIVE = 0x01,
    PRESS_TOGGLE = 0x02,
    PRESS_MODE   = 0x03
} TTPressState;

@interface TTButtonTimer : NSObject {
    TTAppDelegate *appDelegate;
    NSTimer *activeModeTimer;
    TTButtonState *lastButtonState;
    TTButtonState *pairingButtonState;
    BOOL inMultitouch;
    TTModeDirection lastButtonPressedDirection;
    NSDate *lastButtonPressStart;
    NSDate *holdToastStart;
}

@property (nonatomic, readwrite) BOOL inMultitouch;
@property (nonatomic) TTButtonState *lastButtonState;
@property (nonatomic) NSNumber *pairingActivatedCount;

- (void)readBluetoothData:(NSData *)data;
- (void)activateMode:(TTModeDirection)direction;
- (void)activateButton:(TTModeDirection)direction;
- (void)fireButton:(TTModeDirection)direction;
- (void)resetPairingState;
- (void)readBluetoothDataDuringPairing:(NSData *)data;
- (BOOL)isDevicePaired;
- (BOOL)isDirectionPaired:(TTModeDirection)direction;

@end
