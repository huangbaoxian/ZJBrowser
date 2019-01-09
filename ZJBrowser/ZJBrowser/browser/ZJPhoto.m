//
//  ZJPhoto.m
//  ZJBrowser
//
//  Created by huangbaoxian on 2019/1/9.
//  Copyright © 2019 huangbaoxian. All rights reserved.
//

#import "ZJPhoto.h"

@implementation ZJPhoto

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        _image = image;
    }
    return self;
}

- (instancetype)initWithImageUrl:(NSString *)imageUrl {
    if (self = [super init]) {
        _imageUrl = imageUrl;
    }
    return self;
}

@end
