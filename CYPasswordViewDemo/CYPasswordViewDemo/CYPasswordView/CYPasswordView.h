//
//  CYPasswordView.h
//  CYPasswordViewDemo
//
//  Created by cheny on 15/10/8.
//  Copyright © 2015年 zhssit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYPasswordInputView.h"
#import "CYConst.h"

@interface CYPasswordView : UIView

/** 输入框 */
@property (nonatomic, strong) CYPasswordInputView *passwordInputView;
@property (nonatomic, strong) UITextField *txfResponsder;
@property (nonatomic, copy) NSString *loadingText;

/** 完成的回调block */
@property (nonatomic, copy) void (^finish) (NSString *passWord);

/** 忘记密码的block */
@property (nonatomic, copy) PasswordInputViewBlock forgetPasswordBlock;

/** 取消的block */
@property (nonatomic, copy) PasswordInputViewBlock cancelBlock;

/** 弹出 */
- (void)showInView:(UIView *)view;

/** 隐藏键盘 */
- (void)hidenKeyboard;

/** 隐藏密码框 */
- (void)hide;

/** 开始加载 */
- (void)startLoading;

/** 加载完成 */
- (void)stopLoading;

/** 请求完成 */
- (void)requestComplete:(BOOL)state;
- (void)requestComplete:(BOOL)state message:(NSString *)message;

@end
