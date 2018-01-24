//
//  UIView+WSPopView.m
//  自定义封装Present工具
//
//  Created by wangsheng on 2018/1/22.
//  Copyright © 2018年 wangsheng. All rights reserved.
//

#import "UIView+WSPopWindow.h"
#import "UIView+RectExtension.h"
#define kWSAnimatorDuration 0.35f
#define kPopViewTag 10001
#define kWSScreenHeight [UIScreen mainScreen].bounds.size.height
#define kWSScreenWidth  [UIScreen mainScreen].bounds.size.width

/**popView的背景View*/
static UIView *backgrouView = nil;

/**present完成回调*/
dispatch_block_t presentCompletion = nil;
/**dismiss完成回调*/
dispatch_block_t dismissCompletion = nil;

CGRect oldRect ;
CGRect newRect ;
CGPoint ws_offset;
BOOL ws_hideShouldOutSide = YES;

@implementation UIView (WSPopWindow)

#pragma mark - 初始化默认值
- (void)initDefaultValues{
    oldRect = newRect = CGRectZero;
    ws_offset = CGPointZero;
    ws_hideShouldOutSide = YES;
    presentCompletion = nil;
    dismissCompletion = nil;
}

- (UIView *)popWindowView{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    backgrouView = [[UIView alloc] initWithFrame:keyWindow.bounds];
    backgrouView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundView:)];
    [backgrouView addGestureRecognizer:tapGesture];
    [keyWindow addSubview:backgrouView];
    return backgrouView;
}

#pragma mark - 添加手势
- (void)tapBackgroundView:(UITapGestureRecognizer *)gesture
{
    __weak typeof(self)slf = self;
    UIView *popView = [backgrouView viewWithTag:kPopViewTag];
    
    if (ws_hideShouldOutSide) {
        
    }else{
        return;
        //如果设置点击隐隐部分不隐藏
    }
    
    
    
    [UIView animateWithDuration:kWSAnimatorDuration animations:^{
        popView.frame = oldRect;
    } completion:^(BOOL finished) {
        newRect = oldRect = CGRectZero;
        [popView removeFromSuperview];
        [backgrouView removeFromSuperview];
        backgrouView = nil;
        !dismissCompletion?:dismissCompletion();
        [slf initDefaultValues];
    }];
}

-(void)presentWindowWithView:(UIView *)view animatedType:(WSPopViewType)popType completion:(void (^)(void))completion
{
    if (!view) return;
    
    presentCompletion = completion;
    
    [view setTag:kPopViewTag];
    
    [[self popWindowView] addSubview:view];
    
    switch (popType) {
        case WSPopViewBottomFromBottom:{
            [self slideToBottomFromBottom:view];
        }break;
        case WSPopViewMiddleFromBottom:{
            [self slideToMiddleFromBottom:view];
        }break;
        case WSPopViewTopFromBottom:{
            [self slideToTopFromBottom:view];
        }break;
        case WSPopViewTopFromTop:{
            [self slideToTopFromTop:view];
        }break;
        case WSPopViewMiddleFromTop:{
            [self slideToMiddleFromTop:view];
        }break;
        case WSPopViewBottomFromTop:{
            [self slideToBottomFromTop:view];
        }break;
        case WSPopViewMiddle:{
            [self slideToMiddle:view];
        }break;
        case WSPopViewLeftFromLeft:{
            [self slideToLeftFromLeft:view];
        }break;
        case WSPopViewMiddleFromLeft:{
            [self slideToMiddleFromLeft:view];
        }break;
        case WSPopViewRightFromLeft:{
            [self slideToRightFromLeft:view];
        }break;
        case WSPopViewRightFromRight:{
            [self slideToRightFromRight:view];
        }break;
        case WSPopViewMiddleFromRight:{
            [self slideToMiddleFromRight:view];
        }break;
        case WSPopViewLeftFromRight:{
            [self slideToLeftFromRight:view];
        }break;
        default:
            break;
    }
    
}

-(void)presentWindowWithView:(UIView *)view offset:(CGPoint)offset animatedType:(WSPopViewType)popType completion:(void (^)(void))completion
{
    ws_offset = offset;
    [self presentWindowWithView:view animatedType:popType completion:completion];
}

- (void)dismissWindow:(BOOL)animated completion:(void(^)(void))completion
{
    dismissCompletion = completion;
    
    if (animated) {
        __weak typeof(self)slf = self;
        UIView *popView = [backgrouView viewWithTag:kPopViewTag];
        if (!popView) return;
        [UIView animateWithDuration:kWSAnimatorDuration animations:^{
            popView.frame = oldRect;
        } completion:^(BOOL finished) {
            newRect = oldRect = CGRectZero;
            [popView removeFromSuperview];
            [backgrouView removeFromSuperview];
            backgrouView = nil;
            !dismissCompletion?:dismissCompletion();
            [slf initDefaultValues];
        }];
        
    }else{
        
        UIView *popView = [backgrouView viewWithTag:kPopViewTag];
        if (!popView) return;
        popView.hidden = YES;
        newRect = oldRect = CGRectZero;
        [popView removeFromSuperview];
        [backgrouView removeFromSuperview];
        backgrouView = nil;
        !dismissCompletion?:dismissCompletion();
        [self initDefaultValues];
    }
}

#pragma mark - WSPopViewBottomFromBottom

- (void)slideToBottomFromBottom:(UIView *)popView{
    
    oldRect = popView.frame = CGRectMake(0, kWSScreenHeight, popView.ws_width, popView.ws_height);
    
    [UIView animateWithDuration:kWSAnimatorDuration animations:^{
        popView.transform = CGAffineTransformMakeTranslation(0, -popView.ws_height+ws_offset.y);
    } completion:^(BOOL finished) {
        newRect = popView.frame;
        !presentCompletion?:presentCompletion();
    }];
}

#pragma mark -  WSPopViewMiddleFromBottom

- (void)slideToMiddleFromBottom:(UIView *)popView{
    
    oldRect = popView.frame = CGRectMake(0, kWSScreenHeight, popView.ws_width, popView.ws_height);
    
    [UIView animateWithDuration:kWSAnimatorDuration animations:^{
        popView.transform = CGAffineTransformMakeTranslation(0, -((popView.ws_height+backgrouView.ws_height)*0.5-ws_offset.y));
    } completion:^(BOOL finished) {
        newRect = popView.frame;
        !presentCompletion?:presentCompletion();
    }];
}

#pragma mark - WSPopViewTopFromBottom

- (void)slideToTopFromBottom:(UIView *)popView{
    
    oldRect = popView.frame = CGRectMake(0, kWSScreenHeight, popView.ws_width, popView.ws_height);
    
    [UIView animateWithDuration:kWSAnimatorDuration animations:^{
        popView.transform = CGAffineTransformMakeTranslation(0, -(backgrouView.ws_height-ws_offset.y));
    } completion:^(BOOL finished) {
        newRect = popView.frame;
        !presentCompletion?:presentCompletion();
    }];
}

#pragma mark - WSPopViewTopFromTop
- (void)slideToTopFromTop:(UIView *)popView{
    
    oldRect = popView.frame = CGRectMake(0, -popView.ws_height, popView.ws_width, popView.ws_height);
    
    [UIView animateWithDuration:kWSAnimatorDuration animations:^{
        popView.transform = CGAffineTransformMakeTranslation(0, popView.ws_height+ws_offset.y);
    } completion:^(BOOL finished) {
        newRect = popView.frame;
        !presentCompletion?:presentCompletion();
    }];
}

#pragma mark - WSPopViewMiddleFromTop
- (void)slideToMiddleFromTop:(UIView *)popView{
    
    oldRect = popView.frame = CGRectMake(0, -popView.ws_height, popView.ws_width, popView.ws_height);
    
    [UIView animateWithDuration:kWSAnimatorDuration animations:^{
        popView.transform = CGAffineTransformMakeTranslation(0, (popView.ws_height+backgrouView.ws_height)*0.5+ws_offset.y);
    } completion:^(BOOL finished) {
        newRect = popView.frame;
        !presentCompletion?:presentCompletion();
    }];
}

#pragma mark - WSPopViewBottomFromTop
- (void)slideToBottomFromTop:(UIView *)popView{
    
    oldRect = popView.frame = CGRectMake(0, -popView.ws_height, popView.ws_width, popView.ws_height);
    
    [UIView animateWithDuration:kWSAnimatorDuration animations:^{
        popView.transform = CGAffineTransformMakeTranslation(0, backgrouView.ws_height+ws_offset.y);
    } completion:^(BOOL finished) {
        newRect = popView.frame;
        !presentCompletion?:presentCompletion();
    }];
}

#pragma mark - WSPopViewMiddle
- (void)slideToMiddle:(UIView *)popView{
    
    popView.ws_center = backgrouView.ws_center;
    oldRect = popView.frame;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    [popView setTransform:CGAffineTransformScale(transform, 0.2, 0.2)];
    
    popView.alpha = 0.0;
    [UIView animateWithDuration:kWSAnimatorDuration animations:^{
        popView.alpha = 1.0;
        CGPoint center = popView.ws_center;
        center.x = center.x + ws_offset.x;
        center.y = center.y + ws_offset.y;
        popView.ws_center = center;
        [popView setTransform:CGAffineTransformScale(transform, 1.0, 1.0)];
    } completion:^(BOOL finished) {
        newRect = popView.frame;
        !presentCompletion?:presentCompletion();
    }];
}

#pragma mark - WSPopViewLeftFromLeft
- (void)slideToLeftFromLeft:(UIView *)popView{
    
    popView.frame = CGRectMake(-popView.ws_width, 0, popView.ws_width, popView.ws_height);
    popView.ws_centerY = backgrouView.ws_centerY;
    oldRect = popView.frame;
    
    [UIView animateWithDuration:kWSAnimatorDuration animations:^{
        popView.transform = CGAffineTransformMakeTranslation(popView.ws_width+ws_offset.x, 0);
    } completion:^(BOOL finished) {
        newRect = popView.frame;
        !presentCompletion?:presentCompletion();
    }];
}

#pragma mark - WSPopViewMiddleFromLeft
- (void)slideToMiddleFromLeft:(UIView *)popView{
    
    popView.frame = CGRectMake(-popView.ws_width, 0, popView.ws_width, popView.ws_height);
    popView.ws_centerY = backgrouView.ws_centerY;
    oldRect = popView.frame;
    
    [UIView animateWithDuration:kWSAnimatorDuration animations:^{
        popView.transform = CGAffineTransformMakeTranslation((popView.ws_width+backgrouView.ws_width)*0.5+ws_offset.x, 0);
    } completion:^(BOOL finished) {
        newRect = popView.frame;
        !presentCompletion?:presentCompletion();
    }];
}

#pragma mark - WSPopViewRightFromLeft
- (void)slideToRightFromLeft:(UIView *)popView{
    
    popView.frame = CGRectMake(-popView.ws_width, 0, popView.ws_width, popView.ws_height);
    popView.ws_centerY = backgrouView.ws_centerY;
    oldRect = popView.frame;
    
    [UIView animateWithDuration:kWSAnimatorDuration animations:^{
        popView.transform = CGAffineTransformMakeTranslation(backgrouView.ws_width+ws_offset.x, 0);
    } completion:^(BOOL finished) {
        newRect = popView.frame;
        !presentCompletion?:presentCompletion();
    }];
}

#pragma mark - WSPopViewRightFromRight
- (void)slideToRightFromRight:(UIView *)popView{
    
    popView.frame = CGRectMake(backgrouView.ws_width, 0, popView.ws_width, popView.ws_height);
    popView.ws_centerY = backgrouView.ws_centerY;
    oldRect = popView.frame;
    
    [UIView animateWithDuration:kWSAnimatorDuration animations:^{
        popView.transform = CGAffineTransformMakeTranslation(-popView.ws_width+ws_offset.x, 0);
    } completion:^(BOOL finished) {
        newRect = popView.frame;
        !presentCompletion?:presentCompletion();
    }];
}

#pragma mark - WSPopViewMiddleFromRight
- (void)slideToMiddleFromRight:(UIView *)popView{
    
    popView.frame = CGRectMake(backgrouView.ws_width, 0, popView.ws_width, popView.ws_height);
    popView.ws_centerY = backgrouView.ws_centerY;
    oldRect = popView.frame;
    
    [UIView animateWithDuration:kWSAnimatorDuration animations:^{
        popView.transform = CGAffineTransformMakeTranslation(-(backgrouView.ws_width+popView.ws_width)*0.5+ws_offset.x, 0);
    } completion:^(BOOL finished) {
        newRect = popView.frame;
        !presentCompletion?:presentCompletion();
    }];
}

#pragma mark - WSPopViewLeftFromRight
- (void)slideToLeftFromRight:(UIView *)popView{
    
    popView.frame = CGRectMake(backgrouView.ws_width, 0, popView.ws_width, popView.ws_height);
    popView.ws_centerY = backgrouView.ws_centerY;
    oldRect = popView.frame;
    
    [UIView animateWithDuration:kWSAnimatorDuration animations:^{
        popView.transform = CGAffineTransformMakeTranslation(-backgrouView.ws_width+ws_offset.x, 0);
    } completion:^(BOOL finished) {
        newRect = popView.frame;
        !presentCompletion?:presentCompletion();
    }];
}

#pragma mark - set
-(void)setHideShouldTouchOutside:(BOOL)hideShouldTouchOutside
{
    ws_hideShouldOutSide = hideShouldTouchOutside;
}

-(BOOL)hideShouldTouchOutside
{
    return ws_hideShouldOutSide;
}
@end
