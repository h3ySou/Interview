//
//  LocationManager.h
//  Interview
//
//  Created by Andrew Veresov on 6/21/17.
//  Copyright © 2017 sou. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

typedef void(^LocationCompletion)(CLLocation *location);

@interface LocationManager : NSObject

+ (instancetype)shared;
- (void)getUserLocationWithCompletion:(LocationCompletion)completion;

@end
