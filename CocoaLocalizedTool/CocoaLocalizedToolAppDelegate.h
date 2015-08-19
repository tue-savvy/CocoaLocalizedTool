//
//  CocoaLocalizedToolAppDelegate.h
//  CocoaLocalizedTool
//
//  Created by Tue Nguyen on 10/4/11.
//  Copyright 2011 Savvycom JSC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MergingViewController.h"
#import "ConvertCSVViewController.h"
@interface CocoaLocalizedToolAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    NSButton *doGenerate;
    NSTextField *pathTextField;
    NSButton *chooseButton;
    NSButton *generateButton;
    NSProgressIndicator *indicatorControl;
    NSTextField *messageLabel;
}
@property (assign) IBOutlet NSTextField *pathTextField;
@property (assign) IBOutlet NSButton *chooseButton;
@property (assign) IBOutlet NSButton *generateButton;
@property (assign) IBOutlet NSProgressIndicator *indicatorControl;
@property (assign) IBOutlet NSTextField *messageLabel;
@property (assign) IBOutlet MergingViewController *mergingViewController;
@property (assign) IBOutlet ConvertCSVViewController *convertViewController;
@property (assign) IBOutlet NSView *mergingTabContentView;
@property (assign) IBOutlet NSView *convertTabContentView;

@property (assign) IBOutlet NSWindow *window;
- (IBAction)doChooseDirectory:(id)sender;
- (IBAction)doGenerate:(id)sender;
- (BOOL)validate;
- (void)generateLocalizedStringFile:(NSString *)outputDirectory;
- (void)copyXIBFile:(NSString *)outputDirectory;
- (void)clearContent:(NSString *)directory;
- (void)generateXIBSLocalizableStringFile:(NSString *)directory;
- (void)mergeAllXIBStringFrom:(NSString *)xibsPath toOneFile:(NSString *)outputFile;
- (NSDictionary *)collectAllKeyAndValue:(NSString *)file XIBString:(BOOL)isXIBString;
@end
