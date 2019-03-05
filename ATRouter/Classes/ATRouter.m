//
//  ATRouter.m
//  Demo
//
//  Created by lianglibao on 1/3/17.
//  Copyright © 2017 lianglibao All rights reserved.
//

#import "ATRouter.h"
#import "JLRoutes.h"
#import "ATRoutableController.h"
#import <objc/message.h>

/** 获取绑定VC Class key **/
NSString const *kATRouterBindClassKey = @"kJLRoutesBindViewControllerKey";

/** Router参数 **/
// 跳转方式key,默认push. 其他方式 value 传入kATRouterPop(返回), kATRouterDismiss(退下) , kATRouterPresent(弹出)
NSString const *kATRouterMethodKey = @"kATRouterMethodKey";
// pop返回时必需参数value
NSString const *kATRouterPop = @"pop";
// dismiss退下页面时必需参数value
NSString const *kATRouterDismiss = @"dismiss";
// present弹出页面时必需参数value
NSString const *kATRouterPresent = @"present";

// 返回上一页面相关key.
// kATRouterPop时必需参数key, value为当前页面NavVC
NSString const *kATRouterPoperKey = @"kATRouterPoperKey";
// kATRouterDismiss时必需参数key, value为当前页面NavVC或VC
NSString const *kATRouterDismisserKey = @"kATRouterDismisserKey";

// 跳转时是否需要动画key,默认有. value 传入 kATRouterNoAnimation,无动画!
NSString const *kATRouterHasShowAnimationKey = @"kATRouterHasShowAnimationKey";
// 跳转时不需要动画参数value.
NSString const *kATRouterNoAnimation = @"NO";

@implementation ATRouter
+ (void)addRoute:(NSString *)routePattern bindViewControllerClass:(Class)bindClass
         handler:(id (^)(NSDictionary *parameters))handlerBlock {
    if ([bindClass conformsToProtocol:@protocol(ATRoutableController)]) {
        [[JLRoutes globalRoutes] addRoute:routePattern bindClass:bindClass handler:handlerBlock];
    }
}

+ (id)routeURL:(NSURL *)URL {
    return [self routeURL:URL
           withParameters:nil];
}

+ (id)routeURL:(NSURL *)URL withParameters:(NSDictionary *)parameters {    
    id canRoute = [JLRoutes routeURL:URL
                      withParameters:parameters];

    return canRoute;
}

+ (void)navigationWithController:(UIViewController *)controller
                      parameters:(NSDictionary *)parameters {
    if ([parameters[kJLRoutesDontGotoNextPageKey] boolValue]) {
        // kJLRoutesDontGotoNextPageKey 代表只是获取一个实例,并不用跳转!
        return;
    }

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wincompatible-pointer-types-discards-qualifiers"
    BOOL animation = ![parameters[kATRouterHasShowAnimationKey] isEqualToString:kATRouterNoAnimation];

    // 展现方式是present,就应该只有当前顶层控制器来完成.
    if ([parameters[kATRouterMethodKey] isEqualToString:kATRouterPresent]) {
        if (![controller isKindOfClass:UIViewController.class]) {
            // 当初绑定的class或createInstanceWithParameters出来的就不是:UIViewController!!;
            return;
        }

        UIViewController *vc =  [self getTopVisibleController];
        [vc presentViewController:controller animated:animation completion:nil];
        
        return;
    // pop返回,必须需要知道当前nav 并且方法是pop
    // poper 是当前页面的导航控制器.
    } else if ([parameters[kATRouterMethodKey] isEqualToString:kATRouterPop] &&
               [parameters[kATRouterPoperKey] isKindOfClass:UINavigationController.class]) {
        Class destinationClass = NSClassFromString([parameters objectForKey:kATRouterBindClassKey]);
        
        UINavigationController *c = parameters[kATRouterPoperKey];
        __block BOOL isCanPop = NO;
        
        __block UIViewController *tempController = controller;
        if ([controller isKindOfClass:UINavigationController.class]) {
            UINavigationController *tempNavController = (UINavigationController *)tempController;
            tempController = tempNavController.childViewControllers.firstObject;
        }
        
        [c.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj,
                                                             NSUInteger idx,
                                                             BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:destinationClass]) {
                isCanPop = YES;
                tempController = obj;
                *stop = YES;
            }
        }];

        if (isCanPop) {
            [c popToViewController:tempController animated:animation];
            // pop时的反向传值操作.
            if ([tempController respondsToSelector:@selector(updateCurrentPageWithParmeters:)]) {
                [tempController performSelector:@selector(updateCurrentPageWithParmeters:) withObject:parameters];
            }
        }
        return;
        
    // dismisser 当前dismiss的控制器
    } else if ([parameters[kATRouterMethodKey] isEqualToString:kATRouterDismiss] &&
               [parameters[kATRouterDismisserKey] isKindOfClass:UIViewController.class]) {
        UIViewController *tmpDismisser = parameters[kATRouterDismisserKey];
        UIViewController *tempController;
        if ([tmpDismisser.presentingViewController isKindOfClass:UINavigationController.class]) {
            tempController = tmpDismisser.presentingViewController.childViewControllers.lastObject;
        } else if ([tmpDismisser.presentingViewController isKindOfClass:UITabBarController.class]) {
            tempController = ((UITabBarController *)tmpDismisser.presentingViewController).selectedViewController;
            tempController = tempController.childViewControllers.lastObject;
        } else {
            tempController = tmpDismisser.presentingViewController;
        }
        [tmpDismisser dismissViewControllerAnimated:animation completion:nil];
        if ([tempController respondsToSelector:@selector(updateCurrentPageWithParmeters:)]) {
            [tempController performSelector:@selector(updateCurrentPageWithParmeters:) withObject:parameters];
        }
        return;
    }
#pragma clang diagnostic pop
    
    if (![controller isKindOfClass:UIViewController.class]) {
        // 当初绑定的class或createInstanceWithParameters出来的就不是:UIViewController!!;
        return;
    }

    // 通用的push操作.
    if ([controller isKindOfClass:UINavigationController.class]) {
        [[self getTopVisibleNavgationController] pushViewController:controller.childViewControllers.firstObject animated:animation];
    } else if ([controller isKindOfClass:UITabBarController.class]) {
        [[self getTopVisibleNavgationController] pushViewController:[self p_getTopVisibleController:controller] animated:animation];
    } else {
        [[self getTopVisibleNavgationController] pushViewController:controller animated:animation];
    }

    return;
}

+ (UIViewController *)createViewControllerWithURL:(NSURL *)URL
                                        parameter:(NSDictionary *)params {
    id router = [JLRoutes getViewControllerFormURL:URL withParameters:params];
    if ([router isKindOfClass:UIViewController.class]) {
        return router;
    } else {
        return nil;
    }
}



// MARK: - Private Func
/************************************获取当前显示的控制器*********************************************/

+ (UIViewController *)getTopVisibleController {
    
    return [self p_getTopVisibleController:[self p_getCurrentWindowRootController]];
}

+ (UINavigationController *)getTopVisibleNavgationController {
    return [[self getTopVisibleController] navigationController];
}

+ (UIViewController *)p_getCurrentWindowRootController {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    return window.rootViewController;
}

+ (UIViewController *)p_getTopVisibleController:(UIViewController *)vc {
    
    if (vc.presentedViewController) {
        return [self p_getTopVisibleController:vc.presentedViewController];
    } else if ([vc isKindOfClass:UITabBarController.class]) {
        return [self p_getTopVisibleController:((UITabBarController *)vc).selectedViewController];
    } else if ([vc isKindOfClass:UINavigationController.class]) {
        return [self p_getTopVisibleController:((UINavigationController *)vc).visibleViewController];
    } else {
        NSUInteger count = vc.childViewControllers.count;
        for (NSUInteger i = 0; i < count; i++) {
            UIViewController *childVC = vc.childViewControllers[i];
            if (childVC && childVC.view.window) {
                vc = [self p_getTopVisibleController:childVC];
                break;
            }
        }
        return vc;
    }
}
/*************************************获取当前显示的控制器********************************************/

@end
