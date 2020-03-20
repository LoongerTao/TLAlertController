//
//  TLAlertPresentationController.m
//  TLAlertController
//
//  Created by 故乡的云 on 2020/2/27.
//  Copyright © 2020 故乡的云. All rights reserved.
//

#import "TLAlertPresentationController.h"



@interface TLAlertPresentationController () <UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) UIView *dimmingView;

@end

@implementation TLAlertPresentationController 

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController
                       presentingViewController:(UIViewController *)presentingViewController
{
    self = [super initWithPresentedViewController:presentedViewController
                         presentingViewController:presentingViewController];
    if (self) {
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
        self.transitionDuration = .35f;
    }
    
    return self;
}


// MARK: - Life Cycle
- (void)presentationTransitionWillBegin {
    UIView *dimmingView = [[UIView alloc] initWithFrame:self.containerView.bounds];
    dimmingView.backgroundColor = [UIColor blackColor];
    dimmingView.opaque = NO;
    dimmingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [dimmingView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimmingViewTapped:)]];
    self.dimmingView = dimmingView;
    [self.containerView addSubview:dimmingView];
    
    // Get the transition coordinator for the presentation so we can
    // fade in the dimmingView alongside the presentation animation.
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    self.dimmingView.alpha = 0.f;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.alpha = 0.4f;
    } completion:NULL];
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    if (!completed) {
        self.dimmingView = nil;
    }
}

- (void)dismissalTransitionWillBegin {
    id <UIViewControllerTransitionCoordinator>transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.alpha = 0.f;
    } completion:NULL];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    if (completed == YES) {
        self.dimmingView = nil;
    }
}


// MARK: - Layout
- (void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container {
    [super preferredContentSizeDidChangeForChildContentContainer:container];
    
    if (container == self.presentedViewController)
        [self.containerView setNeedsLayout];
}

- (CGSize)sizeForChildContentContainer:(id<UIContentContainer>)container
               withParentContainerSize:(CGSize)parentSize
{
    if (container == self.presentedViewController)
        return ((UIViewController*)container).preferredContentSize;
    else
        return [super sizeForChildContentContainer:container withParentContainerSize:parentSize];
}

- (CGRect)frameOfPresentedViewInContainerView {
    CGRect containerViewBounds = self.containerView.bounds;
    CGSize size = [self sizeForChildContentContainer:self.presentedViewController
                             withParentContainerSize:containerViewBounds.size];
    CGRect frame = containerViewBounds;
    frame.size = size;
    CGFloat margin = (CGRectGetWidth(containerViewBounds) - size.width) * 0.5f;
    frame.origin.x = margin;
    if (_modalStyle == TLModalStyleAlert) {
        frame.origin.y = (CGRectGetMaxY(containerViewBounds) - size.height) * 0.5 + 10;
    }else {
        frame.origin.y = CGRectGetMaxY(containerViewBounds) - size.height - (Is_iPhoneX ? 34 : 8);
    }
    return frame;
}

- (void)containerViewWillLayoutSubviews {
    [super containerViewWillLayoutSubviews];
    
    self.dimmingView.frame = self.containerView.bounds;
    self.presentedView.frame = [self frameOfPresentedViewInContainerView];
}


// MARK: - Tap Gesture Recognizer
- (void)dimmingViewTapped:(UITapGestureRecognizer *)sender {
    if (self.didTapMaskView) {
        self.didTapMaskView();
    }
    if (!self.disableTapMaskToDismiss) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    }
}


// MARK: - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return [transitionContext isAnimated] ? self.transitionDuration : 0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    BOOL isPresenting = (fromViewController == self.presentingViewController);
    
    CGRect __unused fromViewInitialFrame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect fromViewFinalFrame = [transitionContext finalFrameForViewController:fromViewController];
    CGRect toViewInitialFrame = [transitionContext initialFrameForViewController:toViewController];
    CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toViewController];
    
    [containerView addSubview:toView];
    
    NSTimeInterval transitionDuration = isPresenting ? self.transitionDuration : 0.15f;
    if (_modalStyle == TLModalStyleAlert) {
        if (isPresenting) {
            toView.alpha = 0.0f;
            toView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } else {
            fromView.alpha = 1.f;
        }
        
        [UIView animateWithDuration:transitionDuration animations:^{
            if (isPresenting) {
                toView.alpha = 1.f;
                toView.transform = CGAffineTransformIdentity;
            }else {
                fromView.alpha = 0.0f;
            }
            
        } completion:^(BOOL finished) {
    
            BOOL wasCancelled = [transitionContext transitionWasCancelled];
            [transitionContext completeTransition:!wasCancelled];
        }];
        
    }else {
        if (isPresenting) {
            CGFloat x = [self frameOfPresentedViewInContainerView].origin.x;
            toViewInitialFrame.origin = CGPointMake(x, CGRectGetMaxY(containerView.bounds));
            toViewInitialFrame.size = toViewFinalFrame.size;
            toView.frame = toViewInitialFrame;
        } else {
            fromViewFinalFrame = CGRectOffset(fromView.frame, 0, CGRectGetHeight(fromView.frame));
        }
        
        [UIView animateWithDuration:transitionDuration animations:^{
            if (isPresenting)
                toView.frame = toViewFinalFrame;
            else
                fromView.frame = fromViewFinalFrame;
            
        } completion:^(BOOL finished) {
            
            BOOL wasCancelled = [transitionContext transitionWasCancelled];
            [transitionContext completeTransition:!wasCancelled];
        }];
    }
}

// MARK: - UIViewControllerTransitioningDelegate

- (UIPresentationController*)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                     presentingViewController:(UIViewController *)presenting
                                                         sourceViewController:(UIViewController *)source
{
    NSAssert(
             self.presentedViewController == presented,
             @"You didn't initialize %@ with the correct presentedViewController.  Expected %@, got %@.",
             self, presented, self.presentedViewController
             );
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return self;
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}


@end
