//
//  BottomSheetTransitioningDelegate.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import UIKit

final class BottomSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        return DimmedPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
    }
}
