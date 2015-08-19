//
//  MergingViewController.m
//  CocoaLocalizedTool
//
//  Created by Tue Nguyen on 10/20/11.
//  Copyright (c) 2011 Savvycom JSC. All rights reserved.
//

#import "MergingViewController.h"
#import "SAVValidateHelper.h"
#import "SAVStringsParser.h"

#define SOURCE_BUTTON 1000
#define DESTINATION_BUTTON 1001
#define OUTPUT_BUTTON 1002
@interface MergingViewController(PrivateMethods)
- (BOOL)validate:(NSString **)errorMessage;
- (NSDictionary *)merge:(NSDictionary *)source withData:(NSDictionary *)destination override:(BOOL)override;
@end
@implementation MergingViewController
@synthesize mergingButton;
@synthesize overrideCheckBox;
@synthesize sourceTextField;
@synthesize destinationTextField;
@synthesize outputTextField;
@synthesize mergeNewStringSourcePathCheckbox;

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
    
    if(button.tag == SOURCE_BUTTON || button.tag == DESTINATION_BUTTON) {
        NSOpenPanel *openPanel = [NSOpenPanel openPanel];
        [openPanel setAllowedFileTypes:[NSArray arrayWithObject:@"strings"]];
        [openPanel setCanChooseDirectories:NO];
        [openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
            if(result == NSOKButton) {
                NSString *selectedPath = openPanel.URL.path;
                if(button.tag == SOURCE_BUTTON) sourceTextField.stringValue =  selectedPath;
                else destinationTextField.stringValue = selectedPath;
            }
        }];
    } else if(button.tag == OUTPUT_BUTTON) {
        NSSavePanel *savePanel = [NSSavePanel savePanel];
        [savePanel setTitle:@"Select output strings file"];
        [savePanel setAllowedFileTypes:[NSArray arrayWithObject:@"strings"]];
        [savePanel setNameFieldStringValue:@"Localizable"];
        [savePanel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result){
            if(result == NSOKButton) {
                NSString *selectedPath = savePanel.URL.path;               
                outputTextField.stringValue = selectedPath;
            }
        }];
    }
}

- (IBAction)doMerging:(id)sender {
    NSString *errorMessage = nil;
    if(![self validate:&errorMessage]) {
        NSBeginCriticalAlertSheet(@"Cocoa Localized Tool", @"OK", nil, nil, self.view.window, nil, nil, nil, nil, errorMessage);
    } else {
        NSError *error = nil;
        NSStringEncoding *enc = NULL;
        NSString *sourceContent = [NSString stringWithContentsOfFile:sourceTextField.stringValue usedEncoding:enc error:&error];
        NSString *destinationContent = [NSString stringWithContentsOfFile:destinationTextField.stringValue usedEncoding:enc error:&error];
        SAVStringsParser *parser = [[SAVStringsParser alloc] initWithString:sourceContent];
        NSDictionary *sourceKeyValues = parser.dictionaryResult;
        parser = [[SAVStringsParser alloc] initWithString:destinationContent];
        NSDictionary *desKeyValues = parser.dictionaryResult;
        
        
        
//        NSMutableDictionary *dufflicateResult = [NSMutableDictionary dictionary];
//        NSMutableDictionary *sourceOutResult = [NSMutableDictionary dictionary];
//        NSMutableDictionary *desOutResult = [NSMutableDictionary dictionary];
        [self merge:sourceKeyValues withData:desKeyValues override:overrideCheckBox.state == NSOnState];
        
        
        NSBeginAlertSheet(@"Cocoa Localized Tool", @"OK", nil, nil, self.view.window, nil, nil, nil, nil, @"Merging file successfully. Please check your output directory.");
    }
}
- (NSDictionary *)merge:(NSDictionary *)source withData:(NSDictionary *)destination override:(BOOL)override {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSMutableDictionary *dufflicateResult = [NSMutableDictionary dictionary];
    NSMutableDictionary *sourceOutResult = [NSMutableDictionary dictionary];
    NSMutableDictionary *desOutResult = [NSMutableDictionary dictionaryWithDictionary:destination];
    
    NSMutableDictionary *normalizeDesKey = [NSMutableDictionary dictionary];
    for (NSString *key in destination) {
        NSString *normalizeKey = [key stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \t\n\r:\"\'"]];
        normalizeKey = [normalizeKey lowercaseString];
        [normalizeDesKey setObject:key forKey:normalizeKey];
    }
    
    for (NSString *key in source) {
        NSString *value = [source objectForKey:key];
        
        NSString *normalizeKey = [key stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \t\n\r:\"\'"]];
        normalizeKey = [normalizeKey lowercaseString];
        NSString *desKey = [normalizeDesKey objectForKey:normalizeKey];
        
        NSString *desValue = [destination objectForKey:key];
        
        if(desValue == nil && desKey != nil) {
            desValue = [destination objectForKey:desKey];
            if(desValue != nil) key = desKey;
        }
        
        if(desValue == nil) {
            [sourceOutResult setObject:value forKey:key];
            [result setObject:value forKey:key];
        } else {
            [desOutResult removeObjectForKey:key];
            override ? [dufflicateResult setObject:value forKey:key] : [dufflicateResult setObject:desValue forKey:key];
            override ? [result setObject:value forKey:key] : [result setObject:desValue forKey:key];
        }
    }
    
    NSString *outPath = outputTextField.stringValue;
    
    NSMutableString *fileContent = [NSMutableString string];
    
    [fileContent appendString:@"/* Dupplicate Strings in two files */\n"];
    for (id key in dufflicateResult) {
        id value = [dufflicateResult objectForKey:key];
        [fileContent appendFormat:@"\"%@\" = \"%@\";\n", key, value];
    }
    [fileContent appendString:@"\n\n/* Strings in Destination file */\n"];
    for (id key in desOutResult) {
        id value = [desOutResult objectForKey:key];
        [fileContent appendFormat:@"\"%@\" = \"%@\";\n", key, value];
    }
    if(mergeNewStringSourcePathCheckbox.state == NSOnState) {
        [fileContent appendString:@"\n\n/* Strings in Source file */\n"];
        for (id key in sourceOutResult) {
            id value = [sourceOutResult objectForKey:key];
            [fileContent appendFormat:@"\"%@\" = \"%@\";\n", key, value];
        }
    }
    
    [fileContent writeToFile:outPath atomically:YES encoding:NSUTF16StringEncoding error:nil];
    
    return result;
}
- (BOOL)validate:(NSString **)errorMessage {
    BOOL result = NO;
    *errorMessage = @"";
    
    if([SAVValidateHelper isBlank:sourceTextField.stringValue]) {
        *errorMessage = @"Please select source path";
    } else if ([SAVValidateHelper isBlank:destinationTextField.stringValue]) {
        *errorMessage = @"Please select destination path";
    } else if ([SAVValidateHelper isBlank:outputTextField.stringValue]) {
        *errorMessage = @"Please select output path";
    } else {
        result = YES;
    }
    
    
    return result;
}
@end
