//
//  ViewController.m
//  YelpStudy
//
//  Created by JIANCHU XU on 6/30/17.
//  Copyright © 2017 JIANCHU XU. All rights reserved.
//

#import "ViewController.h"
#import "YelpNetworking.h"


@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@property (nonatomic, copy) NSArray <YelpDataModel *> *dataModels;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:37.331566 longitude:-122.032744];
    [[YelpNetworking sharedInstance] fetchRestaurantsBasedOnLocation:loc term:@"sushi" completionBlock:^(NSArray<YelpDataModel *> *dataModelArray) {
        self.dataModels = dataModelArray;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"defaultCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"defaultCell"];
    }
    cell.textLabel.text = self.dataModels[indexPath.row].name;
    cell.detailTextLabel.text = self.dataModels[indexPath.row].displayAddress;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataModels count];
}



@end
