//
//  NSNotificationCenter+LN.h
//  Chitu
//
//  Created by Bing Liu on 1/23/16.
//  Copyright © 2016 linkedin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  封装keyboard will show/change/hide notification，用于监测键盘高度变化，调整UI，解决遮挡问题。
 */
extern NSString * const LNKeyboardWillChangeNotification;

extern NSString * const LNKeyboardFrameEndUserKey;

@interface NSNotificationCenter (LN)

/**
 *  使用方法类似于 NSNotificationCenter 的 addObserverForName:object:queue:usingBlock:，增加了observer字段，notification block关联到此observer，作用类似于key，用于在ln_removeObserver:中查询并移除block。
 *
 * @param observer otification block关联到此observer，作用类似于key，用于在ln_removeObserver:中查询并移除block。
 */
- (void)ln_addObserver:(id)observer name:(NSString *)name object:(id)obj queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *notification))block;

/**
 *  通常在dealloc中调用，用来移除 ln_addObserver:name:object:queue:usingBlock: 方法关联到observer的notification block。
 *
 *  @param observer 用于查询关联到observer的notification block。
 */
- (void)ln_removeObserver:(id)observer;

@end
