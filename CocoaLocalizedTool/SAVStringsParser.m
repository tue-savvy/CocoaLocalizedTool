//
//  SAVStringsParser.m
//  Scanner
//
//  Created by Tue Nguyen on 10/19/11.
//  Copyright (c) 2011 Savvycom JSC. All rights reserved.
//

#import "SAVStringsParser.h"

@interface SAVStringsParser (PrivateMethods)
- (void)parser;
- (unichar)nextChar;
@end

@implementation SAVStringsParser
@synthesize keyValues=allKeyValues,dictionaryResult;
- (id)initWithString:(NSString *)string {
    self = [super init];
    if(self) {
        source = [string copy];
        allKeyValues = [[NSMutableArray alloc] init];	
        dictionaryResult = [[NSMutableDictionary alloc] init];
		// decode xml data
		[self parser];
        
        readerIndex = 0;
    }
    return self;
}
- (void)parser {
    Element *stringsElement = nil;
    unichar character = 0;
    unichar prevChar = 0;
    while ((character = [self nextChar]) != 0) {
        //remove white space
        if(character == ' ' || character == '\t' || character == '\n') {
            prevChar = character;
            continue;
        }
        //chart comment
        if(character == '/') {
            //inline comment
            if(prevChar == '/') {
                //readto end of line
                while ((character = [self nextChar]) != 0) {
                    if(character == '\n') break;
                }
            }
            prevChar = character;
            continue;
        }
        if(character == '*') {
            if(prevChar == '/') {//Multiple line comment
                character = [self nextChar];
                prevChar = character;
                while((character = [self nextChar]) != 0) {
                    if(prevChar == '*' && character == '/') //end multiple line comment
                        break;
                    
                    prevChar = character;
                }
            }
        }
        //Read a pair key & value
        if(character == '"') {
            //Read key first
            NSMutableString *stringBuffer = [NSMutableString string];
            prevChar = character;            
            while ((character = [self nextChar]) != 0) {
                //read key
                
                if(character == '"' && prevChar != '\\') {
                    //NSLog(@"String: %@", stringBuffer);
                    
                    break;
                }
                [stringBuffer appendString:[NSString stringWithCharacters:&character length:1]];
                prevChar = character;
            }
            if(stringsElement == nil) {
                stringsElement = [[Element alloc] init];
                stringsElement.key = stringBuffer;
            } else {
                stringsElement.value = stringBuffer;
                [allKeyValues addObject:stringsElement];
                [dictionaryResult setObject:stringsElement.value forKey:stringsElement.key];
                stringsElement = nil;
            }
        }
    }
}
- (unichar)nextChar {
    if(readerIndex < source.length) {
        return [source characterAtIndex:readerIndex++];
    }
    return 0;
}

@end

@implementation Element

@synthesize key,value;

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ => %@", key, value];
}

@end
