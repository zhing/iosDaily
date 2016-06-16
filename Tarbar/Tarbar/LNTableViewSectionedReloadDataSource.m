//
//  LNTableViewSectionedReloadDataSource.m
//  Chitu
//
//  Created by Bing Liu on 3/18/16.
//  Copyright © 2016 linkedin. All rights reserved.
//

#import "LNTableViewSectionedReloadDataSource.h"

typedef void(^LNTableViewSectionUpdateNotificaion)();
typedef void(^ObserverBindingHandler)(LNTableViewSectionedReloadDataSource *dataSource, id<LNCollectionType> sections);

@interface LNTableViewSection ()

@property (nonatomic, copy) LNTableViewSectionUpdateNotificaion updateNotification;

@end

@interface Observer ()

+ (instancetype)observerWithDataSource:(LNTableViewSectionedReloadDataSource *)dataSource binding:(ObserverBindingHandler)binding;

@property (nonatomic, strong) LNTableViewSectionedReloadDataSource *dataSource;
@property (nonatomic, copy) ObserverBindingHandler binding;

@end

@interface Observable ()

@property (nonatomic, strong) NSMutableArray *observers;

- (void)subscribeProxyDataSourceForTableView:(UITableView *)tableView dataSource:(LNTableViewSectionedReloadDataSource *)dataSource binding:(void(^)(LNTableViewSectionedReloadDataSource *dataSource))binding;

@end

@interface LNTableViewSectionedReloadDataSource () <UITableViewDataSource>

@property (nonatomic, weak) id<LNCollectionType> sectionModels;

@end

@implementation LNTableViewSection

+ (instancetype)sectionWithItems:(id<LNCollectionType>)items {
    return [self sectionWithModel:nil items:items];
}

+ (instancetype)sectionWithModel:(id)model items:(id<LNCollectionType>)items {
    LNTableViewSection *section = [[LNTableViewSection alloc] init];
    section.model = model;
    section.items = items;
    return section;
}

- (void)setItems:(id<LNCollectionType>)items {
    _items = items;
    if (self.updateNotification) {
        self.updateNotification();
    }
}

@end

@implementation Observer

+ (instancetype)observerWithDataSource:(LNTableViewSectionedReloadDataSource *)dataSource binding:(ObserverBindingHandler)binding {
    Observer *observer = [[self alloc] init];
    observer.dataSource = dataSource;
    observer.binding = binding;
    return observer;
}

- (void)onNext:(id<LNCollectionType>)sections {
    if (self.binding) {
        self.binding(self.dataSource, sections);
    }
}

@end

@implementation Observable

+ (instancetype)just:(NSArray *)sections {
    Observable *instance = [[Observable alloc] init];
    instance.sections = sections;
    return instance;
}

- (void)setSections:(NSArray *)sections {
    _sections = sections;
    __weak Observable *weakSelf = self;
    for (NSInteger i = 0; i < sections.count; i++) {
        LNTableViewSection *section = sections[i];
        section.updateNotification = ^{
            for (Observer *obs in weakSelf.observers) {
                [obs onNext:sections];
            }
        };
    }
    for (Observer *obs in self.observers) {
        [obs onNext:sections];
    }
}

- (void)bindTo:(LNTableViewItemsWithDataSourceHandler)binder {
    if (!binder) {
        return;
    }
    binder(self);
}

- (void)reloadData {
    for (Observer *obs in self.observers) {
        [obs onNext:self.sections];
    }
}

- (NSMutableArray *)observers {
    if (!_observers) {
        _observers = [[NSMutableArray alloc] init];
    }
    return _observers;
}

- (void)subscribeProxyDataSourceForTableView:(UITableView *)tableView dataSource:(LNTableViewSectionedReloadDataSource *)dataSource binding:(void(^)(LNTableViewSectionedReloadDataSource *dataSource))binding {
    Observer *observer = [Observer observerWithDataSource:dataSource binding:^(LNTableViewSectionedReloadDataSource *dataSource, id<LNCollectionType> sections) {
        dataSource.sectionModels = sections;
        binding(dataSource);
    }];
    observer.binding(dataSource, self.sections);
    [self.observers addObject:observer];
}

@end


@implementation LNTableViewSectionedReloadDataSource

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.sectionModels.count && indexPath.row < ((LNTableViewSection *)self.sectionModels[indexPath.section]).items.count) {
        return ((LNTableViewSection *)self.sectionModels[indexPath.section]).items[indexPath.row];
    }
    return nil;
}

- (void)setTableView:(UITableView *)tableView {
    tableView.dataSource = self;
    [tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < self.sectionModels.count) {
        return ((LNTableViewSection *)self.sectionModels[section]).items.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.sectionModels.count && indexPath.row < ((LNTableViewSection *)self.sectionModels[indexPath.section]).items.count && self.cellFactory) {
        return self.cellFactory(tableView, indexPath, [self itemAtIndexPath:indexPath]);
    }
    return [[UITableViewCell alloc] init];
}

@end

@implementation UITableView (RX)

- (LNTableViewItemsWithDataSourceHandler)ln_itemsWithDataSource:(LNTableViewSectionedReloadDataSource *)dataSource {
    return ^(Observable *source) {
        __weak typeof(self) weakSelf = self;
        [source subscribeProxyDataSourceForTableView:self dataSource:dataSource binding:^(LNTableViewSectionedReloadDataSource *dataSource) {
            dataSource.tableView = weakSelf;
        }];
    };
}

@end

@implementation UITableViewCell (Model)

- (void)setModel:(id)model {
    
}

@end
