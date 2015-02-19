//
//  KKKeychainSampleImageModelDataConverter.m
//  KeychainKitSample
//
//  Created by david on 19/02/15.
//  Copyright (c) 2015 David Live Org. All rights reserved.
//

#import "KKKeychainSampleImageModelDataConverter.h"
@import UIKit;

@implementation KKKeychainSampleImageModelDataConverter

#pragma mark - KKKeychainSample Model Data Converter Override

- (NSData *)dataFromModel:(id)model {
    UIImage *imageModel = model;
    return UIImagePNGRepresentation(imageModel);
}

- (id)modelFromData:(NSData *)data {
    return [UIImage imageWithData:data];
}

@end
