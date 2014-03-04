//
//  TJLViewController.m
//  RACTraining
//
//  Created by Terry Lewis II on 3/1/14.
//  Copyright (c) 2014 Blue Plover Productions LLC. All rights reserved.
//

#define GreenStar [UIImage imageNamed:@"GreenStar"]
#define RedStar [UIImage imageNamed:@"RedStar"]

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
    
    /// First, make the indicator images show a green star if the field is correct, or a red star is incorrect.
    /// Use the GreenStar and RedStar macros provided.
    /// For ease, the nameField is correct if it contains over 4 characters,
    /// the emailField is correct if it is over 6 characters and contains the @ sign
    /// And the password field is correct if it contains over 6 characters.
    
    /// Start here...
    
    
    
    
    
    /// End here, giving the correct signal to each indicator
    
    ///RAC(self.nameIndicator, image) =
    ///RAC(self.emailIndicator, image) =
    ///RAC(self.passwordIndicator, image) =
}

@end
