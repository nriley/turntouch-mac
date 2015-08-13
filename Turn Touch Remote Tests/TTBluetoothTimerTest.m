//
//  TTBluetoothTimerTest.m
//  Turn Touch Remote
//
//  Created by Samuel Clay on 5/8/15.
//  Copyright (c) 2015 Turn Touch. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "TTAppDelegate.h"
#import "TTButtonTimer.h"


@interface TTBluetoothTimerTest : XCTestCase {
    TTAppDelegate *appDelegate;
    TTButtonTimer *buttonTimer;
    uint16_t clearByte;
    uint16_t northByte;
    uint16_t eastByte;
    uint16_t westByte;
    uint16_t southByte;
}

@end

@implementation TTBluetoothTimerTest

- (void)setUp {
    [super setUp];
    appDelegate = [NSApp delegate];
    buttonTimer = appDelegate.bluetoothMonitor.buttonTimer;
    
    clearByte = 0x000F;
    northByte = 0x0F - (1 << 0);
    eastByte = 0x0F - (1 << 1);
    westByte = 0x0F - (1 << 2);
    southByte = 0x0F - (1 << 3);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)readBluetoothData:(uint16_t)bytes {
    NSData *data = [NSData dataWithBytes:&bytes length:2];
    [buttonTimer readBluetoothData:data];
}

// Test each direction individually
- (void)testButtonsIndividually {
    [self readBluetoothData:northByte];
    XCTAssertEqual(buttonTimer.lastButtonState.north, YES);
    XCTAssertEqual(buttonTimer.lastButtonState.east,  NO);
    XCTAssertEqual(buttonTimer.lastButtonState.west,  NO);
    XCTAssertEqual(buttonTimer.lastButtonState.south, NO);
    
    [self readBluetoothData:clearByte];
    XCTAssertEqual(buttonTimer.lastButtonState.north, NO);
    XCTAssertEqual(buttonTimer.lastButtonState.east,  NO);
    XCTAssertEqual(buttonTimer.lastButtonState.west,  NO);
    XCTAssertEqual(buttonTimer.lastButtonState.south, NO);
    
    [self readBluetoothData:eastByte];
    XCTAssertEqual(buttonTimer.lastButtonState.north, NO);
    XCTAssertEqual(buttonTimer.lastButtonState.east,  YES);
    XCTAssertEqual(buttonTimer.lastButtonState.west,  NO);
    XCTAssertEqual(buttonTimer.lastButtonState.south, NO);
    
    [self readBluetoothData:clearByte];
    XCTAssertEqual(buttonTimer.lastButtonState.north, NO);
    XCTAssertEqual(buttonTimer.lastButtonState.east,  NO);
    XCTAssertEqual(buttonTimer.lastButtonState.west,  NO);
    XCTAssertEqual(buttonTimer.lastButtonState.south, NO);
    
    [self readBluetoothData:westByte];
    XCTAssertEqual(buttonTimer.lastButtonState.north, NO);
    XCTAssertEqual(buttonTimer.lastButtonState.east,  NO);
    XCTAssertEqual(buttonTimer.lastButtonState.west,  YES);
    XCTAssertEqual(buttonTimer.lastButtonState.south, NO);
    
    [self readBluetoothData:clearByte];
    XCTAssertEqual(buttonTimer.lastButtonState.north, NO);
    XCTAssertEqual(buttonTimer.lastButtonState.east,  NO);
    XCTAssertEqual(buttonTimer.lastButtonState.west,  NO);
    XCTAssertEqual(buttonTimer.lastButtonState.south, NO);
    
    [self readBluetoothData:southByte];
    XCTAssertEqual(buttonTimer.lastButtonState.north, NO);
    XCTAssertEqual(buttonTimer.lastButtonState.east,  NO);
    XCTAssertEqual(buttonTimer.lastButtonState.west,  NO);
    XCTAssertEqual(buttonTimer.lastButtonState.south, YES);
    
    [self readBluetoothData:clearByte];
    XCTAssertEqual(buttonTimer.lastButtonState.north, NO);
    XCTAssertEqual(buttonTimer.lastButtonState.east,  NO);
    XCTAssertEqual(buttonTimer.lastButtonState.west,  NO);
    XCTAssertEqual(buttonTimer.lastButtonState.south, NO);
}

// Test multiple directions at once
- (void)testButtonsMultitouch {
    [self readBluetoothData:northByte];
    XCTAssertEqual(buttonTimer.lastButtonState.north, YES);
    XCTAssertEqual(buttonTimer.lastButtonState.east,  NO);
    XCTAssertEqual(buttonTimer.lastButtonState.west,  NO);
    XCTAssertEqual(buttonTimer.lastButtonState.south, NO);
    XCTAssertFalse(buttonTimer.inMultitouch);
    
    [self readBluetoothData:northByte & eastByte];
    XCTAssertEqual(buttonTimer.lastButtonState.north, YES);
    XCTAssertEqual(buttonTimer.lastButtonState.east,  YES);
    XCTAssertEqual(buttonTimer.lastButtonState.west,  NO);
    XCTAssertEqual(buttonTimer.lastButtonState.south, NO);
    XCTAssertTrue(buttonTimer.inMultitouch);
    
    [self readBluetoothData:clearByte];
    XCTAssertEqual(buttonTimer.lastButtonState.north, NO);
    XCTAssertEqual(buttonTimer.lastButtonState.east,  NO);
    XCTAssertEqual(buttonTimer.lastButtonState.west,  NO);
    XCTAssertEqual(buttonTimer.lastButtonState.south, NO);
    
    // This tests for the accidental button press registered when lifting fingers off multiple buttons
    __block BOOL finished = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.050 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        XCTAssertTrue(buttonTimer.inMultitouch);
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.250 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        XCTAssertFalse(buttonTimer.inMultitouch);
        finished = YES;
    });
    
    while (!finished) {
        NSDate *oneSecond = [NSDate dateWithTimeIntervalSinceNow:1];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:oneSecond];
    }
    XCTAssertFalse(buttonTimer.inMultitouch);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
