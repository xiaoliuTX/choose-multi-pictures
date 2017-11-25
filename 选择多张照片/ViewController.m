//
//  ViewController.m
//  选择多张照片
//
//  Created by xiaoliuTX on 2017/10/26.
//  Copyright © 2017年 xiaoliuTX. All rights reserved.
//

#import "ViewController.h"
#import "XLAlbumsTableViewController.h"
#import "XLPhotosViewerController.h"
#import "XLPhotoManager.h"
#import "XLAlbumModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)presentPhotosVC:(id)sender {
    XLAlbumsTableViewController *tableVC = [XLAlbumsTableViewController instanceVC];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tableVC];
    XLAlbumModel *model = [[XLPhotoManager getAllAssetCollections] firstObject];
    XLPhotosViewerController *phototVC = [XLPhotosViewerController instanceVC];
    phototVC.imageAssetsArray = model.imageAssetsArray;
    [nav pushViewController:phototVC animated:NO];
    
    [self presentViewController:nav animated:YES completion:nil];
}

@end
