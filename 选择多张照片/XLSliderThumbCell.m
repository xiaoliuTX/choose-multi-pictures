//
//  XLSliderThumbCell.m
//  选择多张照片
//
//  Created by xiaoliuTX on 2017/10/25.
//  Copyright © 2017年 xiaoliuTX. All rights reserved.
//

#import "XLSliderThumbCell.h"

@implementation XLSliderThumbCell
- (void)setSelected:(BOOL)selected {
    self.layer.borderWidth = 1;
    if (selected) {
        self.layer.borderColor = [UIColor redColor].CGColor;
    } else {
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
}
@end
