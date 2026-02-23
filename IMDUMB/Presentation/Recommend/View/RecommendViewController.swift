//
//  RecommendViewController.swift
//  IMDUMB
//
//  Created by felix on 23/02/26.
//

import UIKit
import Combine

final class RecommendViewController: UIViewController {
    @IBOutlet private weak var lblOverview: UILabel!
    @IBOutlet private weak var txvComment: UITextView!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewDimmed: UIView!
    
    // MARK: - Properties
    
    var movieDetail: MovieDetail!
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureData()
        setupKeyboardDismiss()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        viewContainer.layer.cornerRadius = 20
        viewContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        viewContainer.clipsToBounds = true
        
        txvComment.layer.cornerRadius = 8
        txvComment.layer.masksToBounds = true
        txvComment.layer.borderWidth = 1
        txvComment.layer.borderColor = UIColor.lightGray.cgColor
        
        scrollView.publisher(for: \.contentSize)
            .removeDuplicates()
            .sink { [weak self] contentSize in
                self?.heightConstraint.constant = contentSize.height
            }
            .store(in: &cancellables)
    }

    private func configureData() {
        guard let detail = movieDetail else { return }
        
        if let htmlAttributed = detail.overviewHTML {
            lblOverview.attributedText = htmlAttributed
        } else {
            lblOverview.text = detail.overview
        }
    }
    
    private func setupKeyboardDismiss() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    // MARK: - Actions
    
    @IBAction private func didTapConfirm(_ sender: UIButton) {
        let viewController = self.presentingViewController
        
        dismiss(animated: true) { [weak self] in
            self?.showSuccessAlert(on: viewController)
        }
    }
    
    @IBAction private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction private func didTapDimmed(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard
            let keyboardFrame = notification.userInfo?[
                UIResponder.keyboardFrameEndUserInfoKey
            ] as? CGRect,
            let duration = notification.userInfo?[
                UIResponder.keyboardAnimationDurationUserInfoKey
            ] as? TimeInterval
        else {
            return
        }

        let inset = keyboardFrame.height - (view.safeAreaInsets.bottom)
        
        UIView.animate(withDuration: duration) {
            self.bottomConstraint.constant = inset
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard
            let duration = notification.userInfo?[
                UIResponder.keyboardAnimationDurationUserInfoKey
            ] as? TimeInterval
        else {
            return
        }
        
        UIView.animate(withDuration: duration) {
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Alerts
    
    private func showSuccessAlert(on viewController: UIViewController?) {
        guard let viewController else { return }
        
        let alert = UIAlertController(
            title: "¡Listo!",
            message: "Tu recomendación fue enviada con éxito.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
        viewController.present(alert, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UITextViewDelegate

extension RecommendViewController: UITextViewDelegate {
    
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= 500
    }
}
