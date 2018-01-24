//
//  UIView+RectExtension.h
//  自定义封装Present工具
//
//  Created by wangsheng on 2018/1/22.
//  Copyright © 2018年 wangsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (RectExtension)
@property (nonatomic, assign)CGFloat ws_y;
@property (nonatomic, assign)CGFloat ws_x;
@property (nonatomic, assign)CGPoint ws_center;
@property (nonatomic, assign)CGSize  ws_size;
@property (nonatomic, assign)CGPoint ws_origin;
@property (nonatomic, assign)CGFloat ws_width;
@property (nonatomic, assign)CGFloat ws_height;
@property (nonatomic, assign, readonly)CGFloat ws_maxY;
@property (nonatomic, assign, readonly)CGFloat ws_maxX;
@property (nonatomic, assign)CGFloat ws_centerX;
@property (nonatomic, assign)CGFloat ws_centerY;
@end
