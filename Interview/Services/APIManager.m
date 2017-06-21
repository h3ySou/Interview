//
//  APIManager.m
//  Interview
//
//  Created by Andrew Veresov on 6/20/17.
//  Copyright © 2017 sou. All rights reserved.
//

#import "APIManager.h"
#import <AFNetworking.h>

#import "Route.h"

#import "KeychainUtility.h"
#import "NSError+Extensions.h"

@interface APIManager()

@property (strong, nonatomic) AFURLSessionManager *sessionManager;

@end

@implementation APIManager

#pragma mark - Initialization

+ (instancetype)shared {
    
    static APIManager *shared = nil;
    static dispatch_once_t singleToken;
    dispatch_once(&singleToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    }
    
    return self;
}

#pragma mark - Public

- (void)sendGetWithEndpoint:(NSString *)endpoint
                 parameters:(NSDictionary *)parameters
                 completion:(void(^)(NSError *error, NSDictionary *response))completion
{
    [self requestWithMethod:@"GET"
                   endpoint:endpoint
                 parameters:parameters
                 completion:completion];
}

- (void)sendPostWithEndpoint:(NSString *)endpoint
                  parameters:(NSDictionary *)parameters
                  completion:(void(^)(NSError *error, NSDictionary *response))completion
{
    [self requestWithMethod:@"POST"
                   endpoint:endpoint
                 parameters:parameters
                 completion:completion];
}

#pragma mark - Private

- (void)requestWithMethod:(NSString *)method
                 endpoint:(NSString *)endpoint
               parameters:(NSDictionary *)parameters
               completion:(void(^)(NSError *error, NSDictionary *response))completion
{
    NSString *fullURL = [NSString stringWithFormat:@"%@/%@", [APIManager baseURL], endpoint];
    BOOL isSignup = [endpoint isEqualToString:@"create"];
    BOOL imageCreation = [endpoint isEqualToString:@"image"];
    
    NSMutableURLRequest *request = nil;
    NSURLSessionTask *task = nil;
    
    if (isSignup || imageCreation) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
        
        NSData *data = nil;
        
        if (isSignup) {
            data = dict[@"avatar"];
            [dict removeObjectForKey:@"avatar"];
        } else {
            data = dict[@"image"];
            [dict removeObjectForKey:@"image"];
        }
        request = [[AFJSONRequestSerializer serializer] multipartFormRequestWithMethod:method URLString:fullURL parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
            
            [formData appendPartWithFileData:data
                                        name:isSignup ? @"avatar" : @"image"
                                    fileName:@"filename.jpg"
                                    mimeType:@"image/jpeg"];
            
        } error:nil];
        
        if (!isSignup) {
            NSString *token = [KeychainUtility tokenForLoggedUser];
            if (nil != token && token.length > 0) {
                [request setValue:token forHTTPHeaderField:@"token"];
            }
        }
        
    } else {
        request = [[AFJSONRequestSerializer serializer] requestWithMethod:method URLString:fullURL parameters:parameters error:nil];
        
        NSString *token = [KeychainUtility tokenForLoggedUser];
        if (nil != token && token.length > 0) {
            [request setValue:token forHTTPHeaderField:@"token"];
        }
    }
    
    task = [self.sessionManager dataTaskWithRequest:request uploadProgress:nil
                                   downloadProgress:nil
                                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                      
                                      NSUInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
                                      BOOL invalidToken = statusCode == 403;
                                      
                                      if (error) {
                                          
                                          if (invalidToken) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [KeychainUtility removeUserCredentionals];
                                                  [Route showLoginScreen];
                                              });
                                          } else {
                                              
                                              if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                                  
                                                  if (responseObject[@"error"]) {
                                                      completion([NSError errorWithCode:@"" description:responseObject[@"error"]], nil);
                                                  } else {
                                                      
                                                      if ([responseObject[@"children"] isKindOfClass:[NSDictionary class]]) {
                                                          NSDictionary *children = responseObject[@"children"];
                                                          id singleError = children.allValues.firstObject;
                                                          
                                                          if ([singleError isKindOfClass:[NSArray class]]) {
                                                              NSArray *errors = (NSArray *)singleError;
                                                              
                                                              if ([errors.firstObject isKindOfClass:[NSDictionary class]]) {
                                                                  NSString *message = [(NSDictionary *)errors.firstObject valueForKey:@"error"];
                                                                  completion([NSError errorWithCode:@"" description:message], nil);
                                                              }
                                                          }
                                                      }
                                                      completion(error, nil);
                                                  }
                                              } else {
                                                  completion(error, nil);
                                              }
                                          }
                                      }
                                      
                                      if (response) {
                                          if (invalidToken) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [KeychainUtility removeUserCredentionals];
                                                  [Route showLoginScreen];
                                              });
                                          } else {
                                              
                                              BOOL validJson = (responseObject && [responseObject isKindOfClass:[NSDictionary class]]);
                                              BOOL successCode = (statusCode == 201) || (statusCode == 200);
                                              
                                              if (validJson && successCode) {
                                                  completion(nil, responseObject);
                                              } else {
                                                  completion([NSError errorWithCode:@"" description:@"Unxpected error"], nil);
                                              }
                                          }
                                      } else {
                                          completion([NSError errorWithCode:@"" description:@"Unxpected error"], nil);
                                      }
                                  }];
    
    [task resume];
}

+ (NSString *)baseURL {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"API" withExtension:@"plist"];
    NSDictionary *appDict = [NSDictionary dictionaryWithContentsOfURL:url];
    
    NSString *baseURL = [[appDict objectForKey:@"BaseURL"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return baseURL;
}

@end
