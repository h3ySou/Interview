//
//  UIImageView+Extensions.m
//  Interview
//
//  Created by Andrew Veresov on 6/21/17.
//  Copyright © 2017 sou. All rights reserved.
//

#import "UIImageView+Extensions.h"

@implementation UIImageView (Extensions)

- (void)makeCircly {
    self.layer.cornerRadius = self.bounds.size.width / 2;
    self.clipsToBounds = YES;
}

- (BOOL)isValidUserPickerImage {
    
    UIImage *placeholder = [UIImage imageNamed:@"AvatarPlaceholder"];
    
    NSData *data1 = UIImagePNGRepresentation(placeholder);
    NSData *data2 = UIImagePNGRepresentation(self.image);

    BOOL identicallyImages = [data1 isEqual:data2];
    
    return nil != self.image && !identicallyImages;
}

- (BOOL)isValidCreatedImage {
    
    UIImage *placeholder = [UIImage imageNamed:@"ImagePlaceholder"];
    
    NSData *data1 = UIImagePNGRepresentation(placeholder);
    NSData *data2 = UIImagePNGRepresentation(self.image);
    
    BOOL identicallyImages = [data1 isEqual:data2];
    
    return nil != self.image && !identicallyImages;
}

@end
