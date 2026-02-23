//
//  DimmedPresentationController.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import UIKit

final class DimmedPresentationController: UIPresentationController {
    
    private let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.alpha = 0
        return view
    }()
    
    private let cornerRadius: CGFloat = 20
    private let maxHeightRatio: CGFloat = 0.9
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView,
              let presentedView = presentedView else {
            return .zero
        }
        
        let targetWidth = containerView.bounds.width
        let fittingSize = CGSize(width: targetWidth, height: UIView.layoutFittingCompressedSize.height)
        
        var targetHeight = presentedView.systemLayoutSizeFitting(
            fittingSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height
        
        let maxHeight = containerView.bounds.height * maxHeightRatio
        targetHeight = min(targetHeight, maxHeight)
        
        return CGRect(
            x: 0,
            y: containerView.bounds.height - targetHeight,
            width: targetWidth,
            height: targetHeight
        )
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        
        dimmingView.frame = containerView.bounds
        containerView.insertSubview(dimmingView, at: 0)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped))
        dimmingView.addGestureRecognizer(tapGesture)
        
        presentedView?.layer.cornerRadius = cornerRadius
        presentedView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        presentedView?.clipsToBounds = true
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1
            return
        }
        
        coordinator.animate { _ in
            self.dimmingView.alpha = 1
        }
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0
            return
        }
        
        coordinator.animate { _ in
            self.dimmingView.alpha = 0
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        dimmingView.frame = containerView?.bounds ?? .zero
    }
    
    @objc private func dimmingViewTapped() {
        presentedViewController.dismiss(animated: true)
    }
}
