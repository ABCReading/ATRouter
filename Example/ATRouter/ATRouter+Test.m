//
//  ATRouter+Test.m
//  ATRouter_Example
//
//  Created by lianglibao on 2018/12/4.
//  Copyright © 2018年 Spaino. All rights reserved.
//

#import "ATRouter+Test.h"
#import "ATSupportedControllers.h"
#import <Objection/Objection.h>
#import <ATRoutableController.h>
#import <ATRouter.h>
static NSString *routerTwoStr = @"/two";
static NSString *routerThreeStr = @"/three";
@implementation ATRouter (Test)
+ (void)load {
    // twoVC
    [ATRouter addRoute:routerTwoStr handler:^BOOL(NSDictionary *parameters) {
        id<ATRoutableController> destination = [[JSObjection defaultInjector] getObject:@protocol(ATTwoViewController)];
        
        UIViewController *c = [destination createInstanceWithParameters:parameters];
        
        if (!c) {
            return NO;
        }
        
        [self navigationWithController:c parameters:parameters];
        return YES;
    }];
    
    // threeVC
    [ATRouter addRoute:routerThreeStr handler:^BOOL(NSDictionary *parameters) {
        id<ATRoutableController> destination = [[JSObjection defaultInjector] getObject:@protocol(ATThreeViewController)];
        
        UIViewController *c = [destination createInstanceWithParameters:parameters];
        
        if (!c) {
            return NO;
        }
        
        [self navigationWithController:c parameters:parameters];
        return YES;
    }];

    
}
@end
