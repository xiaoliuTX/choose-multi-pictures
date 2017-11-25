//
//  XLPhotosSliderViewController.h
//  选择多张照片
//
//  Created by xiaoliuTX on 2017/10/23.
//  Copyright © 2017年 xiaoliuTX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "XLSelectImageModel.h"

typedef NS_ENUM(NSInteger, PhotoSliderSource) {
    PhotoSliderSource_
};
@interface XLPhotosSliderViewController : UIViewController
@property (nonatomic, strong) PHFetchResult<PHAsset *> *imageAssetsArray;
@property (nonatomic, strong) NSMutableArray *selectImagesArray;
@property (nonatomic, strong) XLSelectImageModel *nowSelectModel;
+ (instancetype)instaneVC;
@end
