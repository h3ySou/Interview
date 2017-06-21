//
//  APIManager+Auth.h
//  Interview
//
//  Created by Andrew Veresov on 6/20/17.
//  Copyright © 2017 sou. All rights reserved.
//

#import "APIManager.h"

@class User;

@interface APIManager (Auth)

- (void)signupWithUsername:(NSString *)username
                     email:(NSString *)email
                  password:(NSString *)password
                    avatar:(NSData *)avatar
                completion:(void(^)(NSError *error, User *user))completion;

- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
            completion:(void(^)(NSError *error, User *user))completion;

@end
