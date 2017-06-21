//
//  NSError+Extensions.m
//  Interview
//
//  Created by Andrew Veresov on 6/20/17.
//  Copyright © 2017 sou. All rights reserved.
//

#import "NSError+Extensions.h"

@implementation NSError (Extensions)

+ (NSError*)errorWithCode:(NSString *)code description:(NSString *)description {
    return [NSError errorWithDomain:NSCocoaErrorDomain code:[code integerValue] userInfo:@{NSLocalizedDescriptionKey:description}];
}

@end
