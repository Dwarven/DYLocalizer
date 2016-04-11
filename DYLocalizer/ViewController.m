//
//  ViewController.m
//  DYLocalizer
//
//  Created by Dwarven on 16/4/11.
//  Copyright © 2016年 Dwarven. All rights reserved.
//

#import "ViewController.h"
#import "DYLocalizer.h"

@interface ViewController () {
    NSURL * _standardFileURL;
    NSURL * _translateFileURL;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)selectStandardFile:(id)sender {
    [self getPathForTextField:_standardFilePath];
}

- (IBAction)selectTranslateFile:(id)sender {
    [self getPathForTextField:_translateFilePath];
}

- (IBAction)merge:(id)sender {
    [DYLocalizer mergeWithStandardFileURL:_standardFileURL translateFileURL:_translateFileURL];
}

-(void)getPathForTextField:(NSTextField *)textField {
    [_messageLabel setStringValue:@""];
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories:NO];
    [panel setCanCreateDirectories:YES];
    [panel setCanChooseFiles:YES];
    [panel setAllowedFileTypes:@[@"strings"]];
    
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton && [panel URLs] && [[panel URLs] count] > 0) {
            if (textField == _standardFilePath) {
                if ([[[[panel URLs] firstObject] absoluteString] isEqualToString:[_translateFilePath stringValue]]) {
                    [_messageLabel setStringValue:@"They cannot be the same!!!"];
                    return;
                }
                _standardFileURL = [[panel URLs] firstObject];
            }
            if (textField == _translateFilePath) {
                if ([[[[panel URLs] firstObject] absoluteString] isEqualToString:[_standardFilePath stringValue]]) {
                    [_messageLabel setStringValue:@"They cannot be the same!!!"];
                    return;
                }
                _translateFileURL = [[panel URLs] firstObject];
            }
            [_standardFilePath setStringValue:[_standardFileURL absoluteString]];
            [_translateFilePath setStringValue:[_translateFileURL absoluteString]];
            [_mergeButton setEnabled:[[_standardFilePath stringValue] length] > 0 && [[_translateFilePath stringValue] length] > 0];
        }
    }];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

@end
