//
//  NSString+Validation.m
//  Joseph Fabisevich
//
//  Created by Joe on 9/9/12.
//  Copyright (c) 2012 mergesort. All rights reserved.
//

#import "NSString+Validation.h"


@implementation NSString (Validation)

- (NSString *)punctuationRemovedString
{
    NSString *currString = self;
    NSInteger stringLength = (currString.length - 1);

    char lastChar = [currString characterAtIndex:stringLength];

    if (lastChar == '?' || lastChar == '!' || lastChar == '.' || lastChar == ',')
    {
        currString = [currString substringToIndex:stringLength];
    }
    
    return currString;
}

- (BOOL)containsString:(NSString *)subString
{
    return [self rangeOfString:subString].location != NSNotFound;
}

+ (BOOL)isEmptyString:(NSString *)string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0;
}

- (BOOL)isValidEmail
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
}

- (NSString *)URLEncodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR("!*'\"();:@&=+$,/?%#[]% "), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    return result;
}

NSString * emptyIfNil(NSString *string)
{
    return string.length > 0 ? string : @"";
}

@end