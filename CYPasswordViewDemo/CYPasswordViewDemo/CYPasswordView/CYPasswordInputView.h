//
//  CYPasswordInputView.h
//  CYPasswordViewDemo
//
//  Created by cheny on 15/10/8.
//  Copyright © 2015年 zhssit. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PasswordInputViewBlock)(void);

@interface CYPasswordInputView : UIView

@property (nonatomic, copy) NSString *title;

/** 忘记密码的block */
@property (nonatomic, copy) PasswordInputViewBlock forgetPasswordBlock;

/** 取消的block */
@property (nonatomic, copy) PasswordInputViewBlock cancelBlock;

- (void)number:(NSDictionary *)userInfo;
- (void)deleteNumber;
- (void) disEnalbeCloseButton:(BOOL)enable;

@end