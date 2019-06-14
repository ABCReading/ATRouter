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
#import "ATRouterURLHeader.h"
#import "ATViewController.h"


@implementation ATRouter (Test)
+ (void)load {
    // twoVC
    [ATRouter addRoute:ATRouterTestTwoURLPattern bindViewControllerClass:ATTwoViewController.class handler:^id (NSDictionary *parameters) {
        Class destination = NSClassFromString([parameters objectForKey:kATRouterBindClassKey]);

        UIViewController *c = [destination createInstanceWithParameters:parameters];
        
        [self navigationWithController:c parameters:parameters];
        return c;
    }];
    
    // threeVC
    [ATRouter addRoute:ATRouterTestThreeURLPattern bindViewControllerClass:ATThreeViewController.class handler:^id (NSDictionary *parameters) {
        Class destination = NSClassFromString([parameters objectForKey:kATRouterBindClassKey]);
        
        UIViewController *c = [destination createInstanceWithParameters:parameters];
        
        [self navigationWithController:c parameters:parameters];
        return c;
    }];
    
    [ATRouter addRoute:ATRouterTestOneURLPattern
bindViewControllerClass:ATViewController.class
               handler:^id(NSDictionary *parameters) {
                   Class destination = NSClassFromString([parameters objectForKey:kATRouterBindClassKey]);
                   
                   UIViewController *c = [destination createInstanceWithParameters:parameters];
                   
                   [self navigationWithController:c parameters:parameters];
                   
                   return c;
    }];

    
}
@end
