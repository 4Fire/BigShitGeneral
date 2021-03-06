//
//  LoginViewController.m
//  大将军
//
//  Created by apple on 16/7/6.
//  Copyright © 2016年 SingYi. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "UMSocial.h"
#import "MainTabbarController.h"
#import "AddDogViewController.h"

//learCloud
#import <AVOSCloud/AVOSCloud.h>
#import "HttpModel.h"

#import <CoreData/CoreData.h>
#import "Dog.h"
#import "Owner.h"
#import "Context.h"


@interface LoginViewController ()<UITextFieldDelegate>
{
    UITextField *_textField;
}

@property (nonatomic, strong) UIImageView *backView;
@property (nonatomic, strong) UIImageView *iconView;//app头像
@property (nonatomic, strong) UIImageView *nameView;//铲屎大将军文字
@property (nonatomic, strong) UITextField *accountTextField;//账号
@property (nonatomic, strong) UITextField *passwordTextField;//密码
@property (nonatomic, strong) UIButton *loginBtn;//登录按钮
@property (nonatomic, strong) UIButton *forgetPasswordBtn;//忘记密码
@property (nonatomic, strong) UIButton *registerBtn;//注册新用户
@property (nonatomic, strong) UILabel *lineView;//分割线


@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUserInterface];
}

- (void)initializeUserInterface {
    [self.view addSubview:self.backView];
    [self.view addSubview:self.iconView];
    [self.view addSubview:self.nameView];
    [self.view addSubview:self.accountTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.registerBtn];
    [self.view addSubview:self.forgetPasswordBtn];
    [self.view addSubview:self.lineView];
    [self AddTripartiteLoginBtn];//添加三方登录按钮
    
    //注册键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboarkHideAction:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Keyboard
- (void)keyboardAction:(NSNotification *)notif {
    NSValue *keyboardValue = notif.userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    NSNumber *durationValue = notif.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"];
    CGRect keyboardFrame = [keyboardValue CGRectValue];
    CGFloat textfieldH = CGRectGetMaxY(_textField.frame);
    CGFloat keyboardH = CGRectGetMinY(keyboardFrame);
    //如果键盘遮住了输入框
    if (textfieldH > keyboardH) {
        CGFloat distance = textfieldH - keyboardH;
        [UIView animateWithDuration:durationValue.floatValue animations:^{
            _textField.superview.frame = CGRectMake(0,  -distance - 20, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
    }
}

- (void)keyboarkHideAction:(NSNotification *)notification {
    if (_textField.superview.frame.origin.y != 0 ) {
        NSNumber *durationValue = notification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"];
        [UIView animateWithDuration:durationValue.floatValue animations:^{
            _textField.superview.frame = [UIScreen mainScreen].bounds;
        }];
    }
}

#pragma mark - Events
- (void)responseToLoginBtn {
#warning 登陆
    [AVUser logInWithUsernameInBackground:self.accountTextField.text password:self.passwordTextField.text block:^(AVUser *user, NSError *error) {
        if (user != nil) {
            
            BOOL check = [Owner duplicateCheckingOwnerWithContext:[Context context] Account:self.accountTextField.text];
            
            if (check == YES) {
                
                BOOL flag = [Owner insertOwnerToSQLiterWithContext:[Context context] Account:user.username   Password:@"1"];
                
                if (flag == YES) {
                    
                    BOOL flag1 = [Owner insertOwnerToSQLiterWithContext:[Context context] Account:user.username   Password:@"1"];
                    
                    if (flag1 == YES) {
                        [self.view endEditing:true];
                        [self showAlertWithMessage:@"登陆成功成功!" dismiss:^(void){
                            [[NSUserDefaults standardUserDefaults] setObject:user.username forKey:@"ownerAccount"];
                            [self.navigationController pushViewController:[[AddDogViewController alloc] init] animated:YES];
                        }];
                        
                    }else {
                        [self showAlertWithMessage:@"注册失败!" dismiss:nil];
                        return;
                    }
        
                    
            
                }
            } else {
                
                [self.view endEditing:true];
                [self showAlertWithMessage:@"登陆成功!" dismiss:^(void){
                    [[NSUserDefaults standardUserDefaults] setObject:self.accountTextField.text forKey:@"ownerAccount"];
                }];
                [UIApplication sharedApplication].keyWindow.rootViewController = [MainTabbarController new];
                
            }
            
        } else {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            [[self fetchViewControllerByView:self.view] presentViewController:alertController animated:YES completion:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertController dismissViewControllerAnimated:YES completion:nil];
            });
            
        }
    
            
            
            
    }];
    
}

- (UIViewController *)fetchViewControllerByView:(UIView *)aView{
    UIViewController * vc = nil;
    for (UIView * tView = aView; tView.nextResponder; tView = tView.superview) {
        if ([tView.nextResponder isKindOfClass:[UIViewController class]]) {
            vc = (UIViewController *)tView.nextResponder;
            break;
        }
    }
    return vc;
}


- (UINavigationController *)fetchNavigationControllerByView:(UIView *)aView{
    UINavigationController * vc = nil;
    for (UIView * tView = aView; tView.nextResponder; tView = tView.superview) {
        if ([tView.nextResponder isKindOfClass:[UINavigationController class]]) {
            vc = (UINavigationController *)tView.nextResponder;
            break;
        }
    }
    return vc;
}


- (void)responseToRegisterBtn {
//    [[self fetchViewControllerByView:self.view] presentViewController:[[MainTabbarController alloc] init] animated:YES completion:nil];
    [self.navigationController pushViewController:[[RegisterViewController alloc] init]animated:YES];
}

- (void)responseToForgetPasswordBtn {
    
}

- (void)responseToTripartiteLoginBtn:(UIButton *)sender {
    switch (sender.tag) {
        case 100:
            break;
        case 101:
            [self qqLogin];
            break;
        case 102:
            [self sinaLogin];
            break;
        default:
            break;
    }
}

- (void)sinaLogin {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
//            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
//            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
//            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
//            NSLog(@"%@",response.thirdPlatformUserProfile);
        }});
}

- (void)qqLogin {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
#warning  !!!!!!!
//            NSLog(@"QQ ======  \nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            [AVUser logInWithUsernameInBackground:snsAccount.usid password:snsAccount.accessToken block:^(AVUser *user, NSError *error) {
                if (user != nil) {
                    
                    NSString *account = snsAccount.usid;
                    
                    [[NSUserDefaults standardUserDefaults] setObject:account forKey:@"ownerAccount"];
                    
                    NSManagedObjectContext *ctx = [Context context];
                    
                    BOOL check = [Owner duplicateCheckingOwnerWithContext:ctx Account:account];
                    
                    if (check == NO) {
                        [UIApplication sharedApplication].keyWindow.rootViewController = [[MainTabbarController alloc] init];
                    } else {
                        BOOL flag = [Owner insertOwnerToSQLiterWithContext:[Context context] Account:user.username   Password:@"1"];
                        
                        if (flag == YES) {
                            [self.view endEditing:true];
                            [self showAlertWithMessage:@"注册成功!" dismiss:^(void){
                                [[NSUserDefaults standardUserDefaults] setObject:account forKey:@"ownerAccount"];
                                [self.navigationController pushViewController:[[AddDogViewController alloc] init] animated:YES];
                            }];
                            
                        }else {
                            [self showAlertWithMessage:@"注册失败!" dismiss:nil];
                            return;
                        }
                    }
                } else {
                    
                    AVUser *user = [AVUser user];// 新建 AVUser 对象实例
                    user.username = snsAccount.usid;// 设置用户名
                    user.password = snsAccount.accessToken;// 设置密码
                    
                    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        
                        if (succeeded) {
                            BOOL flag = [Owner insertOwnerToSQLiterWithContext:[Context context] Account:self.accountTextField.text   Password:self.passwordTextField.text];
                            if (flag == YES) {
                                [self.view endEditing:true];
                                
                                [self showAlertWithMessage:@"注册成功!" dismiss:^(void){
                                    [[NSUserDefaults standardUserDefaults] setObject:self.accountTextField.text forKey:@"ownerAccount"];
                                    
                                    [self.navigationController pushViewController:[[AddDogViewController alloc] init] animated:YES];
                                }];
                            }
                        } else {
                            // 失败的原因可能有多种，常见的是用户名已经存在。
                            [self showAlertWithMessage:error.localizedDescription dismiss:nil];
                        }
                        
                    }];
                }
            }];
            
        }});
}

- (void)showAlertWithMessage:(NSString *)message dismiss:(void(^)(void))dismiss{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:YES completion:^{
            if (dismiss) {
                dismiss();
            }
        }];
    });
}



#pragma mark - TextField
- (UITextField *)createTextFieldWithCenterH:(CGFloat)centerH Placeholder:(NSString *)placeholder SecureTextEntry:(BOOL)secureTextEntry LeftLabelText:(NSString *)leftText {
    UITextField *textField = [[UITextField alloc] init];
    textField.bounds = CGRectMake(0, 0, SCREEN_WIDTH * 0.76, SCREEN_HEIGHT * 0.064);
    textField.center = CGPointMake(SCREEN_WIDTH * 0.5, centerH);
    textField.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    //占位符
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:COLOR(102, 103, 104), NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    //清除按钮
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.clearsOnBeginEditing = YES;
    //圆角
    textField.layer.cornerRadius = CGRectGetHeight(textField.bounds) * 0.5;
    textField.layer.masksToBounds = YES;
    //字体
    textField.font = [UIFont systemFontOfSize:17];
    textField.textColor = [UIColor whiteColor];
    //左视图
    UILabel *leftLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.18, CGRectGetHeight(textField.bounds))];
    leftLab.text = leftText;
    leftLab.textAlignment = NSTextAlignmentRight;
    leftLab.textColor = [UIColor colorWithWhite:0.6 alpha:1];
    textField.leftView = leftLab;
    textField.leftViewMode = UITextFieldViewModeAlways;
    //保密输入
    if (secureTextEntry == YES) {
        textField.secureTextEntry = YES;
    }
    if (secureTextEntry == NO) {
        textField.secureTextEntry = NO;
    }
    
    textField.textAlignment = NSTextAlignmentCenter;
    return textField;
}


#pragma mark - Btn
- (UIButton *)createBtnWithCenterW:(CGFloat)centerW Title:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.bounds = CGRectMake(0, 0, 65, SCREEN_WIDTH * 0.05);
    btn.center = CGPointMake(centerW, SCREEN_HEIGHT * 0.72);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    return btn;
}

//添加三方登录按钮
- (void)AddTripartiteLoginBtn {
    NSArray *imagesArr = @[@"qq.png"];
    for (NSInteger i = 0; i < imagesArr.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.bounds = CGRectMake(0, 0, SCREEN_WIDTH * 0.05, SCREEN_WIDTH * 0.05);
//        btn.center = CGPointMake(SCREEN_WIDTH * 0.34 + i * SCREEN_WIDTH * 0.16, SCREEN_HEIGHT * 0.89);
        btn.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.89);
        [btn setImage:[UIImage imageNamed:imagesArr[i]] forState:UIControlStateNormal];
//        btn.tag = 100 + i;
        btn.tag = 101;
        [btn addTarget:self action:@selector(responseToTripartiteLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}


#pragma mark - UITextFieldDelegate
// 这个是监听键盘return键的回调方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.accountTextField) {
        [textField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _textField = textField;
    return YES;
}

#pragma mark - Getter
- (UIImageView *)backView {
    if (!_backView) {
        _backView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpeg"]];
        _backView.frame = [UIScreen mainScreen].bounds;
        UIView *view = [[UIView alloc] initWithFrame:_backView.bounds];
        view.backgroundColor = [UIColor colorWithWhite:0.08 alpha:0.9];
        [_backView addSubview:view];
    }
    return _backView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"狗head.png"]];
        _iconView.bounds = CGRectMake( 0, 0, SCREEN_WIDTH * 0.45, SCREEN_WIDTH * 0.45);
        _iconView.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.18);
    }
    return _iconView;
}

- (UIImageView *)nameView {
    if (!_nameView) {
//        UIImage *imag = [UIImage imageNamed:@"屎字1.png"];
        
        _nameView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"屎字1.png"]];
    
        _nameView.bounds = CGRectMake(0, 0, SCREEN_WIDTH * 0.5, SCREEN_WIDTH * 0.3);
        _nameView.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.35);
    }
    return _nameView;
}

- (UITextField *)accountTextField {
    if (!_accountTextField) {
        _accountTextField = [self createTextFieldWithCenterH:SCREEN_HEIGHT * 0.46 Placeholder:@" 请输入大将军暗号" SecureTextEntry:NO LeftLabelText:@"大将军: " ];
        _accountTextField.delegate = self;
        [_accountTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_accountTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        _accountTextField.keyboardType = UIKeyboardTypeAlphabet;
    }
    return _accountTextField;
}

- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [self createTextFieldWithCenterH:SCREEN_HEIGHT * 0.55 Placeholder:@" 请输入大将军密文" SecureTextEntry:YES LeftLabelText:@"密   文: "];
        _passwordTextField.delegate = self;
        _passwordTextField.keyboardType = UIKeyboardTypeAlphabet;
    }
    return _passwordTextField;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.bounds = CGRectMake(0, 0, SCREEN_WIDTH * 0.76, SCREEN_HEIGHT * 0.064);
        _loginBtn.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.65);
        _loginBtn.backgroundColor = BACKGROUNDCOLOR;
//        _loginBtn.backgroundColor = BACKGROUNDCOLOR;
        [_loginBtn setTitle:@"登   录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(responseToLoginBtn) forControlEvents:UIControlEventTouchUpInside];
        
        _loginBtn.layer.cornerRadius = CGRectGetHeight(_loginBtn.bounds) * 0.25;
        _loginBtn.layer.masksToBounds = YES;
    }
    return _loginBtn;
}

- (UIButton *)registerBtn {
    if (!_registerBtn) {
        _registerBtn = [self createBtnWithCenterW:SCREEN_WIDTH * 0.78 Title:@"注册新用户"];
        [_registerBtn addTarget:self action:@selector(responseToRegisterBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}

- (UIButton *)forgetPasswordBtn {
    if (!_forgetPasswordBtn) {
        _forgetPasswordBtn = [self createBtnWithCenterW:SCREEN_WIDTH * 0.22 Title:@"忘记密码"];
        [_forgetPasswordBtn addTarget:self action:@selector(responseToForgetPasswordBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPasswordBtn;
}

- (UILabel *)lineView {
    if (!_lineView) {
        _lineView = [[UILabel alloc] init];
        _lineView.bounds = CGRectMake(0, 0, SCREEN_WIDTH * 0.77, SCREEN_WIDTH * 0.05);
        _lineView.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.83);
        _lineView.text = @"-----------  快捷登录  -----------";
        _lineView.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        _lineView.textAlignment = NSTextAlignmentCenter;
        _lineView.font = [UIFont systemFontOfSize:15];
    }
    return _lineView;
}


@end
