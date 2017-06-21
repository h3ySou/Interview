//
//  APIManager+Auth.m
//  Interview
//
//  Created by Andrew Veresov on 6/20/17.
//  Copyright © 2017 sou. All rights reserved.
//

#import "APIManager+Auth.h"
#import "User.h"

#define kCreate @"create"
#define kLogin @"login"

@implementation APIManager (Auth)

- (void)signupWithUsername:(NSString *)username
                     email:(NSString *)email
                  password:(NSString *)password
                    avatar:(NSData *)avatar
                completion:(void(^)(NSError *error, User *user))completion
{
    NSDictionary *parameters = @{@"username": username,
                                 @"email": email,
                                 @"password": password,
                                 @"avatar": avatar};
    
    [self sendPostWithEndpoint:kCreate
                    parameters:parameters
                    completion:
     ^(NSError *error, NSDictionary *response) {
         
         if (error) {
             completion(error, nil);
         }
         
         if (response) {
             
             NSMutableDictionary *json = [parameters mutableCopy];
             [json addEntriesFromDictionary:response];
             
             User *newUser = [User fromJson:json];
             completion(nil, newUser);
         }
     }];
}

- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
            completion:(void(^)(NSError *error, User *user))completion {
    
    
    NSDictionary *parameters = @{@"email": email,
                                 @"password": password};
    
    [self sendPostWithEndpoint:kLogin
                    parameters:parameters
                    completion:^(NSError *error, NSDictionary *response)
     {
         if (error) {
             completion(error, nil);
         }
         
         if (response) {
             
             NSMutableDictionary *json = [parameters mutableCopy];
             [json addEntriesFromDictionary:response];
             
             User *newUser = [User fromJson:json];
             completion(nil, newUser);
         }
     }];
}

@end
