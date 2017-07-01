//
//  YelpNetworking.m
//  YelpStudy
//
//  Created by JIANCHU XU on 6/30/17.
//  Copyright © 2017 JIANCHU XU. All rights reserved.
//

#import "YelpNetworking.h"

static NSString const * kGrantType = @"client_credentials";
static NSString const * kClient_id = @"_3UAE0CZm627VvDEhtfZTQ";
static NSString const * kClient_secret = @"YKf9WP2XT3Qv6Xue8YsxWenUL6RzZrOppvLJqF0CoMuZ34eJqI9cdnfXDaeYNyxy";
static NSString const * kTokenEndPoint = @"https://api.yelp.com/oauth2/token";

typedef void (^TokenPendingTask)(NSString *token);

@interface YelpNetworking ()

@property (nonatomic, copy) NSString *token;

@end

@implementation YelpNetworking

+ (YelpNetworking *)sharedInstance {
    static YelpNetworking *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[YelpNetworking alloc] init];
    });
    return _sharedInstance;
}


- (void)fetchTokenWithTokenPendingTask:(TokenPendingTask)tokenPendingTask
{
    NSURL *url = [NSURL URLWithString:kTokenEndPoint];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *postString = [NSString stringWithFormat:@"grant_type=%@&client_id=%@&client_secret=%@", kGrantType, kClient_id,kClient_secret];
    
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *postDataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSError *jsonError;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        self.token = dict[@"access_token"];
        if (tokenPendingTask) {
            tokenPendingTask(self.token);
            
        }
    }];
    
    [postDataTask resume];
}

- (void)fetchRestaurantsBasedOnLocation:(CLLocation *)location term:(NSString *)term completionBlock:(RestaurantCompletionBlock)completionBlock
{
        TokenPendingTask tokenTask = ^(NSString *token){
        NSString *string = [NSString stringWithFormat:@"https://api.yelp.com/v3/businesses/search?term=%@&latitude=%.6f&longitude=%.6f",term, location.coordinate.latitude, location.coordinate.longitude];
        
        NSURL *url = [NSURL URLWithString:string];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60.0];
        
        [request setHTTPMethod:@"GET"];
        
        NSString *headerToken = [NSString stringWithFormat:@"Bearer %@",self.token];
        
        [request addValue:headerToken forHTTPHeaderField:@"Authorization"];
        
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NULL error:nil];
            if (!error) {
               completionBlock([YelpDataModel buildDataModelArrayFromDictionaryArray:dict[@"businesses"]]);
            }
            
        }];
        
        [dataTask resume];
    };
    
    if (self.token) {
        tokenTask(self.token);
    } else {
        [self fetchTokenWithTokenPendingTask:tokenTask];
    }
}


@end
