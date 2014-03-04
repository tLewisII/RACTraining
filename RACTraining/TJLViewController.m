//
//  TJLViewController.m
//  RACTraining
//
//  Created by Terry Lewis II on 3/1/14.
//  Copyright (c) 2014 Blue Plover Productions LLC. All rights reserved.
//

#define GreenStar [UIImage imageNamed:@"GreenStar"]
#define RedStar [UIImage imageNamed:@"RedStar"]

#define pictureURL [NSURL URLWithString:@"https://farm9.staticflickr.com/8109/8631724728_48c13f7733_b.jpg"]
#import "TJLViewController.h"

@interface TJLViewController () <UITextFieldDelegate>
@property(weak, nonatomic) IBOutlet UITextField *nameField;
@property(weak, nonatomic) IBOutlet UITextField *emailField;
@property(weak, nonatomic) IBOutlet UITextField *passwordField;
@property(weak, nonatomic) IBOutlet UIImageView *nameIndicator;
@property(weak, nonatomic) IBOutlet UIImageView *emailIndicator;
@property(weak, nonatomic) IBOutlet UIImageView *passwordIndicator;
@property(weak, nonatomic) IBOutlet UIButton *createAccountButton;
@property(strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property(weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation TJLViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    ///We want to constantly monitor the correctness of the text fields so that we can update the indicators in real time. These are arbitrary values used for correctness, you could use whatever you desired.
    RACSignal *nameSignal = [self.nameField.rac_textSignal map:^id(NSString *value) {
        return @(value.length > 4);
    }];
    RACSignal *emailSignal = [self.emailField.rac_textSignal map:^id(NSString *value) {
        return @(value.length > 6 && [value rangeOfString:@"@"].location != NSNotFound);
    }];
    RACSignal *passwordSignal = [self.passwordField.rac_textSignal map:^id(NSString *value) {
        return @(value.length > 6);
    }];
    ///We want to indicate to the user exactly when each field goes from incorrect to correct, or vice-versa;
    id (^block)(NSNumber *) = ^id(NSNumber *value) {
        return value.boolValue ? GreenStar : RedStar;
    };

    RAC(self.nameIndicator, image) = [nameSignal map:block];
    RAC(self.emailIndicator, image) = [emailSignal map:block];
    RAC(self.passwordIndicator, image) = [passwordSignal map:block];


    ///Only enable the create account button when each field is filled out correctly.
    RACSignal *correctnessSignal = [RACSignal combineLatest:@[nameSignal, emailSignal, passwordSignal]
                                                     reduce:^(NSNumber *name, NSNumber *email, NSNumber *password) {
                                                         return @((name.boolValue && email.boolValue && password.boolValue));
                                                     }];
    ///A RACCommand is used for buttons in place of adding target actions. In this case, we only want the command to be able to execute if the correctnessSignal returns true.
    ///Here we return a signal block that executes a network request on a background thread. We send an error if there is an error, or the image and `complete` if it is successful.
    RACCommand *command = [[RACCommand alloc] initWithEnabled:correctnessSignal signalBlock:^RACSignal *(id input) {
        return [RACSignal startLazilyWithScheduler:[RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground] block:^(id <RACSubscriber> subscriber) {
            NSError *error;
            NSData *data = [NSData dataWithContentsOfURL:pictureURL
                                                 options:NSDataReadingMappedAlways
                                                   error:&error];
            if(error) {
                [subscriber sendError:error];
            }
            else {
                [subscriber sendNext:[UIImage imageWithData:data]];
                [subscriber sendCompleted];
            }
        }];
    }];

    ///Here we handle any errors that the command sends.
    [command.errors subscribeNext:^(NSError *x) {
        NSLog(@"%@", x);
    }];
    ///We set the command to be executed whenever the button is pressed.
    self.createAccountButton.rac_command = command;



    /// We want to dismiss the keyboard whenever the button is tapped, but we don't want to do that inside the command
    /// so we could probably use the `racSignalForControlEvents:` method that is available on UIControl to do that.
    /// Start here



   /// We want to bind the results from the contents retrieved from the URL to the imageView
   /// and we need to make sure those results are delivered on the main thread.


    self.activityIndicatorView = [[UIActivityIndicatorView alloc] init];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicatorView];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = 20; //make the activity spinner offset from the edge of the nav bar
    self.activityIndicatorView.color = [UIColor blackColor];
    self.navigationItem.rightBarButtonItems = @[space, item];

    /// The activity indicator should spin while the buttons command is executing, and stop when it is finished.
    /// There are some methods on RACCommand that can help with this.


}

@end
