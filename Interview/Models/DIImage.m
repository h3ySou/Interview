//
//  DIImage.m
//  Interview
//
//  Created by Andrew Veresov on 6/20/17.
//  Copyright © 2017 sou. All rights reserved.
//

#import "DIImage.h"
#import "NSString+Extensions.h"

@implementation DIImage

#pragma mark - Initialization

- (instancetype)initFromJson:(NSDictionary *)json {
    
    DIImage *image = [[DIImage alloc] init];
    image.imageId = [json[@"id"] integerValue];
    image.address = @"NO Address";
    
    NSDictionary *params = json[@"parameters"];
    
    float lat = [params[@"latitude"] floatValue];
    float lng = [params[@"latitude"] floatValue];
    NSString *weather = params[@"weather"];
    
    if (params[@"adress"]) {
        image.address = params[@"adress"];
    }
    
    NSString *bigURL = json[@"bigImagePath"];
    NSString *smallURL = json[@"smallImagePath"];
    
    image.latitude = lat;
    image.longitude = lng;
    image.weather = weather;
    image.bigImageURL = bigURL;
    image.smallImageURL = smallURL;
    
    return image;
}

#pragma mark - Public

- (NSDictionary *)toJson {

    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    if (![self.imageDescription isEmpty]) {
        json[@"description"] = self.imageDescription;
    }
    
    if (![self.hashtag isEmpty]) {
        json[@"hashtag"] = self.hashtag;
    }
    
    json[@"latitude"] = @(self.latitude);
    json[@"longitude"] = @(self.longitude);
    
    json[@"image"] = UIImageJPEGRepresentation(self.image, .5);
    
    return json;
}

@end
