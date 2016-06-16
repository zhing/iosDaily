//
//  LNCollectionType.h
//  Chitu
//
//  Created by Bing Liu on 3/21/16.
//  Copyright © 2016 linkedin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNMutableUniqueArray.h"

@protocol LNCollectionType <NSObject, NSFastEnumeration>

@property (nonatomic, readonly) NSUInteger count;

- (id)objectAtIndex:(NSUInteger)index;

- (NSArray *)filter:(BOOL(^)(id element))includeElement;
- (NSArray *)map:(id(^)(id element))transform;

@end

@interface NSArray (CollectionType) <LNCollectionType>

@end

@interface NSOrderedSet (CollectionType) <LNCollectionType>

@end

@interface LNMutableUniqueArray (CollectionType) <LNCollectionType>

@end
