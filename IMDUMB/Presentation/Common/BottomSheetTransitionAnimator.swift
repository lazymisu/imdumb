//
//  BottomSheetTransitionAnimator.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import UIKit

final class BottomSheetTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    private let isPresenting: Bool

    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
    }

    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        0.35
    }

    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)

        if isPresenting {
            animatePresentation(using: transitionContext, duration: duration)
        } else {
            animateDismiss(using: transitionContext, duration: duration)
        }
    }

    private func animatePresentation(
        using transitionContext: UIViewControllerContextTransitioning,
        duration: TimeInterval
    ) {
        guard let toVC = transitionContext.viewController(forKey: .to) as? RecommendViewController,
              let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }

        let containerView = transitionContext.containerView
        toView.frame = containerView.bounds
        containerView.addSubview(toView)

        toVC.viewDimmed.alpha = 0
        toVC.viewContainer.transform = CGAffineTransform(
            translationX: 0,
            y: containerView.bounds.height
        )

        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                toVC.viewDimmed.alpha = 1
                toVC.viewContainer.transform = .identity
            },
            completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }

    private func animateDismiss(
        using transitionContext: UIViewControllerContextTransitioning,
        duration: TimeInterval
    ) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from) as? RecommendViewController
        else {
            transitionContext.completeTransition(false)
            return
        }

        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                fromVC.viewDimmed.alpha = 0
                fromVC.viewContainer.transform = CGAffineTransform(
                    translationX: 0,
                    y: fromVC.viewContainer.frame.height
                )
            },
            completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}
