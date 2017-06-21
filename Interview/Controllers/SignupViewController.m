//
//  ViewController.m
//  Interview
//
//  Created by Andrew Veresov on 6/20/17.
//  Copyright © 2017 sou. All rights reserved.
//

#import "SignupViewController.h"
#import "UIViewController+Extensions.h"

#import "APIManager+Auth.h"
#import "NSString+Extensions.h"

#import "User.h"

@interface SignupViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation SignupViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - IBActions

- (IBAction)onLoginButton:(UIButton *)sender {
    
    NSString *alerTitle = @"Warning";
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if (![email isValidEmail]) {
        [self showAlertWithTitle:alerTitle message:@"Email not valid"];
        return;
    }
    
    if (![password isValidPassword]) {
        [self showAlertWithTitle:alerTitle message:@"Not correct password"];
        return;
    }
    
    [self showHUDAnimated:YES];
    
    __weak __typeof(self) weakSelf = self;
    [[APIManager shared] loginWithEmail:email
                               password:password
                             completion:^(NSError *error, User *user)
     {
         [weakSelf hideHUDAnimated:YES];
         
         if (error) {
             [weakSelf showAlertBackendError:error];
             return;
         }
         
         if (user) {
             [weakSelf performSegueWithIdentifier:@"toHome" sender:nil];
         }
     }];
}

- (IBAction)onSignupButton:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"toSignin" sender:nil];
}

- (IBAction)onForgotPasswordButton:(UIButton *)sender {
    
    // provide url for retrive password..
}

#pragma mark - Private

- (void)setupUI {
    
    [self setupMainViewResigning];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    
    return YES;
}

@end
