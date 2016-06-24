//
//  handleImageView.m
//  画板
//
//  Created by yk on 16/3/21.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "handleImageView.h"

@interface handleImageView  ()<UIGestureRecognizerDelegate>

@property(nonatomic, weak) UIImageView *imageView;

@end

@implementation handleImageView
//***** 加载imageView****//
-(UIImageView *)imageView
{
    if (_imageView == nil) {

        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        imageView.frame = self.frame;
        _imageView = imageView;
        [self addSubview:imageView];
        //添加手势
        [self setUpGes];
    }
    return _imageView;
}

-(void)setUpGes
{
    //创建手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [_imageView addGestureRecognizer:pan];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [_imageView addGestureRecognizer:pinch];
    pinch.delegate = self;
    
    UIRotationGestureRecognizer *rotationG = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationG:)];
    [_imageView addGestureRecognizer:rotationG];
    rotationG.delegate = self;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [_imageView addGestureRecognizer:longPress];
}

//拖拽
- (void)pan:(UIPanGestureRecognizer *)pan
{
     CGPoint curP = [pan translationInView:pan.view];
    self.imageView.transform = CGAffineTransformTranslate(self.imageView.transform, curP.x, curP.y);
    
    //复位
    [pan setTranslation:CGPointZero inView:pan.view];
}
//缩放
- (void)pinch:(UIPinchGestureRecognizer *)pinch
{
    self.imageView.transform = CGAffineTransformScale(self.imageView.transform, pinch.scale, pinch.scale);
    
    //复位
    [pinch setScale:1];
}

//旋转
 - (void)rotationG:(UIRotationGestureRecognizer *)rotationG
{
    self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, rotationG.rotation);
    
    rotationG.rotation = 0;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

//长按
- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        [UIView animateWithDuration:0.25 animations:^{
            longPress.view.alpha = 0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25 animations:^{
                longPress.view.alpha = 1;
            } completion:^(BOOL finished) {
                //做一个截屏操作
                UIImage *image = [self screenImage];
                
                //通知画板
                [[NSNotificationCenter defaultCenter] postNotificationName:@"imageHandled" object:nil userInfo:@{@"image":image}];
                
                //从父控件移除
                [self removeFromSuperview];
            }];
        }];
    }
    
}
//做一个截屏操作
- (UIImage *)screenImage
{
    UIGraphicsBeginImageContext(self.frame.size);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
//***** 设置imageView的图片****//
-(void)setImage:(UIImage *)image
{
    _image = image;
    
    self.imageView.image = image;
}

@end
