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
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(self.view);
    }];
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
  
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(self.container);
    }];

    
    [self.collectionView reloadData];
}

#pragma mark UIColectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZJBrowserCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZJBrowserCollectionCell" forIndexPath:indexPath];
    if(cell)
    {
        if (self.dataArray.count > indexPath.row) {
            [cell loadZJPhoto:self.dataArray[indexPath.row]];
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
    return CGSizeMake(self.screenWidth, self.screenHeight);
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
