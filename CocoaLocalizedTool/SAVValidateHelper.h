/** 
 * @file  
 * WIDValidateHelper.h
 * WiseID
 * 
 * Created by Han Dang on 7/4/11.
 * Copyright 2011 Savvycom JSC. All rights reserved.
 * 
 * Define class that support validate operation
 */ 

#import <Foundation/Foundation.h>


/**
 * This class supply common validate functions
 */
@interface SAVValidateHelper : NSObject {
@private

}
/**
 * Check whether input string is a valid email address
 * @param emailValue string to check
 * @return YES if input string is a valid email address, otherwise NO
 */
+ (BOOL) isEmailAddress :(NSString *)emailValue;
/**
 * Check whether input string is Nil/empty or not
 * @param string string to check
 * @return YES if input string is a nil or empty string, otherwise NO
 */
+ (BOOL) isNilOrEmpty:(NSString *)string;
/**
 * Check whether input string contains only space/newline character or not
 * @param string string to check
 * @return YES if input string contains only space/newline character, otherwise NO
 */
+ (BOOL) isBlank:(NSString *)string;
/**
 * Check whether input string is a number or not
 * @param value string to check
 * @return YES if input string is a number, otherwise NO
 */
+ (BOOL) isNumber:(NSString *)value;
/**
 * Check whether input string is a valid phone number or not
 * @param phoneNumber string to check
 * @return YES if input string is a valid phone number, otherwise NO
 */
+ (BOOL) isPhoneNumber:(NSString *)phoneNumber;
/**
 * Check whether input string represented a date or not
 * @param dateValue Date string
 * @param dateFormat Date format
 * @return YES if input string is a date, otherwise NO
 */
+ (BOOL) isDate:(NSString *)dateValue withFormat: (NSString *)dateFormat;
/**
 * Check whether input string is a valid url or not
 * @param urlString string to check
 * @return YES if input string is a valid url, otherwise NO
 */
+ (BOOL) isUrl:(NSString *)urlString;
/**
 * Check whether input string contains only alphabet, number & dot character or not
 * @param alphaNumbericString string to check
 * @return YES if input string contains only alphabet, number & dot character, otherwise NO
 */
+(BOOL) validateAlphaNumericWithDot:(NSString*) alphaNumbericString;
/**
 * Check whether input string contains only alphabet, number character or not
 * @param alphaNumbericString string to check
 * @return YES if input string contains only alphabet, number & dot character, otherwise NO
 */
+(BOOL) validateAlphaNumeric:(NSString*) alphaNumbericString;
@end
