//
//  ViewImageCollectionViewCell.h
//  仿朋友圈
//
//  Created by xiaoliuTX on 2017/9/4.
//  Copyright © 2017年 xiaoliuTX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLViewImageCollectionCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
- (void)setScrollViewContentSize;
@property (nonatomic, copy) void (^dismissBlock)(void);
//- (void)configureWithImageUrl:(NSURL *)url thubnailImage:(UIImage *)thubImage;
@end
