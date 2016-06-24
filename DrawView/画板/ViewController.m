//
//  ViewController.m
//  画板
//
//  Created by yk on 16/3/21.
//  Copyright © 2016年 yk. All rights reserved.
//

#import "ViewController.h"
#import "DrawView.h"
#import "MBProgressHUD+YK.h"
#import "handleImageView.h"

@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet DrawView *drawView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
//清屏
- (IBAction)clearView:(id)sender {
    [self.drawView clearView];
}
//撤销
- (IBAction)undo:(id)sender {
    [self.drawView undo];
}
//橡皮擦
- (IBAction)eraser:(UIButton *)sender {
    [self.drawView eraser:sender];
}
//设置线的颜色
- (IBAction)setLineColor:(UIButton *)sender {
    [self.drawView setLineColorWith:sender.backgroundColor];
}
//设置线宽
- (IBAction)setLineWidth:(UISlider *)sender {
    [self.drawView setLineWidth:sender.value];
}
//保存
- (IBAction)save:(id)sender {

    UIGraphicsBeginImageContextWithOptions(self.drawView.frame.size, NO, 0.0);
    
    [self.drawView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    //保存到系统相册
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    //展示错误信息
    if (error) {
        [MBProgressHUD showError:@"图片保存失败"];
    } else
    {
        [MBProgressHUD showSuccess:@"图片保存成功"];
    }
    
}
//照片
- (IBAction)photo:(id)sender {
    
    //弹出UIImagePickerController,使用modal
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    
    //设置图片来源
    pickerVC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    //使用代理获得相册的数据
    pickerVC.delegate = self;
    
    [self presentViewController:pickerVC animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    //根据key取出Image
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    //把图片处理完(旋转,缩放...)再传给画板
    handleImageView *handleImageV = [[handleImageView alloc] initWithFrame:self.drawView.bounds];
    handleImageV.backgroundColor = [UIColor clearColor];
    handleImageV.image = image;
    
    [self.drawView addSubview:handleImageV];
    
    //使用代理后必须手动去关闭控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}

//隐藏状态栏
-(BOOL)prefersStatusBarHidden
{
    return YES;
}


@end
