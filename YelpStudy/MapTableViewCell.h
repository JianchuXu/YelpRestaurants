//
//  MapTableViewCell.h
//  YelpStudy
//
//  Created by JIANCHU XU on 7/7/17.
//  Copyright © 2017 JIANCHU XU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YelpDataModel.h"

@interface MapTableViewCell : UITableViewCell

- (void)updateBasedOnDataModel:(YelpDataModel *)dataModel;

@end
