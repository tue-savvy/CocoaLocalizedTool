//
//  ConvertCSVViewController.m
//  CocoaLocalizedTool
//
//  Created by Tue Nguyen on 10/25/11.
//  Copyright (c) 2011 Savvycom JSC. All rights reserved.
//

#import "ConvertCSVViewController.h"
#import "SAVStringsParser.h"
#import "SAVCSVWriter.h"

#define SOURCE_BUTTON 1000
#define DESTINATION_BUTTON 1001
#define OUTPUT_BUTTON 1002

@implementation ConvertCSVViewController

@synthesize sourceTextField;
@synthesize outputTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
- (IBAction)doChooseFile:(id)sender {
    NSButton *button = (NSButton *)sender;
    
    if(button.tag == SOURCE_BUTTON) {
        NSOpenPanel *openPanel = [NSOpenPanel openPanel];
        [openPanel setAllowedFileTypes:[NSArray arrayWithObject:@"strings"]];
        [openPanel setCanChooseDirectories:NO];
        [openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
            if(result == NSOKButton) {
                NSString *selectedPath = openPanel.URL.path;
                sourceTextField.stringValue =  selectedPath;
            }
        }];
    } else if(button.tag == OUTPUT_BUTTON) {
        NSSavePanel *savePanel = [NSSavePanel savePanel];
        [savePanel setTitle:@"Select output strings file"];
        [savePanel setAllowedFileTypes:[NSArray arrayWithObject:@"csv"]];
        [savePanel setNameFieldStringValue:@"Localizable"];
        [savePanel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result){
            if(result == NSOKButton) {
                NSString *selectedPath = savePanel.URL.path;               
                outputTextField.stringValue = selectedPath;
            }
        }];
    }
}

- (IBAction)doConvert:(id)sender {
    NSString *strContent = [NSString stringWithContentsOfFile:sourceTextField.stringValue usedEncoding:nil error:nil];
    SAVStringsParser *stringsParser = [[SAVStringsParser alloc] initWithString:strContent];
    NSMutableString *csvContent = [NSMutableString string];
    SAVCSVWriter *csvWriter = [[SAVCSVWriter alloc] initWithMutableString:csvContent];
    NSArray *allKeyValues = [stringsParser keyValues];
    [csvWriter writeNext:[NSArray arrayWithObjects:@"English", @"Gemany", nil]];
    for (Element *element in allKeyValues) {
        NSString *key = element.key;
        NSString *value = element.value;
        [csvWriter writeNext:[NSArray arrayWithObjects:key, value, nil]];        
    }
    [[NSFileManager defaultManager] removeItemAtPath:outputTextField.stringValue error:nil];
    //const char *utf8string = [csvContent UTF8String];
    //NSString *content = [[NSString alloc] initWithUTF8String:utf8string];
    [csvContent writeToFile:outputTextField.stringValue atomically:YES encoding:NSUTF16StringEncoding error:nil];
    NSBeginAlertSheet(@"Cocoa Localized Tool", @"OK", nil, nil, self.view.window, nil, nil, nil, nil, @"CSV file has been created successfully");
}
@end
