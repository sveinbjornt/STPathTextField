//
//  AppDelegate.m
//  STPathTextFieldExample
//
//  Created by Sveinbjorn Thordarson on 11/07/15.
//  Copyright (c) 2015 Sveinbjorn Thordarson. All rights reserved.
//

#import "AppDelegate.h"
#import "STPathTextField.h"

@interface AppDelegate ()

@property IBOutlet NSWindow *window;
@end

@implementation AppDelegate


- (void)awakeFromNib {
    
    [self.shellStylePathTextField setAutocompleteStyle:STShellAutocomplete];
    [self.shellStylePathTextField setFoldersAreValid:YES];
    
    [self.browserStylePathTextField setAutocompleteStyle:STBrowserAutocomplete];
    [self.browserStylePathTextField setFoldersAreValid:YES];

    [self.noAutocompletePathTextField setAutocompleteStyle:STNoAutocomplete];
    [self.noAutocompletePathTextField setStringValue:@"/some/path/to/nowhere"];
    
//    [self.shellStylePathTextField setStringValue:@"~/"];

}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
