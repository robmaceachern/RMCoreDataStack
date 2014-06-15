//
//  RMCoreDataConfiguration.h
//  Pods
//
//  Created by Rob MacEachern on 2014-06-14.
//
//

#import <Foundation/Foundation.h>

@interface RMCoreDataConfiguration : NSObject

@property (nonatomic, strong) NSString *modelName;
@property (nonatomic, strong) NSURL *modelURL;
@property (nonatomic) BOOL iCloudEnabled;
@property (nonatomic, strong) id mergePolicy;
@property (nonatomic, strong) NSURL *persistentStoreURL;
@property (nonatomic, strong) NSString *persistentStoreType;
@property (nonatomic, strong) NSMutableDictionary *persistentStoreOptions;

@end
