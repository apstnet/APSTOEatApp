/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  AAPLCoolPresentationController implementation.
  
 */

#import "AAPLCoolPresentationController.h"

@implementation AAPLCoolPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if(self)
    {
        // Create our dimming view
        _dimmingView = [[UIView alloc] init];
        [[self dimmingView] setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    
    }
    return self;
}

- (CGRect)frameOfPresentedViewInContainerView
{
    // Return a frame that's centered in the display, with a width of 300pt and a height which varies based on our vertical size class
    CGRect containerBounds = [[self containerView] bounds];
    
    CGRect presentedViewFrame = CGRectZero;
    CGFloat width = 320;
    CGFloat height = 392;
    
    presentedViewFrame.size = CGSizeMake(width, height);
    presentedViewFrame.origin = CGPointMake(containerBounds.size.width / 2.0, containerBounds.size.height / 2.0);
    presentedViewFrame.origin.x -= presentedViewFrame.size.width / 2.0;
    presentedViewFrame.origin.y -= presentedViewFrame.size.height / 2.0;
    
    return presentedViewFrame;
}

- (void)presentationTransitionWillBegin
{
    [super presentationTransitionWillBegin];
    
    // Add our chrome to the dimming view

    [self addViewsToDimmingView];

    // Before the presentation begins, we want to have our dimming view be totally transparent

    [[self dimmingView] setAlpha:0.0];
    
    [[[self presentedViewController] transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [[self dimmingView] setAlpha:1.0];
    } completion:nil];

}

- (void)containerViewWillLayoutSubviews
{
    [[self dimmingView] setFrame:[[self containerView] bounds]];
    [[self presentedView] setFrame:[self frameOfPresentedViewInContainerView]];
//    [self moveJaguarPrintToPresentedPosition:YES];
}

- (void)dismissalTransitionWillBegin
{
    [super dismissalTransitionWillBegin];

    // In -dismissalTransitionWillBegin, we want to undo what we did in
    // -presentationTransitionWillBegin. Fade our dimming view's alpha back to 0
    [[[self presentedViewController] transitionCoordinator] animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [[self dimmingView] setAlpha:0.0];
} completion:nil];
}

- (void)addViewsToDimmingView
{
    
    
    [[self containerView] addSubview:[self dimmingView]];
}

@end
