//
//  UIViewController+Routing.m
//  Demo
//
//  Created by lianglibao on 1/14/17.
//  Copyright © 2017 lianglibao All rights reserved.
//

#import "UIViewController+Routing.h"


@implementation UIViewController (Routing)

- (BOOL)routeURL:(NSURL *)URL {
    return [self routeURL:URL withParameters:nil];
}

- (BOOL)routeURL:(NSURL *)URL withParameters:(NSDictionary *)parameters {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameters];

    dic[kATRouterPrefferedNavigationController] = self.navigationController;

    return [ATRouter routeURL:URL withParameters:[dic copy]];
}

@end
