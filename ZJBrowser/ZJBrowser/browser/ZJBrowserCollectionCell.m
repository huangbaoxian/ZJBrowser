//
//  ZJBrowserCollectionCell.m
//  ZJBrowser
//
//  Created by huangbaoxian on 2019/1/9.
//  Copyright © 2019 huangbaoxian. All rights reserved.
//

#import "ZJBrowserCollectionCell.h"
#import <Masonry/Masonry.h>
#import "ZJPhoto.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ZJScale.h"

@interface ZJBrowserCollectionCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scollView;
@property (nonatomic, strong) UIImageView *showView;

@property (nonatomic, assign) CGFloat minScale;
@property (nonatomic, assign) CGFloat maxSclae;
@property (nonatomic, assign) CGFloat mainScreenWidth;
@property (nonatomic, assign) CGFloat mainScreenHeight;

@property (nonatomic, assign) CGRect showImageFrame;


@end

@implementation ZJBrowserCollectionCell
- (void)dealloc {
    _scollView.delegate = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _minScale = 1.0;
        _maxSclae = 3.0;
        [self creatSubView];
    }
    return self;
}

- (void)loadZJPhoto:(ZJPhoto *)photo screenWidth:(CGFloat)width screenHeight:(CGFloat)height
 {
     
     
     self.scollView.frame = CGRectMake(0, 0, width, height);
     self.scollView.contentSize = CGSizeMake(width, height);
     self.showView.frame = self.showImageFrame;
   
     self.mainScreenWidth = width;
     self.mainScreenHeight = height;
     self.scollView.zoomScale = 1.0;
//     self.scollView.minimumZoomScale = 1.0;
//     self.scollView.maximumZoomScale = 1.0;
//     self.scollView.maximumZoomScale = 3.0;
   
    
    if (photo.image) {
        self.showView.image = photo.image;
    }else if(photo.imageUrl  && [photo.imageUrl isKindOfClass:[NSString class]]){
        [self.showView sd_setImageWithURL:[NSURL URLWithString:photo.imageUrl] placeholderImage:nil];
        
        __weak typeof(self) weakSelf = self;
        [self.showView sd_setImageWithURL:[NSURL URLWithString:photo.imageUrl] placeholderImage:nil options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            if (expectedSize == 0) {
                expectedSize = 1;
            }
            CGFloat pro = (CGFloat)receivedSize/(CGFloat)expectedSize;
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [weakSelf updateShowImageSize:image];
           
        }];
    }
}


- (void)updateShowImageSize:(UIImage *)image {
    CGRect showFrame = [image imageRectSizeWithScreenWidth:self.mainScreenWidth screenHeight:self.mainScreenHeight];
    self.showView.image = image;
    self.showView.frame = showFrame;
    self.showImageFrame = showFrame;
}

- (void)creatSubView {
    [self.contentView addSubview:self.scollView];
    [self.scollView addSubview:self.showView];
    [self.contentView layoutIfNeeded];
    self.scollView.pagingEnabled = YES;
    self.scollView.minimumZoomScale = self.minScale;
    self.scollView.maximumZoomScale = self.maxSclae;
    self.scollView.bounces = NO;
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _showView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    // 延中心点缩放
    CGRect rect = _showView.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    if (rect.size.width < self.mainScreenWidth) {
        rect.origin.x = floorf((self.mainScreenWidth - rect.size.width) / 2.0);
    }
    if (rect.size.height < self.mainScreenHeight) {
        rect.origin.y = floorf((self.mainScreenHeight - rect.size.height) / 2.0);
    }
    _showView.frame = rect;
    
    
    // Update tap view frame
    // Center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _showView.frame;
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    // Center
    if (!CGRectEqualToRect(_showView.frame, frameToCenter))
        _showView.frame = frameToCenter;
  
}


- (UIImageView *)showView {
    if (!_showView) {
        _showView = [[UIImageView alloc] init];
    }
    return _showView;
}

- (UIScrollView *)scollView {
    if (!_scollView) {
        _scollView = [[UIScrollView alloc] init];
        _scollView.delegate = self;
    }
    return _scollView;
}

@end
