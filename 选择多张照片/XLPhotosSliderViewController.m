//
//  XLPhotosSliderViewController.m
//  选择多张照片
//
//  Created by xiaoliuTX on 2017/10/23.
//  Copyright © 2017年 xiaoliuTX. All rights reserved.
//

#import "XLPhotosSliderViewController.h"
#import "XLViewImageCollectionCell.h"
#import "XLPhotoManager.h"
#import "XLSliderThumbCell.h"

#define ScreeWidth  [UIScreen mainScreen].bounds.size.width
#define ScreeHeight [UIScreen mainScreen].bounds.size.height


@interface XLPhotosSliderViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectoinViewWidthCons;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *thumbImageCollectionView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *topIndexLabel;
@property (nonatomic, assign) BOOL layoutOK;
//@property (nonatomic, strong) NSMutableArray *originImagesArray;
@end

@implementation XLPhotosSliderViewController
+ (instancetype)instaneVC {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"slider"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.layoutOK = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:@"XLViewImageCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"imageCell"];
    // Do any additional setup after loading the view.
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.thumbImageCollectionView.delegate = self;
    self.thumbImageCollectionView.dataSource = self;
    
    self.collectoinViewWidthCons.constant = ScreeWidth+15;
    [self.view layoutIfNeeded];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(ScreeWidth+15, ScreeHeight);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 15;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
  
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.pagingEnabled = YES;
   
    
    UICollectionViewFlowLayout *thumblayout = [[UICollectionViewFlowLayout alloc] init];
    thumblayout.itemSize = CGSizeMake(54, 54);
    thumblayout.minimumInteritemSpacing = 13;
    thumblayout.minimumLineSpacing = 13;
    thumblayout.sectionInset = UIEdgeInsetsMake(13, 13, 13, 13);
    thumblayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.thumbImageCollectionView.collectionViewLayout = thumblayout;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.thumbImageCollectionView addGestureRecognizer:longPress];
    
    if (self.selectImagesArray.count == 0) {
        self.collectionViewHeightCons.constant = 0;
        [self.view layoutIfNeeded];
    }
    
    [self.collectionView reloadData];
    [self.thumbImageCollectionView reloadData];
    
    self.topIndexLabel.layer.cornerRadius = CGRectGetWidth(self.topIndexLabel.frame)/2;
    self.topIndexLabel.layer.masksToBounds = YES;
    self.topIndexLabel.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}



- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!self.layoutOK) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.nowSelectModel.idxInDataSource inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
//        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:200 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        if (self.nowSelectModel.idxInChose-1 >=0) {
            [self.thumbImageCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.nowSelectModel.idxInChose-1 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
        self.layoutOK = YES;
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)setTopAndBottomView:(BOOL)show {
    if (show) {
        self.bottomView.alpha = 1;
        self.topView.alpha = 1;
    } else {
        self.bottomView.alpha = 0;
        self.topView.alpha = 0;
    }
}

- (IBAction)longPressGestureRecognized:(id)sender {
    NSLog(@"调用");
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.thumbImageCollectionView];
    NSIndexPath *indexPath = [self.thumbImageCollectionView indexPathForItemAtPoint:location];
    
    static UIView *snapshot = nil;
    static NSIndexPath *sourceIndexPath = nil;
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                NSLog(@"Began");
                sourceIndexPath = indexPath;
                UICollectionViewCell *cell = [self.thumbImageCollectionView cellForItemAtIndexPath:sourceIndexPath];
                snapshot = [self customSnapshotFromView:cell];
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.thumbImageCollectionView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    center.x= cell.center.x;
                    center.y = cell.center.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                } completion:^(BOOL finished) {
                    cell.hidden = YES;
                }];
                
            }
        }
            break;
        case UIGestureRecognizerStateChanged: {
            NSLog(@"Changed");
            CGPoint center = snapshot.center;
            center.x = location.x;
            center.y = location.y;
            snapshot.center = center;
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                [self.selectImagesArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                [self.thumbImageCollectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                sourceIndexPath = indexPath;
            }
        }
            break;
        default: {
            NSLog(@"default");
            UICollectionViewCell *cell = [self.thumbImageCollectionView cellForItemAtIndexPath:indexPath];
            cell.hidden = NO;
            //            cell.alpha = 0;
            [UIView animateWithDuration:0.25 animations:^{
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0;
                cell.alpha = 1.0;
            } completion:^(BOOL finished) {
                cell.hidden = NO;
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
            }];
        }
            break;
    }
}

- (UIView *)customSnapshotFromView:(UIView *)inputView {
    //    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    //    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    //    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, YES, 0);
    [inputView drawViewHierarchyInRect:inputView.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = YES;
    snapshot.layer.cornerRadius = 0;
    snapshot.layer.shadowOffset = CGSizeMake(-5, 0);
    snapshot.layer.shadowRadius = 5;
    snapshot.layer.shadowColor = [[UIColor redColor] CGColor];
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:self.collectionView]) {
        return self.imageAssetsArray.count;
    } else {
        return self.selectImagesArray.count;
    }
}

static BOOL flag = YES;

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.collectionView]) {
        __weak typeof(self)weakSelf = self;
        XLViewImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
        __weak typeof(cell)weakCell = cell;
        
        PHAsset *asset = self.imageAssetsArray[indexPath.row];
        [XLPhotoManager requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight) resizeMode:PHImageRequestOptionsResizeModeNone resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            weakCell.imageView.image = result;
        }];
        [cell setScrollViewContentSize];
        cell.dismissBlock = ^{
            [weakSelf setTopAndBottomView:flag];
            flag = !flag;
        };
        
        NSArray *array = [self.selectImagesArray valueForKey:@"idxInDataSource"];
        if ([array containsObject:@(indexPath.row)]) {
            NSInteger index = [array indexOfObject:@(indexPath.row)];
            XLSelectImageModel *model = self.selectImagesArray[index];
            [self.thumbImageCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:model.idxInChose inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            
            self.topIndexLabel.text = [NSString stringWithFormat:@"%ld",(long)model.idxInChose];
            self.topIndexLabel.hidden = NO;
        } else {
            self.topIndexLabel.hidden = YES;
        }
        
        return cell;
    } else {
        XLSliderThumbCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"thumb" forIndexPath:indexPath];
        XLSelectImageModel *model = self.selectImagesArray[indexPath.row];
        cell.imageView.image = model.image;
        
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.thumbImageCollectionView]) {
        XLSelectImageModel *model = self.selectImagesArray[indexPath.row];
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:model.idxInDataSource inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}



@end
