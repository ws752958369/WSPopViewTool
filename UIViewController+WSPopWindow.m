//
//  UIViewController+WSPopView.m
//  自定义封装Present工具
//
//  Created by wangsheng on 2018/1/22.
//  Copyright © 2018年 wangsheng. All rights reserved.
//

#import "UIViewController+WSPopWindow.h"
#import "UIView+RectExtension.h"

#define kWSAnimatorDuration 0.35f
#define kPopViewTag 10001
#define kWSScreenHeight [UIScreen mainScreen].bounds.size.height
#define kWSScreenWidth  [UIScreen mainScreen].bounds.size.width

/**popView的背景View*/
static UIView *backgrouView1 = nil;

/**present完成回调*/
dispatch_block_t presentCompletion1 = nil;
/**dismiss完成回调*/
dispatch_block_t dismissCompletion1 = nil;

CGRect oldRect1 ;
CGRect newRect1 ;
CGPoint ws_offset1;
BOOL ws_hideShouldOutSide1 = YES;

@implementation UIViewController (WSPopWindow)

#pragma mark - 初始化默认值
- (void)initDefaultValues{
    oldRect1 = newRect1 = CGRectZero;
    ws_offset1 = CGPointZero;
    ws_hideShouldOutSide1 = YES;
    presentCompletion1 = nil;
    dismissCompletion1 = nil;
}

- (UIView *)popWindowView{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    backgrouView1 = [[UIView alloc] initWithFrame:keyWindow.bounds];
    backgrouView1.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundView:)];
    [backgrouView1 addGestureRecognizer:tapGesture];
    [keyWindow addSubview:backgrouView1];
    return backgrouView1;
}

#pragma mark - 添加手势
- (void)tapBackgroundView:(UITapGestureRecognizer *)gesture
{
    __weak typeof(self)slf = self;
    UIView *popView = [backgrouView1 viewWithTag:kPopViewTag];
    
    if (ws_hideShouldOutSide1) {
        
    }else{
        return;
        //如果设置点击隐隐部分不隐藏
    }

    
    [UIView animateWithDuration:kWSAnimatorDuration animations:^{
        popView.frame = oldRect1;
    } completion:^(BOOL finished) {
        newRect1 = oldRect1 = CGRectZero;
        [popView removeFromSuperview];
        [backgrouView1 removeFromSuperview];
        backgrouView1 = nil;
        !dismissCompletion1?:dismissCompletion1();
        [slf initDefaultValues];
    }];
}

#pragma mark - presentWindowWithView

- (void)presentWindowWithView:(UIView *)view animatedType:(WSPopViewFrameType)popType completion:(void(^)(void))completion
{
    if (!view) return;
    
    presentCompletion1 = completion;
    
    [view setTag:kPopViewTag];
    
    [[self popWindowView] addSubview:view];
    
    switch (popType) {
        case WSPopViewFrameBottomFromBottom:{
            [self slideToBottomFromBottom:view];
        }break;
        case WSPopViewFrameMiddleFromBottom:{
            [self slideToMiddleFromBottom:view];
        }break;
        case WSPopViewFrameTopFromBottom:{
            [self slideToTopFromBottom:view];
        }break;
        case WSPopViewFrameTopFromTop:{
            [self slideToTopFromTop:view];
        }break;
        case WSPopViewFrameMiddleFromTop:{
            [self slideToMiddleFromTop:view];
        }break;
        case WSPopViewFrameBottomFromTop:{
            [self slideToBottomFromTop:view];
        }break;
        case WSPopViewFrameMiddle:{
            [self slideToMiddle:view];
        }break;
        case WSPopViewFrameLeftFromLeft:{
            [self slideToLeftFromLeft:view];
        }break;
        case WSPopViewFrameMiddleFromLeft:{
            [self slideToMiddleFromLeft:view];
        }break;
        case WSPopViewFrameRightFromLeft:{
            [self slideToRightFromLeft:view];
        }break;
        case WSPopViewFrameRightFromRight:{
            [self slideToRightFromRight:view];
        }break;
        case WSPopViewFrameMiddleFromRight:{
            [self slideToMiddleFromRight:view];
        }break;
        case WSPopViewFrameLeftFromRight:{
            [self slideToLeftFromRight:view];
        }break;
        default:
            break;
    }
    
}

-(void)presentWindowWithView:(UIView *)view offset:(CGPoint)offset animatedType:(WSPopViewFrameType)popType completion:(void (^)(void))completion
{
    ws_offset1 = offset;
    [self presentWindowWithView:view animatedType:popType completion:completion];
}

#pragma mark - presentPopViewController

- (void)presentPopViewController:(UIViewController *)popViewController animatedType:(WSPopViewFrameType)popType completion:(void (^)(void))completion
{
    [self presentWindowWithView:popViewController.view animatedType:popType completion:completion];
}

- (void)presentPopViewController:(UIViewController *)popViewController offset:(CGPoint)offset animatedType:(WSPopViewFrameType)popType completion:(void (^)(void))completion
{
    ws_offset1 = offset;
    [self presentPopViewController:popViewController animatedType:popType completion:completion];
}

#pragma mark -  dismissWindow

- (void)dismissWindow:(BOOL)animated completion:(void(^)(void))completion
{
    dismissCompletion1 = completion;
    
    if (animated) {
        __weak typeof(self)slf = self;
        UIView *popView = [backgrouView1 viewWithTag:kPopViewTag];
        if (!popView) return;
        [UIView animateWithDuration:kWSAnimatorDuration animations:^{
            popView.frame = oldRect1;
        } completion:^(BOOL finished) {
            newRect1 = oldRect1 = CGRectZero;
            [popView removeFromSuperview];
            [backgrouView1 removeFromSuperview];
            backgrouView1 = nil;
            !dismissCompletion1?:dismissCompletion1();
            [slf initDefaultValues];
        }];
    }else{
        
        UIView *popView = [backgrouView1 viewWithTag:kPopViewTag];
        if (!popView) return;
        popView.hidden = YES;
        newRect1 = oldRect1 = CGRectZero;
        [popView removeFromSuperview];
        [backgrouView1 removeFromSuperview];
        backgrouView1 = nil;
        !dismissCompletion1?:dismissCompletion1();
        [self initDefaultValues];
    }
}

#pragma mark - WSPopViewBottomFromBottom

- (void)slideToBottomFromBottom:(UIView *)popView{
    
    oldRect1 = popView.frame = CGRectMake(0, kWSScreenHeight, popView.ws_width, popView.ws_height);
    
    [UIView animateWithDuration:kWSAnimatorDuration animations:^{
        popView.transform = CGAffineTransformMakeTranslation(0, -(popView.ws_height-ws_offset1.y));
    } completion:^(BOOL finished) {
        newRect1 = popView.frame;
        !presentCompletion1?:presentCompletion1();
    }];
}

#pragma mark -  WSPopViewMiddleFromBottom

- (void)slideToMiddleFromBottom:(UIView *)popView{
    
    oldRect1 = popView.frame = CGRectMake(0, kWSScreenHeight, popView.ws_width, popView.ws_height);
    
    [UIView animateWithDuration:kWSAnimatorDuration animations:^{
        popView.transform = CGAffineTransformMakeTranslation(0, -((popView.ws_height+backgrouView1.ws_height)*0.5-ws_offset1.y));
    } completion:^(BOOL finished) {
        newRect1 = popView.frame;
        !presentCompletion1?:presentCompletion1();
    }];
}

#pragma mark - WSPopViewTopFromBottom

- (void)slideToTopFromBottom:(UIView *)popView{
    
    oldRect1 = popView.frame = CGRectMake(0, kWSScreenHeight, popView.ws_width, popView.ws_height);
    
    [UIView animateWithDuration:kWSAnimatorDuration animations:^{
        popView.transform = CGAffineTransformMakeTranslation(0, -(backgrouView1.ws_height-ws_offset1.y));
    } completion:^(BOOL finished) {
        newRect1 = popView.frame;
        !presentCompletion1?:presentCompletion1();
    }];
}

#pragma mark - WSPopViewTopFromTop
- (void)slideToTopFromTop:(UIView *)popView{
    
    oldRect1 = popView.frame = CGRectMake(0, -popView.ws_height, popView.ws_width, popView.ws_height);
    
    [UIView animateWithDuration:kWSAnimatorDuration animations:^{
        popView.transform = CGAffineTransformMakeTranslation(0, popView.ws_height+ws_offset1.y);
    } completion:^(BOOL finished) {
        newRect1 = popView.frame;
        !presentCompletion1?:presentCompletion1();
    }];
}

#pragma mark - WSPopViewMiddleFromTop
- (void)slideToMiddleFromTop:(UIView *)popView{
    
    oldRect1 = popView.frame = CGRectMake(0, -popView.ws_height, popView.ws_width, popView.ws_height);
    
    [UIView animateWithDuration:kWSAnimatorDuration animations:^{
        popView.transform = CGAffineTransformMakeTranslation(0, (popView.ws_height+backgrouView1.ws_height)*0.5+ws_offset1.y);
    } completion:^(BOOL finished) {
        newRect1 = popView.frame;
        !presentCompletion1?:presentCompletion1();
    }];
}

#pragma mark - WSPopViewBottomFromTop
- (void)slideToBottomFromTop:(UIView *)popView{
    
    oldRect1 = popView.frame = CGRectMake(0, -popView.ws_height, popView.ws_width, popView.ws_height);
    
    [UIView animateWithDuration:kWSAnimatorDuration animations:^{
        popView.transform = CGAffineTransformMakeTranslation(0, backgrouView1.ws_height+ws_offset1.y);
    } completion:^(BOOL finished) {
        newRect1 = popView.frame;
        !presentCompletion1?:presentCompletion1();
    }];
}

#pragma mark - WSPopViewMiddle
- (void)slideToMiddle:(UIView *)popView{
    
    popView.ws_center = backgrouView1.ws_center;
    oldRect1 = popView.frame;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    [popView setTransform:CGAffineTransformScale(transform, 0.2, 0.2)];
    
    popView.alpha = 0.0;
    [UIView animateWithDuration:kWSAnimatorDuration animations:^{
        [popView setTransform:CGAffineTransformScale(transform, 1.0, 1.0)];
        popView.alpha = 1.0;
        CGPoint center = popView.ws_center;
        center.x = center.x + ws_offset1.x;
        center.y = center.y + ws_offset1.y;
        popView.ws_center = center;
    } completion:^(BOOL finished) {
        newRect1 = popView.frame;
        !presentCompletion1?:presentCompletion1();
    }];
}

#pragma mark - WSPopViewLeftFromLeft
- (void)slideToLeftFromLeft:(UIView *)popView{
    
    popView.frame = CGRectMake(-popView.ws_width, 0, popView.ws_width, popView.ws_height);
    popView.ws_centerY = backgrouView1.ws_centerY;
    oldRect1 = popView.frame;
    
    [UIView animateWithDuration:kWSAnimatorDuration animations:^{
        popView.transform = CGAffineTransformMakeTranslation(popView.ws_width+ws_offset1.x, 0);
    } completion:^(BOOL finished) {
        newRect1 = popView.frame;
        !presentCompletion1?:presentCompletion1();
    }];
}

#pragma mark - WSPopViewMiddleFromLeft
- (void)slideToMiddleFromLeft:(UIView *)popView{
    
    popView.frame = CGRectMake(-popView.ws_width, 0, popView.ws_width, popView.ws_height);
    popView.ws_centerY = backgrouView1.ws_centerY;
    oldRect1 = popView.frame;
    
    [UIView animateWithDuration:kWSAnimatorDuration animations:^{
        popView.transform = CGAffineTransformMakeTranslation((popView.ws_width+backgrouView1.ws_width)*0.5+ws_offset1.x, 0);
    } completion:^(BOOL finished) {
        newRect1 = popView.frame;
        !presentCompletion1?:presentCompletion1();
    }];
}

#pragma mark - WSPopViewRightFromLeft
- (void)slideToRightFromLeft:(UIView *)popView{
    
    popView.frame = CGRectMake(-popView.ws_width, 0, popView.ws_width, popView.ws_height);
    popView.ws_centerY = backgrouView1.ws_centerY;
    oldRect1 = popView.frame;
    
    [UIView animateWithDuration:kWSAnimatorDuration animations:^{
        popView.transform = CGAffineTransformMakeTranslation(backgrouView1.ws_width+ws_offset1.x, 0);
    } completion:^(BOOL finished) {
        newRect1 = popView.frame;
        !presentCompletion1?:presentCompletion1();
    }];
}

#pragma mark - WSPopViewRightFromRight
- (void)slideToRightFromRight:(UIView *)popView{
    
    popView.frame = CGRectMake(backgrouView1.ws_width, 0, popView.ws_width, popView.ws_height);
    popView.ws_centerY = backgrouView1.ws_centerY;
    oldRect1 = popView.frame;
    
    [UIView animateWithDuration:kWSAnimatorDuration animations:^{
        popView.transform = CGAffineTransformMakeTranslation(-popView.ws_width+ws_offset1.x, 0);
    } completion:^(BOOL finished) {
        newRect1 = popView.frame;
        !presentCompletion1?:presentCompletion1();
    }];
}

#pragma mark - WSPopViewMiddleFromRight
- (void)slideToMiddleFromRight:(UIView *)popView{
    
    popView.frame = CGRectMake(backgrouView1.ws_width, 0, popView.ws_width, popView.ws_height);
    popView.ws_centerY = backgrouView1.ws_centerY;
    oldRect1 = popView.frame;
    
    [UIView animateWithDuration:kWSAnimatorDuration animations:^{
        popView.transform = CGAffineTransformMakeTranslation(-(backgrouView1.ws_width+popView.ws_width)*0.5+ws_offset1.x, 0);
    } completion:^(BOOL finished) {
        newRect1 = popView.frame;
        !presentCompletion1?:presentCompletion1();
    }];
}

#pragma mark - WSPopViewLeftFromRight
- (void)slideToLeftFromRight:(UIView *)popView{
    
    popView.frame = CGRectMake(backgrouView1.ws_width, 0, popView.ws_width, popView.ws_height);
    popView.ws_centerY = backgrouView1.ws_centerY;
    oldRect1 = popView.frame;
    
    [UIView animateWithDuration:kWSAnimatorDuration animations:^{
        popView.transform = CGAffineTransformMakeTranslation(-backgrouView1.ws_width+ws_offset1.x, 0);
    } completion:^(BOOL finished) {
        newRect1 = popView.frame;
        !presentCompletion1?:presentCompletion1();
    }];
}

#pragma mark - set
-(void)setHideShouldTouchOutside:(BOOL)hideShouldTouchOutside
{
    ws_hideShouldOutSide1 = hideShouldTouchOutside;
}

-(BOOL)hideShouldTouchOutside
{
    return ws_hideShouldOutSide1;
}

@end
