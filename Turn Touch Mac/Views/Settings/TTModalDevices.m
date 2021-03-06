//
//  TTModalDevices.m
//  Turn Touch Remote
//
//  Created by Samuel Clay on 3/15/16.
//  Copyright © 2016 Turn Touch. All rights reserved.
//

#import "TTModalDevices.h"
#import "NSDate+TimeAgo.h"

@interface TTModalDevices ()

@end

@implementation TTModalDevices

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = (TTAppDelegate *)[NSApp delegate];
    [self registerAsObserver];
}

- (void)viewWillAppear {    
    [super viewWillAppear];
    [self.devicesTable reloadData];
}

- (void)closeModal:(id)sender {
    [self.appDelegate.panelController.backgroundView switchPanelModal:PANEL_MODAL_APP];
}

#pragma mark - KVO

- (void)registerAsObserver {
    [self.appDelegate.bluetoothMonitor addObserver:self
                                   forKeyPath:@"batteryPct"
                                      options:0 context:nil];
    [self.appDelegate.bluetoothMonitor addObserver:self
                                   forKeyPath:@"lastActionDate"
                                      options:0 context:nil];
    [self.appDelegate.bluetoothMonitor addObserver:self
                                   forKeyPath:@"pairedDevicesCount"
                                      options:0 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqual:NSStringFromSelector(@selector(batteryPct))]) {
        [self.devicesTable reloadData];
    } else if ([keyPath isEqual:NSStringFromSelector(@selector(lastActionDate))]) {
        [self.devicesTable reloadData];
    } else if ([keyPath isEqual:NSStringFromSelector(@selector(pairedDevicesCount))]) {
        [self.devicesTable reloadData];
    }
}

- (void)dealloc {
    [self.appDelegate.bluetoothMonitor removeObserver:self forKeyPath:@"batteryPct"];
    [self.appDelegate.bluetoothMonitor removeObserver:self forKeyPath:@"lastActionDate"];
    [self.appDelegate.bluetoothMonitor removeObserver:self forKeyPath:@"pairedDevicesCount"];
}

#pragma mark - Devices Table

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.appDelegate.bluetoothMonitor.foundDevices.connectedCount;
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    NSTextField *result = [tableView makeViewWithIdentifier:@"Devices" owner:self];
    if (result == nil) {
        result = [[NSTextField alloc] initWithFrame:NSZeroRect];
        [result setIdentifier:@"Devices"];
        [result setEditable:NO];
        [result setBordered:NO];
        [result setBackgroundColor:[NSColor clearColor]];
        [result setDelegate:self];
    }
    
    TTDevice *device = [self.appDelegate.bluetoothMonitor.foundDevices connectedDeviceAtIndex:row];
    if (!device.isPaired) {
        // Unpaired
        if ([tableColumn.identifier isEqualToString:@"deviceIdentifier"]) {
            result.stringValue = device.nickname ? device.nickname : device.uuid ? device.uuid : @"";
        } else if ([tableColumn.identifier isEqualToString:@"batteryLevel"]) {
            result.stringValue = device.batteryPct ? [NSString stringWithFormat:@"%@%%", device.batteryPct] : @"";
        } else if ([tableColumn.identifier isEqualToString:@"firmwareVersion"]) {
            result.stringValue = [NSString stringWithFormat:@"v%ld", (long)device.firmwareVersion];
        } else if ([tableColumn.identifier isEqualToString:@"lastAction"]) {
            result.stringValue = @"Pairing...";
        }
    } else if (device.batteryPct.intValue <= 0) {
        // Still connecting
        if ([tableColumn.identifier isEqualToString:@"deviceIdentifier"]) {
            result.stringValue = @"Connecting to remote...";
        } else if ([tableColumn.identifier isEqualToString:@"batteryLevel"]) {
            result.stringValue = @"";
        } else if ([tableColumn.identifier isEqualToString:@"firmwareVersion"]) {
            result.stringValue = @"";
        } else if ([tableColumn.identifier isEqualToString:@"lastAction"]) {
            result.stringValue = @"";
        }
    } else {
        if ([tableColumn.identifier isEqualToString:@"deviceIdentifier"]) {
            result.stringValue = device.nickname ? device.nickname : device.uuid;
            if (device.nickname) {
                [result setEditable:YES];
            }
        } else if ([tableColumn.identifier isEqualToString:@"batteryLevel"]) {
            result.stringValue = [NSString stringWithFormat:@"%@%%", device.batteryPct];
        } else if ([tableColumn.identifier isEqualToString:@"firmwareVersion"]) {
            result.stringValue = [NSString stringWithFormat:@"v%ld", (long)device.firmwareVersion];
        } else if ([tableColumn.identifier isEqualToString:@"lastAction"]) {
            result.stringValue = [device.lastActionDate timeAgo];
        }
    }
    
    return result;
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {
    NSInteger row = [self.devicesTable rowForView:control];
    if (row == -1) {
        return YES;
    }
    TTDevice *device = [self.appDelegate.bluetoothMonitor.foundDevices connectedDeviceAtIndex:row];
    
    [self.appDelegate.bluetoothMonitor writeNickname:control.stringValue toDevice:device];
    
    [control setStringValue:device.nickname];
    
    return YES;
}


@end
