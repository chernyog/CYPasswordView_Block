//
//  CYPasswordView.m
//  CYPasswordViewDemo
//
//  Created by cheny on 15/10/8.
//  Copyright © 2015年 zhssit. All rights reserved.
//

#import "CYPasswordView.h"
#import "UIView+Extension.h"

#define kPWDLength 6

@interface CYPasswordView () <UITextFieldDelegate>

/** 蒙板 */
@property (nonatomic, strong) UIControl *coverView;
/** 返回密码 */
@property (nonatomic, copy) NSString *password;

@property (nonatomic, strong) UIImageView *imgRotation;
@property (nonatomic, strong) UILabel *lblMessage;

@end

@implementation CYPasswordView

#pragma mark  - 常量区
static NSString *tempStr;

#pragma mark  - 生命周期方法
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CYScreen.bounds];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)dealloc {
    NSLog(@" =========== %@：我走了", [self class]);
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    // 蒙版
    [self addSubview:self.coverView];
    // 输入框
    [self addSubview:self.passwordInputView];
    // 响应者
    [self addSubview:self.txfResponsder];
    [self.passwordInputView addSubview:self.imgRotation];
    [self.passwordInputView addSubview:self.lblMessage];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
}

- (void)tap:(UITapGestureRecognizer *)recognizer {
    CGPoint p = [recognizer locationInView:self.passwordInputView];
    CGRect f = CGRectMake(39, 80, 297, 50);
    if (CGRectContainsPoint(f, p)) {
        NSLog(@"点击了文本框");
        [self.txfResponsder becomeFirstResponder];
    } else {
        NSLog(@"==============");
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imgRotation.centerX = self.passwordInputView.centerX;
    self.imgRotation.centerY = self.passwordInputView.height * 0.5;
    
    self.lblMessage.x = 0;
    self.lblMessage.y = CGRectGetMaxY(self.imgRotation.frame) + 20;
    self.lblMessage.width = CYScreenWidth;
    self.lblMessage.height = 30;
}

#pragma mark  - <UITextFieldDelegate>
#pragma mark  处理字符串 和 删除键
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (!tempStr) {
        tempStr = string;
    }else{
        tempStr = [NSString stringWithFormat:@"%@%@",tempStr,string];
    }
    
    if ([string isEqualToString:@""]) {
        [self.passwordInputView deleteNumber];
        if (tempStr.length > 0) {   //  删除最后一个字符串
            NSString *lastStr = [tempStr substringToIndex:[tempStr length] - 1];
            tempStr = lastStr;
        }
    } else{
        if (tempStr.length == 6) {
            if (self.finish) {
                self.finish(tempStr);
                self.finish = nil;
            }
            tempStr = nil;
        }
        NSMutableDictionary *userInfoDict = [NSMutableDictionary dictionary];
        userInfoDict[CYPasswordViewKeyboardNumberKey] = string;
        [self.passwordInputView number:userInfoDict];
    }
    return YES;
}

/** 输入框的取消按钮点击 */
- (void)cancel {
    [self resetPasswordView];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}
/** 输入框的忘记密码按钮点击 */
- (void)forgetPassword {
    [self resetPasswordView];
    if (self.forgetPasswordBlock) {
        self.forgetPasswordBlock();
    }
}

/** 重置密码框 */
- (void)resetPasswordView {
    [self hidenKeyboard:^(BOOL finished) {
        self.passwordInputView.hidden = YES;
        tempStr = nil;
        [self removeFromSuperview];
        [self hidenKeyboard:nil];
        [self.passwordInputView setNeedsDisplay];
    }];
}

#pragma mark  - 公开方法
// 关闭键盘
- (void)hidenKeyboard {
    [self hidenKeyboard:nil];
}

- (void)hide {
    [self removeFromSuperview];
}

- (void)showInView:(UIView *)view {
    [view addSubview:self];
    /** 输入框起始frame */
    self.passwordInputView.height = CYPasswordInputViewHeight;
    self.passwordInputView.y = self.height;
    self.passwordInputView.width = CYScreenWidth;
    self.passwordInputView.x = 0;
    /** 弹出键盘 */
    [self showKeyboard];
}

- (void)startLoading {
    [self startRotation:self.imgRotation];
    [self.passwordInputView disEnalbeCloseButton:NO];
}

- (void)stopLoading {
    [self stopRotation:self.imgRotation];
    [self.passwordInputView disEnalbeCloseButton:YES];
}

- (void)requestComplete:(BOOL)state {
    if (state) {
        [self requestComplete:state message:@"支付成功"];
    } else {
        [self requestComplete:state message:@"支付失败"];
    }
}
- (void)requestComplete:(BOOL)state message:(NSString *)message {
    if (state) {
        // 请求成功
        self.lblMessage.text = message;
        self.imgRotation.image = [UIImage imageNamed:CYPasswordViewSrcName(@"password_success")];
    } else {
        // 请求失败
        self.lblMessage.text = message;
        self.imgRotation.image = [UIImage imageNamed:CYPasswordViewSrcName(@"password_error")];
    }
}

#pragma mark  - 私有方法
/** 键盘弹出 */
- (void)showKeyboard {
    [self.txfResponsder becomeFirstResponder];
    [UIView animateWithDuration:CYPasswordViewAnimationDuration delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        self.passwordInputView.y = (self.height - self.passwordInputView.height);
    } completion:^(BOOL finished) {
        NSLog(@" ========= %@", NSStringFromCGRect(self.passwordInputView.frame));
    }];
}

/** 键盘退下 */
- (void)hidenKeyboard:(void (^)(BOOL finished))completion {
    [self.txfResponsder endEditing:NO];
    [UIView animateWithDuration:CYPasswordViewAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.inputView.transform = CGAffineTransformIdentity;
    } completion:completion];
}

/**
 *  开始旋转
 */
- (void)startRotation:(UIView *)view {
    _imgRotation.hidden = NO;
    _lblMessage.hidden = NO;
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 2.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

/**
 *  结束旋转
 */
- (void)stopRotation:(UIView *)view {
    //    _imgRotation.hidden = YES;
    //    _lblMessage.hidden = YES;
    [view.layer removeAllAnimations];
}

#pragma mark - Set 方法
- (void)setLoadingText:(NSString *)loadingText {
    _loadingText = [loadingText copy];
    self.lblMessage.text = loadingText;
}

#pragma mark  - 懒加载
- (UIControl *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIControl alloc] init];
        [_coverView setBackgroundColor:[UIColor blackColor]];
        _coverView.alpha = 0.4;
        _coverView.frame = self.bounds;
    }
    return _coverView;
}

- (CYPasswordInputView *)passwordInputView {
    WS(weakself);
    if (_passwordInputView == nil) {
        _passwordInputView = [[CYPasswordInputView alloc] init];
        _passwordInputView.cancelBlock = ^{
            [weakself cancel];
        };
        _passwordInputView.forgetPasswordBlock = ^{
            [weakself forgetPassword];
        };
    }
    return _passwordInputView;
}

- (UITextField *)txfResponsder {
    if (_txfResponsder == nil) {
        _txfResponsder = [[UITextField alloc] init];
        _txfResponsder.delegate = self;
        _txfResponsder.keyboardType = UIKeyboardTypeNumberPad;
        _txfResponsder.frame = CGRectMake(0, 0, 1, 1);
        _txfResponsder.secureTextEntry = YES;
    }
    return _txfResponsder;
}

- (UIImageView *)imgRotation {
    if (_imgRotation == nil) {
        _imgRotation = [[UIImageView alloc] init];
        _imgRotation.image = [UIImage imageNamed:CYPasswordViewSrcName(@"password_loading_b")];
        [_imgRotation sizeToFit];
        _imgRotation.hidden = YES;
    }
    return _imgRotation;
}

- (UILabel *)lblMessage {
    if (_lblMessage == nil) {
        _lblMessage = [[UILabel alloc] init];
        _lblMessage.text = @"支付中...";
        _lblMessage.hidden = YES;
        _lblMessage.textColor = [UIColor darkGrayColor];
        _lblMessage.font = CYLabelFont;
        _lblMessage.textAlignment = NSTextAlignmentCenter;
    }
    return _lblMessage;
}

@end
