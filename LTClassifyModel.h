//
//  LTClassifyModel.h
//  AgricultureWindow
//
//  Created by Jonny on 16/3/15.
//  Copyright © 2016年 农业之窗. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTClassifyModel : NSObject

@property (nonatomic,copy)NSString *title;

// 筛选相关
@property (nonatomic,assign)BOOL isClose;           ///< 记录是否关闭
@property (nonatomic, strong) NSArray *subClassArr; ///< 对应的二级分类数组

@end



