//
//  APIManager+Image.m
//  Interview
//
//  Created by Andrew Veresov on 6/21/17.
//  Copyright © 2017 sou. All rights reserved.
//

#import "APIManager+Image.h"
#import "DIImage.h"

#define kImage @"image"
#define kGif   @"gif"
#define kAll   @"all"

@implementation APIManager (Image)

- (void)getAllImagesWithCompletion:(void(^)(NSError *error, NSArray *images))completion {
    
    [[APIManager shared] sendGetWithEndpoint:kAll
                                  parameters:nil
                                  completion:^(NSError *error, NSDictionary *response)
     {
         if (error) {
             completion(error, nil);
             return;
         }
         
         if (response) {
             
             NSMutableArray *images = [NSMutableArray array];
             if ([response[@"images"] isKindOfClass:[NSArray class]]) {
                 NSArray *serverImages = response[@"images"];
                 
                 if (0 == serverImages.count) {
                     completion(nil, serverImages);
                     return;
                 } else {
                     
                     for (NSDictionary *json in serverImages) {
                         DIImage *singleImage = [[DIImage alloc] initFromJson:json];
                         [images addObject:singleImage];
                     }
                     
                     completion(nil, images);
                 }
             }
         }
     }];
}

- (void)createGifWithWeather:(NSString *)weather
                  completion:(void(^)(NSError *error, NSString *gifURL))completion
{
    
    NSDictionary *parameters = @{@"weather": weather};
    
    [[APIManager shared] sendGetWithEndpoint:kGif
                                  parameters:parameters
                                  completion:^(NSError *error, NSDictionary *response)
     {
         if (error) {
             completion(error, nil);
             return;
         }
         
         if (response) {
             completion(nil, response[@"gif"]);
         }
     }];
}

- (void)uploadImage:(DIImage *)image
         completion:(void(^) (NSError *error))completion
{
    
    NSDictionary *parameters = [image toJson];
    
    [[APIManager shared] sendPostWithEndpoint:kImage
                                   parameters:parameters
                                   completion:^(NSError *error, NSDictionary *response)
     {
         if (error) {
             completion(error);
             return;
         }
         
         if (response) {
             if (response[@"bigImage"]) {
                 image.bigImageURL = response[@"bigImage"];
             }
             
             if (response[@"smallImage"]) {
                 image.smallImageURL = response[@"smallImage"];
             }
             
             if ([response[@"parameters"] isKindOfClass:[NSDictionary class]]) {
                 NSDictionary *params = response[@"parameters"];
                 
                 NSString *address = params[@"address"];
                 NSString *weather = params[@"weather"];
                 
                 image.address = address;
                 image.weather = weather;
             }
             
             completion(nil);
         }
     }];
}

@end
