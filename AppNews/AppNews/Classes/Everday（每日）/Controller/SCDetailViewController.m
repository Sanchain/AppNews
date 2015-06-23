//
//  SCDetailViewController.m
//  AppNews
//
//  Created by SanChain on 15/6/22.
//  Copyright (c) 2015年 SanChain. All rights reserved.
//

#import "SCDetailViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
#import "SCConst.h"
#import "Colours.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "SCDetailDemo.h"
#import "SCDetailDemoAuthor.h"
#import "SCDetailLikesData.h"
#import "SCDetailCommentsData.h"


@interface SCDetailViewController ()
/** demo作者模型 */
@property (nonatomic, strong) SCDetailDemoAuthor *demoAuthor;
/** 点赞者模型数组 */
@property (nonatomic, strong) NSMutableArray *likesModelArrayM;
/** 评论者模型数组 */
@property (nonatomic, strong) NSMutableArray *commentsModelArray;

@end

@implementation SCDetailViewController
- (NSMutableArray *)likesModelArrayM
{
    if (!_likesModelArrayM) {
        _likesModelArrayM = [NSMutableArray array];
    }
    return _likesModelArrayM;
}
- (NSMutableArray *)commentsModelArray
{
    if (!_commentsModelArray) {
        _commentsModelArray = [NSMutableArray array];
    }
    return _commentsModelArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    // 导航条设置
    [self setupNavigationBarAttribute];

    // 设置titleView
    [self setupTitleView];
    
    // 加载详情 网络数据
    [self loadDetailData];
    
}

#pragma mark 加载详情 网络数据
- (void)loadDetailData
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSString *url = [NSString stringWithFormat:@"http://www.demo8.com/api/product/%zd", self.demoID.integerValue];
    [mgr GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        // 字典 转 模型
        SCDetailDemo *detailDemo = [SCDetailDemo objectWithKeyValues:responseObject];
        
        // demo作者模型
        SCDetailDemoAuthor *demoAuthor = [SCDetailDemoAuthor objectWithKeyValues:detailDemo.author];
        self.demoAuthor = demoAuthor;
        
        // 装入点赞者模型数组
        for (SCDetailLikesData *likesData in detailDemo.likesData) {
            [self.likesModelArrayM addObject:likesData];
        }
        NSLog(@"-----likesModelArrayM:%zd", self.likesModelArrayM.count);
        
        // 装入评论者数组模型
        for (SCDetailCommentsData *commentsData in detailDemo.commentsData) {
            [self.commentsModelArray addObject:commentsData];
        }
        NSLog(@"-----commentsModelArray:%zd", self.commentsModelArray.count);

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
}



#pragma mark 监听titleView点击
- (void)clickSegmentedControll:(UISegmentedControl *)seg
{
    NSInteger indext = seg.selectedSegmentIndex;
    switch (indext) {
        case 0:
            [self clickDetailBtn]; // 详情
            break;
         case 1:
            [self clickWebBtn]; // 网站
            break;
        default:
            break;
    }
}
// 详情
- (void)clickDetailBtn
{
    NSLog(@"clickDetailBtn");

}

// 网站
- (void)clickWebBtn
{
//    NSLog(@"clickWebBtn");
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.bounds;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}

#pragma mark 集成分享
- (void)share
{
    NSLog(@"share-----%@", self.demoID);
}




#pragma mark 导航条属性设置
- (void)setupNavigationBarAttribute
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStyleDone target:self action:@selector(share)];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor: [UIColor emeraldColor]];
}

#pragma mark 添加navigationBar的titleView
- (void)setupTitleView
{
    NSArray *array = [[NSArray alloc] initWithObjects:@"详情", @"网站", nil];
    UISegmentedControl *segC = [[UISegmentedControl alloc] initWithItems:array];
    segC.selectedSegmentIndex = 0;
    [segC addTarget:self action:@selector(clickSegmentedControll:) forControlEvents:UIControlEventValueChanged];
    segC.width = SCScreenWith * 0.6;
    segC.height = SCNavigationBarH * 0.65;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, [UIColor emeraldColor], NSForegroundColorAttributeName, nil, nil];
    [segC setTitleTextAttributes:dict forState:UIControlStateNormal];
    
    [segC setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil, nil] forState:UIControlStateHighlighted];
    
    self.navigationItem.titleView = segC;
}

@end
