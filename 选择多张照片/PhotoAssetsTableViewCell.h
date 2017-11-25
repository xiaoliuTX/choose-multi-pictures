//
//  PhotoAssetsTableViewCell.h
//  选择多张照片
//
//  Created by xiaoliuTX on 2017/10/20.
//  Copyright © 2017年 xiaoliuTX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoAssetsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *assetNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoCountsLabel;
@end
