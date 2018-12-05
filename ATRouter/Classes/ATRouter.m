//
//  ATRouter.m
//  Demo
//
//  Created by lianglibao on 1/3/17.
//  Copyright © 2017 lianglibao All rights reserved.
//

#import "ATRouter.h"
#import <JLRoutes/JLRoutes.h>
#import <Objection/Objection.h>
#import "ATRoutableController.h"


NSString * const kATRouterTargetController = @"route_target";
NSString * const kATRouterSourceController = @"sourceViewController";
NSString * const kATRouterPrefferedNavigationController = @"prefferedNavigationController";

@implementation ATRouter

+ (void)addRoute:(NSString *)routePattern handler:(BOOL (^)(NSDictionary *parameters))handlerBlock {
    [[JLRoutes globalRoutes] addRoute:routePattern handler:handlerBlock];
}

+ (BOOL)routeURL:(NSURL *)URL {
    return [self routeURL:URL withParameters:nil];
}

+ (BOOL)routeURL:(NSURL *)URL withParameters:(NSDictionary *)parameters {
    id controller = [UIApplication sharedApplication].delegate.window.rootViewController;
    BOOL canRoute = NO;

    if ([controller conformsToProtocol:@protocol(ATRouteHostController)]) {

        canRoute = [controller routeURL:URL withParameters:parameters];

    }
    
    if (!canRoute) {

        canRoute = [JLRoutes routeURL:URL withParameters:parameters];

    }

    return canRoute;
}

+ (BOOL)routeWithProtocol:(id)protocol parameters:(NSDictionary *)parameters {

    UIViewController *c = [self controllerWithProtocol:protocol parameters:parameters];
    if (!c) {
        return NO;
    }
    
    [self navigationWithController:c parameters:parameters];

    return YES;
}

+ (UIViewController *)controllerWithProtocol:(id)protocol parameters:(NSDictionary *)parameters {
    id<ATRoutableController> destination = [[JSObjection defaultInjector] getObject:protocol];

    return [destination createInstanceWithParameters:parameters];
}

+ (void)navigationWithController:(UIViewController *)controller parameters:(NSDictionary *)parameters {
    // parameters[@"presenter"] &&
    // 展现方式是present,就应该只有当前顶层控制器来完成.
    if ([parameters[@"method"] isEqualToString:@"present"]) {
        // UIViewController *c = (UIViewController *)parameters[@"presenter"];
        id root = [UIApplication sharedApplication].delegate.window.rootViewController;
        id presentRoot = [root performSelector:@selector(presentedViewController)];
        // 例如,当前nav present 一个nav, 然后presentNav 需要present vc
        if (presentRoot) {
            root = presentRoot;
        }
        [root presentViewController:controller animated:YES completion:nil];
        return;
        
    // 指定导航控制器push
    } else if (parameters[kATRouterPrefferedNavigationController]) {
        UINavigationController *c = (UINavigationController *)parameters[kATRouterPrefferedNavigationController];
        [c pushViewController:controller animated:YES];
        return;

    // pop返回,必须需要知道当前nav 并且方法是pop
    // poper 当前页面的导航控制器.
    } else if ([parameters[@"method"] isEqualToString:@"pop"] && [parameters[@"poper"] isKindOfClass:UINavigationController.class]) {
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
            // pop时的反向传值操作.
            if ([tempController respondsToSelector:@selector(updateCurrentPageWithParmeters:)]) {
                [tempController performSelector:@selector(updateCurrentPageWithParmeters:) withObject:parameters];
            }
            [c popToViewController:tempController animated:YES];
        } else {
            // 这里是否欠考虑? 目标控制器实际不能pop的时候,是否什么应该都不做呢?
            if ([controller isKindOfClass:UINavigationController.class]) {
                [c pushViewController:controller.childViewControllers.firstObject animated:YES];
            } else {
                [c pushViewController:controller animated:YES];
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
        if ([tempController respondsToSelector:@selector(updateCurrentPageWithParmeters:)]) {
            [tempController performSelector:@selector(updateCurrentPageWithParmeters:) withObject:parameters];
        }
        [tmpDismisser dismissViewControllerAnimated:YES completion:nil];
        return;
    }

    // root is navVC/tabVC,通用的push结构.
    id root = [UIApplication sharedApplication].delegate.window.rootViewController;
    id presentRoot = [root performSelector:@selector(presentedViewController)];
    // 例如,当前nav present 一个nav, 然后presentNav 需要push vc
    if (presentRoot) {
        root = presentRoot;
    }
    
    if ([root conformsToProtocol:@protocol(ATRouteHostController)]) {
        id<ATRouteHostController> c = (id<ATRouteHostController>)root;
        [[c activeNavigationController] pushViewController:controller animated:YES];
        return;
    }
    
    // root 是没有包装的nav 直接push.
    if ([root isKindOfClass:UINavigationController.class]) {
        [root pushViewController:controller animated:YES];
        return;
    }


    NSAssert(NO, @"TODO: 未实现的分支逻辑");
}

+ (UIViewController *)createViewControllerWithScheme:(NSString *)path
                                           parameter:(NSDictionary *)params {
    id<ATRoutableController> destination = [JLRoutes routesForScheme:path];
    
    return [destination createInstanceWithParameters:params];
}

@end
