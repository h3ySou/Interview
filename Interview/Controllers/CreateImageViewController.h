//
//  CreateImageViewController.h
//  Interview
//
//  Created by Andrew Veresov on 6/21/17.
//  Copyright © 2017 sou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DIImage;

@protocol CreateImageViewControllerDelegate <NSObject>

- (void)didCreateImage:(DIImage *)image;

@end

@interface CreateImageViewController : UIViewController

@property (weak, nonatomic) id<CreateImageViewControllerDelegate> delegate;

@end
