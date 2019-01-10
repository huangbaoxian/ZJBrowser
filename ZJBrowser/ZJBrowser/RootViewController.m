//
//  RootViewController.m
//  ZJBrowser
//
//  Created by huangbaoxian on 2019/1/9.
//  Copyright © 2019 huangbaoxian. All rights reserved.
//

#import "RootViewController.h"
#import "ZJPhotoBrowser.h"
#import "ZJPhoto.h"


@interface RootViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
//    [self initTableView];
}
//@"http://pic34.photophoto.cn/20150314/0034034877183417_b.jpg",

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSArray *array = @[@"http://www.pptbz.com/pptpic/UploadFiles_6909/201211/2012111719294197.jpg",
                       
                       @"http://s14.sinaimg.cn/mw690/0070m3m6zy7oc0bQINvbd&690",
                       @"http://pic24.nipic.com/20121010/3798632_184253198370_2.jpg"
                       ];
    NSMutableArray *itemArray = [NSMutableArray array];
    for (NSString *str in array) {
        ZJPhoto *photo = [[ZJPhoto alloc] initWithImageUrl:str];
        [itemArray addObject:photo];
    }
    
    ZJPhotoBrowser *vc = [[ZJPhotoBrowser alloc] init];
    [vc updateZJBrowserWithPhotoArray:itemArray];
    [self.navigationController pushViewController:vc animated:YES];
    [vc reloadDataBrowser];
}

#pragma mark - tableDelegate source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}


- (void)initTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
