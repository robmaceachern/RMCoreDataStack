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
        
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
        NSURL *storeURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        storeURL = [storeURL URLByAppendingPathComponent:@"PersistentStore.pstore"];
        _persistentStoreURL = storeURL;
#else
        NSError *error;
        NSURL* dir = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory
                                         inDomain:NSUserDomainMask
                                appropriateForURL:nil
                                           create:YES
                                            error:&error];
        
        ZAssert(!error, @"Error generating the persistent store URL: %@\n%@",
                [error localizedDescription], [error userInfo]);
        
        NSString *executableName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
        ZAssert([executableName length] > 0, @"No CFBundleExecutable in Info.plist");
        
        NSURL* storeDir = [dir URLByAppendingPathComponent:executableName];
        [[NSFileManager defaultManager] createDirectoryAtURL:storeDir
                                                withIntermediateDirectories:YES
                                                                 attributes:@{}
                                                                      error:&error];
        
        ZAssert(!error, @"Error creating application directory in application support: %@\n%@",
                [error localizedDescription], [error userInfo]);
        
        NSURL *storeURL = [storeDir URLByAppendingPathComponent:@"PersistentStore.pstore"];
        _persistentStoreURL = storeURL;
#endif
        
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
    }
    
    if (self.iCloudEnabled) {
        _persistentStoreOptions[NSPersistentStoreUbiquitousContentNameKey] = @"UbiquitousContentName";
    } else {
        [_persistentStoreOptions removeObjectForKey:NSPersistentStoreUbiquitousContentNameKey];
    }
    
    return _persistentStoreOptions;
}

@end
