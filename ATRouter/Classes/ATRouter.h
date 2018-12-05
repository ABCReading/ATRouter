//
//  ATRouter.h
//  Demo
//
//  Created by lianglibao on 1/3/17.
//  Copyright © 2017 lianglibao All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 路由的流程:
 
 1. 应用内 触发路由时，给出 url，参数，和一个 optional 的 navigation controller，和 可选的方式，比如 present 或者 push
 
    由 appDelegate 的根控制器，分别实现路由过程，检查它当前的路径是不是自己的子页面如果是的话转换到此页面，再让子页面执行路由过程.
 
    如果都不是，则看 参数里面有没有给定的 navigation controller , 有的话在里面 push ，否则使用给定的 controller 来进行 present.

    如果也没有，则拿到当前 vc 对应的导航控制器来进行 push 
 */

// 可选的,导航目标控制器
extern NSString * const kATRouterTargetController;
// 可选的,导航发起的控制器
extern NSString * const kATRouterSourceController;
// 希望被使用的调用栈.
extern NSString * const kATRouterPrefferedNavigationController;

@interface ATRouter : NSObject

/// Migrate from JLRoutes.
/// Registers a routePattern with default priority (0) in the receiving scheme namespace.
+ (void)addRoute:(NSString *)routePattern handler:(BOOL (^)(NSDictionary *parameters))handlerBlock;

+ (BOOL)routeURL:(NSURL *)URL;
+ (BOOL)routeURL:(NSURL *)URL withParameters:(NSDictionary *)parameters;

+ (BOOL)routeWithProtocol:(id)protocol parameters:(NSDictionary *)parameters;

+ (void)navigationWithController:(UIViewController *)controller parameters:(NSDictionary *)parameters;

// 得到指定类型的 controller.
+ (UIViewController *)controllerWithProtocol:(id)protocol parameters:(NSDictionary *)parameters;

+ (UIViewController *)createViewControllerWithScheme:(NSString *)path
                                           parameter:(NSDictionary *)params;

@end
