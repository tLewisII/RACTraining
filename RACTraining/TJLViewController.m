//
//  TJLViewController.m
//  RACTraining
//
//  Created by Terry Lewis II on 3/1/14.
//  Copyright (c) 2014 Blue Plover Productions LLC. All rights reserved.
//

#import "TJLViewController.h"

@interface TJLViewController ()
@property(weak, nonatomic) IBOutlet UITextField *textField;
@property(strong, nonatomic) NSString *pikachuString;
@end

@implementation TJLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textField.rac_textSignal subscribeNext:^(NSString *text) {
        NSLog(@"%@", text);
    }];

    RAC(self, pikachuString) = self.textField.rac_textSignal;

    [RACObserve(self, pikachuString) subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}


@end
