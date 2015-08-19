//
//  SAVCSVReader.h
//  ApplicationTemplate
//
//  Created by Tue Nguyen on 10/21/11.
//  Copyright (c) 2011 Savvycom JSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAVCSVReader : NSObject {
@private
    NSString *_csvString;
    NSArray *_lines;
    int _currentLine;
    char _separator;
    char _quoteChar;
    int _skipLines;
    BOOL _lineSkiped;
}
/**
 * Constructs CSVReader using a comma for the separator.
 *
 * @param reader
 *            the reader to an underlying CSV source.
 */
- (id)initWithCSVString:(NSString *)csvString;
/**
 * Constructs CSVReader with supplied separator and quote char.
 *
 * @param reader
 *            the reader to an underlying CSV source.
 * @param separator
 *            the delimiter to use for separating entries
 * @param quotechar
 *            the character to use for quoted elements
 * @param line
 *            the line number to skip for start reading
 */
- (id)initWithCSVString:(NSString *)csvString separator:(char)separator quoteChar:(char)quoteChar skipLine:(int)skipLines;

- (BOOL)hasNext;
/**
 * Reads the next line from the buffer and converts to a string array.
 *
 * @return a string array with each comma-separated element as a separate
 *         entry.
 */
- (NSArray *)next;
@end
