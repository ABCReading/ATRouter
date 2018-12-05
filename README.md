# ATRouter

[![CI Status](https://img.shields.io/travis/Spaino/ATRouter.svg?style=flat)](https://travis-ci.org/Spaino/ATRouter)
[![Version](https://img.shields.io/cocoapods/v/ATRouter.svg?style=flat)](https://cocoapods.org/pods/ATRouter)
[![License](https://img.shields.io/cocoapods/l/ATRouter.svg?style=flat)](https://cocoapods.org/pods/ATRouter)
[![Platform](https://img.shields.io/cocoapods/p/ATRouter.svg?style=flat)](https://cocoapods.org/pods/ATRouter)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ATRouter is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ATRouter'
```

> - 1. pod 安装后需要在项目宿主工程中创建一个全局的header 协议文件,用于声明所有需要协议路由router的VC协议,示例如下:
>
>   <pre>
>   #ifndef ATSupportedControllers_h
>   #define ATSupportedControllers_h
>   // TwoVC
>   @protocol ATTwoViewController <NSObject>
>   @end
>   #endif
>   </pre> 
>
> - 2. 在每一个频道(模块)Module下,创建一个bind module class 用来绑定所有已被ATSupportedControllers.h声明过的VC,示例如下:
>
>   <pre>
>   /// .h 文件
>   #import <Objection/Objection.h>
>   @interface ATBindClassModule : JSObjectionModule
>   
>   @end
>   
>   /// .m文件
>   #import "ATBindClassModule.h"
>   #import "ATSupportedControllers.h"
>   #import "ATTwoViewController.h"
>   
>   @implementation ATBindClassModule
>   + (void)load {
>       JSObjectionInjector *injector = [JSObjection defaultInjector];
>       injector = injector ? : [JSObjection createInjector];
>       injector = [injector withModule:[[self alloc] init]];
>       [JSObjection setDefaultInjector:injector];
>   }
>   
>   - (void)configure {
>       // twoVC
>       [self bindMetaClass:ATTwoViewController.class toProtocol:@protocol(ATTwoViewController)];
>   }
>   
>   @end    
>   </pre>
>
> - 3. 在每一个频道(模块)Module下,创建一个ATRouter分类,用于注册VC route,示例如下:
>
>      <pre>
>      /// .h文件
>      #import <ATRouter/ATRouter.h>
>      
>      NS_ASSUME_NONNULL_BEGIN
>      
>      @interface ATRouter (Test)
>      
>      @end
>      
>      /// .m文件
>      #import "ATRouter+Test.h"
>      #import "ATSupportedControllers.h"
>      #import <Objection/Objection.h>
>      #import <ATRoutableController.h>
>      #import <ATRouter.h>
>      static NSString *routerStr = @"/TwoVC/pass";
>      @implementation ATRouter (Test)
>      + (void)load {
>          // webVC
>          [ATRouter addRoute:routerStr handler:^BOOL(NSDictionary *parameters) {
>              id<ATRoutableController> destination = [[JSObjection defaultInjector] getObject:@protocol(ATTwoViewController)];
>              
>              UIViewController *c = [destination createInstanceWithParameters:parameters];
>              
>              if (!c) {
>                  return NO;
>              }
>              
>              [self navigationWithController:c parameters:parameters];
>              return YES;
>          }];
>          
>      }
>      @end
>      </pre>
>
> - 4. 在需要路由的VC里遵循<ATRoutableController>协议,并且实现createInstanceWithParameters工厂方法,示例如下:
>
>   <pre>
>   #import "ATTwoViewController.h"
>   #import <ATRouter/ATRoutableController.h>
>   @interface ATTwoViewController () <ATRoutableController>
>   
>   @end
>   
>   @implementation ATTwoViewController
>   
>   - (void)viewDidLoad {
>       [super viewDidLoad];
>       // Do any additional setup after loading the view.
>       self.title = NSStringFromClass(self.class);
>       self.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
>   }
>   
>   + (UIViewController *)createInstanceWithParameters:(NSDictionary *)parameters {
>       NSLog(@"%@", parameters);
>       return [self new];
>   }
>   @end
>   </pre>
>
> - 5. 在根nav或tab里遵循<ATRouteHostController>协议,并且实现createInstanceWithParameters工厂方法,示例如下:
>
>   <pre>
>   #import "ATViewController.h"
>   #import <ATRouter/ATRouter.h>
>   @interface ATViewController () <ATRouteHostController>
>   
>   @end
>   
>   @implementation ATViewController
>   // MARK: - <ATRouteHostController>
>   - (BOOL)routeURL:URL withParameters:(NSDictionary *)parameters {
>       return NO;
>   }
>   
>   - (UINavigationController *)activeNavigationController {
>       return (UINavigationController *)self.navigationController;
>   }
>   
>   @end
>   </pre>

## Author

ABCReading, 2397172648@qq.com

## License

ATRouter is available under the MIT license. See the LICENSE file for more info.
