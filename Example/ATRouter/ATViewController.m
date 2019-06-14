//
//  ATViewController.m
//  ATRouter
//
//  Created by Spaino on 12/04/2018.
//  Copyright (c) 2018 Spaino. All rights reserved.
//

#import "ATViewController.h"
#import <ATRouter/ATRouter.h>
#import "ATUnifyUpdateInfoClass.h"
#import "ATRouterURLHeader.h"

@implementation ATViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [ATUnifyUpdateInfoClass saveUpdateInstance:self];
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
    [ATRouter routeURL:[NSURL URLWithString:ATRouterTestTwoURLPattern]
        withParameters:@{@"title":NSStringFromClass(self.class),
                         kATRouterMethodKey:kATRouterPresent}];
}


- (void)testUpdateMthod:(id)object {
    NSLog(@"%s++++++++%@", __func__, object);
}

- (void)dealloc {
    [ATUnifyUpdateInfoClass removeUpdateInstance:self];
}

+ (UIViewController *)createInstanceWithParameters:(NSDictionary *)parameters {
    return nil;
}


@end
