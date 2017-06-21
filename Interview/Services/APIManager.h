//
//  APIManager.h
//  Interview
//
//  Created by Andrew Veresov on 6/20/17.
//  Copyright © 2017 sou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject

+ (instancetype)shared;

- (void)sendGetWithEndpoint:(NSString *)endpoint
                 parameters:(NSDictionary *)parameters
                 completion:(void(^)(NSError *error, NSDictionary *response))completion;

- (void)sendPostWithEndpoint:(NSString *)endpoint
                  parameters:(NSDictionary *)parameters
                  completion:(void(^)(NSError *error, NSDictionary *response))completion;

@end
