//
//  ATThreeViewController.m
//  ATRouter_Example
//
//  Created by lianglibao on 2018/12/5.
//  Copyright © 2018年 Spaino. All rights reserved.
//

#import "ATThreeViewController.h"
#import <ATRouter/ATRoutableController.h>
#import <ATRouter/ATRouter.h>
#import "ATUnifyUpdateInfoClass.h"
@interface ATThreeViewController ()<ATRoutableController>

@end

@implementation ATThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [ATUnifyUpdateInfoClass saveUpdateInstance:self];
    // Do any additional setup after loading the view.
    self.title = NSStringFromClass(self.class);
    self.view.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1];
    
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
    [ATUnifyUpdateInfoClass removeUpdateInstance:self];
//    [self dismissViewControllerAnimated:YES completion:nil];
    [ATRouter routeURL:[NSURL URLWithString:@"/two"] withParameters:@{kATRouterMethodKey:kATRouterDismiss, kATRouterDismisserKey : self.navigationController}];
//    [ATRouter routeURL:[NSURL URLWithString:@"/two"] withParameters:@{kATRouterMethodKey:kATRouterPop, kATRouterPoperKey: self.navigationController}];
}

+ (UIViewController *)createInstanceWithParameters:(NSDictionary *)parameters {
    NSLog(@"%@", parameters);
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[self new]];
    return nav;

}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [[ATUnifyUpdateInfoClass sharedInstance] updateInstanceMethod:NSStringFromClass(self.class)];
//}

- (void)testUpdateMthod:(id)object {
    NSLog(@"%s++++++++%@", __func__, object);
}

- (void)dealloc {
    
}

@end
