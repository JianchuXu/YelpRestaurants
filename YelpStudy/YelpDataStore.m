//
//  YelpDataStore.m
//  YelpStudy
//
//  Created by JIANCHU XU on 7/5/17.
//  Copyright © 2017 JIANCHU XU. All rights reserved.
//
#import "YelpDataStore.h"
@implementation YelpDataStore

+ (YelpDataStore *)sharedInstance {
    static YelpDataStore *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[YelpDataStore alloc] init];
    });
    return _sharedInstance;
}
@end
