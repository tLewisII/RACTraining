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


    /// Now we want to enable or disable the createAccountButton depending on the correctness of the text fields.
    /// So what we want is some way to combine all the latest values from the text field signals and reduce them
    /// to a BOOL that can be used to derive the enabled-ness of the button. If only there were a way to do that
    /// with a class method on RACSignal...
    /// Start here




    /// You will use a RACCommand for the button. We will simply make a call to a URL which is defined
    /// by the pictureURL macro. Use `+NSData dataWithContentsOfURL:options:error:` to get the contents of the URL
//    RACCommand *command = [[RACCommand alloc] initWithEnabled: signalBlock:^RACSignal *(id input) {
//       you should return a signal here.
//    }];



    /// End here
    /// self.createAccountButton.rac_command =

}

@end
