//
//  DIImage.h
//  Interview
//
//  Created by Andrew Veresov on 6/20/17.
//  Copyright © 2017 sou. All rights reserved.
//

@import UIKit;

@interface DIImage : NSObject

@property (nonatomic, copy) NSString *imageDescription;
@property (nonatomic, copy) NSString *hashtag;

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *weather;

@property (nonatomic, copy) NSString *bigImageURL;
@property (nonatomic, copy) NSString *smallImageURL;

@property (strong, nonatomic) UIImage *image;

@property (assign, nonatomic) float latitude;
@property (assign, nonatomic) float longitude;

@property (assign, nonatomic) NSInteger imageId;

- (instancetype)initFromJson:(NSDictionary *)json;
- (NSDictionary *)toJson;

@end
