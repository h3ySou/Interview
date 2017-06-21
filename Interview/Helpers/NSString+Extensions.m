//
//  NSString+Extensions.m
//  Interview
//
//  Created by Andrew Veresov on 6/21/17.
//  Copyright © 2017 sou. All rights reserved.
//

#import "NSString+Extensions.h"

@implementation NSString (Extensions)

- (BOOL)isValidEmail {
    
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidPassword {
    
    BOOL specialCharacter = NO;
    BOOL punctuationCharacter = NO;
    BOOL whitespaceCharacter = NO;
    BOOL digit = NO;
    BOOL uperCharacter = YES;
    if ([self length] >= 4)
    {
        for (int i = 0; i < [self length]; i++)
        {
            unichar c = [self characterAtIndex:i];
            
            if(!whitespaceCharacter)
            {
                whitespaceCharacter = [[NSCharacterSet whitespaceCharacterSet] characterIsMember:c];
            }
            if(!specialCharacter)
            {
                specialCharacter = [[NSCharacterSet symbolCharacterSet] characterIsMember:c];
            }
            if(!punctuationCharacter)
            {
                punctuationCharacter = [[NSCharacterSet punctuationCharacterSet] characterIsMember:c];
            }
            if(!digit)
            {
                digit = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c];
            }
            if(!uperCharacter)
            {
                uperCharacter = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:c];
            }
        }
        
        return (uperCharacter && digit && !whitespaceCharacter && !punctuationCharacter);
        
    } else {
        return NO;
    }
}

- (BOOL)isValidName {
    
    BOOL specialCharacter = NO;
    BOOL punctuationCharacter = NO;
    BOOL whitespaceCharacter = YES;
    
    if([self length] >= 4) {
        
        for (int i = 0; i < [self length]; i++) {
            unichar c = [self characterAtIndex:i];
            
            if(!whitespaceCharacter)
            {
                whitespaceCharacter = [[NSCharacterSet whitespaceCharacterSet] characterIsMember:c];
            }
            if(!specialCharacter)
            {
                specialCharacter = [[NSCharacterSet symbolCharacterSet] characterIsMember:c];
            }
            if(!punctuationCharacter)
            {
                punctuationCharacter = [[NSCharacterSet punctuationCharacterSet] characterIsMember:c];
            }
        }
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isEmpty {
    return self.length == 0 || [self isEqualToString:@""];
}

@end
