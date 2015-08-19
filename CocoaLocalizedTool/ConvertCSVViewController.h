//
//  ConvertCSVViewController.h
//  CocoaLocalizedTool
//
//  Created by Tue Nguyen on 10/25/11.
//  Copyright (c) 2011 Savvycom JSC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ConvertCSVViewController : NSViewController {
    
}
@property (assign) IBOutlet NSTextField *sourceTextField;
@property (assign) IBOutlet NSTextField *outputTextField;

- (IBAction)doChooseFile:(id)sender;
- (IBAction)doConvert:(id)sender;
@end
