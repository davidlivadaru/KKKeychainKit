//
//  KKSKeychainHandler.h
//  KeychainKitSample
//
//  Created by david on 17/12/14.
//  Copyright (c) 2014 David Live Org. All rights reserved.
//

@import KeychainKit;
#import <Foundation/Foundation.h>
#import "KKKeychainSampleItemDataVisualizer.h"
#import "KKSDataModel.h"

@class KKSKeychainHandler;

@protocol KKSKeychainHandlerDataSource <KKKeychainSampleItemDataVisualizer>

- (NSString *)keychainItemLabel;
- (NSString *)keychainItemServiceName;

@end

@interface KKSKeychainHandler : NSObject

// Life Cycle
- (instancetype)initWithDataModel:(KKSDataModel *)dataModel
                   dataSource:(id<KKSKeychainHandlerDataSource>)dataSource;

// Operations
- (void)performKeychainOperation;

@end
