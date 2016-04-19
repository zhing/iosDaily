//
//  FMDB.h
//  Tarbar
//
//  Created by Qing Zhang on 4/19/16.
//  Copyright © 2016 zhing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fmdb : NSObject

- (void)openDb:(NSString *)dbname;
- (void)executeNonQuery:(NSString *)sql;
- (NSArray *)executeQuery:(NSString *)sql;

@end
