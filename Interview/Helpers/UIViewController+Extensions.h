//
//  UIViewController+Extensions.h
//  Interview
//
//  Created by Andrew Veresov on 6/20/17.
//  Copyright © 2017 sou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extensions)

- (void)setupMainViewResigning;

- (void)showHUDAnimated:(BOOL)animated;
- (void)hideHUDAnimated:(BOOL)animated;

- (void)showAlertWithError:(NSError *)error;
- (void)showAlertWithTitle:(NSString*)title message:(NSString*)message;
- (void)showAlertBackendError:(NSError*)error;

- (void)showInputTextFieldAlertWithTitle:(NSString *)title
                                 message:(NSString *)message
                             placeholder:(NSString *)placeholder
                              completion:(void (^)(NSString *text))completion;

- (void)showCameraAction:(id)sender alert:(BOOL)alert delegate:(id)delegate;
- (void)showCropperFromPicker:(UIImagePickerController *)picker
                     forImage:(UIImage *)chosenImage
                     delegate:(id)delegate;

@end
