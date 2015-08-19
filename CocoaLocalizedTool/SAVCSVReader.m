//
//  SAVCSVReader.m
//  ApplicationTemplate
//
//  Created by Tue Nguyen on 10/21/11.
//  Copyright (c) 2011 Savvycom JSC. All rights reserved.
//

#import "SAVCSVReader.h"

#define DEFAULT_SEPARATOR ','
#define DEFAULT_QUOTE_CHAR '"'
#define DEFAULT_SKIP_LINE 0

@interface SAVCSVReader (PrivateMethods)
- (NSString *)readNextLine;
- (NSArray *)parserLine:(NSString *)lineString;
@end

@implementation SAVCSVReader

- (id)initWithCSVString:(NSString *)csvString {
    return [self initWithCSVString:csvString separator:DEFAULT_SEPARATOR quoteChar:DEFAULT_QUOTE_CHAR skipLine:DEFAULT_SKIP_LINE];
}
- (id)initWithCSVString:(NSString *)csvString separator:(char)separator quoteChar:(char)quoteChar skipLine:(int)skipLines {
    self = [super init];
    
    if (self) {
        _csvString = [csvString retain];
        _separator = separator;
        _quoteChar = quoteChar;
        _skipLines = skipLines;
        _lines = [_csvString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        _currentLine = 0;
    }
    
    return self;
}

- (void)dealloc {
    [_csvString release];
    [super dealloc];
}

- (BOOL)hasNext {
    return _currentLine < _lines.count;
}

- (NSArray *)next {
    if([self hasNext]) {
        NSString *nextLine = [self readNextLine];
        
        return [self parserLine:nextLine];
    } else {
        return nil;
    }
}

#pragma mark - Private Methods
- (NSString *)readNextLine {
    if(!_lineSkiped) {
        _currentLine = _skipLines;
        _lineSkiped = YES;
    }
    
    if([self hasNext]) {
        return [_lines objectAtIndex:_currentLine++];
    } else {
        return nil;
    }
    
}
/**
 * Parses an incoming String and returns an array of elements.
 *
 * @param nextLine
 *            the string to parse
 * @return the comma-tokenized list of elements, or null if nextLine is null
 */
- (NSArray *)parserLine:(NSString *)lineString {
    NSLog(@"Line: %@", lineString);
    if(lineString == nil) return nil;
    BOOL inQuotes = NO;
    NSMutableArray *tokensOnThisLine = [NSMutableArray array];
    NSMutableString *sb = [NSMutableString string];
    do {
        if(inQuotes) {
            //continuing a quoted section, reappend newline
            [sb appendString:@"\n"];
            lineString = [self readNextLine];
            if (lineString == nil) break;
        }
        for (NSUInteger i = 0; i < lineString.length; i++) {
            unichar c = [lineString characterAtIndex:i];
            if (c == _quoteChar) {
                if (inQuotes
                    && lineString.length > (i + 1)
                    && [lineString characterAtIndex: i + 1] == _quoteChar) {
                    unichar c = [lineString characterAtIndex: i + 1];
                    [sb appendString:[NSString stringWithCharacters:&c length:1]];
                    i++;
                } else {
                    inQuotes = !inQuotes;
                    if (i > 1
                        && [lineString characterAtIndex:i - 1] != _separator
                        && lineString.length > i + 1
                        && [lineString characterAtIndex: i + 1] != _separator) {
                        [sb appendString:[NSString stringWithCharacters:&c length:1]];
                    }
                }
            } else if (c == _separator && !inQuotes) {
                [tokensOnThisLine addObject:sb];
                sb = [NSMutableString string];
            } else {
                [sb appendString:[NSString stringWithCharacters:&c length:1]];
            }
        }
    } while (inQuotes);
    [tokensOnThisLine addObject:sb];
    return tokensOnThisLine;
}
@end
