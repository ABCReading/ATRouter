//
//  ATRoutableController.h
//  Demo
//
//  Created by lianglibao on 1/3/17.
//  Copyright © 2017 lianglibao All rights reserved.
//

#ifndef ATRoutableController_h
#define ATRoutableController_h

@class UIViewController;

/// 路由中间节点，如果一个容器 controller 下面有下属的可路由到的页面，则此容器 controller 需要作为 host controller，
/// 比如 tab controller 先去问下面的子 controller 是否可以路由
@protocol ATRouteHostController <NSObject>
// host controller是tabVC 或 navVC, 当从一个频道的VC直接切换到另外一个频道VC时需要在hostVC里面去处理跳转逻辑.
- (BOOL)routeURL:URL withParameters:(NSDictionary *)parameters;

// 当前活动的导航栈，当 host controller 没有命中的时候（不是路由到某个固定的频道页面或下属的子页面），这时由最上面的 host controller 返回一个当前的活动导航栈，在上面 push 进去
- (UINavigationController *)activeNavigationController;

@end

@protocol ATRoutableController <NSObject>

/// 默认创建实例的方法.
+ (UIViewController *)createInstanceWithParameters:(NSDictionary *)parameters;

/// 页面的标识.
//- (NSString *)navigationIdentifier;

/// 在当前显示的控制器跳转前调用，如果当前处于不可中断的状态，返回 NO;
//- (BOOL)canPerformNavigationWithController:(UIViewController *)controller
//                                identifier:(NSString *)identifier;

@end


#endif /* ATRoutableController_h */
