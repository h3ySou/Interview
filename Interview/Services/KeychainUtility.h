//
//  KeychainUtility.h
//  Interview
//
//  Created by Andrew Veresov on 6/21/17.
//  Copyright © 2017 sou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface KeychainUtility : NSObject

+ (NSString *)passwordForLoggedUser;
+ (NSString *)tokenForLoggedUser;
+ (NSString *)tokenForAccount:(NSString *)account;

+ (void)configureUser:(User *)user
            withToken:(NSString *)token
             password:(NSString *)password;

+ (void)removeUserCredentionals;

@end
