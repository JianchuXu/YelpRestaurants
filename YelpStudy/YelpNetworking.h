//
//  YelpNetworking.h
//  YelpStudy
//
//  Created by JIANCHU XU on 6/30/17.
//  Copyright © 2017 JIANCHU XU. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "YelpDataModel.h"

@import CoreLocation;



typedef void (^RestaurantCompletionBlock)(NSArray <YelpDataModel *>* dataModelArray);

@interface YelpNetworking : NSObject

+ (YelpNetworking *)sharedInstance;

- (void)fetchRestaurantsBasedOnLocation:(CLLocation *)location term:(NSString *)term completionBlock:(RestaurantCompletionBlock)completionBlock;

@end

