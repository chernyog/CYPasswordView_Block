#import <UIKit/UIKit.h>

// 日志输出
#ifdef DEBUG
#define CYLog(...) NSLog(__VA_ARGS__)
#else
#define CYLog(...)
#endif

// RGB颜色
#define CYColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define CYColor_A(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

// 字体大小
#define CYLabelFont [UIFont boldSystemFontOfSize:13]
#define CYFont(f) [UIFont systemFontOfSize:(f)]
#define CYFontB(f) [UIFont boldSystemFontOfSize:(f)]

#define WS(weakself)  __weak __typeof(&*self)weakself = self;
#define SS(strongself)  __strong __typeof(&*self)strongself = self;

// 图片路径
#define CYPasswordViewSrcName(file) [@"CYPasswordView.bundle" stringByAppendingPathComponent:file]

/** 屏幕的宽高 */
#define CYScreen [UIScreen mainScreen]
#define CYScreenWidth CYScreen.bounds.size.width
#define CYScreenHeight CYScreen.bounds.size.height

// 常量
/** 密码框的高度 */
UIKIT_EXTERN const CGFloat CYPasswordInputViewHeight;
/** 密码框标题的高度 */
UIKIT_EXTERN const CGFloat CYPasswordViewTitleHeight;
/** 密码框显示或隐藏时间 */
UIKIT_EXTERN const CGFloat CYPasswordViewAnimationDuration;
/** 关闭按钮的宽高 */
UIKIT_EXTERN const CGFloat CYPasswordViewCloseButtonWH;
/** 关闭按钮的左边距 */
UIKIT_EXTERN const CGFloat CYPasswordViewCloseButtonMarginLeft;
/** 输入点的宽高 */
UIKIT_EXTERN const CGFloat CYPasswordViewPointnWH;
/** TextField图片的宽 */
UIKIT_EXTERN const CGFloat CYPasswordViewTextFieldWidth;
/** TextField图片的高 */
UIKIT_EXTERN const CGFloat CYPasswordViewTextFieldHeight;
/** TextField图片向上间距 */
UIKIT_EXTERN const CGFloat CYPasswordViewTextFieldMarginTop;
/** 忘记密码按钮向上间距 */
UIKIT_EXTERN const CGFloat CYPasswordViewForgetPWDButtonMarginTop;

UIKIT_EXTERN NSString *const CYPasswordViewKeyboardNumberKey;