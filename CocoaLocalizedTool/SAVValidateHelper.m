/** 
 * @file  
 * WIDValidateHelper.m
 * WiseID
 * 
 * Created by Han Dang on 7/4/11.
 * Copyright 2011 Savvycom JSC. All rights reserved.
 * 
 * Implemenation of SAVValidateHelper
 */ 
#import "SAVValidateHelper.h"

NSString *const DATE_FORMAT_STRING = @"yyyy-MM-dd";
@implementation SAVValidateHelper


+ (BOOL) isEmailAddress :(NSString *)emailValue {    
    //BOOL stricterFilter = YES; 
    NSString *emailFormat = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailFormat];
    return [emailTest evaluateWithObject:emailValue];
}
+ (BOOL) isNilOrEmpty:(NSString *)string {
    if(string != nil && [string length] > 0) {
        return NO;
    }
    return YES;
}

+ (BOOL) isBlank:(NSString *)string {
    if(string != nil && [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {
        return NO;
    }
    return YES;
}

+ (BOOL) isNumber:(NSString *)value
{
	NSString *numberFormat = @"^[0-9]*$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberFormat];
    return [numberTest evaluateWithObject:value];
}
+ (BOOL) isPhoneNumber:(NSString *)phoneNumber {
    NSString *numberFormat = @"^[0-9 \t]*$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberFormat];
    return [numberTest evaluateWithObject:phoneNumber];
}
+ (BOOL) isUrl:(NSString *)urlString
{    
	NSString *urlRegEx = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([-|\\.|;|/|?|=|%|#|+|&|:]((\\w)*|([0-9]*)|([-|_|#|%|+])*))+";
//    NSString *urlRegEx = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx]; 
    return [urlTest evaluateWithObject:[urlString lowercaseString]];
}

+ (BOOL) isDate:(NSString *)dateValue withFormat: (NSString *)dateFormat
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:dateFormat];
    NSDate *myDate = [df dateFromString: dateValue];
    [df release];
    if(myDate == nil)
    {
        return NO;
    }
    else {
        return YES;
    }

}

+(BOOL) validateAlphaNumericWithDot:(NSString*) alphaNumbericString
{
	NSString *regexString = @"^[a-zA-Z0-9.]*$";
	NSPredicate *alphaNumbericTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
	return [alphaNumbericTest evaluateWithObject:alphaNumbericString];
}

+(BOOL) validateAlphaNumeric:(NSString*) alphaNumbericString
{
	NSString *regexString = @"^[a-zA-Z0-9]*$";
	NSPredicate *alphaNumbericTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
	return [alphaNumbericTest evaluateWithObject:alphaNumbericString];
}
@end
