/*
    STPathTextField.h

    Created by Sveinbjorn Thordarson on 6/27/08.
    Copyright (C) 2008-2015 Sveinbjorn Thordarson. All rights reserved.
	
    ************************ ABOUT *****************************

    STPathTextField is a subclass of NSTextField for receiving
    and displaying a file system path.  It supports path validation
    and autocompletion.  Autocompletion can use "web browser" style -
    e.g. expansion and selection, or shell autocompletion style -
    tab-expansion.

    To use STPathTextField, just add a text field to a window in
    Interface Builder, and set its class to STPathTextField.

    See code on how to set the settings for the text field.
    Defaults are the following:

    autocompleteStyle = STNoAutocomplete;
    colorInvalidPath = YES;
    foldersAreValid = NO;
    expandTildeInPath = YES;

    There are three settings for autocompleteStyle

    enum
    {
        STNoAutocomplete = 0,
        STShellAutocomplete = 1,
        STBrowserAutocomplete = 2
    };
 

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


#import <Cocoa/Cocoa.h>

typedef enum
{
	STNoAutocomplete = 0,
	STShellAutocomplete = 1,
	STBrowserAutocomplete = 2
} STPathTextFieldAutocompleteStyle;

@interface STPathTextField : NSTextField <NSTextViewDelegate>

@property STPathTextFieldAutocompleteStyle autocompleteStyle;
@property BOOL colorInvalidPath;
@property BOOL foldersAreValid;
@property BOOL expandTildeInPath;

- (BOOL)hasValidPath;

@end
