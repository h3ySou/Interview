//
//  GalleryCell.m
//  Interview
//
//  Created by Andrew Veresov on 6/21/17.
//  Copyright © 2017 sou. All rights reserved.
//

#import "GalleryCell.h"
#import "DIImage.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface GalleryCell()

// UI
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *headlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *sublineLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end

@implementation GalleryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 1.f;
}

#pragma mark - Public

+ (NSString *)cellIdentifier {
    return NSStringFromClass(self);
}

+ (UINib *)cellNib {
    return [UINib nibWithNibName:[GalleryCell cellIdentifier] bundle:nil];
}

- (void)configureWithImage:(DIImage *)image {
    
    if (!image) {
        return;
    }
    
    UIImage *placeholder = [UIImage imageNamed:@"ImagePlaceholder"];
    
    __weak __typeof(self) weakSelf = self;
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:image.smallImageURL]
                           placeholderImage:placeholder
                                    options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf.activity stopAnimating];
         });
     }];
    self.headlineLabel.text = image.address;
    self.sublineLabel.text = image.weather;
}

@end
