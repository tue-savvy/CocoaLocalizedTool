//
//  SAVCSVWriter.m
//  ApplicationTemplate
//
//  Created by Tue Nguyen on 10/21/11.
//  Copyright (c) 2011 Savvycom JSC. All rights reserved.
//

#import "SAVCSVWriter.h"
#define DEFAULT_ESCAPE_CHARACTER '"'
#define DEFAULT_SEPARATOR ','
#define DEFAULT_QUOTE_CHAR '"'
#define NO_QUOTE_CHARACTER '\0'
#define NO_ESCAPE_CHARACTER '\0'
#define DEFAULT_LINE_END @"\n"

@implementation SAVCSVWriter
- (id)initWithMutableString:(NSMutableString *)writer {
    
    return [self initWithMutableString:writer separator:DEFAULT_SEPARATOR quotechar:DEFAULT_QUOTE_CHAR escapechar:DEFAULT_ESCAPE_CHARACTER lineEnd:DEFAULT_LINE_END];
}
- (id)initWithMutableString:(NSMutableString *)writer separator:(unichar)separator quotechar:(unichar)quotechar escapechar:(unichar)escapechar lineEnd:(NSString *)lineEnd {
    self = [super init];
    if(self) {
        _writer = [writer retain];
        _separator = separator;
        _quotechar = quotechar;
        _escapechar = escapechar;
        _lineEnd = [lineEnd retain];
    }
    
    return self;
}
- (void)writeNext:(NSArray *)nextLine {
    if(nextLine == nil) return;
    
    NSMutableString *sb = [NSMutableString string];
    
    for (NSInteger i = 0; i < nextLine.count; i++) {
        if (i != 0) {
            [sb appendString:[NSString stringWithCharacters:&_separator length:1]];
        }
        
        NSString *nextElement = [nextLine objectAtIndex:i];
        if(nextElement == nil) continue;
        
        if (_quotechar != NO_QUOTE_CHARACTER) {
            [sb appendString:[NSString stringWithCharacters:&_quotechar length:1]];
        }
        for (int j = 0; j < nextElement.length; j++) {
            unichar nextChar = [nextElement characterAtIndex:j];
            if (_escapechar != NO_ESCAPE_CHARACTER && nextChar == _quotechar) {
                [sb appendString:[NSString stringWithCharacters:&_escapechar length:1]];
                [sb appendString:[NSString stringWithCharacters:&nextChar length:1]];
            } else if (_escapechar != NO_ESCAPE_CHARACTER && nextChar == _escapechar) {
                [sb appendString:[NSString stringWithCharacters:&_escapechar length:1]];
                [sb appendString:[NSString stringWithCharacters:&nextChar length:1]];
            } else {
                [sb appendString:[NSString stringWithCharacters:&nextChar length:1]];
            }
        }
        if (_quotechar != NO_QUOTE_CHARACTER) {
            [sb appendString:[NSString stringWithCharacters:&_quotechar length:1]];
        }        
    }
    [sb appendString:_lineEnd];
    [_writer appendString:sb];
}
- (void)dealloc {
    [_lineEnd release];
    [_writer release];
    [super dealloc];
}
@end
