//
//  GifViewController.m
//  Interview
//
//  Created by Andrew Veresov on 6/21/17.
//  Copyright © 2017 sou. All rights reserved.
//

#import "GifViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface GifViewController ()

// UI
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end

@implementation GifViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gifImageView.clipsToBounds = YES;
    
    UIImage *placeholder = [UIImage imageNamed:@"ImagePlaceholder"];
    
    __weak __typeof(self) weakSelf = self;
    [self.gifImageView sd_setImageWithURL:self.gifURL
                         placeholderImage:placeholder
                                  options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.activity stopAnimating];
         });
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - IBActions

- (IBAction)onCloseButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
