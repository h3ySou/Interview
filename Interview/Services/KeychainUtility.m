//
//  KeychainUtility.m
//  Interview
//
//  Created by Andrew Veresov on 6/21/17.
//  Copyright © 2017 sou. All rights reserved.
//

#import "KeychainUtility.h"
#import <SAMKeychain.h>

#import "User.h"

#define kPassword @"password"
#define kToken    @"token"

@implementation KeychainUtility

+ (NSString *)passwordForLoggedUser {
    
    User *user = [User currentUser];
    return [SAMKeychain passwordForService:kPassword account:user.email];
}

+ (NSString *)tokenForLoggedUser {
    
    User *user = [User currentUser];
    return [SAMKeychain passwordForService:kToken account:user.email];
}

+ (NSString *)tokenForAccount:(NSString *)account {
    return [SAMKeychain passwordForService:kToken account:account];
}

+ (void)configureUser:(User *)user
            withToken:(NSString *)token
             password:(NSString *)password {
    
    [SAMKeychain deletePasswordForService:kPassword account:user.email];
    [SAMKeychain deletePasswordForService:kToken account:user.email];
    
    [SAMKeychain setPassword:password forService:kPassword account:user.email];
    [SAMKeychain setPassword:token forService:kToken account:user.email];
}

+ (void)removeUserCredentionals {
    
    User *user = [User currentUser];
    [SAMKeychain deletePasswordForService:kPassword account:user.email];
    [SAMKeychain deletePasswordForService:kToken account:user.email];
}

@end
