//
//  ATUnifyUpdateInfoClass.h
//  ATRouter_Example
//
//  Created by lianglibao on 2018/12/27.
//  Copyright © 2018年 Spaino. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ATUnifyUpdateInfoClassDelegate <NSObject>
@optional
- (void)testUpdateMthod:(id)object;

@end

@interface ATUnifyUpdateInfoClass : NSObject
+ (void)saveUpdateInstance:(nonnull NSObject *)instance;
+ (void)removeUpdateInstance:(nonnull NSObject *)instance;
+ (void)updateInstanceMethod:(id)object;
@end

NS_ASSUME_NONNULL_END
