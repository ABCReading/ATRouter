//
//  ATRouter.h
//  Demo
//
//  Created by lianglibao on 1/3/17.
//  Copyright © 2017 lianglibao All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 路由的流程:
 
 1. 应用内 触发路由时，给出 url，参数，和一个 optional 的 navigation controller，和 可选的方式，比如 present 或者 push
 
    由 appDelegate 的根控制器，分别实现路由过程，检查它当前的路径是不是自己的子页面如果是的话转换到此页面，再让子页面执行路由过程.
 
    如果都不是，则看 参数里面有没有给定的 navigation controller , 有的话在里面 push ，否则使用给定的 controller 来进行 present.

    如果也没有，则拿到当前 vc 对应的导航控制器来进行 push 
 */
/** 获取绑定VC Class key **/
extern NSString const *kATRouterBindClassKey;

/** Router参数 **/
// 跳转方式key,默认push. 其他方式 value 传入kATRouterPop(返回), kATRouterDismiss(退下) , kATRouterPresent(弹出)
extern NSString const *kATRouterMethodKey;
// pop返回时必需参数value
extern NSString const *kATRouterPop;
// dismiss退下页面时必需参数value
extern NSString const *kATRouterDismiss;
// present弹出页面时必需参数value
extern NSString const *kATRouterPresent;

// 返回上一页面相关key.
// kATRouterPop时必需参数key, value为当前页面NavVC
extern NSString const *kATRouterPoperKey;
// kATRouterDismiss时必需参数key, value为当前页面NavVC或VC
extern NSString const *kATRouterDismisserKey;


// 跳转时是否需要动画key,默认有. value 传入 kATRouterNoAnimation,无动画!
extern NSString const *kATRouterHasShowAnimationKey;
// 跳转时不需要动画参数value.
extern NSString const *kATRouterNoAnimation;


@interface ATRouter : NSObject

/// Migrate from JLRoutes.
/// Registers a routePattern with default priority (0) in the receiving scheme namespace.
+ (void)addRoute:(NSString *)routePattern bindViewControllerClass:(Class)bindClass
         handler:(id (^)(NSDictionary *parameters))handlerBlock;

+ (id)routeURL:(NSURL *)URL;
+ (id)routeURL:(NSURL *)URL withParameters:(NSDictionary *)parameters;

+ (void)navigationWithController:(UIViewController *)controller
                      parameters:(NSDictionary *)parameters;

+ (UIViewController *)createViewControllerWithURL:(NSURL *)URL
                                        parameter:(NSDictionary *)params;

@end
