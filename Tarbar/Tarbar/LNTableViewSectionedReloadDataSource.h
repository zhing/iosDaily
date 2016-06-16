//
//  LNTableViewSectionedReloadDataSource.h
//  Chitu
//
//  Created by Bing Liu on 3/18/16.
//  Copyright © 2016 linkedin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNCollectionType.h"

@class  Observable;

typedef UITableViewCell *(^LNTableViewSectionReloadDataSourceCellFactory)(UITableView *tableView, NSIndexPath *indexPath, id item);
typedef void(^LNTableViewItemsWithDataSourceHandler)(Observable *source);

@protocol UITableViewCellModelProtocol <NSObject>

- (void)setModel:(id)model;

@end

@interface LNTableViewSection : NSObject

@property (nonatomic, strong) id model;
@property (nonatomic, strong) id<LNCollectionType> items;

+ (instancetype)sectionWithItems:(id<LNCollectionType>)items;
+ (instancetype)sectionWithModel:(id)model items:(id<LNCollectionType>)items;

@end

@interface Observer : NSObject

- (void)onNext:(id<LNCollectionType>)sections;

@end

@interface Observable : NSObject

+ (instancetype)just:(NSArray *)sections;

@property (nonatomic, strong) NSArray *sections;

- (void)bindTo:(LNTableViewItemsWithDataSourceHandler)binder;
- (void)reloadData;

@end

@interface LNTableViewSectionedReloadDataSource : NSObject

@property (nonatomic, copy) LNTableViewSectionReloadDataSourceCellFactory cellFactory;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface UITableView (RX)

- (LNTableViewItemsWithDataSourceHandler)ln_itemsWithDataSource:(LNTableViewSectionedReloadDataSource *)dataSource;

@end

@interface UITableViewCell (Model) <UITableViewCellModelProtocol>

@end
