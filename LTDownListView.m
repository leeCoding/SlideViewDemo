//
//  LTDownListView.m
//  LTCarouselView
//
//  Created by Jonny on 16/3/14.
//  Copyright © 2016年 Jonny. All rights reserved.
//

#import "LTDownListView.h"
#import "LTClassifyModel.h"

#define _kScreenWidth [UIScreen mainScreen].bounds.size.width
#define _kScreenHeight [UIScreen mainScreen].bounds.size.height
#define _kFontSize 17

#define _kBaseColor [UIColor colorWithRed:240 green:243 blue:243 alpha:1]

@interface LTDownListView ()<UITableViewDelegate,UITableViewDataSource> {
    
    UIView *_backView;          ///< 黑色背景
    UITableView *_tableView;    ///< 表数据
    NSArray *_state;            ///< 状态值
}

@end

@implementation LTDownListView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        //表头
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _kScreenWidth, 60)];
        
        UIButton * returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        returnBtn.frame = CGRectMake(10, 23, 25, 25);
        [returnBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:0];
        returnBtn.titleLabel.font = [ UIFont systemFontOfSize:_kFontSize ];
        
        [returnBtn setTitleColor:[UIColor blackColor] forState:0];
        [returnBtn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:returnBtn];
        
        //标题
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((headView.bounds.size.width-100)/2, 23, 100, 25)];
        titleLabel.text = @"全部分类";
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font =[UIFont systemFontOfSize:_kFontSize];
        [headView addSubview:titleLabel];
        
        //线
        CALayer *line = [[CALayer alloc]init];
        line.frame = CGRectMake(0, 59, _kScreenWidth, 1);
        
        
        
        line.backgroundColor = _kBaseColor.CGColor;
        
        [headView.layer addSublayer:line];
        
        //表视图
         _tableView= [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _kScreenWidth-60, _kScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = headView;
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        [self addSubview:_tableView];
        
    }
    return self;

}

- (void)setClassifyArr:(NSArray *)classifyArr {
    
    _classifyArr = classifyArr;
    [_tableView reloadData];
}

#pragma mark - PublicMethod
/** 隐藏 */
- (void)hideView {
    
    [self cancelAnimation:^{
    }];
}

/** 显示 */
- (void)showPhotoActionSheet {
    
    [self addSubview];
    
    CGRect frame = self.frame;
    
    frame.origin.x = 60;
    [UIView animateWithDuration:.25f animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - PrivateMethod
- (void)addSubview {
    
    UIViewController *toVC = [self appRootViewController];
    if (toVC.tabBarController != nil) {
        [toVC.tabBarController.view addSubview:self];
    }else if (toVC.navigationController != nil){
        [toVC.navigationController.view addSubview:self];
    }else{
        [toVC.view addSubview:self];
    }
}

- (UIViewController *)appRootViewController {
    
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

/** 隐藏 */
- (void)cancelAnimation:(void (^)(void))comple {
    
    CGRect frame = self.frame;
    frame.origin.x = [UIScreen mainScreen].bounds.size.width-40;
    [UIView animateWithDuration:.25f animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        if (comple) {
            comple();
        }
        //动画结束调用
        if ([self.delegate respondsToSelector:@selector(hideAnimationWithOver:)]) {
            [self.delegate hideAnimationWithOver:self];
        }
        
        [self removeFromSuperview];
    }];
}

/** 点击显示下拉数据 */
-(void)tapDownList:(UITapGestureRecognizer *)tap {
    
    LTClassifyModel *model  = _classifyArr[tap.view.tag];
    model.isClose =!model.isClose;
    NSMutableArray *tempStateAry = [_classifyArr mutableCopy];
    [tempStateAry removeObjectAtIndex:tap.view.tag];
    [tempStateAry insertObject:model atIndex:tap.view.tag];
    _classifyArr = [tempStateAry copy];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:tap.view.tag];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade]; //刷新指定单元格
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    LTClassifyModel *model =  _classifyArr[section];
    NSArray *ary = model.subClassArr;
    return model.isClose == NO ? 0 : ary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    LTClassifyModel *model = _classifyArr[indexPath.section];;
    LTClassifyModel *kind = model.subClassArr[indexPath.row];
    cell.textLabel.text = kind.title;
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) { [cell setSeparatorInset:UIEdgeInsetsZero]; }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])  { [cell setLayoutMargins:UIEdgeInsetsZero]; }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _classifyArr == nil ? 0 : _classifyArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectZero];
    sectionView.backgroundColor = [UIColor whiteColor];
    
    // 线
    CALayer *line = [[CALayer alloc]init];
    line.frame = CGRectMake(sectionView.frame.origin.x, 39, _kScreenWidth, 1);
    line.backgroundColor = _kBaseColor.CGColor;
    [sectionView.layer addSublayer:line];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 39)];
    titleLabel.backgroundColor = [UIColor whiteColor];
    LTClassifyModel *model = _classifyArr[section];;
    titleLabel.text = model.title;
    [sectionView addSubview:titleLabel];
    sectionView.tag = section;
    
    // 箭头
    UIImageView *downImage = [[UIImageView alloc]initWithFrame:CGRectMake(tableView.frame.size.width- 30, 10, 20, 20)];
    downImage.image = [UIImage imageNamed:@"back"];
    
    if (model.isClose) {
        
        downImage.transform = CGAffineTransformMakeRotation(M_PI/2);
        
    } else {
        
        downImage.transform = CGAffineTransformMakeRotation(300);
    }
    
    [sectionView addSubview:downImage];
    
    // 手势
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDownList:)];
    [sectionView addGestureRecognizer:tap];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LTClassifyModel *model = _classifyArr[indexPath.section];;
    LTClassifyModel *subkind = model.subClassArr[indexPath.row];
    
    //选择分类回调
    if ([self.delegate respondsToSelector:@selector(selectorClassifyWithRow:classifyModel:)]) {
        [self.delegate selectorClassifyWithRow:self classifyModel:subkind];
        //隐藏侧滑
        [self hideView];
    }
}

@end
