//
//  NSMutableDictionary+KeychainKit.m
//  KeychainKitSample
//
//  Created by david on 11/01/15.
//

#import "NSMutableDictionary+KeychainKit.h"

@implementation NSMutableDictionary (KeychainKit)

/*!
 *  Checks if anObject and aKey are not nil.
 *  If they aren't, setObject:forKey: is called.
 *
 *  @param anObject an object which can be nil.
 *  @param aKey     a key which can be nil.
 */
- (void)setObjectSafely:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject && aKey) {
        [self setObject:anObject forKey:aKey];
    }
}

@end
