//
//  BottomSheetPresentable.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import UIKit

protocol BottomSheetPresentable: UIViewController {
    var viewContainer: UIView! { get }
    var viewDimmed: UIView! { get }
}
