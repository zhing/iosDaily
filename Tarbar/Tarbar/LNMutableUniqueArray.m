//
//  LNMutableUniqueArray.m
//  Chitu
//
//  Created by Jinxing Liao on 10/23/15.
//  Copyright © 2015 linkedin. All rights reserved.
//

#import "LNMutableUniqueArray.h"
#import "LNUniqueInArrayProtocol.h"

@interface LNMutableUniqueArray ()

@property (nonatomic, strong) NSMutableSet *idSet;
@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation LNMutableUniqueArray

- (instancetype)init
{
    self = [super init];
    self.idSet = [NSMutableSet set];
    self.array = [NSMutableArray array];
    return self;
}

- (instancetype)initWithArray:(NSArray *)array
{
    self = [self init];
    [self addObjectsFromArray:array];
    return self;
}

+ (instancetype)array
{
    LNMutableUniqueArray *uniqueArray = [[LNMutableUniqueArray alloc] init];
    return uniqueArray;
}

+ (instancetype)arrayWithArray:(NSArray *)array
{
    LNMutableUniqueArray *uniqueArray = [[LNMutableUniqueArray alloc] initWithArray:array];
    return uniqueArray;
}

- (id)uniqueIdentityForObject:(id)anObject {
    if ([anObject conformsToProtocol:@protocol(LNUniqueInArrayProtocol)]) {
        return [anObject uniqueIdentifier];
    }
    return nil;
}

- (void)addObject:(id)anObject
{
    id identity = [self uniqueIdentityForObject:anObject];
    if (identity) {
        if ([self.idSet containsObject:identity]) {
            return;
        } else {
            [self.idSet addObject:identity];
        }
    }
    [self.array addObject:anObject];
}

- (void)addObjectsFromArray:(NSArray *)array
{
    for (id anObject in array) {
        [self addObject:anObject];
    }
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index
{
    id identity = [self uniqueIdentityForObject:anObject];
    if (identity) {
        if ([self.idSet containsObject:identity]) {
            return;
        } else {
            [self.idSet addObject:identity];
        }
    }
    [self.array insertObject:anObject atIndex:index];
}

- (void)removeObject:(id)anObject
{
    if ([self.array containsObject:anObject]) {
        id identity = [self uniqueIdentityForObject:anObject];
        if (identity) {
            [self.idSet removeObject:identity];
        }
        [self.array removeObject:anObject];
    }
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    id obj = [self.array objectAtIndex:index];
    if (obj) {
        [self removeObject:obj];
    }
}

- (void)removeAllObjects
{
    [self.idSet removeAllObjects];
    [self.array removeAllObjects];
}

- (NSUInteger)count
{
    return self.array.count;
}

- (id)objectAtIndex:(NSUInteger)index
{
    return [self.array objectAtIndex:index];
}

- (id)firstObject
{
    return [self.array firstObject];
}

- (id)lastObject
{
    return [self.array lastObject];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len
{
    return [self.array countByEnumeratingWithState:state objects:buffer count:len];
}

- (NSUInteger)indexOfObject:(id)anObject
{
    return [self.array indexOfObject:anObject];
}

- (id)mutableCopy
{
    LNMutableUniqueArray *array = [LNMutableUniqueArray arrayWithArray:self.array];
    return array;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return [self objectAtIndex:idx];
}

- (BOOL)containsObject:(id)obj
{
    return [self.array containsObject:obj];
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx
{
    [self removeObjectAtIndex:idx];
    [self insertObject:obj atIndex:idx];
}

- (NSMutableArray *)toNSArray
{
    return self.array;
}

@end
