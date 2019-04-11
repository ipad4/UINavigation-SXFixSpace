//
//  UINavigationItem+SXFixSpace.m
//  UINavigation-SXFixSpace
//
//  Created by charles on 2018/4/20.
//  Copyright © 2018年 None. All rights reserved.
//

#import "UINavigationItem+SXFixSpace.h"
#import "NSObject+SXRuntime.h"
#import "UINavigationConfig.h"

@implementation UINavigationItem (SXFixSpace)



+(void)load {
    if (@available(iOS 11.0, *)) {
        
    } else {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSArray <NSString *>*oriSels = @[
                                            @"setLeftBarButtonItem:",
                                            @"setLeftBarButtonItem:animated:",
                                            @"setLeftBarButtonItems:",
                                            @"setLeftBarButtonItems:animated:",
                                            @"setRightBarButtonItem:",
                                            @"setRightBarButtonItem:animated:",
                                            @"setRightBarButtonItems:",
                                            @"setRightBarButtonItems:animated:",
                                            @"initWithBarButtonSystemItem:target:action:"
                                            ];
            
            [oriSels enumerateObjectsUsingBlock:^(NSString * _Nonnull oriSel, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *swiSel = [NSString stringWithFormat:@"sx_%@", oriSel];
                [self swizzleInstanceMethodWithOriginSel:NSSelectorFromString(oriSel)
                                             swizzledSel:NSSelectorFromString(swiSel)];
            }];
            
        });
    }
}

-(void)sx_setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem {
    [self setLeftBarButtonItem:leftBarButtonItem animated:NO];
}

-(void)sx_setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem animated:(BOOL)animated {
    if (!sx_disableFixSpace && leftBarButtonItem) {//存在按钮且需要调节
        [self setLeftBarButtonItems:@[leftBarButtonItem] animated:animated];
    } else {//不存在按钮,或者不需要调节
        [self sx_setLeftBarButtonItem:leftBarButtonItem animated:animated];
    }
}


-(void)sx_setLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)leftBarButtonItems {
    [self setLeftBarButtonItems:leftBarButtonItems animated:NO];
}

-(void)sx_setLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)leftBarButtonItems animated:(BOOL)animated {
    if (leftBarButtonItems.count) {
        UIBarButtonItem *firstItem = leftBarButtonItems.firstObject;
        if (firstItem.tag == UIBarButtonSystemItemFixedSpace) {//已经存在space
            [self sx_setLeftBarButtonItems:leftBarButtonItems animated:animated];
        } else {
            NSMutableArray *items = [NSMutableArray arrayWithArray:leftBarButtonItems];
            [items insertObject:[self fixedSpaceWithWidth:sx_fixedSpaceWidth] atIndex:0];
            [self sx_setLeftBarButtonItems:items animated:animated];
        }
    } else {
        [self sx_setLeftBarButtonItems:leftBarButtonItems animated:animated];
    }
}

-(void)sx_setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem{
    [self setRightBarButtonItem:rightBarButtonItem animated:NO];
}

- (void)sx_setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem animated:(BOOL)animated {
    if (!sx_disableFixSpace && rightBarButtonItem) {//存在按钮且需要调节
        [self setRightBarButtonItems:@[rightBarButtonItem] animated:animated];
    } else {//不存在按钮,或者不需要调节
        [self sx_setRightBarButtonItem:rightBarButtonItem animated:animated];
    }
}

-(void)sx_setRightBarButtonItems:(NSArray<UIBarButtonItem *> *)rightBarButtonItems{
    [self setRightBarButtonItems:rightBarButtonItems animated:NO];
}

- (void)sx_setRightBarButtonItems:(NSArray<UIBarButtonItem *> *)rightBarButtonItems animated:(BOOL)animated {
    if (rightBarButtonItems.count) {
        UIBarButtonItem *firstItem = rightBarButtonItems.firstObject;
        if (firstItem.tag == UIBarButtonSystemItemFixedSpace) {//已经存在space
            [self sx_setRightBarButtonItems:rightBarButtonItems animated:animated];
        } else {
            NSMutableArray *items = [NSMutableArray arrayWithArray:rightBarButtonItems];
            [items insertObject:[self fixedSpaceWithWidth:sx_fixedSpaceWidth] atIndex:0];
            [self sx_setRightBarButtonItems:items animated:animated];
        }
    } else {
        [self sx_setRightBarButtonItems:rightBarButtonItems animated:animated];
    }
}

- (UIBarButtonItem *)sx_initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem target:(nullable id)target action:(nullable SEL)action {
    UIBarButtonItem *item = [self sx_initWithBarButtonSystemItem:systemItem target:target action:action];
    if (systemItem == UIBarButtonSystemItemFixedSpace) {
        item.tag = UIBarButtonSystemItemFixedSpace;
    }
    return item;
}

-(UIBarButtonItem *)fixedSpaceWithWidth:(CGFloat)width {
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:nil
                                                                               action:nil];
    fixedSpace.width = width;
    return fixedSpace;
}

@end
