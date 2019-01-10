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

@interface ZJBrowserCollectionCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scollView;
@property (nonatomic, strong) UIImageView *showView;

@property (nonatomic, assign) CGFloat minScale;
@property (nonatomic, assign) CGFloat maxSclae;
@property (nonatomic, assign) CGFloat mainScreenWidth;
@property (nonatomic, assign) CGFloat mainScreenHeight;

@property (nonatomic, assign) CGFloat realImageHeight;
@property (nonatomic, assign) CGFloat realImageWidth;


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
     
    self.showView.frame = CGRectMake((width - self.realImageWidth)/2 , (height - self.realImageHeight)/2 , self.realImageWidth, self.realImageHeight);
     self.scollView.zoomScale = 1.0;
    self.mainScreenWidth = width;
    self.mainScreenHeight = height;
   
    
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
    
    if (image.size.width > image.size.height) {
        //已宽度为主
        CGFloat realHeight = 0;
        if (image.size.width > self.mainScreenWidth) {
            //超过屏幕，需要计算
            CGFloat realHeight = self.mainScreenWidth / image.size.width *  image.size.height;
            self.showView.frame = CGRectMake(0, (self.mainScreenHeight - realHeight)/2, self.mainScreenWidth, realHeight);
        }else {
            realHeight = image.size.width;
            self.showView.frame = CGRectMake((self.mainScreenWidth - image.size.width)/2, (self.mainScreenHeight - image.size.height)/2, image.size.width, image.size.height);
        }
    }else {
        //以高度为主
        CGFloat realWidth = 0;
        if (image.size.height > self.mainScreenHeight) {
            realWidth = self.mainScreenHeight / image.size.height *  image.size.width;
            self.showView.frame = CGRectMake((self.mainScreenWidth - realWidth)/2, 0, realWidth, self.mainScreenHeight);
        }else {
            self.showView.frame = CGRectMake((self.mainScreenWidth - image.size.width)/2, (self.mainScreenHeight - image.size.height)/2, image.size.width, image.size.height);
        }
    }
    self.showView.image = image;
    self.realImageWidth = self.showView.frame.size.width;
    self.realImageHeight = self.showView.frame.size.height;
    
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
//        _showView.contentMode = UIViewContentModeScaleAspectFit;
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
