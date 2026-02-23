//
//  BottomSheetTransitioningDelegate.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import UIKit

final class BottomSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        BottomSheetTransitionAnimator(isPresenting: true)
    }

    func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        BottomSheetTransitionAnimator(isPresenting: false)
    }
}
