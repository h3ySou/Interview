//
//  UIImage+Extensions.m
//  Interview
//
//  Created by Andrew Veresov on 6/21/17.
//  Copyright © 2017 sou. All rights reserved.
//

#import "UIImage+Extensions.h"

@implementation UIImage (Extensions)

- (NSString*)base64EncodedStringFromImageWithTransperent:(BOOL)withTransperent {
    
    NSData *imgData = withTransperent ? UIImagePNGRepresentation(self) : UIImageJPEGRepresentation([UIImage compressedImage:self], .5);
    
    NSString *imageString = [imgData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    NSString *additionalInfo = withTransperent ? @"data:image/png;base64," : @"data:image/jpeg;base64,";
    
    NSString *res = [additionalInfo stringByAppendingString:imageString];
    
    return res;
}

+ (UIImage *)compressedImage:(UIImage *)image {
    
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    
    float maxSide = 2048.;
    
    if (actualWidth <= maxSide && actualHeight <= maxSide)
        return image;
    
    float ratio = actualWidth / actualHeight;
    
    float newWidth = ratio >= 1.0 ? maxSide : roundf(maxSide * ratio);
    float newHeight = ratio >= 1.0 ? roundf(maxSide * ratio) : maxSide;
    
    CGRect rect = CGRectMake(0.0, 0.0, newWidth, newHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    return img;
}

@end
