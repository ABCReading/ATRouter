//
//  ATUnifyUpdateInfoClass.m
//  ATRouter_Example
//
//  Created by lianglibao on 2018/12/27.
//  Copyright © 2018年 Spaino. All rights reserved.
//

#import "ATUnifyUpdateInfoClass.h"

static NSMutableArray *__updateInstanceArray;
@implementation ATUnifyUpdateInfoClass

+ (void)saveUpdateInstance:(NSObject *)instance {
    if (!__updateInstanceArray) {
        __updateInstanceArray = [NSMutableArray array];
    }

    if (instance &&
        [instance respondsToSelector:@selector(testUpdateMthod:)] &&
         ![__updateInstanceArray containsObject:instance]) {
        [__updateInstanceArray addObject:instance];
    }
}

+ (void)removeUpdateInstance:(NSObject *)instance {
    if (instance &&
        [__updateInstanceArray containsObject:instance]) {
        [__updateInstanceArray removeObject:instance];
    }
}

+ (void)updateInstanceMethod:(id)object {
    [__updateInstanceArray makeObjectsPerformSelector:@selector(testUpdateMthod:)
                                              withObject:object];
}

@end
