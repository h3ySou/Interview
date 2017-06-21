//
//  Route.m
//  Interview
//
//  Created by Andrew Veresov on 6/21/17.
//  Copyright © 2017 sou. All rights reserved.
//

#import "Route.h"
#import "AppDelegate.h"

@implementation Route

+ (void)showLoginScreen {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIViewController *rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SignupViewController"];
    
    UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
    appDelegate.window.rootViewController = navigation;
}

@end
