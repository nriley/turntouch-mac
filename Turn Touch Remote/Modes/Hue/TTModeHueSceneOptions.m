//
//  TTModeHueSceneEarlyEvening.m
//  Turn Touch Remote
//
//  Created by Samuel Clay on 1/13/15.
//  Copyright (c) 2015 Turn Touch. All rights reserved.
//

#import "TTModeHue.h"
#import "TTModeHueSceneOptions.h"
#import <HueSDK_OSX/HueSDK.h>

NSString *const kHueScene = @"hueScene";
NSString *const kHueDuration = @"hueDuration";

@interface TTModeHueSceneOptions ()

@end

@implementation TTModeHueSceneOptions

@synthesize scenePopup;
@synthesize durationLabel;
@synthesize durationSlider;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *sceneSelectedIdentifier = [appDelegate.modeMap actionOptionValue:kHueScene];
    NSInteger sceneDuration = [[appDelegate.modeMap actionOptionValue:kHueDuration] integerValue];
    NSString *sceneSelected;
    
    PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
    NSMutableArray *scenes = [[NSMutableArray alloc] init];
    [scenePopup removeAllItems];
    for (PHScene *scene in cache.scenes.allValues) {
        NSLog(@"Scene: %@ %@", scene.identifier, scene.name);
        [scenes addObject:@{@"name": scene.name, @"identifier": scene.identifier}];
    }

    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [scenes sortUsingDescriptors:@[sd]];
    
    for (NSDictionary *scene in scenes) {
        [scenePopup addItemWithTitle:scene[@"name"]];
        if ([scene[@"identifier"] isEqualToString:sceneSelectedIdentifier]) {
            sceneSelected = scene[@"name"];
        }
        
    }
    if (sceneSelected) {
        [scenePopup selectItemWithTitle:sceneSelected];
    }
    
    [durationSlider setIntegerValue:sceneDuration];
    [self updateSliderLabel];
}

#pragma mark - Actions

- (IBAction)didChangeScene:(id)sender {
    NSMenuItem *menuItem = [scenePopup selectedItem];
    PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
    NSString *sceneIdentifier;
    
    for (PHScene *scene in cache.scenes.allValues) {
        if ([scene.name isEqualToString:menuItem.title]) {
            sceneIdentifier = scene.identifier;
            break;
        }
    }
    
    [appDelegate.modeMap changeActionOption:kHueScene to:sceneIdentifier];
}

- (IBAction)didChangeDuration:(id)sender {
    NSInteger duration = durationSlider.integerValue;

    [appDelegate.modeMap changeActionOption:kHueDuration to:[NSNumber numberWithInteger:duration]];
    [self updateSliderLabel];
}

- (void)updateSliderLabel {
    NSInteger duration = durationSlider.integerValue;
    
    NSString *durationString;
    if (duration == 0)      durationString = @"Immediate";
    else if (duration == 1) durationString = @"1 minute";
    else                    durationString = [NSString stringWithFormat:@"%@ minutes", @(duration)];
    
    [durationLabel setStringValue:durationString];
}

@end