//
//  ViewController.h
//  DYLocalizer
//
//  Created by Dwarven on 16/4/11.
//  Copyright © 2016年 Dwarven. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (weak) IBOutlet NSTextField *standardFilePath;
@property (weak) IBOutlet NSTextField *translateFilePath;
@property (weak) IBOutlet NSButton *mergeButton;
@property (weak) IBOutlet NSTextField *messageLabel;

@end

