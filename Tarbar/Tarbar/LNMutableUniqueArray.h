//
//  LNMutableUniqueArray.h
//  Chitu
//
//  Created by Jinxing Liao on 10/23/15.
//  Copyright © 2015 linkedin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LNMutableUniqueArray : NSObject<NSFastEnumeration>

+ (instancetype)array;
+ (instancetype)arrayWithArray:(NSArray *)array;

- (instancetype)init;
- (instancetype)initWithArray:(NSArray *)array;

- (id)objectAtIndex:(NSUInteger)index;
- (id)lastObject;
- (id)firstObject;

- (void)addObject:(id)anObject;
- (void)addObjectsFromArray:(NSArray *)array;
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;

- (void)removeObject:(id)anObject;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)removeAllObjects;

@property (nonatomic, readonly) NSUInteger count;
- (NSUInteger)indexOfObject:(id)anObject;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;
- (BOOL)containsObject:(id)obj;


- (NSMutableArray *)toNSArray;

@end
