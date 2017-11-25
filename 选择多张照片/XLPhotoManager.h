//
//  XLPhotoManager.h
//  选择多张照片
//
//  Created by xiaoliuTX on 2017/10/25.
//  Copyright © 2017年 xiaoliuTX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLAlbumModel.h"
#import "XLSelectImageModel.h"

@interface XLPhotoManager : NSObject
@property (nonatomic, strong) NSMutableArray<XLSelectImageModel*> *selectImagesArray;
@property (nonatomic, assign) NSInteger MaxNum;         //最多选择图片数
+ (instancetype)shareInstance;
// 获取所有的相册图集
+ (NSArray *)getAllAssetCollections;

+ (void)requestImageForAsset:(PHAsset*)asset targetSize:(CGSize)targetS resizeMode:(PHImageRequestOptionsResizeMode)resizeMode resultHandler:(void (^)(UIImage *result, NSDictionary * info))resultHandler;
@end
