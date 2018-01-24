#  "UIView+WSPopWindow"
使用方法样例:

PopView *presentView = [PopView new];
presentView.frame = CGRectMake(0, 0, self.view.ws_width, 300);
presentView.backgroundColor = [UIColor yellowColor];

//点击弹出框周围是否隐藏
presentView.hideShouldTouchOutside = NO;

//不带偏移

[self.view presentWindowWithView:presentView animatedType:WSPopViewBottomFromBottom completion:^{
    NSLog(@"完成回调1");
}];

//带偏移

[self.view presentWindowWithView:presentView offset:CGPointMake(0, -34) animatedType:WSPopViewBottomFromBottom completion:^{
    NSLog(@"完成回调2");
}];

//animated 是否动画
[self.view dismissWindow:YES completion:^{
    NSLog(@"完成回调3");
}];
# "UIViewController+WSPopWindow"
使用方法样例:

PresentViewController *presentVC = [[PresentViewController alloc] init];
presentVC.view.frame = CGRectMake(0, 0, self.view.ws_width, 300);
presentVC.hideShouldTouchOutside = NO;

//不带偏移

[self presentPopViewController:presentVC offset:CGPointMake(0, -34) animatedType:WSPopViewFrameBottomFromBottom completion:^{
    NSLog(@"完成回调1");
}];

//带偏移

[self.view presentWindowWithView:presentView offset:CGPointMake(0, -34) animatedType:WSPopViewBottomFromBottom completion:^{
    NSLog(@"完成回调2");
}];

//animated 是否动画

[self.view dismissWindow:YES completion:^{
    NSLog(@"完成回调3");
}];


# "UIView+WSPopView"

PopView *presentView = [PopView new];
presentView.frame = CGRectMake(0, 0, self.view.ws_width, 200);
presentView.backgroundColor = [UIColor yellowColor];

//只能决定弹出方向，具体位置需要去设置
[self.view wsPresentFramePopupView:presentView animationType:WSFramePopupViewSlideBottomTop dismissed:^{
     NSLog(@"完成回调");
}];

[self.view wsDismissPopupViewControllerWithanimationType:WSFramePopupViewSlideBottomTop];
