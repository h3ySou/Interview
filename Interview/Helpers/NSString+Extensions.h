//
//  NSString+Extensions.h
//  Interview
//
//  Created by Andrew Veresov on 6/21/17.
//  Copyright © 2017 sou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extensions)

- (BOOL)isValidEmail;
- (BOOL)isValidPassword;
- (BOOL)isValidName;
- (BOOL)isEmpty;

@end
