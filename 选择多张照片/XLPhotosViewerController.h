//
//  XLPhotosViewerController.h
//  选择多张照片
//
//  Created by xiaoliuTX on 2017/10/20.
//  Copyright © 2017年 xiaoliuTX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface XLPhotosViewerController : UIViewController
@property (nonatomic, strong) PHFetchResult<PHAsset *> *imageAssetsArray;

+ (instancetype)instanceVC;
@end
