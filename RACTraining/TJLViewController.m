//
//  TJLViewController.m
//  RACTraining
//
//  Created by Terry Lewis II on 3/1/14.
//  Copyright (c) 2014 Blue Plover Productions LLC. All rights reserved.
//

#import "TJLViewController.h"

@interface TJLViewController () <UITableViewDataSource, UITableViewDelegate>
@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic) NSArray *dataArray;
@end

@implementation TJLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = @[@"Red", @"Green", @"Blue"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    @weakify(self)
    RACSignal *selectionSignal = [[self rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:)] map:^id(RACTuple *value) {
        @strongify(self)
        NSIndexPath *path = value.second;
        return self.dataArray[(NSUInteger)path.row];
    }];

    [self rac_liftSelector:@selector(performSegueWithIdentifier:sender:) withSignals:selectionSignal, [RACSignal return:nil], nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];

    cell.textLabel.text = self.dataArray[(NSUInteger)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *controller = segue.destinationViewController;
    controller.title = segue.identifier;
}

@end
