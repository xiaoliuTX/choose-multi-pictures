//
//  XLPhotosCollectionViewCell.h
//  选择多张照片
//
//  Created by xiaoliuTX on 2017/10/20.
//  Copyright © 2017年 xiaoliuTX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLPhotosCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIButton *choseButton;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (nonatomic, copy) void (^choseButtonTapBlock)(BOOL select);

@property (nonatomic, assign) NSInteger selectIndex;        // 选中标记顺序
@end
