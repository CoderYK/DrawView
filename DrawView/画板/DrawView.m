//
//  DrawView.m
//  画板
//
//  Created by yk on 16/3/21.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "DrawView.h"
#import "myBezierPath.h"

@interface DrawView ()
//记录当前创建的路径
@property (nonatomic, strong) UIBezierPath *path;
//保存路径到数组中
@property (nonatomic, strong) NSMutableArray *pathsArr;
//记录当前创建的路径的颜色
@property (nonatomic ,strong) UIColor *color;
//记录线宽
@property (nonatomic ,assign) CGFloat width;

@end

@implementation DrawView

-(void)awakeFromNib
{
    //初始化线宽
    self.width = 1;
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserverForName:@"imageHandled" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        self.image = note.userInfo[@"image"];
    }];
}

-(NSMutableArray *)pathsArr
{
    if (!_pathsArr) {
        _pathsArr = [NSMutableArray array];
    }
    return _pathsArr;
}

//开始点击时调用
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint curP = [self getCurPoint:touches];
    
    myBezierPath *path = [[myBezierPath alloc] init];
    path.lineWidth = self.width;
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineCapStyle = kCGLineCapRound;
    path.color = self.color;
    self.path = path;
    
    [self.pathsArr addObject:path];
    //设置起点
    [path moveToPoint:curP];
}

//获取当前点
- (CGPoint)getCurPoint:(NSSet<UITouch *> *)touches
{
    UITouch *touch = [touches anyObject];
    
    return [touch locationInView:self];
}

//手指移动时调用
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint curP = [self getCurPoint:touches];
    //终点
    [self.path addLineToPoint:curP];
    //重绘
    [self setNeedsDisplay];
}

//清屏
- (void)clearView
{
    //把保存路径的数组清空
    [self.pathsArr removeAllObjects];
    //重绘
    [self setNeedsDisplay];
}

//撤销
- (void)undo
{
    //把保存路径的数组的最后一个元素移除
    [self.pathsArr removeLastObject];
    //重绘
    [self setNeedsDisplay];
}

//设置线的颜色
- (void)setLineColorWith:(UIColor *)color
{
    self.color = color;
}

//设置线宽
- (void)setLineWidth:(CGFloat)width
{
    self.width = width;
}

//橡皮擦
- (void)eraser:(UIButton *)eraser
{
    eraser.tag = !eraser.tag;
    if (eraser.tag) {
        self.color = [UIColor whiteColor];
    } else
    {
        self.color = [UIColor blackColor];
    }
}

-(void)setImage:(UIImage *)image
{
    _image = image;
    //把图片添加数组中
    [self.pathsArr addObject:_image];
    
    //重绘
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
//    [self.path stroke];
    for (myBezierPath *path in self.pathsArr) {
        //把路径取出来后做一个类型判断
        if ([path isKindOfClass:[UIImage class]]) {
            UIImage *image = (UIImage *)path;
            [image drawInRect:rect];
        } else
        {
            [path.color set];
            [path stroke];
        }
    }
}

@end
