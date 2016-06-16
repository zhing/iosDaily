//
//  LNCollectionType.m
//  Chitu
//
//  Created by Bing Liu on 3/21/16.
//  Copyright © 2016 linkedin. All rights reserved.
//

#import "LNCollectionType.h"

@interface NSObject (CollectionType) <LNCollectionType>

@end

@implementation NSObject (CollectionType)

- (NSUInteger)count {
    return 0;
}

- (id)objectAtIndex:(NSUInteger)index {
    return nil;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id  _Nonnull *)buffer count:(NSUInteger)len {
    return 0;
}

- (NSArray *)filter:(BOOL (^)(id))includeElement {
    NSMutableArray *filteredArray = [NSMutableArray arrayWithCapacity:self.count];
    for (id element in self) {
        if (includeElement && includeElement(element)) {
            [filteredArray addObject:element];
        }
    }
    return filteredArray;
}

- (NSArray *)map:(id (^)(id))transform {
    NSMutableArray *filteredArray = [NSMutableArray arrayWithCapacity:self.count];
    for (id element in self) {
        if (transform) {
            id newElement = transform(element);
            if (newElement) {
                [filteredArray addObject:newElement];
            }
        }
    }
    return filteredArray;
}

@end
