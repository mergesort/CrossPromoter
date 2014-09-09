//
//  NSString+Validation.h
//  Joseph Fabisevich
//
//  Created by Joe on 9/9/12.
//  Copyright (c) 2012 mergesort. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Validation)

- (NSString *)punctuationRemovedString;
- (BOOL)containsString:(NSString *)subString;
+ (BOOL)isEmptyString:(NSString *)string;
- (BOOL)isValidEmail;
- (NSString *)URLEncodedString;

NSString * emptyIfNil(NSString *string);

@end