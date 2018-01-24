//
//  UIView+WSPopView.m
//  自定义封装Present工具
//
//  Created by wangsheng on 2018/1/23.
//  Copyright © 2018年 wangsheng. All rights reserved.
//

#import "UIView+WSPopView.h"
#import <objc/runtime.h>

#define kPopupModalAnimationDuration 0.35

#define kSourceViewTag 1123941
#define kPopupViewTag 1123942
#define kBackgroundViewTag 1123943
#define kOverlayViewTag 1123945

static NSString *MJPopupViewDismissedKey = @"MJPopupViewDismissed";

@implementation UIView (WSPopView)

- (void)wsPresentPopupFrameView:(UIView*)popupView animationType:(WSFramePopupViewAnimation)animationType
{
    
    [self wsPresentFramePopupView:popupView animationType:animationType dismissed:nil];
}



- (void)wsPresentFramePopupView:(UIView*)popupView animationType:(WSFramePopupViewAnimation)animationType dismissed:(void(^)(void))dismissed;
{
    
    UIView * sourceView = self;
    
    sourceView.tag = kSourceViewTag;
    popupView.tag = kPopupViewTag;
    
    
    //解决多次动画的问题
    if([sourceView.subviews containsObject:popupView])
        return;
    
    
    UIView *overlayView = [[UIView alloc] initWithFrame:sourceView.bounds];
    overlayView.backgroundColor = [UIColor clearColor];
    overlayView.tag = kOverlayViewTag;
    
    
    
    // BackgroundView
    UIView *backgroundView = [[UIView alloc] initWithFrame:sourceView.bounds];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.3;
    [overlayView addSubview:backgroundView];
    
    // Make the Background Clickable
    UIButton * dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.backgroundColor = [UIColor clearColor];
    dismissButton.frame = sourceView.bounds;
    [overlayView addSubview:dismissButton];
    
    
    
    //    [overlayView addSubview:popupView];
    [sourceView addSubview:overlayView];
    [sourceView addSubview:popupView];
    
    
    
    switch (animationType) {
        case WSFramePopupViewSlideTopBottom:
            [dismissButton addTarget:self action:@selector(wsDismissPopupViewControllerWithAnimationTypeSlideTopBottom) forControlEvents:UIControlEventTouchUpInside];
            [self ttSlideViewIn:popupView sourceView:sourceView overlayView:overlayView withAnimationType:WSFramePopupViewSlideTopBottom];
            break;
        case WSFramePopupViewSlideBottomTop:
            [dismissButton addTarget:self action:@selector(wsDismissPopupViewControllerWithAnimationTypeSlideBottomTop) forControlEvents:UIControlEventTouchUpInside];
            [self ttSlideViewIn:popupView sourceView:sourceView overlayView:overlayView withAnimationType:WSFramePopupViewSlideBottomTop];
            break;
        case WSFramePopupViewAnimationSlideRightLeft:
            [dismissButton addTarget:self action:@selector(dismissPopupViewControllerWithanimationTypeSlideRightLeft) forControlEvents:UIControlEventTouchUpInside];
            [self ttSlideViewIn:popupView sourceView:sourceView overlayView:overlayView withAnimationType:WSFramePopupViewAnimationSlideRightLeft];
            break;
        case WSFramePopupViewAnimationFade:
            [dismissButton addTarget:self action:@selector(dismissPopupViewControllerWithanimationTypeFade) forControlEvents:UIControlEventTouchUpInside];
            [self fadeViewIn:popupView sourceView:sourceView overlayView:overlayView];
            break;
        default:
            break;
    }
    
    [self setDismissedCallback:dismissed];
    
    
}



#pragma mark ----slide
-(void)ttSlideViewIn:(UIView *)popupView
          sourceView:(UIView *)sourceView
         overlayView:(UIView*)overlayView
   withAnimationType:(WSFramePopupViewAnimation)animationType
{
    
    CGRect popupViewRect = popupView.frame;
    CGRect sourceupViewRect = sourceView.frame;
    
    if(animationType == WSFramePopupViewSlideTopBottom){
        CGRect startRect = CGRectMake(popupViewRect.origin.x, -popupViewRect.size.height, popupViewRect.size.width, popupViewRect.size.height);
        
        [popupView layoutIfNeeded];
        [popupView setFrame:startRect];
        
        
        [UIView animateWithDuration:kPopupModalAnimationDuration animations:^{
            
            popupView.frame = popupViewRect;
            
        } completion:^(BOOL finished) {
            
        }];
    }else if(animationType == WSFramePopupViewSlideBottomTop){
        CGRect startRect = CGRectMake(popupViewRect.origin.x, popupViewRect.size.height + sourceView.frame.size.height, popupViewRect.size.width, popupViewRect.size.height);
        
        [popupView layoutIfNeeded];
        [popupView setFrame:startRect];
        
        
        [UIView animateWithDuration:kPopupModalAnimationDuration animations:^{
            
            popupView.frame = popupViewRect;
            
        } completion:^(BOOL finished) {
            
        }];
        
        
        
    }else if(animationType == WSFramePopupViewAnimationSlideRightLeft){
        
        
        CGRect startRect = CGRectMake(sourceupViewRect.size.width, (sourceupViewRect.size.height-popupViewRect.size.height)/2, popupViewRect.size.width, popupViewRect.size.height);
        
        
        CGRect endRect = CGRectMake((sourceupViewRect.size.width-popupViewRect.size.width)/2, (sourceupViewRect.size.height-popupViewRect.size.height)/2, popupViewRect.size.width, popupViewRect.size.height);
        
        popupView.frame = startRect;
        popupView.alpha = 1.0f;
        [UIView animateWithDuration:kPopupModalAnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            popupView.frame = endRect;
        } completion:^(BOOL finished) {
        }];
        
        
        
        
    }
    
    
    
}


- (void)fadeViewIn:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView
{
    
    //    [popupView layoutIfNeeded];
    //    // Generating Start and Stop Positions
    CGSize sourceSize = sourceView.bounds.size;
    CGSize popupSize = popupView.bounds.size;
    CGRect popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2,
                                     (sourceSize.height - popupSize.height) / 2,
                                     popupSize.width,
                                     popupSize.height);
    
    
    
    // Set starting properties
    popupView.frame = popupEndRect;
    popupView.alpha = 0.0f;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    [popupView setTransform:CGAffineTransformScale(transform, 0.2, 0.2)];
    
    [UIView animateWithDuration:kPopupModalAnimationDuration animations:^{
        popupView.alpha = 1.0f;
        //[popupView setAlpha:0.5];
        [popupView setTransform:CGAffineTransformScale(transform, 1.0, 1.0)];
    } completion:^(BOOL finished) {
        
    }];
    
}



- (void)ttSlideViewOut:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView withAnimationType:(WSFramePopupViewAnimation)animationType
{
    CGRect popupViewRect = popupView.frame;
    CGRect sourceupViewRect = sourceView.frame;
    
    
    if(animationType == WSFramePopupViewSlideTopBottom){
        CGRect endRect = CGRectMake(popupViewRect.origin.x, -popupViewRect.size.height, popupViewRect.size.width, popupViewRect.size.height);
        
        [UIView animateWithDuration:kPopupModalAnimationDuration animations:^{
            popupView.frame = endRect;
            
            
        } completion:^(BOOL finished) {
            
            popupView.frame = popupViewRect;
            [popupView removeFromSuperview];
            [overlayView removeFromSuperview];
            
            id dismissed = [self dismissedCallback];
            if (dismissed != nil)
            {
                ((void(^)(void))dismissed)();
                [self setDismissedCallback:nil];
            }
            
        }];
        
        
    }else if(animationType == WSFramePopupViewSlideBottomTop){
        
        CGRect endRect = CGRectMake(popupViewRect.origin.x, sourceView.frame.size.height+popupViewRect.size.height, popupViewRect.size.width, popupViewRect.size.height);
        
        [UIView animateWithDuration:kPopupModalAnimationDuration animations:^{
            popupView.frame = endRect;
            
            
        } completion:^(BOOL finished) {
            
            popupView.frame = popupViewRect;
            [popupView removeFromSuperview];
            [overlayView removeFromSuperview];
            
            id dismissed = [self dismissedCallback];
            if (dismissed != nil)
            {
                ((void(^)(void))dismissed)();
                [self setDismissedCallback:nil];
            }
            
        }];
        
        
    }else if(animationType == WSFramePopupViewAnimationSlideRightLeft){
        
        
        
        CGRect endRect = CGRectMake(sourceupViewRect.size.width, (sourceupViewRect.size.height-popupViewRect.size.height), popupViewRect.size.width, popupViewRect.size.height);
        
        [UIView animateWithDuration:kPopupModalAnimationDuration animations:^{
            popupView.frame = endRect;
            
            
        } completion:^(BOOL finished) {
            
            popupView.frame = popupViewRect;
            [popupView removeFromSuperview];
            [overlayView removeFromSuperview];
            id dismissed = [self dismissedCallback];
            if (dismissed != nil)
            {
                ((void(^)(void))dismissed)();
                [self setDismissedCallback:nil];
            }
            
        }];
        
        
    }
    
    
    
    
    
    
    
    
}





- (void)fadeViewOut:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView
{
    [UIView animateWithDuration:kPopupModalAnimationDuration animations:^{
        popupView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [popupView removeFromSuperview];
        [overlayView removeFromSuperview];
    }];
}


#pragma mark --miss
- (void)wsDismissPopupViewControllerWithAnimationTypeSlideTopBottom
{
    
    [self wsDismissPopupViewControllerWithanimationType:WSFramePopupViewSlideTopBottom];
    
}


- (void)wsDismissPopupViewControllerWithAnimationTypeSlideBottomTop
{
    
    [self wsDismissPopupViewControllerWithanimationType:WSFramePopupViewSlideBottomTop];
    
}


- (void)dismissPopupViewControllerWithanimationTypeSlideRightLeft
{
    [self wsDismissPopupViewControllerWithanimationType:WSFramePopupViewAnimationSlideRightLeft];
}

- (void)dismissPopupViewControllerWithanimationTypeFade
{
    [self wsDismissPopupViewControllerWithanimationType:WSFramePopupViewAnimationFade];
}



- (void)wsDismissPopupViewControllerWithanimationType:(WSFramePopupViewAnimation)animationType
{
    
    UIView *sourceView = self;
    UIView *popupView = [sourceView viewWithTag:kPopupViewTag];
    UIView *overlayView = [sourceView viewWithTag:kOverlayViewTag];
    
    
    if(animationType == WSFramePopupViewSlideTopBottom || animationType == WSFramePopupViewSlideBottomTop|| animationType == WSFramePopupViewAnimationSlideRightLeft){
        
        [self ttSlideViewOut:popupView sourceView:sourceView overlayView:overlayView withAnimationType:animationType];
    } else {
        [self fadeViewOut:popupView sourceView:sourceView overlayView:overlayView];
        
        
    }
    
    
}

#pragma mark --- Dismissed

- (void)setDismissedCallback:(void(^)(void))dismissed
{
    objc_setAssociatedObject(self, &MJPopupViewDismissedKey, dismissed, OBJC_ASSOCIATION_RETAIN);
}

- (void(^)(void))dismissedCallback
{
    return objc_getAssociatedObject(self, &MJPopupViewDismissedKey);
}

@end
