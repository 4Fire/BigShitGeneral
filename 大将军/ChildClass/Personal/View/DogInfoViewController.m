

//
//  DogInfoViewController.m
//  大将军
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import "DogInfoViewController.h"


@interface DogInfoViewController ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSString *_oldName;
}
@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, strong) UIImageView *pureView;
@property (nonatomic, strong) UIButton *dogIcon;
@property (nonatomic, strong) UITextField *dogName;
@property (nonatomic, strong) NSNumber *isMale;
@property (nonatomic, strong) NSString *variety;
@property (nonatomic, strong) NSNumber *neutering;
@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *cancelBtn;


@end

@implementation DogInfoViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeUserInterface];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initializeUserInterface];
//    [self moveAnimation];
   //    NSLog(@"%@",self.dog.iconImage);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self moveAnimation];
}

- (void)initializeUserInterface {
    self.view.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    [self.view addSubview:self.detailView];
    [self.detailView addSubview:self.pureView];
    [self.pureView addSubview:self.dogIcon];
    [self.detailView addSubview:self.dogName];
    [self.detailView addSubview:self.backBtn];
    [self.detailView addSubview:self.cancelBtn];
}

- (void)setDog:(Dog *)dog {
    _dog = dog;
    [self.dogIcon setImage:[UIImage imageWithData:self.dog.iconImage] forState:UIControlStateNormal];
    self.dogName.text = _dog.name;
    _oldName = _dog.name;
}


#pragma mark - Animation
- (void)moveAnimation {
//     _detailView.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT *  -0.5);
    [UIView animateWithDuration:0.5 animations:^{
        [self.detailView setCenter:CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5)];
    }];
    CAKeyframeAnimation *animation = [[CAKeyframeAnimation alloc] init];
    animation.values = @[@(M_PI / 64), @(0), @(- M_PI / 64), @(0), @(M_PI / 64), @(0)];
    animation.duration = 0.5f;
    //平面圆的旋转
    [animation setKeyPath:@"transform.rotation"];
    //结束后不恢复原状
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [animation setDelegate:self];
    [self.detailView.layer addAnimation:animation forKey:@"shake"];

}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    if ((picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) | UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
        UIImage  *photo = info[UIImagePickerControllerOriginalImage];
        //        NSLog(@"%@", photo);
        [self.dogIcon setImage:photo forState:UIControlStateNormal];
    }
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImage *photo = info[UIImagePickerControllerOriginalImage];
        //        [[NSUserDefaults standardUserDefaults] setObject:photo forKey:@"ownerIcon"];
        //        NSLog(@"%@", photo);
        [self.dogIcon setImage:photo forState:UIControlStateNormal];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Events
- (void)cancel {
    [UIView animateWithDuration:0.5 animations:^{
        self.detailView.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 1.5);
        self.detailView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    }completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)back {
    if (self.dogName.text.length == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"狗狗名字不能为空!" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertController dismissViewControllerAnimated:YES completion:nil];
        });
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }else {
        if ( [self.delegate respondsToSelector:@selector(dogInfoDidChanged)] ) {
            [self.delegate dogInfoDidChanged];
        }
    NSData *image1 = UIImageJPEGRepresentation(self.dogIcon.currentImage, 0.5);
        [Dog changeDogInfoWithNewName:self.dogName.text OldName:_oldName Icon:image1 Account:[[NSUserDefaults standardUserDefaults] objectForKey:@"ownerAccount"]];
    [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)responseToDogIcon {
    
    UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
    pickerView.delegate = self;
    
    if  ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请选择照片来源" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *photoLibraryAct = [UIAlertAction actionWithTitle:@"打开照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            pickerView.sourceType = UIImagePickerControllerSourceTypePhotoLibrary | UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            //            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:pickerView animated:YES completion:nil];
            [self presentViewController:pickerView animated:YES completion:nil];
        }];
        UIAlertAction *cameraAct = [UIAlertAction actionWithTitle:@"打开照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            pickerView.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerView.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            pickerView.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            //            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:pickerView animated:YES completion:nil];
            [self presentViewController:pickerView animated:YES completion:nil];
        }];
        UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:photoLibraryAct];
        [alertController addAction:cameraAct];
        [alertController addAction:cancelAct];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


#pragma mark - Getter

- (UIView *)detailView {
    if (!_detailView) {
        _detailView = [[UIView alloc] init];
        _detailView.bounds = CGRectMake(0, 0, SCREEN_WIDTH * 0.8, SCREEN_HEIGHT * 0.5);
        _detailView.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT *  -0.5);
        _detailView.backgroundColor = [UIColor whiteColor];
    }
    return _detailView;
}

- (UIImageView *)pureView {
    if (!_pureView) {
        _pureView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"背景.jpeg"]];
        _pureView.frame = CGRectMake(0, 0, CGRectGetWidth(self.detailView.bounds), CGRectGetWidth(self.detailView.bounds) * 0.5);
        _pureView.userInteractionEnabled = YES;
    }
    return _pureView;
}

- (UIButton *)dogIcon {
    if (!_dogIcon) {
        _dogIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        _dogIcon.bounds = CGRectMake(0, 0, CGRectGetWidth(self.detailView.bounds) * 0.3, CGRectGetWidth(self.detailView.bounds) * 0.3);
        _dogIcon.center = CGPointMake(CGRectGetWidth(self.pureView.frame) * 0.5, CGRectGetHeight(self.pureView.frame) * 0.55);
        _dogIcon.backgroundColor = [UIColor whiteColor];
        _dogIcon.layer.cornerRadius = CGRectGetHeight(_dogIcon.bounds) * 0.5;
        _dogIcon.layer.masksToBounds = YES;
        
        NSArray<UIColor *> *colors = @[COLOR(247, 68, 97), COLOR(147, 224, 254), COLOR(255, 95, 73), COLOR(236, 1, 18), COLOR(177, 153, 185), COLOR(140, 221, 73), COLOR(172, 237, 239)];
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:_dogIcon.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(CGRectGetWidth(_dogIcon.bounds) * 0.5, CGRectGetWidth(_dogIcon.bounds) * 0.5)];
        CAShapeLayer *shapLayer = [CAShapeLayer layer];
        shapLayer.path = bezierPath.CGPath;
        shapLayer.strokeColor = colors[arc4random() % colors.count].CGColor;
        shapLayer.fillColor = [UIColor clearColor].CGColor;
        shapLayer.lineWidth = 10;
        [_dogIcon.layer addSublayer:shapLayer];
        
        [_dogIcon setImage:[UIImage imageWithData:self.dog.iconImage] forState:UIControlStateNormal];
    
        [_dogIcon addTarget:self action:@selector(responseToDogIcon) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dogIcon;
}

- (UITextField *)dogName {
    if (!_dogName) {
        _dogName = [[UITextField alloc] init];
        _dogName.bounds = CGRectMake(0, 0, CGRectGetWidth(self.detailView.bounds) * 0.7, 44);
        _dogName.center = CGPointMake(CGRectGetWidth(self.detailView.bounds) * 0.5, CGRectGetHeight(self.detailView.bounds) * 0.6);
        _dogName.layer.cornerRadius = CGRectGetHeight(_dogName.bounds) * 0.5;
        _dogName.layer.masksToBounds = YES;
        _dogName.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
        _dogName.textAlignment = NSTextAlignmentCenter;
        UILabel *lab = [[UILabel alloc] init];
        lab.bounds = CGRectMake(0, 0, CGRectGetWidth(self.detailView.bounds) * 0.2, 44);
        lab.text = @"名字";
        lab.textColor = [UIColor whiteColor];
        lab.textAlignment = NSTextAlignmentRight;
        _dogName.leftView = lab;
        _dogName.leftViewMode = UITextFieldViewModeAlways;
        _dogName.placeholder = @"重新起个名字吧";
        _dogName.clearButtonMode = UITextFieldViewModeWhileEditing;
        _dogName.returnKeyType = UIReturnKeyGo;
        _dogName.delegate = self;
    }
    return _dogName;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.bounds = CGRectMake(0, 0, CGRectGetWidth(self.detailView.bounds) * 0.5, 44);
        _backBtn.center = CGPointMake(CGRectGetWidth(self.detailView.bounds) * 0.5, CGRectGetHeight(self.detailView.bounds) * 0.9);
        [_backBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.backgroundColor = BACKGROUNDCOLOR;
    }
    return _backBtn;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(CGRectGetWidth(self.detailView.frame) - SCREEN_WIDTH * 0.1, 0, SCREEN_WIDTH * 0.1, SCREEN_WIDTH * 0.1);
        [_cancelBtn setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
@end
