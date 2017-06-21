//
//  HomeViewController.m
//  Interview
//
//  Created by Andrew Veresov on 6/21/17.
//  Copyright © 2017 sou. All rights reserved.
//

#import "HomeViewController.h"
#import "CreateImageViewController.h"
#import "GifViewController.h"

#import "GalleryCell.h"

#import "APIManager+Image.h"

#import "UIViewController+Extensions.h"

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

#import "DIImage.h"

#define kCellWidth ([UIScreen mainScreen].bounds.size.width - 40) / 2

@interface HomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, CreateImageViewControllerDelegate>

// UI
@property (weak, nonatomic) IBOutlet UICollectionView *galleryCollecitonView;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

// DataSource && Logics
@property (strong, nonatomic) NSMutableArray *photos;

@property (assign, nonatomic) BOOL shouldDisplayEmptySource;

@end

@implementation HomeViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self showHUDAnimated:YES];
    
    __weak __typeof(self) weakSelf = self;
    [[APIManager shared] getAllImagesWithCompletion:^(NSError *error, NSArray *images) {
        weakSelf.shouldDisplayEmptySource = YES;
        
        [weakSelf hideHUDAnimated:YES];
        weakSelf.photos = [images mutableCopy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.galleryCollecitonView reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - IBActions

- (void)onAddNewPhotoButton:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"toCreateImage" sender:nil];
}

- (void)onShowGifButton:(UIBarButtonItem *)sender {
    
    __weak __typeof(self) weakSelf = self;
    [self showInputTextFieldAlertWithTitle:@"GIF"
                                   message:@"Setup weather for GIF"
                               placeholder:@"Weather" completion:^(NSString *text)
     {
         [weakSelf showHUDAnimated:YES];
         [[APIManager shared] createGifWithWeather:text
                                        completion:^(NSError *error, NSString *gifURL)
          {
              dispatch_async(dispatch_get_main_queue(), ^{
                  [weakSelf hideHUDAnimated:YES];
                  [weakSelf performSegueWithIdentifier:@"toGIF" sender:gifURL];
              });
          }];
     }];
}

- (void)onRefresh:(UIRefreshControl *)sender {
    
    __weak __typeof(self) weakSelf = self;
    [[APIManager shared] getAllImagesWithCompletion:^(NSError *error, NSArray *images) {
        weakSelf.shouldDisplayEmptySource = YES;
        weakSelf.photos = [images mutableCopy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [sender endRefreshing];
            [weakSelf.galleryCollecitonView reloadData];
        });
    }];
}

#pragma mark - Private

- (NSDictionary *)attributtesForTitleWithSize:(CGFloat )size {
    
    UIFont *font = [UIFont systemFontOfSize:size];
    UIColor *textColor = [UIColor whiteColor];
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:font forKey:NSFontAttributeName];
    [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return attributes;
}

- (void)setupUI {
    
    self.shouldDisplayEmptySource = NO;
    
    // nav
    UIBarButtonItem *addImage = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddNewPhotoButton:)];
    UIBarButtonItem *showGIF = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(onShowGifButton:)];
    [self.navigationItem setRightBarButtonItems:@[addImage, showGIF]];
    
    // collection view
    [self.galleryCollecitonView registerNib:[GalleryCell cellNib] forCellWithReuseIdentifier:[GalleryCell cellIdentifier]];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.galleryCollecitonView.alwaysBounceVertical = YES;
    
    SEL refreshAction = @selector(onRefresh:);
    [self.refreshControl addTarget:self action:refreshAction forControlEvents:UIControlEventValueChanged];
    [self.galleryCollecitonView insertSubview:self.refreshControl atIndex:0];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DIImage *image = self.photos[indexPath.item];
    
    GalleryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[GalleryCell cellIdentifier] forIndexPath:indexPath];
    [cell configureWithImage:image];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kCellWidth, kCellWidth);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 20.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 20.f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10.f, 10.f, 0.f, 10.f);
}

#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = @"No images found";
    return [[NSAttributedString alloc] initWithString:text attributes:[self attributtesForTitleWithSize:30.f]];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = @"Be the first to create new image";
    return [[NSAttributedString alloc] initWithString:text attributes:[self attributtesForTitleWithSize:20.f]];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    
    NSString *text = @"Add new image";
    return [[NSAttributedString alloc] initWithString:text attributes:[self attributtesForTitleWithSize:16.f]];
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.shouldDisplayEmptySource;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self onAddNewPhotoButton:nil];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    [self onAddNewPhotoButton:nil];
}

#pragma mark - CreateImageViewControllerDelegate

- (void)didCreateImage:(DIImage *)image {
    [self.photos addObject:image];
    
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.galleryCollecitonView reloadData];
    });
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"toCreateImage"]) {
        CreateImageViewController *controller = [segue destinationViewController];
        controller.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"toGIF"]) {
        GifViewController *controller = [segue destinationViewController];
        controller.gifURL = [NSURL URLWithString:sender];
    }
}

@end
