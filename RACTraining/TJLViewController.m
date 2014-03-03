//
//  TJLViewController.m
//  RACTraining
//
//  Created by Terry Lewis II on 3/1/14.
//  Copyright (c) 2014 Blue Plover Productions LLC. All rights reserved.
//

#import "TJLViewController.h"

@interface TJLViewController ()
@property(weak, nonatomic) IBOutlet UILabel *stateLabel;
@property(weak, nonatomic) IBOutlet UILabel *translationLabel;

@end

@implementation TJLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGPoint originalCenter = self.view.center;
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
    RACSignal *panGestureSignal = panGestureRecognizer.rac_gestureSignal;
    [self.view addGestureRecognizer:panGestureRecognizer];
    RACSignal *panGestureMapped = [panGestureSignal map:^id(UIPanGestureRecognizer *recognizer) {
        CGPoint translation = [recognizer translationInView:recognizer.view];
        CGFloat yBoundary = MIN(recognizer.view.center.y + translation.y, originalCenter.y);
        [recognizer setTranslation:CGPointZero inView:self.view];
        return [NSValue valueWithCGPoint:CGPointMake(recognizer.view.center.x, yBoundary)];
    }];
    RAC(self, view.center) = panGestureMapped;

    ///We want to keep track of the y value of the translation and display it in real time to the user,
    /// so we transform the value into a String and return that.
    RACSignal *panGestureString = [panGestureMapped map:^id(NSValue *value) {
        return [NSString stringWithFormat:@"Y Translation = %f", value.CGPointValue.y];
    }];

    ///We also want real time information about the state of the gesture,
    /// so we transform that into a String as well. You have to move very slowly if you want to see the label update when the Gesture begins.
    RACSignal *panGestureState = [panGestureSignal map:^id(UIPanGestureRecognizer *recognizer) {
        NSString *state;
        switch(recognizer.state) {
            case UIGestureRecognizerStateBegan:
                state = @"Gesture Began";
                break;
            case UIGestureRecognizerStateChanged:
                state = @"Gesture is Changed";
                break;
            case UIGestureRecognizerStateEnded:
                state = @"Gesture is Ended";
                break;
            default:
                break;
            case UIGestureRecognizerStatePossible:
                break;
            case UIGestureRecognizerStateCancelled:
                break;
            case UIGestureRecognizerStateFailed:
                break;
        }
        return state;
    }];

    ///We want a different color to represent the state of the gesture, so we use the states as keys.
    NSDictionary *colors = @{@(UIGestureRecognizerStateEnded)   : [UIColor blueColor],
                             @(UIGestureRecognizerStateChanged) : [UIColor purpleColor]};
    ///Here we filter the values, and only return a color from our dictionary when the state is one of the ones we care about.
    RACSignal *colorSignal = [[panGestureSignal filter:^BOOL(UIPanGestureRecognizer *recognizer) {
        return (recognizer.state == UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateEnded);
    }] map:^id(UIPanGestureRecognizer *recognizer) {
        return colors[@(recognizer.state)];
    }];
    ///We want the starting point displayed when the view loads.
    NSString *initialPoint = [NSString stringWithFormat:@"Y Translation = %f", originalCenter.y];
    ///+[RACSignal merge] takes an array of signals and returns a value each time one of the signals fires.
    /// Here the initialPoint immediately returns, thus the label is set when the view loads. Then afterwards, the panGestureSignal will be sending its values when it is activated.
    RAC(self.translationLabel, text) = [RACSignal merge:@[panGestureString, [RACSignal return:initialPoint]]];
    ///The label will always reflect the current state of the recognizer.
    RAC(self.stateLabel, text) = panGestureState;
    ///The color will be updated each time the signal returns a value.
    RAC(self.view, backgroundColor) = colorSignal;
}

@end
