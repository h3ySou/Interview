//
//  LocationManager.m
//  Interview
//
//  Created by Andrew Veresov on 6/21/17.
//  Copyright © 2017 sou. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager() <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) LocationCompletion completion;

@end

@implementation LocationManager

#pragma mark - Initialization

+ (instancetype)shared {
    
    static LocationManager *shared = nil;
    static dispatch_once_t singleToken;
    dispatch_once(&singleToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    return self;
}

- (void)startUpdatingLocation {
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation {
    self.locationManager.delegate = nil;
    [self.locationManager stopUpdatingLocation];
}

- (void)getUserLocationWithCompletion:(LocationCompletion)completion {
    [self startUpdatingLocation];
    self.completion = completion;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *location = [locations lastObject];
    if (self.completion) {
        self.completion(location);
    }
    self.completion = nil;
    [self stopUpdatingLocation];
}

@end
