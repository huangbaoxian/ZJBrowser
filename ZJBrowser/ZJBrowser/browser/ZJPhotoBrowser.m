//
//  ZJPhotoBrowser.m
//  ZJBrowser
//
//  Created by huangbaoxian on 2019/1/9.
//  Copyright © 2019 huangbaoxian. All rights reserved.
//

#import "ZJPhotoBrowser.h"
#import <Masonry/Masonry.h>
#import "ZJBrowserCollectionCell.h"

#define KSCREENWIDTH  [UIScreen mainScreen].bounds.size.width;
#define KSCREENHEIGHT  [UIScreen mainScreen].bounds.size.height;


@interface ZJPhotoBrowser () <UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic,assign)  UIDeviceOrientation currentOrientation;
@property (nonatomic,assign)  BOOL isRotate;// 判断是否正在切换横竖屏
@property (nonatomic, assign) BOOL isLandScape;


@end

@implementation ZJPhotoBrowser

- (instancetype)init {
    if (self = [super init]) {
        _screenWidth = KSCREENWIDTH;
        _screenHeight = KSCREENHEIGHT;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initCollectionView];
    
    // Do any additional setup after loading the view.
}


- (void)updateZJBrowserWithPhotoArray:(NSArray *)photoArray {
    if (photoArray && [photoArray isKindOfClass:[NSArray class]]) {
        [self.dataArray addObjectsFromArray:photoArray];
    }
}

- (void)reloadDataBrowser {
    [self.collectionView reloadData];
}

- (void)initCollectionView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.container];
    self.container.frame = self.view.bounds;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    // 布局方式改为从上至下，默认从左到右
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // Section Inset就是某个section中cell的边界范围
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 每行内部cell item的间距
    flowLayout.minimumInteritemSpacing = 0;
    // 每行的间距
    flowLayout.minimumLineSpacing = 0;
   
   
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth,self.screenHeight) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
      [_collectionView registerClass:[ZJBrowserCollectionCell class] forCellWithReuseIdentifier:@"ZJBrowserCollectionCell"];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.container addSubview:self.collectionView];
  
    self.collectionView.frame = self.container.bounds;
    
    [self.collectionView reloadData];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark UIColectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZJBrowserCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZJBrowserCollectionCell" forIndexPath:indexPath];
    NSLog(@"indexPath.row : %d", indexPath.row);
    if(cell)
    {
       
        if (self.dataArray.count > indexPath.row) {
            [cell loadZJPhoto:self.dataArray[indexPath.row] screenWidth:self.screenWidth screenHeight:self.screenHeight];
        }
    }
    return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isLandScape) {
        return CGSizeMake(self.screenHeight, self.screenWidth);
    }
    return CGSizeMake(self.screenWidth, self.screenHeight);
}

#pragma mark Orientation Method


- (void)deviceOrientationDidChange:(NSNotification *)notification
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    CGRect backViewFrame ;
    if(orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight)
    {
        _isRotate = YES;
       
        _currentOrientation = orientation;
        if(_currentOrientation == UIDeviceOrientationPortrait)
        {
            self.isLandScape = NO;
             backViewFrame = CGRectMake(0, 0, self.screenWidth, self.screenHeight);
            [UIView animateWithDuration:0.5 animations:^{
                self.view.transform = CGAffineTransformMakeRotation(0);
            }];
        }
        else
        {
            self.isLandScape = YES;
             backViewFrame = CGRectMake(0, 0, self.screenHeight, self.screenWidth);
            if(_currentOrientation == UIDeviceOrientationLandscapeLeft)
            {
                [UIView animateWithDuration:0.5 animations:^{
                    self.container.transform = CGAffineTransformMakeRotation(M_PI / 2);
                }];
            }
            else
            {
                [UIView animateWithDuration:0.5 animations:^{
                    self.container.transform = CGAffineTransformMakeRotation(- M_PI / 2);
                }];
            }
        }
        self.container.frame = CGRectMake(0, 0, self.screenWidth, self.screenHeight);
        self.collectionView.frame = backViewFrame;
        [_collectionView reloadData];
    }
}

- (UIView *)container {
    if (!_container) {
        _container = [[UIView alloc] init];
        _container.userInteractionEnabled = YES;
        _container.backgroundColor = [UIColor clearColor];
    }
    return _container;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end
