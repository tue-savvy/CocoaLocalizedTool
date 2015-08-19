//
//  SAVCSVWriter.h
//  ApplicationTemplate
//
//  Created by Tue Nguyen on 10/21/11.
//  Copyright (c) 2011 Savvycom JSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAVCSVWriter : NSObject {
@private
    NSMutableString *_writer;
    unichar _separator;
    unichar _quotechar;
    unichar _escapechar;
    NSString *_lineEnd;
}
/**
 * Constructs CSVWriter using a comma for the separator.
 *
 * @param writer
 *            the writer to an underlying CSV source.
 */
- (id)initWithMutableString:(NSMutableString *)writer;
/**
 * Constructs CSVWriter with supplied separator, quote char, escape char and line ending.
 *
 * @param writer
 *            the writer to an underlying CSV source.
 * @param separator
 *            the delimiter to use for separating entries
 * @param quotechar
 *            the character to use for quoted elements
 * @param escapechar
 *            the character to use for escaping quotechars or escapechars
 * @param lineEnd
 *                    the line feed terminator to use
 */
- (id)initWithMutableString:(NSMutableString *)writer separator:(unichar)separator quotechar:(unichar)quotechar escapechar:(unichar)escapechar lineEnd:(NSString *)lineEnd;
/**
 * Writes the next line to the file.
 *
 * @param nextLine
 *            a string array with each comma-separated element as a separate
 *            entry.
 */
- (void)writeNext:(NSArray *)nextLine;
@end
