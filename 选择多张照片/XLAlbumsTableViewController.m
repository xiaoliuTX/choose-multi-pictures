//
//  ViewController.m
//  选择多张照片
//
//  Created by xiaoliuTX on 2017/10/20.
//  Copyright © 2017年 xiaoliuTX. All rights reserved.
//

#import "XLAlbumsTableViewController.h"
#import "PhotoAssetsTableViewCell.h"
#import "XLPhotosViewerController.h"
#import "XLPhotoManager.h"

@interface XLAlbumsTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableArray *datasArray;
@end

@implementation XLAlbumsTableViewController
+ (instancetype)instanceVC {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"albums"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [XLPhotoManager shareInstance].MaxNum = 4;
    self.tableView.rowHeight = 50;
    
    self.datasArray = [NSMutableArray arrayWithArray:[XLPhotoManager getAllAssetCollections]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoAssetsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"asset" forIndexPath:indexPath];
    XLAlbumModel *model = self.datasArray[indexPath.row];
    __weak typeof(cell)weakCell = cell;
    
    CGSize size = cell.imageView.bounds.size;
    [XLPhotoManager requestImageForAsset:model.coverAsset targetSize:CGSizeMake(size.width*[UIScreen mainScreen].scale, size.height*[UIScreen mainScreen].scale) resizeMode:PHImageRequestOptionsResizeModeFast resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result) {
            weakCell.coverImageView.image = result;
        }
    }];
    
    cell.assetNameLabel.text = model.title;
    cell.photoCountsLabel.text = [NSString stringWithFormat:@"( %lu )",(unsigned long)model.imageAssetsArray.count];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XLPhotosViewerController *vc = [XLPhotosViewerController instanceVC];
    XLAlbumModel *model = self.datasArray[indexPath.row];
    vc.imageAssetsArray = model.imageAssetsArray;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSMutableArray *)datasArray {
    if (!_datasArray) {
        _datasArray = [NSMutableArray array];
    }
    
    return _datasArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
