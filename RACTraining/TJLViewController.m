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

    /// Most signals are cold by default, that is, they do not do any work until they are subscribed to.
    RACSignal *coldSignal = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        [subscriber sendNext:@"pikachu"];
        [subscriber sendCompleted];

        return nil;
    }];

    /// Since this signal was subscribed to, it will execute its block and send @"pikachu" as a next event.
    [coldSignal subscribeNext:^(NSString *value) {
        NSLog(@"%@", value);
    }];

    /// This signal will never perform any work since it is a cold signal that is never subscribed to.
    RACSignal *anotherColdSignal __unused = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        [subscriber sendNext:@"I am cold"];
        [subscriber sendCompleted];
        NSLog(@"this is a cold signal");
        return nil;
    }];

    /// This signal is a hot signal, which means that it will immediatly execute the given block even without any subscribers.
    RACSignal *hotSignal __unused = [RACSignal startEagerlyWithScheduler:[RACScheduler mainThreadScheduler] block:^(id <RACSubscriber> subscriber) {
        NSLog(@"squirtle");
    }];
}


@end
