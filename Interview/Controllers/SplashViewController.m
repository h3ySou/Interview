//
//  SplashViewController.m
//  Interview
//
//  Created by Andrew Veresov on 6/20/17.
//  Copyright © 2017 sou. All rights reserved.
//

#import "SplashViewController.h"
#import "User.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    User *user = [User currentUser];
    
    __weak __typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (user) {
            [weakSelf performSegueWithIdentifier:@"toHome" sender:nil];
        } else {
            [weakSelf performSegueWithIdentifier:@"toSignup" sender:nil];
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
