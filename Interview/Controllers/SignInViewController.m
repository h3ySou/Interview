//
//  SignInViewController.m
//  Interview
//
//  Created by Andrew Veresov on 6/20/17.
//  Copyright © 2017 sou. All rights reserved.
//

#import "SignInViewController.h"
#import <RSKImageCropper.h>

#import "UIViewController+Extensions.h"
#import "UIImageView+Extensions.h"
#import "NSString+Extensions.h"
#import "UIImage+Extensions.h"

#import "APIManager+Auth.h"

#import "User.h"

@interface SignInViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, RSKImageCropViewControllerDelegate>

// UI
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordTextField;

@property (weak, nonatomic) IBOutlet UIButton *signupButton;

@end

@implementation SignInViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction

- (void)onAvatar:(UITapGestureRecognizer *)sender {
    [self showCameraAction:sender alert:NO delegate:self];
}

- (IBAction)onSignupButton:(UIButton *)sender {
    [self checkUserInput];
}

- (IBAction)onTermsSwitch:(UISwitch *)sender {
    self.signupButton.enabled = sender.isOn;
    self.signupButton.alpha = sender.isOn ? 1.f : 0.45f;
}

#pragma mark - Private

- (void)setupUI {
    
    [self setupMainViewResigning];
    
    // avatar
    self.avatarImageView.userInteractionEnabled = YES;
    SEL avatarAction = @selector(onAvatar:);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:avatarAction];
    [self.avatarImageView addGestureRecognizer:tap];
    
    [self.avatarImageView makeCircly];
    
    // signup button
    self.signupButton.enabled = NO;
    self.signupButton.alpha = 0.45f;
}

- (void)checkUserInput {
    
    NSString *alerTitle = @"Warning";
    
    UIImage *avatar = self.avatarImageView.image;
    
    if (![self.avatarImageView isValidUserPickerImage]) {
        [self showAlertWithTitle:alerTitle message:@"Please, provide the image for sign up"];
        return;
    }
    
    NSString *username = self.usernameTextField.text;
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *repeatPassword = self.repeatPasswordTextField.text;
    
    __weak __typeof(self) weakSelf = self;
    
    if (username.length > 0) {
        if (![username isValidName]) {
            [weakSelf showAlertWithTitle:alerTitle message:@"Usernmae not valid"];
            return;
        }
    }
    
    if (![email isValidEmail]) {
        [weakSelf showAlertWithTitle:alerTitle message:@"Email not valid"];
        return;
    }
    
    if (![password isEqualToString:repeatPassword] || password.length == 0) {
        [self showAlertWithTitle:alerTitle message:@"Passwords do not match"];
        return;
    }
    
    if (![password isValidPassword]) {
        [self showAlertWithTitle:alerTitle message:@"Password not valid, password should be more then 6 characters"];
        return;
    }
    
    NSData *avatarData = UIImageJPEGRepresentation(avatar, .5);
    
    [self showHUDAnimated:YES];
    [[APIManager shared] signupWithUsername:username
                                      email:email
                                   password:password
                                     avatar:avatarData
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

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    [self showCropperFromPicker:picker forImage:chosenImage delegate:self];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - RSKImageCropViewControllerDelegate

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect {
    
    self.avatarImageView.image = croppedImage;
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    
    return YES;
}

@end
