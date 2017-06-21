//
//  UIViewController+Extensions.m
//  Interview
//
//  Created by Andrew Veresov on 6/20/17.
//  Copyright © 2017 sou. All rights reserved.
//

#import "UIViewController+Extensions.h"
#import <RSKImageCropper.h>
#import <MBProgressHUD.h>

@import MobileCoreServices;

@implementation UIViewController (Extensions)

- (void)showHUDAnimated:(BOOL)animated {

    dispatch_async(dispatch_get_main_queue(), ^{
      [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
}

- (void)hideHUDAnimated:(BOOL)animated {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (void)setupMainViewResigning {
    
    SEL didTapMainView = @selector(didTapMainView:);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:didTapMainView];
    [self.view addGestureRecognizer:tap];
}

- (void)didTapMainView:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (void)showAlertWithError:(NSError *)error {
    [self showAlertWithTitle:nil message:error.localizedDescription];
}

- (void)showAlertWithTitle:(NSString*)title message:(NSString*)message {
    [self showAlertWithTitle:title message:message doneAction:nil];
}

- (void)showInputTextFieldAlertWithTitle:(NSString *)title message:(NSString *)message placeholder:(NSString *)placeholder completion:(void (^)(NSString *text))completion {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *submit = [UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                       if (alert.textFields.count > 0) {
                                                           
                                                           UITextField *textField = [alert.textFields firstObject];
                                                           if (completion) {
                                                               completion(textField.text);
                                                           }
                                                       }
                                                   }];
    [alert addAction:submit];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = placeholder;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message doneAction:(void (^)(UIAlertAction *action))doneAction {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:doneAction];
    [alertController addAction:actionOk];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showAlertBackendError:(NSError*)error {
    [self showAlertWithTitle:@"Error" message:error.userInfo[NSLocalizedDescriptionKey]];
}

- (void)showCameraAction:(id)sender alert:(BOOL)alert delegate:(id)delegate {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:alert ? UIAlertControllerStyleActionSheet : UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cameraAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:
                                   ^(UIAlertAction * _Nonnull action)
                                   {
                                       BOOL cameraAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
                                       
                                       if (cameraAvailable) {
                                           
                                           UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                                           imagePickerController.navigationBar.translucent = NO;
                                           imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                           imagePickerController.delegate = delegate;
                                           imagePickerController.modalPresentationStyle = UIModalPresentationOverFullScreen;
                                           
                                           if (!alert) {
                                               imagePickerController.mediaTypes = [[NSArray alloc]initWithObjects:(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage, nil];
                                           }
                                           [self presentViewController:imagePickerController animated:YES completion:nil];
                                           
                                       } else {
                                           [self showAlertWithTitle:nil message:@"Camera not enabled"];
                                       }
                                   }];
    
    UIAlertAction* galleryAction = [UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
        imagePickerController.navigationBar.translucent = NO;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate = delegate;
        imagePickerController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        if (!alert) {
            imagePickerController.mediaTypes = [[NSArray alloc]initWithObjects:(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage, nil];
        }
        
        // chanage color navigation if needs
        //imagePickerController.navigationBar.tintColor = [UIColor appPinkColor];
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    alertController.popoverPresentationController.barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sender];
    alertController.popoverPresentationController.sourceView = self.view;
    
    [alertController addAction:cameraAction];
    [alertController addAction:galleryAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showCropperFromPicker:(UIImagePickerController *)picker
                         forImage:(UIImage *)chosenImage
                         delegate:(id)delegate {
    
    UIViewController *controller = picker.presentingViewController;
    [picker dismissViewControllerAnimated:NO completion:^{
        RSKImageCropViewController *cropController = [[RSKImageCropViewController alloc] initWithImage:chosenImage cropMode:RSKImageCropModeCircle];
        cropController.avoidEmptySpaceAroundImage = YES;
        cropController.delegate = delegate;
        [controller presentViewController:cropController animated:YES completion:NULL];
    }];
}

@end
