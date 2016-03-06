/*
 STPathTextField.m
 
 Created by Sveinbjorn Thordarson on 6/27/08.
 Copyright (C) 2008-2015 Sveinbjorn Thordarson. All rights reserved.
 
 # BSD License
 # Redistribution and use in source and binary forms, with or without
 # modification, are permitted provided that the following conditions are met:
 #     * Redistributions of source code must retain the above copyright
 #       notice, this list of conditions and the following disclaimer.
 #     * Redistributions in binary form must reproduce the above copyright
 #       notice, this list of conditions and the following disclaimer in the
 #       documentation and/or other materials provided with the distribution.
 #     * Neither the name of Sveinbjorn Thordarson nor that of any other
 #       contributors may be used to endorse or promote products
 #       derived from this software without specific prior written permission.
 #
 # THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 # ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 # WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 # DISCLAIMED. IN NO EVENT SHALL  BE LIABLE FOR ANY
 # DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 # (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 # LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 # ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 # (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 # SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

#import "STPathTextField.h"

@implementation STPathTextField

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setDefaults];
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        [self setDefaults];
    }
    return self;
}

- (void)setDefaults
{
    // default settings for the text field
    _autocompleteStyle = STShellAutocomplete;
    _colorInvalidPath = YES;
    _foldersAreValid = NO;
    _expandTildeInPath = YES;
    
    [self registerForDraggedTypes:[NSArray arrayWithObjects: NSFilenamesPboardType, nil]];
}

#pragma mark -

- (BOOL)hasValidPath
{
    BOOL isDir;
    NSString *path = self.expandTildeInPath ? [[self stringValue] stringByExpandingTildeInPath] : [self stringValue];
    return ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] && (!(isDir && !self.foldersAreValid)));
}

#pragma mark -

- (void)keyUp:(NSEvent *)event
{
    unichar keyCode = [[event characters] characterAtIndex:0];
    
    if (self.autocompleteStyle == STBrowserAutocomplete) {
        if (keyCode != 13 && keyCode != 9 && keyCode != 127 && keyCode != NSLeftArrowFunctionKey && keyCode != NSRightArrowFunctionKey) {
            [self autoComplete:self];
        }
    }
    
    [super keyUp:event];
    [self updateTextColoring];
}

- (void)setStringValue:(NSString *)aString
{
    [super setStringValue:aString];
    [self textChanged];
}

- (void)updateTextColoring
{
    if (!self.colorInvalidPath) {
        return;
    }
    
    NSColor *textColor = [self hasValidPath] ? [NSColor blackColor]: [NSColor redColor];
    [self setTextColor: textColor];
}

- (BOOL)autoComplete:(id)sender
{
    NSString *path = [self stringValue];
    NSUInteger len = [path length];
    
    // let's not waste time if the string is empty
    if (len == 0) {
        return NO;
    }
    
    // we only try to expand if this looks like a real path, i.e. starts with / or ~
    unichar firstchar = [path characterAtIndex: 0];
    if (firstchar != '/' && firstchar != '~') {
        return NO;
    }
    
    // expand tilde to home dir
    if (firstchar == '~' && self.expandTildeInPath) {
        path = [[self stringValue] stringByExpandingTildeInPath];
        len = [path length];
    }
    
    // get suggestion for autocompletion
    NSString *autocompletedPath = nil;
    [path completePathIntoString:&autocompletedPath caseSensitive:YES matchesIntoArray:nil filterTypes:nil];
    
    // stop if no suggestions
    if (autocompletedPath == nil) {
        return NO;
    }
    
    // stop if suggestion is current value and current value is a valid path
    BOOL isDir;
    if ([autocompletedPath isEqualToString:[self stringValue]] &&
        [[NSFileManager defaultManager] fileExistsAtPath:autocompletedPath isDirectory:&isDir] &&
        !(isDir && !self.foldersAreValid)) {
        return NO;
    }
    
    // replace field string with autocompleted string
    [self setStringValue: autocompletedPath];
    
    // if browser style autocompletion is enabled
    // we select the autocomplete extension to the previous string
    if (self.autocompleteStyle == STBrowserAutocomplete) {
        NSUInteger dlen = [autocompletedPath length];
        [[self currentEditor] setSelectedRange:NSMakeRange(len, dlen)];
    }
    
    return YES;
}

// we make sure coloring is correct whenever text changes
- (void)textDidChange:(NSNotification *)aNotification
{
    [self textChanged];
}

- (void)textChanged
{
    if (self.colorInvalidPath) {
        [self updateTextColoring];
    }
    
    if ([self delegate] && [[self delegate] respondsToSelector:@selector(controlTextDidChange:)]) {
        [[self delegate] performSelector: @selector(controlTextDidChange:) withObject:nil];
    }
}

- (BOOL)textView:(NSTextView *)aTextView doCommandBySelector:(SEL)aSelector
{
    // intercept tab
    if (aSelector == @selector(insertTab:) && self.autocompleteStyle == STShellAutocomplete) {
        
        NSString *string = [self stringValue];
        BOOL result = NO;
        NSRange selectedRange = [aTextView selectedRange];
        
        // we only do tab autocomplete if the insertion point is at the end of the field
        // and if selection in the field is empty
        if (selectedRange.length == 0 && selectedRange.location == [[self stringValue] length]) {
            result = [self autoComplete: self];
        }
        
        // we only let the user tab out of the field if it's empty or has valid path
        if ([[self stringValue] length] == 0 || ([self hasValidPath] && [string isEqualToString: [self stringValue]])) {
            return NO;
        }
        
        return result;
    }
    return NO;
//    return [super textView: aTextView doCommandBySelector: aSelector];
}

#pragma mark - Dragging

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    if ([[[sender draggingPasteboard] types] containsObject:NSFilenamesPboardType]) {
        return NSDragOperationLink;
    }
    return NSDragOperationNone;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    if ([[[sender draggingPasteboard] types] containsObject:NSFilenamesPboardType]) {
        NSArray *files = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
        [self setStringValue:files[0]];
        return YES;
    }
    return NO;
}

@end