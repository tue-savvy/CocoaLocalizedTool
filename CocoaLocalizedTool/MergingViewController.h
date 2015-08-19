//
//  MergingViewController.h
//  CocoaLocalizedTool
//
//  Created by Tue Nguyen on 10/20/11.
//  Copyright (c) 2011 Savvycom JSC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MergingViewController : NSViewController {
    
}
@property (assign) IBOutlet NSButton *mergingButton;
@property (assign) IBOutlet NSButton *overrideCheckBox;
@property (assign) IBOutlet NSTextField *sourceTextField;
@property (assign) IBOutlet NSTextField *destinationTextField;
@property (assign) IBOutlet NSTextField *outputTextField;
@property (assign) IBOutlet NSButton *mergeNewStringSourcePathCheckbox;

- (IBAction)doChooseFile:(id)sender;
- (IBAction)doMerging:(id)sender;
@end
