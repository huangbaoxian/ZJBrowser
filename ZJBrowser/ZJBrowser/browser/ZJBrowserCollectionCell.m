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

@interface ZJBrowserCollectionCell ()

@property (nonatomic, strong) UIImageView *showView;

@end

@implementation ZJBrowserCollectionCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatSubView];
    }
    return self;
}

- (void)loadZJPhoto:(ZJPhoto *)photo {
    if (photo.image) {
        self.showView.image = photo.image;
    }else if(photo.imageUrl  && [photo.imageUrl isKindOfClass:[NSString class]]){
        [self.showView sd_setImageWithURL:[NSURL URLWithString:photo.imageUrl] placeholderImage:nil];
    }
}


- (void)creatSubView {
    [self.contentView addSubview:self.showView];
    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.top.equalTo(self.contentView);
    }];
}


- (UIImageView *)showView {
    if (!_showView) {
        _showView = [[UIImageView alloc] init];
        _showView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _showView;
}

@end
