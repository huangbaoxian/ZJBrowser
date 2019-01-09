//
//  ZJPhoto.h
//  ZJBrowser
//
//  Created by huangbaoxian on 2019/1/9.
//  Copyright © 2019 huangbaoxian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZJPhoto : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *imageUrl;

- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithImageUrl:(NSString *)imageUrl;


@end


