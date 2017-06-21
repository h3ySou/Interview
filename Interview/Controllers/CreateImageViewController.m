//
//  CreateImageViewController.m
//  Interview
//
//  Created by Andrew Veresov on 6/21/17.
//  Copyright © 2017 sou. All rights reserved.
//

#import "CreateImageViewController.h"
#import "UIViewController+Extensions.h"
#import "NSString+Extensions.h"

#import "APIManager+Image.h"
#import "LocationManager.h"
#import "DIImage.h"

@import MobileCoreServices;
@import Photos;

@interface CreateImageViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

// UI
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *hashtagTextField;

@property (strong, nonatomic) DIImage *image;

@end

@implementation CreateImageViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - IBActions

- (void)onCreateButton:(UIBarButtonItem *)sender {
    
    if (!self.image) {
        [self showAlertWithTitle:@"Error" message:@"Please provide the image"];
        return;
    }
    
    NSString *hashtag = self.hashtagTextField.text;
    NSString *descriptionText = self.descriptionTextField.text;
    
    if (!self.image.image) {
        [self showAlertWithTitle:@"Error" message:@"Please provide the image"];
        return;
    }

    void(^completion)() = ^{
        
        if (![hashtag isEmpty]) {
            self.image.hashtag = hashtag;
        } else {
            self.image.hashtag = @"";
        }
        
        if (![descriptionText isEmpty]) {
            self.image.imageDescription = descriptionText;
        } else {
            self.image.imageDescription = @"";
        }
        __weak __typeof(self) weakSelf = self;
        [[APIManager shared] uploadImage:self.image
                              completion:^(NSError *error)
         {
             [weakSelf hideHUDAnimated:YES];
             
             if (error) {
                 [weakSelf showAlertBackendError:error];
             } else {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [weakSelf.navigationController popViewControllerAnimated:YES];
                     
                     if ([weakSelf.delegate respondsToSelector:@selector(didCreateImage:)]) {
                         [weakSelf.delegate didCreateImage:weakSelf.image];
                     }
                 });
             }
         }];
    };
    
    [self showHUDAnimated:YES];
    
    // SERVER DID NOT RECOGNIZE NEGATIVE LATITUDE/ LONG..
    if (0 == self.image.latitude && 0 == self.image.longitude) {
        __weak __typeof(self) weakSelf = self;
        [[LocationManager shared] getUserLocationWithCompletion:^(CLLocation *location) {
            weakSelf.image.longitude = location.coordinate.longitude < 0 ? 0 : location.coordinate.longitude;
            weakSelf.image.latitude = location.coordinate.latitude < 0 ? 0 : location.coordinate.latitude;
            
            completion();
        }];
    } else {
        completion();
    }
}

- (void)onPicture:(UITapGestureRecognizer *)sender {
    [self showCameraAction:sender alert:NO delegate:self];
}

#pragma mark - Private

- (void)createImageWithGeoInfo:(NSDictionary *)info {
    
    if (!info) {
        float longitude = [info[@"longitude"] floatValue];
        float latitude = [info[@"latitude"] floatValue];
        
        self.image.longitude = longitude;
        self.image.latitude = latitude;
    }
}

- (void)setupUI {
    [self setupMainViewResigning];
    
    // nav
    SEL buttonAction = @selector(onCreateButton:);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:buttonAction];
    self.navigationItem.rightBarButtonItem = item;
    
    // picture
    self.pictureImageView.clipsToBounds = YES;
    self.pictureImageView.userInteractionEnabled = YES;
    
    SEL pictureAction = @selector(onPicture:);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:pictureAction];
    [self.pictureImageView addGestureRecognizer:tap];
}

- (NSDictionary *)getGPSInformationForAsset:(PHAsset *)asset {
    
    float longitude = asset.location.coordinate.longitude;
    float latitude = asset.location.coordinate.latitude;
    
    if (0 == longitude && 0 == latitude) {
        return nil;
    }
    NSDictionary *geo = @{@"longitude": @(longitude < 0 ? 0 : longitude),
                          @"latitude": @(latitude < 0 ? 0 : latitude)};
    
    return geo;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.image = [[DIImage alloc] init];
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.pictureImageView.image = chosenImage;
    self.image.image = chosenImage;
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        NSURL *assetURL = info[UIImagePickerControllerReferenceURL];
        PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[assetURL] options:nil];
        PHAsset *asset = result.firstObject;
        
        NSDictionary *geoInfo = [self getGPSInformationForAsset:asset];
        
        [self createImageWithGeoInfo:geoInfo];
        
    } else {
        
        __weak __typeof(self) weakSelf = self;
        __block PHObjectPlaceholder *placeholder = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetChangeRequest *changeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:info[UIImagePickerControllerOriginalImage]];
            placeholder = changeRequest.placeholderForCreatedAsset;
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            
            if (nil != placeholder && success) {
                
                NSString *identifier = placeholder.localIdentifier;
                
                PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:@[identifier] options:nil];
                PHAsset *asset = result.firstObject;
                
                NSDictionary *geoInfo = [weakSelf getGPSInformationForAsset:asset];
                
                [weakSelf createImageWithGeoInfo:geoInfo];
            }
        }];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    
    return YES;
}

@end
