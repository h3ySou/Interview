//
//  User.m
//  Interview
//
//  Created by Andrew Veresov on 6/20/17.
//  Copyright © 2017 sou. All rights reserved.
//

#import "User.h"
#import "KeychainUtility.h"

#define kIsValidObject(object)          (([NSNull null] != object) && (nil != object))

@interface User()

@end

@implementation User

#pragma mark - Initialization

- (instancetype)initWithUsername:(NSString *)username
                           email:(NSString *)email
                       avatarURL:(NSString *)avatarURL
{
    self = [super init];
    
    if (self) {
        self.username = username;
        self.email = email;
        self.avatarURL = avatarURL;
    }
    
    return self;
}

#pragma mark - Public

+ (User *)fromJson:(NSDictionary *)json {

    User *user = [[User alloc] init];
    
    if (kIsValidObject(json[@"username"])) {
        NSString *username = json[@"username"];
        user.username = username;
    } else {
        user.username = @"";
    }
    
    if (kIsValidObject(json[@"email"])) {
        NSString *email = json[@"email"];
        user.email = email;
    } else {
        user.email = @"";
    }
    
    if (kIsValidObject(json[@"avatar"])) {
        NSString *avatarURL = json[@"avatar"];
        
        user.avatarURL = avatarURL;
    } else {
        user.avatarURL = @"";
    }
    
    NSString *token = @"";
    NSString *password = @"";
    
    if (kIsValidObject(json[@"token"])) {
        NSString *jsonToken = json[@"token"];
        
        token = jsonToken;
    }
    
    if (kIsValidObject(json[@"password"])) {
        NSString *jsonPassword = json[@"password"];
        
        password = jsonPassword;
    }
    
    [User saveWithUser:user token:token password:password];
    
    return user;
}

+ (void)saveWithUser:(User *)user
               token:(NSString *)token
            password:(NSString *)password {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:@"username"];
    
    [defaults setObject:user.email forKey:@"email"];
    [defaults setObject:user.avatarURL forKey:@"avatarURL"];
    [defaults setObject:user.username forKey:@"username"];
    
    [KeychainUtility configureUser:user withToken:token password:password];
}

+ (User *)currentUser {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"username"];
    NSString *avatarURL = [defaults objectForKey:@"avatarURL"];
    NSString *email = [defaults objectForKey:@"email"];
    
    if ([email isEqualToString:@""] || email == nil) {
        return nil;
    }
    
    NSString *token = [KeychainUtility tokenForAccount:email];
    
    if ([token isEqualToString:@""] || email == nil) {
        return nil;
    }
    
    return [[User alloc] initWithUsername:username email:email avatarURL:avatarURL];
}

@end
