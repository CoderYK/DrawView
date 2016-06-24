//
//  DrawView.h
//  画板
//
//  Created by yk on 16/3/21.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView

@property (nonatomic, strong) UIImage *image;

//清屏
- (void)clearView;
//撤销
- (void)undo;
//橡皮擦
- (void)eraser:(UIButton *)eraser;
//设置线的颜色
- (void)setLineColorWith:(UIColor *)color;
//设置线宽
- (void)setLineWidth:(CGFloat)width;

@end
