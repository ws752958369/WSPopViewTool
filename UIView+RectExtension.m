//
//  UIView+RectExtension.m
//  自定义封装Present工具
//
//  Created by wangsheng on 2018/1/22.
//  Copyright © 2018年 wangsheng. All rights reserved.
//

#import "UIView+RectExtension.h"

@implementation UIView (RectExtension)

-(void)setWs_x:(CGFloat)ws_x
{
    CGRect rect = self.frame;
    rect.origin.x = ws_x;
    self.frame = rect;
}

-(CGFloat)ws_x
{
    CGRect rect = self.frame;
    return rect.origin.x;
}

-(void)setWs_y:(CGFloat)ws_y
{
    CGRect rect = self.frame;
    rect.origin.y = ws_y;
    self.frame = rect;
}

-(CGFloat)ws_y
{
    CGRect rect = self.frame;
    return rect.origin.y;
}

-(void)setWs_center:(CGPoint)ws_center
{
    self.center = ws_center;
}

-(CGPoint)ws_center
{
    return self.center;
}

-(void)setWs_size:(CGSize)ws_size
{
    CGRect rect = self.frame;
    rect.size = ws_size;
    self.frame = rect;
}

-(CGSize)ws_size
{
    return self.frame.size;
}

-(void)setWs_origin:(CGPoint)ws_origin
{
    CGRect rect = self.frame;
    rect.origin = ws_origin;
    self.frame = rect;
}

-(CGPoint)ws_origin
{
    return self.frame.origin;
}

-(void)setWs_width:(CGFloat)ws_width
{
    CGRect rect = self.frame;
    rect.size.width = ws_width;
    self.frame = rect;
}

-(CGFloat)ws_width
{
    return self.frame.size.width;
}

-(void)setWs_height:(CGFloat)ws_height
{
    CGRect rect = self.frame;
    rect.size.height = ws_height;
    self.frame = rect;
}

-(CGFloat)ws_height
{
    return self.frame.size.height;
}

-(CGFloat)ws_maxY
{
    CGRect rect = self.frame;
    return (rect.origin.y + rect.size.height);
}

-(CGFloat)ws_maxX
{
    CGRect rect = self.frame;
    return (rect.origin.x + rect.size.width);
}

-(void)setWs_centerX:(CGFloat)ws_centerX
{
    CGPoint center = self.center;
    center.x = ws_centerX;
    self.center = center;
}

-(CGFloat)ws_centerX
{
    return self.center.x;
}

-(void)setWs_centerY:(CGFloat)ws_centerY
{
    CGPoint center = self.center;
    center.y = ws_centerY;
    self.center = center;
}

-(CGFloat)ws_centerY
{
    return self.center.y;
}

@end
