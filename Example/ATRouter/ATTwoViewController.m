//
//  ATTwoViewController.m
//  ATRouter_Example
//
//  Created by lianglibao on 2018/12/4.
//  Copyright © 2018年 Spaino. All rights reserved.
//

#import "ATTwoViewController.h"
#import <ATRouter/ATRoutableController.h>
@interface ATTwoViewController () <ATRoutableController>

@end

@implementation ATTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSStringFromClass(self.class);
    self.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
}

+ (UIViewController *)createInstanceWithParameters:(NSDictionary *)parameters {
    NSLog(@"%@", parameters);
    return [self new];
}
@end
