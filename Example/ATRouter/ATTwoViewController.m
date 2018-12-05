//
//  ATTwoViewController.m
//  ATRouter_Example
//
//  Created by lianglibao on 2018/12/4.
//  Copyright © 2018年 Spaino. All rights reserved.
//

#import "ATTwoViewController.h"
#import <ATRouter/ATRoutableController.h>
#import <ATRouter/ATRouter.h>
@interface ATTwoViewController () <ATRoutableController>

@end

@implementation ATTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSStringFromClass(self.class);
    self.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    
    [self.view addSubview:({
        UIButton *btn = [UIButton new];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.backgroundColor = [UIColor blueColor];
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backToPerious) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        btn.center = self.view.center;
        btn;
    })];
}

- (void)backToPerious {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [ATRouter routeURL:[NSURL URLWithString:@"/three"] withParameters:@{@"title":NSStringFromClass(self.class), @"method":@"present"}];
}

+ (UIViewController *)createInstanceWithParameters:(NSDictionary *)parameters {
    NSLog(@"%@", parameters);
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[self new]];
    return nav;
}

@end
