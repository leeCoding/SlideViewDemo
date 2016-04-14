//
//  ViewController.m
//  SlideViewDemo
//
//  Created by Jonny on 16/4/14.
//  Copyright © 2016年 Jonny. All rights reserved.
//

#import "ViewController.h"
#import "LTDownListView.h"
#import "LTClassifyModel.h"


#define _kScreenWidth [UIScreen mainScreen].bounds.size.width
#define _kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface ViewController ()
<
    LTDownListViewDelegate
>
@property(nonatomic,strong,getter = getListView)LTDownListView *downListView;
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)NSMutableArray *dataAry;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //显示按钮
    UIButton * showListView = [UIButton buttonWithType:UIButtonTypeCustom];
    showListView.frame = CGRectMake((_kScreenWidth-(_kScreenWidth/2))/2, 200, _kScreenWidth/2, 30);
    [showListView setTitle:@"show" forState:0];
    showListView.backgroundColor = [UIColor purpleColor];
    [showListView addTarget:self action:@selector(showRightScreenView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showListView];
    
    [self initData];
}

#pragma mark - 初始化数据
- (void)initData {
    
    self.dataAry = [NSMutableArray array];
    
    for (int i = 0;i < 10 ;i++) {
        
        LTClassifyModel *modelBig = [[LTClassifyModel alloc]init];
        modelBig.title = [NSString stringWithFormat:@"区%d",i];
        
        NSMutableArray *ary = [NSMutableArray array];
        for (int j = 0; j<5;j++ ) {
            LTClassifyModel *model = [[LTClassifyModel alloc]init];
            model.title = [NSString stringWithFormat:@"行%d",j];
            [ary addObject:model];
            modelBig.subClassArr = [ary copy];
        }
        
        [self.dataAry addObject:modelBig];
    }
}

-(LTDownListView *)getListView {
    
    if (!_downListView) {
        _downListView = [[LTDownListView alloc]initWithFrame:CGRectMake(_kScreenWidth-60, 0, _kScreenWidth-60, _kScreenHeight)];
        _downListView.delegate = self;
    }
    return _downListView;
}

#pragma mark - LTDownListViewDelegate
- (void)hideAnimationWithOver:(LTDownListView *)downListView {
    
    self.backView.alpha = 0;
}

- (void)selectorClassifyWithRow:(LTDownListView *)downListView classifyModel:(LTClassifyModel *)classifyModel {
 
     NSLog(@" 选择之后%@",classifyModel.title);
}

/* 显示 */
- (void)showRightScreenView {
    
    //配置数据
    self.downListView.classifyArr = self.dataAry;
    
    //添加背景
    [self addBackView];
    
    //显示侧滑
    [self.downListView showPhotoActionSheet];
}

/* 黑色背景消失 */
- (void)hideDownListView {
    
    [self.downListView hideView];
    self.backView.alpha = 0;
}

/* 黑色背景 */
- (void)addBackView {
    //背景
    _backView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _backView.backgroundColor = [UIColor blackColor];
    _backView .alpha = 0.5;
    
    //点击手势消失
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideDownListView)];
    [_backView addGestureRecognizer:tap];
    [self.view addSubview:_backView];
}

/* 页面消失时 隐藏侧滑 */
-(void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    self.backView.alpha = 0;
    [self.downListView hideView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
