//
//  XLPhotosViewerController.m
//  选择多张照片
//
//  Created by xiaoliuTX on 2017/10/20.
//  Copyright © 2017年 xiaoliuTX. All rights reserved.
//

#import "XLPhotosViewerController.h"
#import "XLPhotosCollectionViewCell.h"
#import "XLPhotosSliderViewController.h"
#import "XLPhotoManager.h"
#import "XLSelectImageModel.h"

#define ScreeWidth [UIScreen mainScreen].bounds.size.width

@interface XLPhotosViewerController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger selectTotals;
@property (nonatomic, strong) NSMutableArray *selectIndexArray;
@property (nonatomic, strong) NSMutableArray *allIndexArray;
@property (nonatomic, assign) BOOL layoutOK;
@end

@implementation XLPhotosViewerController

+ (instancetype)instanceVC {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"photos"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.layoutOK = NO;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.itemSize = CGSizeMake((ScreeWidth-25)/4, ((ScreeWidth-25)/4));
    self.collectionView.collectionViewLayout = layout;
    
    [self.collectionView reloadData];
    
    [self.imageAssetsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.allIndexArray addObject:@(idx)];
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!self.layoutOK) {
        if (self.imageAssetsArray.count >= 1) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.imageAssetsArray.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
            self.layoutOK = YES;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageAssetsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XLPhotosCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gridCell" forIndexPath:indexPath];
    __weak typeof(cell)weakCell = cell;
    CGSize size = cell.contentImageView.bounds.size;
    PHAsset *asset = self.imageAssetsArray[indexPath.row];
    [XLPhotoManager requestImageForAsset:asset targetSize:CGSizeMake(size.width*[UIScreen mainScreen].scale, size.height*[UIScreen mainScreen].scale) resizeMode:PHImageRequestOptionsResizeModeFast resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result) {
            weakCell.contentImageView.image = result;
        }
    }];
    
    // Configure the cell
    __weak typeof(self)weakSelf = self;
    cell.choseButtonTapBlock = ^(BOOL select) {
        if ([XLPhotoManager shareInstance].selectImagesArray.count == [XLPhotoManager shareInstance].MaxNum) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"您最多选择%ld张图片",(long)[XLPhotoManager shareInstance].MaxNum] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
            [alertVC addAction:action];
            
            [self presentViewController:alertVC animated:YES completion:nil];
            return;
        }
        
        if (select) {
//            [weakSelf.selectIndexArray addObject:@(indexPath.row)];
            weakSelf.selectTotals++;
            if (weakSelf.selectTotals == 9) {
                [weakSelf updateUnselectCellStatus:NO];
            }
            
            weakCell.tagLabel.transform = CGAffineTransformMakeScale(0, 0);
            weakCell.selectIndex = weakSelf.selectTotals;
            [UIView animateWithDuration:0.25 animations:^{
                weakCell.tagLabel.transform = CGAffineTransformIdentity;
            }];
            
            XLSelectImageModel *model = [[XLSelectImageModel alloc] init];
            model.image = weakCell.contentImageView.image;
            model.idxInDataSource = indexPath.row;
            model.idxInChose = weakCell.selectIndex;
            [[XLPhotoManager shareInstance].selectImagesArray addObject:[XLSelectImageModel new]];
            [[XLPhotoManager shareInstance].selectImagesArray replaceObjectAtIndex:weakCell.selectIndex-1 withObject:model];
            if ([XLPhotoManager shareInstance].selectImagesArray.count == [XLPhotoManager shareInstance].MaxNum) {
                [weakSelf updateUnselectCellStatus:NO];
            }
        } else {
//            [weakSelf.selectIndexArray removeObject:@(indexPath.row)];
//            if (weakSelf.selectTotals == 9) {
//                [weakSelf updateUnselectCellStatus:YES];
//            }
//            weakSelf.selectTotals --;
//            weakCell.selectIndex = 0;
//
//            [weakSelf updateSelectCellStatus];
            [[XLPhotoManager shareInstance].selectImagesArray removeObjectAtIndex:weakCell.selectIndex];
            if ([XLPhotoManager shareInstance].selectImagesArray.count == [XLPhotoManager shareInstance].MaxNum) {
                [weakSelf updateUnselectCellStatus:YES];
            }
            weakSelf.selectTotals --;
            weakCell.selectIndex = 0;
            [weakSelf updateSelectCellStatus];
        }
        
    };
    
    return cell;
}

- (void)updateUnselectCellStatus:(BOOL)enable {
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.allIndexArray];
    [array removeObjectsInArray:self.selectIndexArray];
    
    [array enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XLPhotosCollectionViewCell *cell = (XLPhotosCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:obj.intValue inSection:0]];
        cell.userInteractionEnabled = enable;
    }];
}

- (void)updateSelectCellStatus {
    [self.selectIndexArray enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *  stop) {
        XLPhotosCollectionViewCell *cell = (XLPhotosCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:obj.intValue inSection:0]];
        cell.selectIndex = idx+1;
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XLPhotosSliderViewController *vc = [XLPhotosSliderViewController instaneVC];
    vc.imageAssetsArray = self.imageAssetsArray;
    XLPhotosCollectionViewCell *cell = (XLPhotosCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    XLSelectImageModel *model = [[XLSelectImageModel alloc] init];
    model.idxInChose = cell.selectIndex;
    model.idxInDataSource = indexPath.row;
    vc.nowSelectModel = model;
    
    NSMutableArray *selectImagesArray = [NSMutableArray array];
    [self.selectIndexArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XLPhotosCollectionViewCell *cell = (XLPhotosCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:[obj intValue] inSection:0]];
        XLSelectImageModel *model = [[XLSelectImageModel alloc] init];
        model.image = cell.contentImageView.image;
        model.idxInDataSource = [obj intValue];
        model.idxInChose = cell.selectIndex;
        [selectImagesArray addObject:model];
    }];
    
    vc.selectImagesArray = [XLPhotoManager shareInstance].selectImagesArray;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onPreViewBtnClick:(id)sender {
    XLPhotosSliderViewController *vc = [XLPhotosSliderViewController instaneVC];
    NSMutableArray *selectImagesArray = [NSMutableArray array];
    NSMutableArray *AssetsArray = [NSMutableArray new];
    [self.selectIndexArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XLPhotosCollectionViewCell *cell = (XLPhotosCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:[obj intValue] inSection:0]];
        XLSelectImageModel *model = [[XLSelectImageModel alloc] init];
        model.image = cell.contentImageView.image;
        model.idxInDataSource = [obj intValue];
        model.idxInChose = cell.selectIndex;
        [selectImagesArray addObject:model];
        
        PHAsset *asset = self.imageAssetsArray[[obj intValue]];
        [AssetsArray addObject:asset];
    }];
    vc.selectImagesArray = selectImagesArray;
    vc.imageAssetsArray = AssetsArray;
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark <UICollectionViewDelegate>
- (NSMutableArray *)allIndexArray {
    if (!_allIndexArray) {
        _allIndexArray = [NSMutableArray array];
    }
    return _allIndexArray;
}

- (NSMutableArray *)selectIndexArray {
    if (!_selectIndexArray) {
        _selectIndexArray = [NSMutableArray array];
    }
    return _selectIndexArray;
}
@end
