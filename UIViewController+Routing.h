//
//  UIViewController+Routing.h
//  Demo
//
//  Created by lianglibao on 1/14/17.
//  Copyright © 2017 lianglibao All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATRouter.h"

@interface UIViewController (Routing)

- (BOOL)routeURL:(NSURL *)URL;
- (BOOL)routeURL:(NSURL *)URL withParameters:(NSDictionary *)parameters;

@end
