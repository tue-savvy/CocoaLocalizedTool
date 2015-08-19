//
//  SAVStringsParser.h
//  Scanner
//
//  Created by Tue Nguyen on 10/19/11.
//  Copyright (c) 2011 Savvycom JSC. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef struct _SAVStringsElement {
    char *key;
    char *value;
} SAVStringsElement;
@interface SAVStringsParser : NSObject {
    char * bytes;
    NSInteger readerIndex;
	long bytesLength;
    NSString *source;
    NSMutableArray *allKeyValues;
    NSMutableDictionary *dictionaryResult;
}
@property (nonatomic, readonly) NSArray *keyValues;
@property (nonatomic, readonly) NSDictionary *dictionaryResult;
- (id)initWithString:(NSString *)string;

@end

@interface Element : NSObject {
@private
    NSString *key;
    NSString *value;
}
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;
@end
