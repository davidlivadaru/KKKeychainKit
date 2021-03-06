//
//  KKKeychainGenericPasswordBuilder.m
//  KeychainKitSample
//
//  Created by david on 11/02/15.
//

#import "KKKeychainGenericPasswordBuilder.h"
#import "KKKeychainItemBuilder+KeychainKitInterface.h"
#import "KKKeychainItemBuilder+SubclassesInterface.h"
#import "KKKeychainGenericPassword.h"

@implementation KKKeychainGenericPasswordBuilder

#pragma mark - Building

- (id)buildKeychainItem {
    return [[KKKeychainGenericPassword alloc] initWithData:self.data label:self.label
                                               accessGroup:self.accessGroup
                                              creationDate:self.creationDate
                                          modificationDate:self.modificationDate
                                           itemDescription:self.itemDescription comment:self.comment
                                                   creator:self.creator
                                                      type:self.type isInvisible:self.isInvisible
                                                isNegative:self.isNegative
                                                   account:self.account service:self.service
                                                   generic:self.generic
                                             accessibility:self.accessibility];
}

- (id)buildKeychainItemFromDictionary:(NSDictionary *)dictionary {
    [self setPropertiesFromDictionary:dictionary];
    return [self buildKeychainItem];
}

#pragma mark - KKKeychainItemBuilder Subclasses interface

- (void)setPropertiesFromDictionary:(NSDictionary *)dictionary {
    [super setPropertiesFromDictionary:dictionary];
    
    NSString *service = [dictionary objectForKey:(__bridge id)kSecAttrService];
    if (service) {
        self.service = service;
    }
    NSData *generic = [dictionary objectForKey:(__bridge id)kSecAttrGeneric];
    if (generic) {
        self.generic = generic;
    }
}

@end
