//
//  ZMKHUserUploadPictureTool.m
//  zmPurse
//
//  Created by 胡庭 on 2019/4/28.
//  Copyright © 2019 胡庭. All rights reserved.
//

#import "ZMKHUserUploadPictureTool.h"

static ZMKHUserUploadPictureTool *_zmkhUserPictureTool;

@interface ZMKHUserUploadPictureTool ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation ZMKHUserUploadPictureTool


+ (instancetype)zmkhUserUplaodPictureManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(_zmkhUserPictureTool == nil){
            _zmkhUserPictureTool = [[self alloc] init];
        }
    });
    return _zmkhUserPictureTool;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _zmkhUserPictureTool = [super allocWithZone:zone];
    });
    return _zmkhUserPictureTool;
}

-(id)copyWithZone:(NSZone *)zone
{
    return _zmkhUserPictureTool;
}

-(id)mutableCopyWithZone:(NSZone *)zone {
    return _zmkhUserPictureTool;
}


- (void)uploadCamer
{
    UIAlertController *alertCtl =[[UIAlertController alloc]init];
    UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        SYTLog(@"cancel");
    }];
    UIAlertAction *xiangji =[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SYTLog(@"xiangji");
        [self popCamerOrPhotoLibraary:UIImagePickerControllerSourceTypeCamera];
    }];
    UIAlertAction *xiangce =[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SYTLog(@"xiangce");
        [self popCamerOrPhotoLibraary:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [alertCtl addAction:cancel];
        [alertCtl addAction:xiangji];
        [alertCtl addAction:xiangce];
    }else{
        [alertCtl addAction:cancel];
        [alertCtl addAction:xiangce];
    }
    
    [[self zmkhJumpRooVc:self] presentViewController:alertCtl animated:YES completion:nil];
}



#pragma mark - 跳转相机-相册


- (void)popCamerOrPhotoLibraary:(NSUInteger )sourceType
{
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    
    imagePickerController.allowsEditing = YES;
    
    imagePickerController.sourceType = sourceType;
    
    //跳转动画效果
//    imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [[self zmkhJumpRooVc:self] presentViewController:imagePickerController animated:YES completion:^{}];
}



#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    [[self zmkhJumpRooVc:self] dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (self.uplaodBlock) {
        self.uplaodBlock(image);
    }
    //=======
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    [[self zmkhJumpRooVc:self] dismissViewControllerAnimated:YES completion:^{}];
}



#pragma mark - 获取当前vc

/*
 当前类vc
 */
- (UIViewController *)zmkhJumpRooVc:(id)responder
{
    return [self fetchViewController:responder];
}

#pragma mark --- private

- (UIViewController *)fetchViewController:(id)responder
{
    UIViewController *vc;
    if ([responder isKindOfClass:[UIView class]]) {
        vc = [self fetchViewControllerFromView:responder];
    }else if ([responder isKindOfClass:[UIViewController class]]){
        vc = responder;
    }
    if (!vc) {
        vc = [self fetchViewControllerFromRootViewController];
    }
    return vc;
}

- (UIViewController *)fetchViewControllerFromView:(UIView *)view
{
    UIResponder *responder = view.nextResponder;
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            break;
        }
        responder = responder.nextResponder;
    }
    return (UIViewController *)responder;
}

- (UIViewController *)fetchViewControllerFromRootViewController
{
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (vc) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = [(UITabBarController *)vc selectedViewController];
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = [(UINavigationController *)vc visibleViewController];
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}



/*
 
 - (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<UIImagePickerControllerInfoKey, id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0);
 - (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info;
 - (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
 
 */




@end
