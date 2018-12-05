//
//  ATViewController.m
//  ATRouter
//
//  Created by Spaino on 12/04/2018.
//  Copyright (c) 2018 Spaino. All rights reserved.
//

#import "ATViewController.h"
#import <ATRouter/ATRouter.h>
@interface ATViewController () <ATRouteHostController>

@end

@implementation ATViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = NSStringFromClass(self.class);
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [ATRouter routeURL:[NSURL URLWithString:@"https://TwoVC/pass?qq=110"]
//        withParameters:@{@"title": NSStringFromClass(self.class)}];
    [ATRouter routeURL:[NSURL URLWithString:@"/two"] withParameters:@{@"title":NSStringFromClass(self.class), @"method":@"present"}];
}

// MARK: - <ATRouteHostController>
- (BOOL)routeURL:URL withParameters:(NSDictionary *)parameters {
    return NO;
}

- (UINavigationController *)activeNavigationController {
    return (UINavigationController *)self.navigationController;
}


@end
