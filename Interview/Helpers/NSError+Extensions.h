//
//  NSError+Extensions.h
//  Interview
//
//  Created by Andrew Veresov on 6/20/17.
//  Copyright © 2017 sou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Extensions)

+ (NSError*)errorWithCode:(NSString *)code description:(NSString *)description;

@end
