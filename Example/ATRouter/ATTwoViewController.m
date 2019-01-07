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
#import "ATUnifyUpdateInfoClass.h"
@interface ATTwoViewController () <ATRoutableController>
@property (nonatomic, strong) UIButton *backBtn;
@end

@implementation ATTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [ATUnifyUpdateInfoClass saveUpdateInstance:self];
    // Do any additional setup after loading the view.
    self.title = NSStringFromClass(self.class);
    self.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    
    [self.view addSubview:({
        UIButton *btn = [UIButton new];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backToPerious) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        btn.center = self.view.center;
        self.backBtn = btn;
        btn;
    })];
    
    [self.view addSubview:({
        UIButton *btn = [UIButton new];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.backgroundColor = [UIColor lightGrayColor];
        [btn setTitle:@"NEXT" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        btn.center = CGPointMake(self.view.frame.size.width / 2.0, self.backBtn.frame.origin.y + 100);
        btn;
    })];
}

- (void)backToPerious {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [ATUnifyUpdateInfoClass removeUpdateInstance:self];
}

- (void)next {
    
    [ATRouter routeURL:[NSURL URLWithString:@"/three"]
        withParameters:@{@"title":NSStringFromClass(self.class),@"method":@"present"
                         }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [ATUnifyUpdateInfoClass updateInstanceMethod:NSStringFromClass(self.class)];
}

+ (UIViewController *)createInstanceWithParameters:(NSDictionary *)parameters {
    NSLog(@"%@", parameters);
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[self new]];
    return nav;
}

- (void)testUpdateMthod:(id)object {
    NSLog(@"%s++++++++%@", __func__, object);
}

@end
