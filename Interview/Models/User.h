//
//  User.h
//  Interview
//
//  Created by Andrew Veresov on 6/20/17.
//  Copyright © 2017 sou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *avatarURL;

- (instancetype)initWithUsername:(NSString *)username
                           email:(NSString *)email
                       avatarURL:(NSString *)avatarURL;

+ (User *)currentUser;
+ (User *)fromJson:(NSDictionary *)json;

@end
