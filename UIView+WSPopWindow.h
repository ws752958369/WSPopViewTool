//
//  UIView+WSPopView.h
//  自定义封装Present工具
//
//  Created by wangsheng on 2018/1/22.
//  Copyright © 2018年 wangsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    /**从下至上*/
    WSPopViewBottomFromBottom = 0,
    WSPopViewMiddleFromBottom,
    WSPopViewTopFromBottom,
    /**从上至下*/
    WSPopViewTopFromTop,
    WSPopViewMiddleFromTop,
    WSPopViewBottomFromTop,
    /**中心展示*/
    WSPopViewMiddle,//透明度变化
    /**从左边至右*/
    WSPopViewLeftFromLeft,
    WSPopViewMiddleFromLeft,
    WSPopViewRightFromLeft,
    /**从右边至左*/
    WSPopViewRightFromRight,
    WSPopViewMiddleFromRight,
    WSPopViewLeftFromRight,
    /**其他*/
    WSPopViewOthers,
} WSPopViewType;

@interface UIView (WSPopWindow)
/**点击popView外面是否隐藏 默认YES*/
@property (nonatomic,assign)BOOL hideShouldTouchOutside;
- (void)presentWindowWithView:(UIView *)view animatedType:(WSPopViewType)popType completion:(void(^)(void))completion;
- (void)dismissWindow:(BOOL)animated completion:(void(^)(void))completion;
- (void)presentWindowWithView:(UIView *)view offset:(CGPoint)offset animatedType:(WSPopViewType)popType completion:(void (^)(void))completion;
@end
