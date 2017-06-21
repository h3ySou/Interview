//
//  GalleryCell.h
//  Interview
//
//  Created by Andrew Veresov on 6/21/17.
//  Copyright © 2017 sou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DIImage;

@interface GalleryCell : UICollectionViewCell

- (void)configureWithImage:(DIImage *)image;

+ (NSString *)cellIdentifier;
+ (UINib *)cellNib;

@end
