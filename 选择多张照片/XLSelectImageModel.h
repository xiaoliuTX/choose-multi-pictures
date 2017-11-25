//
//  XLSelectImageModel.h
//  选择多张照片
//
//  Created by xiaoliuTX on 2017/10/25.
//  Copyright © 2017年 xiaoliuTX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XLSelectImageModel : NSObject
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) NSInteger idxInDataSource;            //在所有数据源中的位置
@property (nonatomic, assign) NSInteger idxInChose;                 //在选中图片中的位置
@end
