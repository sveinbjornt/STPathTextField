//
//  AppDelegate.h
//  STPathTextFieldExample
//
//  Created by Sveinbjorn Thordarson on 11/07/15.
//  Copyright (c) 2015 Sveinbjorn Thordarson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class STPathTextField;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property IBOutlet STPathTextField *shellStylePathTextField;
@property IBOutlet STPathTextField *browserStylePathTextField;
@property IBOutlet STPathTextField *noAutocompletePathTextField;

@end

