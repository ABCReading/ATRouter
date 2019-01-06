//
//  ATRouter+Test.m
//  ATRouter_Example
//
//  Created by lianglibao on 2018/12/4.
//  Copyright © 2018年 Spaino. All rights reserved.
//

#import "ATRouter+Test.h"
#import "ATSupportedControllers.h"
#import <ATRoutableController.h>
#import <ATRouter.h>
#import "ATTwoViewController.h"
#import "ATThreeViewController.h"
static NSString *routerTwoStr = @"/two";
static NSString *routerThreeStr = @"/three";
@implementation ATRouter (Test)
+ (void)load {
    // twoVC
    [ATRouter addRoute:routerTwoStr bindViewControllerClass:ATTwoViewController.class handler:^id (NSDictionary *parameters) {
        Class destination = NSClassFromString([parameters objectForKey:kATRouterBindClassKey]);

        UIViewController *c = [destination createInstanceWithParameters:parameters];
        
        if (!c) {
            return nil;
        }
        
        [self navigationWithController:c parameters:parameters];
        return c;
    }];
    
    // threeVC
    [ATRouter addRoute:routerThreeStr bindViewControllerClass:ATThreeViewController.class handler:^id (NSDictionary *parameters) {
        Class destination = NSClassFromString([parameters objectForKey:kATRouterBindClassKey]);
        
        UIViewController *c = [destination createInstanceWithParameters:parameters];
        
        if (!c) {
            return nil;
        }
        
        [self navigationWithController:c parameters:parameters];
        return c;
    }];

    
}
@end
