//
//  XLPhotosCollectionViewCell.m
//  选择多张照片
//
//  Created by xiaoliuTX on 2017/10/20.
//  Copyright © 2017年 xiaoliuTX. All rights reserved.
//

#import "XLPhotosCollectionViewCell.h"
@interface XLPhotosCollectionViewCell()
@end

@implementation XLPhotosCollectionViewCell
- (void)awakeFromNib {
    [super awakeFromNib];

    self.tagLabel.layer.cornerRadius = CGRectGetWidth(self.tagLabel.frame)/2;
    self.tagLabel.layer.masksToBounds = YES;

}
- (IBAction)click:(UIButton*)sender {
    if (self.choseButtonTapBlock) {
        if (sender.selected) {
            self.choseButtonTapBlock(NO);
        } else {
            self.choseButtonTapBlock(YES);
        }
    }
    sender.selected = !sender.selected;
}

//- (void)setSelected:(BOOL)selected {
//    if (selected) {
//        [self.choseButton setTitle:@"1" forState:UIControlStateNormal];
//    } else {
//        [self.choseButton setTitle:@"no" forState:UIControlStateNormal];
//    }
//}

- (void)setSelectIndex:(NSInteger)selectIndex {
    if (selectIndex != 0) {
        self.tagLabel.text = [NSString stringWithFormat:@"%ld",(long)selectIndex];
        self.tagLabel.hidden = NO;
    } else {
        self.tagLabel.text = @"";
        self.tagLabel.hidden = YES;
    }
    _selectIndex = selectIndex;
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    [super setUserInteractionEnabled:userInteractionEnabled];
    
    if (!userInteractionEnabled) {
        self.contentImageView.alpha = 0.5;
    } else {
        self.contentImageView.alpha = 1;
    }
}
@end
