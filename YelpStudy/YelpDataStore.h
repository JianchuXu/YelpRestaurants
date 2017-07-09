//
//  YelpDataStore.h
//  YelpStudy
//
//  Created by JIANCHU XU on 7/5/17.
//  Copyright © 2017 JIANCHU XU. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "YelpDataModel.h"
@import CoreLocation;
@interface YelpDataStore : NSObject
@property (nonatomic, copy) NSArray <YelpDataModel *> *dataModels;
@property (nonatomic) CLLocation *userLocation;

+ (YelpDataStore *)sharedInstance;
@end
