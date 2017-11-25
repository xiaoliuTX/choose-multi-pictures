//
//  XLAlbumModel.h
//  选择多张照片
//
//  Created by xiaoliuTX on 2017/10/24.
//  Copyright © 2017年 xiaoliuTX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface XLAlbumModel : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) PHAsset *coverAsset;
@property (nonatomic, strong) PHFetchResult<PHAsset *> *imageAssetsArray;
@end
