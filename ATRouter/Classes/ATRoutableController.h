//
//  ATRoutableController.h
//  Demo
//
//  Created by lianglibao on 1/3/17.
//  Copyright © 2017 lianglibao All rights reserved.
//

#ifndef ATRoutableController_h
#define ATRoutableController_h

@class UIViewController;
@protocol ATRoutableController <NSObject>
@required;
/// 默认创建实例的方法.
+ (UIViewController *)createInstanceWithParameters:(NSDictionary *)parameters;

@optional;
/// pop/dismiss回来时候反向传值操作更新.
- (void)updateCurrentPageWithParmeters:(NSDictionary *)parameters;
@end


#endif /* ATRoutableController_h */
