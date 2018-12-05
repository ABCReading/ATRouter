//
//  ATBindClassModule.m
//  ATRouter_Example
//
//  Created by lianglibao on 2018/12/4.
//  Copyright © 2018年 Spaino. All rights reserved.
//

#import "ATBindClassModule.h"
#import "ATSupportedControllers.h"
#import "ATTwoViewController.h"
#import "ATThreeViewController.h"

@implementation ATBindClassModule
+ (void)load {
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure {
    // twoVC
    [self bindMetaClass:ATTwoViewController.class toProtocol:@protocol(ATTwoViewController)];
    // threeVC
    [self bindMetaClass:ATThreeViewController.class toProtocol:@protocol(ATThreeViewController)];
}

@end
