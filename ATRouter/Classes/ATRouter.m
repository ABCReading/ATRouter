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

NSString * const kATRouterBindClassKey = @"kJLRoutesBindViewControllerKey";

@implementation ATRouter
+ (void)addRoute:(NSString *)routePattern bindViewControllerClass:(Class)bindClass
         handler:(id (^)(NSDictionary *parameters))handlerBlock {
    if ([bindClass conformsToProtocol:@protocol(ATRoutableController)]) {
        [[JLRoutes globalRoutes] addRoute:routePattern bindClass:bindClass handler:handlerBlock];
    }
}

+ (id)routeURL:(NSURL *)URL {
    return [self routeURL:URL withParameters:nil];
}

+ (id)routeURL:(NSURL *)URL withParameters:(NSDictionary *)parameters {
    
    id canRoute = [JLRoutes routeURL:URL withParameters:parameters];

    return canRoute;
}

+ (void)navigationWithController:(UIViewController *)controller parameters:(NSDictionary *)parameters {
    if ([parameters[kJLRoutesDontGotoNextPageKey] boolValue]) {
        // kJLRoutesDontGotoNextPageKey 代表只是获取一个实例,并不用跳转!
        return;
    }
    
    if (![controller isKindOfClass:UIViewController.class]) {
        // 当初绑定的class或createInstanceWithParameters出来的就不是:UIViewController!!;
        return;
    }

    BOOL animation = ![parameters[@"animation"] isEqualToString:@"NO"];
    
    // parameters[@"presenter"] &&
    // 展现方式是present,就应该只有当前顶层控制器来完成.
    if ([parameters[@"method"] isEqualToString:@"present"]) {
        
        UIViewController *vc =  [self getTopVisibleController];
        [vc presentViewController:controller animated:animation completion:nil];
        
        return;
    // pop返回,必须需要知道当前nav 并且方法是pop
    // poper 当前页面的导航控制器.
    } else if ([parameters[@"method"] isEqualToString:@"pop"] &&
               [parameters[@"poper"] isKindOfClass:UINavigationController.class]) {
        UINavigationController *c = parameters[@"poper"];
        __block BOOL isCanPop = NO;
        
        __block UIViewController *tempController = controller;
        if ([controller isKindOfClass:UINavigationController.class]) {
            UINavigationController *tempNavController = (UINavigationController *)tempController;
            tempController = tempNavController.childViewControllers.firstObject;
        }
        
        [c.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj,
                                                             NSUInteger idx,
                                                             BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:tempController.class]) {
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
        } else {
            // 这里是否欠考虑? 目标控制器实际不能pop的时候,是否什么应该都不做呢?
            if ([controller isKindOfClass:UINavigationController.class]) {
                [c pushViewController:controller.childViewControllers.firstObject animated:animation];
            } else {
                [c pushViewController:controller animated:animation];
            }
        }
        return;
        
    // dismisser 当前dismiss的控制器
    } else if ([parameters[@"method"] isEqualToString:@"dismiss"] &&
               [parameters[@"dismisser"] isKindOfClass:UIViewController.class]) {
        UIViewController *tmpDismisser = parameters[@"dismisser"];
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

    // 通用的push操作.
    if ([controller isKindOfClass:UINavigationController.class]) {
        [[self getTopVisibleNavgationController] pushViewController:controller.childViewControllers.firstObject animated:animation];
    } else if ([controller isKindOfClass:UITabBarController.class]) {
        [[self getTopVisibleNavgationController] pushViewController:[self p_getTopVisibleController:controller] animated:animation];
    } else {
        [[self getTopVisibleNavgationController] pushViewController:controller animated:animation];
    }

    return;

    NSAssert(NO, @"TODO: 未实现的分支逻辑");
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
