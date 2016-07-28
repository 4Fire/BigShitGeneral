//
//  OwnerSettingController.m
//  大将军
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import "OwnerSettingController.h"
#import "Context.h"
#import "Owner.h"
#import "Dog.h"

@interface OwnerSettingController ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UIView *pureColorView;
@property (nonatomic, strong) UIButton *ownerIcon;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIImageView *sexView;
@property (nonatomic, strong) UITextField *nickNameTextField;
@property (nonatomic, strong) UILabel *sexLab;
@property (nonatomic, strong) UIButton *maleImageView;
@property (nonatomic, strong) UIButton *famaleImageView;
@property (nonatomic, strong) UIImageView *maleSelectImag;
@property (nonatomic, strong) UIImageView *famaleSelectImag;
@property (nonatomic, strong) NSNumber *sex;
@property (nonatomic, strong) UIButton *resetIcon;
@property (nonatomic, strong) NSArray<UIColor *> *colors;

@end

@implementation OwnerSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUserInterface];
}

- (void)initializeUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pureColorView];
    [self.pureColorView addSubview:self.ownerIcon];
    [self.view addSubview:self.sureBtn];
    [self.pureColorView addSubview:self.sexView];
    [self.view addSubview:self.nickNameTextField];
    _nickNameTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"];
    [self.view addSubview:self.sexLab];
    [self.view addSubview:self.maleImageView];
    [self.view addSubview:self.famaleImageView];
    NSNumber *sex = [[NSUserDefaults standardUserDefaults] objectForKey:@"ownerSex"];
    if ([sex isEqual:@0]) {
        self.famaleSelectImag.image = [UIImage imageNamed:@"选中.png"];
        self.maleSelectImag.image = [UIImage new];
    }else {
        self.maleSelectImag.image = [UIImage imageNamed:@"选中.png"];
        self.famaleSelectImag.image = [UIImage new];
    }
    [self.view addSubview:self.resetIcon];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [[NSUserDefaults standardUserDefaults] setObject:self.nickNameTextField.text forKey:@"nickName"];
    [self.view endEditing:YES];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
#pragma mark - Event
- (void)responseToSureBtn {
    NSData *image = UIImageJPEGRepresentation(self.ownerIcon.currentImage, 0.5);
    NSManagedObjectContext *ctx = [Context context];
    [Owner insertOwnerToSQLiterWithContext:ctx account:[[NSUserDefaults standardUserDefaults] objectForKey:@"ownerAccount"] iconImage:image name:self.nickNameTextField.text sex:_sex];
    [[NSUserDefaults standardUserDefaults] setObject:@"hasOwnerIconAlready" forKey:@"ownerIcon"];
    [[NSUserDefaults standardUserDefaults] setObject:self.nickNameTextField.text forKey:@"nickName"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ownerSetting" object:nil  ];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)responseToResetIconBtn {
    if ([_sex isEqual:@1]) {
        [self.ownerIcon setImage:[UIImage imageNamed:@"ownerMale.jpeg"] forState:UIControlStateNormal];
    }else {
        [self.ownerIcon setImage:[UIImage imageNamed:@"ownerFamale.jpeg"] forState:UIControlStateNormal];
    }
    
}


- (void)chooseMale {
    _maleSelectImag.image = [UIImage imageNamed:@"选中"];
    _famaleSelectImag.image = [UIImage imageNamed:@""];
    _sex = @1;
    [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"ownerSex"];
    self.sexView.image = [UIImage imageNamed:@"男性选中"];

//    [self.ownerIcon setImage:[UIImage imageNamed:@"ownerMale.jpeg"] forState:UIControlStateNormal];
}

- (void)chooseFamale {
    _maleSelectImag.image = [UIImage imageNamed:@""];
    _famaleSelectImag.image = [UIImage imageNamed:@"选中"];
    _sex = @0;
    [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"ownerSex"];
    self.sexView.image = [UIImage imageNamed:@"女性未选中"];
    
//    [self.ownerIcon setImage:[UIImage imageNamed:@"ownerFamale.jpeg"] forState:UIControlStateNormal];
}

- (void)responseToOwnerIcon {
    
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

- (UIViewController *)fetchViewControllerWithView:(UIView *)view {
    UIViewController *vc = nil;
    for (UIView *tView = view; tView.nextResponder;tView = tView.superview) {
        if ([tView isKindOfClass:[UIViewController class]]) {
            vc = (UIViewController *)tView.nextResponder;
        }
    }
    return vc;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    if ((picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) | UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
        UIImage  *photo = info[UIImagePickerControllerOriginalImage];
        //        NSLog(@"%@", photo);
        [self.ownerIcon setImage:photo forState:UIControlStateNormal];
    }
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImage *photo = info[UIImagePickerControllerOriginalImage];
//        [[NSUserDefaults standardUserDefaults] setObject:photo forKey:@"ownerIcon"];
        //        NSLog(@"%@", photo);
        [self.ownerIcon setImage:photo forState:UIControlStateNormal];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getting
- (UIView *)pureColorView {
    if (!_pureColorView) {
        _pureColorView = [[UIView alloc] initWithFrame:CGRectMake(0 , 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.68)];
        _pureColorView.backgroundColor = BACKGROUNDCOLOR;
    }
    return _pureColorView;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.bounds = CGRectMake(0, 0, SCREEN_WIDTH * 0.5, 44);
        _sureBtn.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.85);
        _sureBtn.backgroundColor = BACKGROUNDCOLOR;
        [_sureBtn setTitle:@"确     定" forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(responseToSureBtn) forControlEvents:UIControlEventTouchUpInside];
        _sureBtn.layer.cornerRadius = CGRectGetHeight(_sureBtn.bounds) * 0.5;
        _sureBtn.layer.masksToBounds = YES;
    }
    return _sureBtn;
}

- (UIButton *)ownerIcon {
    if (!_ownerIcon) {
        _ownerIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        _ownerIcon.bounds = CGRectMake(0, 0, SCREEN_WIDTH * 0.35, SCREEN_WIDTH * 0.35);
        _ownerIcon.center = CGPointMake(SCREEN_WIDTH * 0.5, CGRectGetHeight(self.pureColorView.bounds) * 0.55);
        _ownerIcon.backgroundColor = [UIColor whiteColor];
        _ownerIcon.layer.cornerRadius = CGRectGetHeight(_ownerIcon.bounds) * 0.5;
        _ownerIcon.layer.masksToBounds = YES;
        
        _colors = @[COLOR(247, 68, 97), COLOR(147, 224, 254), COLOR(255, 95, 73), COLOR(236, 1, 18), COLOR(177, 153, 185), COLOR(140, 221, 73), COLOR(172, 237, 239)];
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:_ownerIcon.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(CGRectGetWidth(_ownerIcon.bounds) * 0.5, CGRectGetWidth(_ownerIcon.bounds) * 0.5)];
        CAShapeLayer *shapLayer = [CAShapeLayer layer];
        shapLayer.path = bezierPath.CGPath;
        shapLayer.strokeColor = _colors[arc4random() % _colors.count].CGColor;
        shapLayer.fillColor = [UIColor clearColor].CGColor;
        shapLayer.lineWidth = 10;
        [_ownerIcon.layer addSublayer:shapLayer];
        
        NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"ownerAccount"];
        NSManagedObjectContext *ctx = [Context context];
        Owner *owner = [Owner fetchOwnerToSQLiterWithContext:ctx Account:account];
        
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"ownerIcon"]) {
            [_ownerIcon setImage:[UIImage imageNamed:@"ownerMale.jpeg"] forState:UIControlStateNormal];
        }else {
            [_ownerIcon setImage:[UIImage imageWithData:owner.iconImage] forState:UIControlStateNormal];
        }
        
        [_ownerIcon addTarget:self action:@selector(responseToOwnerIcon) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ownerIcon;
}

- (UIImageView *)sexView {
    if (!_sexView ) {
        _sexView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"男性未选中"]];
        _sexView.bounds = CGRectMake(0, 0, SCREEN_WIDTH * 0.07, SCREEN_WIDTH * 0.07);
        _sexView.center = CGPointMake(SCREEN_WIDTH * 0.64, CGRectGetHeight(self.pureColorView.bounds) * 0.73);
        _sexView.backgroundColor = [UIColor clearColor];
    }
    return _sexView;
}

- (UITextField *)nickNameTextField {
    if (!_nickNameTextField) {
        _nickNameTextField = [[UITextField alloc] init];
        _nickNameTextField.bounds = CGRectMake(0, 0, SCREEN_WIDTH * 0.6, 44);
        _nickNameTextField.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.45);
        UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"毛笔.png"]];
        leftView.bounds = CGRectMake(0, 0, CGRectGetHeight(_nickNameTextField.bounds), CGRectGetHeight(_nickNameTextField.bounds));
//        _nickNameTextField.leftView = leftView;
        _nickNameTextField.leftViewMode = UITextFieldViewModeAlways;
        _nickNameTextField.placeholder = @"请输入大将军昵称";
        _nickNameTextField.delegate = self;
        _nickNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nickNameTextField.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
        _nickNameTextField.layer.cornerRadius = CGRectGetHeight(_nickNameTextField.bounds) * 0.5;
        _nickNameTextField.layer.masksToBounds = YES;
        _nickNameTextField.textAlignment = NSTextAlignmentCenter;
        _nickNameTextField.keyboardType = UIKeyboardTypeDefault;
    }
    return _nickNameTextField;
}

- (UILabel *)sexLab {
    if (!_sexLab) {
        _sexLab = [[UILabel alloc] init];
        _sexLab.bounds = CGRectMake(0, 0, SCREEN_WIDTH * 0.5, SCREEN_WIDTH * 0.04);
        _sexLab.center = CGPointMake(SCREEN_WIDTH * 0.5, CGRectGetMaxY(self.nickNameTextField.frame) + SCREEN_WIDTH * 0.1);
        _sexLab.text = @"选个喜欢的性别吧";
        _sexLab.textColor = BACKGROUNDCOLOR;
        _sexLab.textAlignment = NSTextAlignmentCenter;
    }
    return _sexLab;
}

- (UIButton *)getBtnWithCenter:(CGPoint)center isMale:(BOOL)isMale {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.bounds = CGRectMake(0, 0, SCREEN_WIDTH * 0.3, SCREEN_WIDTH * 0.3);
    btn.center = center;
    if (isMale) {
        [btn setImage:[UIImage imageNamed:@"ownerMale.jpeg"] forState:UIControlStateNormal];
        _maleSelectImag = [[UIImageView alloc] initWithFrame:CGRectMake(btn.bounds.size.width * 0.8, btn.bounds.size.height * 0.8, CGRectGetWidth(btn.bounds) * 0.2, CGRectGetWidth(btn.bounds) * 0.2)];
//        _maleSelectImag.backgroundColor = [UIColor orangeColor];
        [btn addSubview:_maleSelectImag];
    }else {
        [btn setImage:[UIImage imageNamed:@"ownerFamale.jpeg"] forState:UIControlStateNormal];
        _famaleSelectImag = [[UIImageView alloc] initWithFrame:CGRectMake(btn.bounds.size.width * 0.8, btn.bounds.size.height * 0.8, CGRectGetWidth(btn.bounds) * 0.2, CGRectGetWidth(btn.bounds) * 0.2)];
//        _famaleSelectImag.backgroundColor = [UIColor orangeColor];
        [btn addSubview:_famaleSelectImag];

    }
    return btn;
}

- (UIButton *)maleImageView {
    if (!_maleImageView) {
        _maleImageView = [self getBtnWithCenter:CGPointMake(SCREEN_WIDTH * 0.3, CGRectGetMaxY(self.sexLab.frame) + SCREEN_WIDTH * 0.2) isMale:YES];
        [_maleImageView addTarget:self action:@selector(chooseMale) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maleImageView;
}

- (UIButton *)famaleImageView {
    if (!_famaleImageView) {
        _famaleImageView = [self getBtnWithCenter:CGPointMake(SCREEN_WIDTH * 0.7, CGRectGetMaxY(self.sexLab.frame) + SCREEN_WIDTH * 0.2) isMale:NO];
        [_famaleImageView addTarget:self action:@selector(chooseFamale) forControlEvents:UIControlEventTouchUpInside];
    }
    return _famaleImageView;
}

- (UIButton *)resetIcon {
    if (!_resetIcon) {
        _resetIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        _resetIcon.bounds = CGRectMake(0, 0, SCREEN_WIDTH * 0.25, SCREEN_WIDTH * 0.05);
        _resetIcon.center = CGPointMake(SCREEN_WIDTH * 0.5, CGRectGetMaxY(self.ownerIcon.frame) + 20);
        [_resetIcon setTitle:@"重置头像" forState:UIControlStateNormal];
        [_resetIcon setTitleColor:_colors[arc4random() % _colors.count] forState:UIControlStateNormal];
        _resetIcon.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
        [_resetIcon addTarget:self action:@selector(responseToResetIconBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetIcon;
}

@end
