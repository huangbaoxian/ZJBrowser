//
//  UIImage+ZJScale.m
//  ZJBrowser
//
//  Created by huangbaoxian on 2019/1/10.
//  Copyright © 2019 huangbaoxian. All rights reserved.
//

#import "UIImage+ZJScale.h"

@implementation UIImage (ZJScale)
// 得到图像显示完整后的宽度和高度
- (CGRect)imageRectSizeWithScreenWidth:(CGFloat)screenWidth screenHeight:(CGFloat)screenHeight
{
    CGFloat widthRatio = screenWidth / self.size.width;
    CGFloat heightRatio = screenHeight / self.size.height;
    CGFloat scale = MIN(widthRatio, heightRatio);
    CGFloat width = scale * self.size.width;
    CGFloat height = scale * self.size.height;
    return CGRectMake((screenWidth - width) / 2, (screenHeight - height) / 2, width, height);
}

@end
