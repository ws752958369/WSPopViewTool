//
//  UIView+WSPopView.h
//  自定义封装Present工具
//
//  Created by wangsheng on 2018/1/23.
//  Copyright © 2018年 wangsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WSFramePopupViewSlideTopBottom = 1,
    WSFramePopupViewSlideBottomTop = 2,
    WSFramePopupViewAnimationSlideRightLeft,
    WSFramePopupViewAnimationFade
}  WSFramePopupViewAnimation ;

@interface UIView (WSPopView)
- (void)wsPresentFramePopupView:(UIView*)popupView animationType:(WSFramePopupViewAnimation)animationType dismissed:(void(^)(void))dismissed;


- (void)wsDismissPopupViewControllerWithanimationType:(WSFramePopupViewAnimation)animationType;
@end
