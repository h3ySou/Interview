//
//  APIManager+Image.h
//  Interview
//
//  Created by Andrew Veresov on 6/21/17.
//  Copyright © 2017 sou. All rights reserved.
//

#import "APIManager.h"

@class DIImage;

@interface APIManager (Image)

- (void)getAllImagesWithCompletion:(void(^)(NSError *error, NSArray *images))completion;

- (void)uploadImage:(DIImage *)image completion:(void(^) (NSError *error))completion;

- (void)createGifWithWeather:(NSString *)weather
                  completion:(void(^)(NSError *error, NSString *gifURL))completion;

@end
