//
//  RMCoreDataConfiguration.m
//  Pods
//
//  Created by Rob MacEachern on 2014-06-14.
//
//

#import "RMCoreDataConfiguration.h"
#import "RMCoreDataMacros.h"

@implementation RMCoreDataConfiguration

- (NSURL *)modelURL {
    if (!_modelURL) {
        _modelURL = [[[NSBundle mainBundle] URLsForResourcesWithExtension:@"momd" subdirectory:nil] lastObject];
    }
    return _modelURL;
}

- (NSURL *)persistentStoreURL {
    if (!_persistentStoreURL) {
        NSURL *storeURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        storeURL = [storeURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.pstore", self.modelName]];
        _persistentStoreURL = storeURL;
    }
    return _persistentStoreURL;
}

- (id)mergePolicy {
    if (!_mergePolicy) {
        _mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    }
    return _mergePolicy;
}

- (NSString *)persistentStoreType {
    if (!_persistentStoreType) {
        _persistentStoreType = NSSQLiteStoreType;
    }
    return _persistentStoreType;
}

- (NSMutableDictionary *)persistentStoreOptions {
    if (!_persistentStoreOptions) {
        _persistentStoreOptions = [[NSMutableDictionary alloc] init];
        if (self.iCloudEnabled) {
            _persistentStoreOptions[NSPersistentStoreUbiquitousContentNameKey] = @"UbiquitousContentName";
        }
    }
    return _persistentStoreOptions;
}

@end
