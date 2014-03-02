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

    /// Most signals do their work synchronously, and will deliver their results on the thread they started on
    RACSignal *mainThreadSignal = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        NSString *pikachu = @"pikachu";
        if(NSThread.isMainThread) {
            NSLog(@"%@ signal block executed on main thread", pikachu);
        }
        else {
            NSLog(@"%@ signal block not executed on main thread", pikachu);
        }
        [subscriber sendNext:pikachu];
        return nil;
    }];

    /// The signal did its work on the main thread, and delivers it work on the main thread.
    [mainThreadSignal subscribeNext:^(id x) {
        if(NSThread.isMainThread) {
            NSLog(@"%@ subscription block executed on main thread", x);
        }
        else {
            NSLog(@"%@ subscription block not executed on main thread", x);
        }
    }];

    /// This signal does its work on the main thread, but will deliver its results on a background thread
    RACSignal *backgroundThreadSignal = [[RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        NSString *squirtle = @"squirtle";
        if(NSThread.isMainThread) {
            NSLog(@"%@ signal block executed on main thread", squirtle);
        }
        else {
            NSLog(@"%@ signal block not executed on main thread", squirtle);
        }
        [subscriber sendNext:squirtle];
        return nil;
    }] deliverOn:[RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground]];

    [backgroundThreadSignal subscribeNext:^(id x) {
        if(NSThread.isMainThread) {
            NSLog(@"%@ subscription block executed on main thread", x);
        }
        else {
            NSLog(@"%@ subscription block not executed on main thread", x);
        }
    }];

    /// This signal will do its work on a background thread.
    RACSignal *lazySignal = [RACSignal startLazilyWithScheduler:[RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground] block:^(id <RACSubscriber> subscriber) {
        NSString *charizard = @"charizard";
        if(NSThread.isMainThread) {
            NSLog(@"%@ subscription block executed on main thread", charizard);
        }
        else {
            NSLog(@"%@ subscription block not executed on main thread", charizard);
        }

        [subscriber sendNext:charizard];
    }];

    /// All we have to do to receive results on the main thread is call `-deliverOn:` with the main thread scheduler.
    [[lazySignal deliverOn:RACScheduler.mainThreadScheduler] subscribeNext:^(id x) {
        if(NSThread.isMainThread) {
            NSLog(@"%@ subscription block executed on main thread", x);
        }
        else {
            NSLog(@"%@ subscription block not executed on main thread", x);
        }
    }];
}

@end
