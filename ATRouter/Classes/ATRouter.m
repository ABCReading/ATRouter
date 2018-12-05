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
    if ([parameters[@"method"] isEqualToString:@"present"] ) {
        // UIViewController *c = (UIViewController *)parameters[@"presenter"];
        UIViewController *c = [UIApplication sharedApplication].delegate.window.rootViewController;
        [c presentViewController:controller animated:YES completion:nil];
        return;
    // 指定导航控制器push
    } else if (parameters[kATRouterPrefferedNavigationController]) {
        UINavigationController *c = (UINavigationController *)parameters[kATRouterPrefferedNavigationController];
        [c pushViewController:controller animated:YES];
        return;

    }

    // root is navVC/tabVC,通用的push结构.
    id root = [UIApplication sharedApplication].delegate.window.rootViewController;
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