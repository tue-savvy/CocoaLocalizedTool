//
//  CocoaLocalizedToolAppDelegate.m
//  CocoaLocalizedTool
//
//  Created by Tue Nguyen on 10/4/11.
//  Copyright 2011 Savvycom JSC. All rights reserved.
//

#import "CocoaLocalizedToolAppDelegate.h"
#import "SAVStringsParser.h"

static  NSString *tempPath = @"/tmp/CocoaLocalizedApp";

@implementation CocoaLocalizedToolAppDelegate
@synthesize pathTextField;
@synthesize chooseButton;
@synthesize generateButton;
@synthesize indicatorControl;
@synthesize messageLabel;
@synthesize mergingViewController;
@synthesize convertViewController;
@synthesize mergingTabContentView;
@synthesize convertTabContentView;
@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    mergingViewController.view.frame = mergingTabContentView.bounds;
    [mergingTabContentView addSubview:mergingViewController.view];
    
    convertViewController.view.frame = convertTabContentView.bounds;
    [convertTabContentView addSubview:convertViewController.view];
}
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

- (IBAction)doChooseDirectory:(id)sender {
    NSOpenPanel *openDirectory = [[NSOpenPanel alloc] init];
    openDirectory.canChooseDirectories = YES;
    openDirectory.canChooseFiles = NO;
    openDirectory.allowsMultipleSelection = NO;
    [openDirectory beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if(result == NSOKButton) {
            NSURL *selectedURL = [[openDirectory URLs] lastObject];
            pathTextField.stringValue = [selectedURL path];
        }
    }];
}

- (IBAction)doGenerate:(id)sender {
    
    if([self validate]) {
        
        NSThread *t = [[NSThread alloc] initWithTarget:self selector:@selector(startGenerate) object:nil];
        [t start];
        [t release];
    } else {
        NSBeginCriticalAlertSheet(@"Cocoa Localized Tool", @"OK", nil, nil, self.window, nil, nil, nil, nil, @"Please check the project source directory!");
    }
}
- (BOOL)validate {
    //Validate
    BOOL ret = NO;
    BOOL isDirectory = NO;
    //Check blank
    if([[pathTextField.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        ret = NO;
    } else if([[NSFileManager defaultManager] fileExistsAtPath:pathTextField.stringValue isDirectory:&isDirectory]) {
        ret = isDirectory;
    }
    return ret;
}
- (void)beginGenerate {
    [chooseButton setEnabled:NO];
    [generateButton setHidden:YES];
    [pathTextField setEnabled:NO];
    [indicatorControl setHidden:NO];
    [indicatorControl startAnimation:nil];
    [messageLabel setHidden:NO];
}
- (void)endGenerate {
    [chooseButton setEnabled:YES];
    [generateButton setHidden:NO];
    [pathTextField setEnabled:YES];
    [indicatorControl setHidden:YES];
    [indicatorControl stopAnimation:nil];
    [messageLabel setHidden:YES];
    NSBeginAlertSheet(@"Cocoa Localized Tool", @"OK", nil, nil, self.window, nil, nil, nil, nil, @"Localizable string file has been generated successfully. Please check your file at the Desktop directory");
}

- (void)updateStatusLabel:(NSString *)message {
    self.messageLabel.stringValue = message;
}

- (void)startGenerate {
    [self performSelectorOnMainThread:@selector(beginGenerate) withObject:nil waitUntilDone:NO];
    NSString *outputDirectory = @"/tmp";
    NSString *desktopDirectory = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) lastObject];
    //NSString *xibLocalizableStringFile = [tempPath stringByAppendingPathComponent:@"LocalizedXIB.strings"];
    [self generateLocalizedStringFile:outputDirectory];
    //[self copyXIBFile:tempPath];
    //[self generateXIBSLocalizableStringFile:tempPath];
    //[self mergeAllXIBStringFrom:tempPath toOneFile:xibLocalizableStringFile];
    //NSDictionary *xibKeyValue = [self collectAllKeyAndValue:xibLocalizableStringFile XIBString:YES];
    NSDictionary *sourceKeyValue = [self collectAllKeyAndValue:[outputDirectory stringByAppendingPathComponent:@"Localizable.strings"] XIBString:NO];
    //JOIN 2 DICTIONARY
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result addEntriesFromDictionary:sourceKeyValue];
    
    //Write localized dictionary to files
    NSMutableString *fileContent = [NSMutableString string];
    [fileContent appendString:@"/*The content below is generated automatically by LocalizationTool v1.1*/\n"];
    for (NSString *key in result) {
        NSString *value = [result objectForKey:key];
        
        [fileContent appendFormat:@"\"%@\" = \"%@\";\n", key, value];
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    
    [fm removeItemAtPath:[desktopDirectory stringByAppendingPathComponent:@"Localizable.strings"] error:nil];
    
    [fileContent writeToFile:[desktopDirectory stringByAppendingPathComponent:@"Localizable.strings"] atomically:YES encoding:NSUTF16StringEncoding error:nil];
    NSLog(@"DONE");
    [self performSelectorOnMainThread:@selector(endGenerate) withObject:nil waitUntilDone:NO];
}
- (void)generateLocalizedStringFile:(NSString *)outputDirectory {
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if(![fm fileExistsAtPath:outputDirectory]) {
        [fm createDirectoryAtPath:outputDirectory withIntermediateDirectories:YES attributes:nil error:nil];        
    }
    [fm removeItemAtPath:[outputDirectory stringByAppendingPathComponent:@"Localizable.strings"] error:nil];
    
    NSLog(@"Generate Localized string file for source files");
    [self performSelectorOnMainThread:@selector(updateStatusLabel:) withObject:@"Generate Localized string file for source files"waitUntilDone:NO];
    NSString *projectPath = pathTextField.stringValue;
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: @"/usr/bin/find"];
    
    NSArray *arguments;
    arguments = [NSArray arrayWithObjects: projectPath, @"-name", @"*.m", @"-exec",  @"genstrings", @"-a", @"-o", outputDirectory, @"{}", @";", nil];
    [task setArguments: arguments];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data;
    data = [file readDataToEndOfFile];
    
    NSString *string;
    string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    NSLog (@"Result returned:\n%@", string);
    
    [string release];
    [task release];
}
- (void)copyXIBFile:(NSString *)outputDirectory {
    NSLog(@"Coping XIB Files");
    [self performSelectorOnMainThread:@selector(updateStatusLabel:) withObject:@"Coping XIB Files" waitUntilDone:NO];
    //Clear output directory
    [self clearContent:outputDirectory];
    NSError *error = nil;
    NSFileManager *fm = [NSFileManager defaultManager];
    
    [fm createDirectoryAtPath:outputDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    if(error) NSLog(@"Create directory error: %@", error);
    
    //Copy xib file
    NSString *projectPath = pathTextField.stringValue;
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: @"/usr/bin/find"];
    
    NSArray *arguments;
    arguments = [NSArray arrayWithObjects: projectPath, @"-name", @"*.xib", @"-exec",  @"cp", @"{}", outputDirectory, @";", nil];
    [task setArguments: arguments];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data;
    data = [file readDataToEndOfFile];
    
    NSString *string;
    string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    NSLog (@"Result returned:\n%@", string);
    
    [string release];
    [task release];
}
- (void)clearContent:(NSString *)directory {
    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:directory]) {
        NSError *error;
        [fm removeItemAtPath:directory error:&error];
        if(error) NSLog(@"Error: %@", error);
    }
}
- (void)generateXIBSLocalizableStringFile:(NSString *)directory {
    NSLog(@"generateXIBSLocalizableStringFile %@", directory);
    [self performSelectorOnMainThread:@selector(updateStatusLabel:) withObject:@"Generating XIB localizable string files..." waitUntilDone:NO];
    //Copy xib file
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: @"/usr/bin/find"];
    
    NSArray *arguments;
    arguments = [NSArray arrayWithObjects: directory, @"-name", @"*.xib", @"-exec",  @"ibtool", @"--generate-strings-file", @"{}.strings", @"{}", @";", nil];
    [task setArguments: arguments];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data;
    data = [file readDataToEndOfFile];
    
    NSString *string;
    string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    
    NSLog (@"Result returned:\n%@", string);    
    [string release];
    [task release];
    
}
- (void)mergeAllXIBStringFrom:(NSString *)xibsPath toOneFile:(NSString *)outputFile {
    NSFileManager *fm = [NSFileManager defaultManager];    
    NSLog(@"mergeAllXIBStringFrom %@ to %@", xibsPath, outputFile);
    [self performSelectorOnMainThread:@selector(updateStatusLabel:) withObject:@"Merge all xib string files..." waitUntilDone:NO];
    NSError *error = nil;
    NSArray *allFiles = [fm contentsOfDirectoryAtPath:xibsPath error:&error];
    NSMutableData *data = [NSMutableData data];
    for (NSString *fileName in allFiles) {
        if([[fileName pathExtension] isEqualToString:@"strings"]) {
            NSLog(@"File: %@", fileName);
            [data appendData:[NSData dataWithContentsOfFile:[xibsPath stringByAppendingPathComponent:fileName]]];
        }
    }
    //[fm createFileAtPath:outputFile contents:nil attributes:nil];
    [data writeToFile:outputFile atomically:YES];
}
- (NSDictionary *)collectAllKeyAndValue:(NSString *)file XIBString:(BOOL)isXIBString {
    NSLog(@"collectAllKeyAndValue for %@", file);
    [self performSelectorOnMainThread:@selector(updateStatusLabel:) withObject:@"Collecting key and value pair..." waitUntilDone:NO];
    NSError *error = nil;
    NSString *fileContent = [NSString stringWithContentsOfFile:file usedEncoding:NULL error:&error];
    
    SAVStringsParser *parser = [[SAVStringsParser alloc] initWithString:fileContent];
    
    return [parser dictionaryResult];
    
    
    
//    NSArray *allLines = [fileContent componentsSeparatedByString:@"\n"];
//    NSMutableDictionary *result = [NSMutableDictionary dictionary];
//    for (NSString *line in allLines) {
//        line = [line stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \n\t\ufeff"]];
//        
//        if ([line isEqualToString:@""]) continue;//By pass all empty lines
//        
//        if ([line rangeOfString:@"/*"].location == 0) continue;//By pass all comment lines
//        line = [line stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@";"]];
//        NSArray *keyValue = [line componentsSeparatedByString:@" = "];
//        if(keyValue.count == 2) {
//            NSString *key = [keyValue objectAtIndex:0];            
//            NSString *value = [keyValue objectAtIndex:1];
//            key = [key substringWithRange:NSMakeRange(1, key.length - 2)];
//            value = [value substringWithRange:NSMakeRange(1, value.length - 2)];
//            if(isXIBString) key = value;
//            
//            if([result objectForKey:key] == nil) {
//                [result setObject:value forKey:key];
//            }
//        } else {
//            NSLog(@"=======================");
//            NSLog(@"Exception in line: %@", line);
//        }
//    }
//    return result;
}
@end
