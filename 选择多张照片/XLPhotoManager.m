//
//  XLPhotoManager.m
//  选择多张照片
//
//  Created by xiaoliuTX on 2017/10/25.
//  Copyright © 2017年 xiaoliuTX. All rights reserved.
//

#import "XLPhotoManager.h"

@implementation XLPhotoManager
+(instancetype)shareInstance {
    static XLPhotoManager *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [XLPhotoManager new];
    });
    
    return shareManager;
}

- (NSMutableArray *)selectImagesArray {
    if (!_selectImagesArray) {
        _selectImagesArray = [NSMutableArray array];
    }
    
    return _selectImagesArray;
}

+ (NSArray *)getAllAssetCollections {
    NSMutableArray *array = [NSMutableArray array];
    
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHFetchResult<PHAssetCollection *> *assetCollections1 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    NSArray *assetCollectionsArray = @[assetCollections1,assetCollections];
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    for (PHFetchResult<PHAssetCollection *> *album in assetCollectionsArray) {
        [album enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {
            //过滤PHCollectionList对象
            if (![collection isKindOfClass:PHAssetCollection.class]) return;
            //过滤最近删除
            if (collection.assetCollectionSubtype == 205 || collection.assetCollectionSubtype == 215 || collection.assetCollectionSubtype ==202 ||collection.assetCollectionSubtype ==201 ||collection.assetCollectionSubtype ==203) return;
            if (collection.assetCollectionSubtype > 213) return;
            
            PHFetchResult<PHAsset *> *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            if (!result.count) return;
            
            XLAlbumModel *model = [[XLAlbumModel alloc] init];
            model.title = collection.localizedTitle;
            model.coverAsset = result.lastObject;
            model.imageAssetsArray = result;
            
            if (collection.assetCollectionSubtype == 209) {
                [array insertObject:model atIndex:0];
            } else {
                [array addObject:model];
            }
        }];
    }
    
    return array;
}

+ (void)requestImageForAsset:(PHAsset*)asset targetSize:(CGSize)targetS resizeMode:(PHImageRequestOptionsResizeMode)resizeMode resultHandler:(void (^)(UIImage *__nullable result, NSDictionary *__nullable info))resultHandler {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.resizeMode = resizeMode;
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetS contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        NSLog(@"%@",result);
        resultHandler(result, info);
    }];
}
@end
