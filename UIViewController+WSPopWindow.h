//
//  UIViewController+WSPopView.h
//  自定义封装Present工具
//
//  Created by wangsheng on 2018/1/22.
//  Copyright © 2018年 wangsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    /**从下至上*/
    WSPopViewFrameBottomFromBottom = 0,
    WSPopViewFrameMiddleFromBottom,
    WSPopViewFrameTopFromBottom,
    /**从上至下*/
    WSPopViewFrameTopFromTop,
    WSPopViewFrameMiddleFromTop,
    WSPopViewFrameBottomFromTop,
    /**中心展示*/
    WSPopViewFrameMiddle,//透明度变化
    /**从左边至右*/
    WSPopViewFrameLeftFromLeft,
    WSPopViewFrameMiddleFromLeft,
    WSPopViewFrameRightFromLeft,
    /**从右边至左*/
    WSPopViewFrameRightFromRight,
    WSPopViewFrameMiddleFromRight,
    WSPopViewFrameLeftFromRight,
    /**其他*/
    WSPopViewFrameOthers,
} WSPopViewFrameType;

@interface UIViewController (WSPopWindow)
/**点击popView外面是否隐藏 默认YES 操作对象为presentingView*/
@property (nonatomic,assign)BOOL hideShouldTouchOutside;
- (void)presentWindowWithView:(UIView *)view animatedType:(WSPopViewFrameType)popType completion:(void(^)(void))completion;
-(void)presentWindowWithView:(UIView *)view offset:(CGPoint)offset animatedType:(WSPopViewFrameType)popType completion:(void (^)(void))completion;

- (void)presentPopViewController:(UIViewController *)popViewController animatedType:(WSPopViewFrameType)popType completion:(void (^)(void))completion;
- (void)presentPopViewController:(UIViewController *)popViewController offset:(CGPoint)offset animatedType:(WSPopViewFrameType)popType completion:(void (^)(void))completion;

- (void)dismissWindow:(BOOL)animated completion:(void(^)(void))completion;
@end
