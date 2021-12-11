//
//  SignUpViewController.swift
//  TreeTracker
//
//  Created by Alex Cornforth on 15/05/2020.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, KeyboardDismissing, AlertPresenting {

    @IBOutlet private var usernameLabel: UILabel! {
        didSet {
            usernameLabel.font = FontFamily.Lato.regular.font(size: 45.0)
            usernameLabel.textColor = .white
            usernameLabel.textAlignment = .left
            usernameLabel.text = viewModel?.usernameText
        }
    }
    @IBOutlet private var firstNameTextField: SignInTextField! {
        didSet {
            firstNameTextField.delegate = self
            firstNameTextField.keyboardType = .default
            firstNameTextField.returnKeyType = .next
            firstNameTextField.autocapitalizationType = .words
            firstNameTextField.textColor = .white
            firstNameTextField.validationState = .normal
            firstNameTextField.attributedPlaceholder = NSAttributedString( string:  L10n.SignUp.TextInput.FirstName.placeholder,attributes: [NSAttributedString.Key.foregroundColor: Asset.Colors.grayLight.color])
            firstNameTextField.backgroundColor = .black
            firstNameTextField.layer.borderColor = UIColor.lightGray.cgColor
            firstNameTextField.layer.cornerRadius = 10.0
            firstNameTextField.layer.borderWidth = 1.0
            firstNameTextField.clipsToBounds = true
        }
    }
    @IBOutlet private var lastNameTextField: SignInTextField! {
        didSet {
            lastNameTextField.delegate = self
            lastNameTextField.keyboardType = .default
            lastNameTextField.returnKeyType = .next
            lastNameTextField.autocapitalizationType = .words
            lastNameTextField.textColor = .white
            lastNameTextField.validationState = .normal
            lastNameTextField.attributedPlaceholder = NSAttributedString( string:L10n.SignUp.TextInput.LastName.placeholder,attributes: [NSAttributedString.Key.foregroundColor: Asset.Colors.grayLight.color])
            lastNameTextField.backgroundColor = .black
            lastNameTextField.layer.borderColor = UIColor.lightGray.cgColor
            lastNameTextField.layer.cornerRadius = 10.0
            lastNameTextField.layer.borderWidth = 1.0
            lastNameTextField.clipsToBounds = true
        }
    }
    @IBOutlet private var organizationTextField: SignInTextField! {
        didSet {
            organizationTextField.delegate = self
            organizationTextField.keyboardType = .default
            organizationTextField.returnKeyType = .done
            organizationTextField.autocapitalizationType = .words
            firstNameTextField.textColor = .white
            organizationTextField.validationState = .normal
            organizationTextField.attributedPlaceholder = NSAttributedString( string:L10n.SignUp.TextInput.Organization.placeholder,attributes: [NSAttributedString.Key.foregroundColor: Asset.Colors.grayLight.color])
            organizationTextField.backgroundColor = .black
            organizationTextField.layer.borderColor = UIColor.lightGray.cgColor
            organizationTextField.layer.cornerRadius = 10.0
            organizationTextField.layer.borderWidth = 1.0
            organizationTextField.clipsToBounds = true
        }
    }
    @IBOutlet private var signUpButton: UIButton! {
        didSet {
            signUpButton.setTitle(L10n.SignUp.SignUpButton.title, for: .normal)
            signUpButton.backgroundColor =  Asset.Colors.secondaryGreen.color
            signUpButton.isEnabled = false
        }
    }

    var viewModel: SignUpViewModel? {
        didSet {
            viewModel?.viewDelegate = self
            title = viewModel?.title
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addEndEditingBackgroundTapGesture()
        addKeyboardObservers()
        self.view.backgroundColor = .black
    }
}

// MARK: - Button Actions
private extension SignUpViewController {

    @IBAction func signUpButtonPressed() {
        viewModel?.signUp()
    }
}
// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        switch textField {
        case firstNameTextField:
            lastNameTextField.becomeFirstResponder()
        case lastNameTextField:
            organizationTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return false
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let text = textField.text as NSString? else {
            return true
        }

        let newText = text.replacingCharacters(in: range, with: string)

        switch textField {
        case firstNameTextField:
            viewModel?.firstName = newText
        case lastNameTextField:
            viewModel?.lastName = newText
        case organizationTextField:
            viewModel?.organizationName = newText
        default:
            break
        }

        return true
    }
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: SignUpViewModelViewDelegate {

    func signUpViewModel(_ signUpViewModel: SignUpViewModel, didReceiveError error: Error) {
        present(alert: .error(error))
    }

    func signUpViewModel(_ signUpViewModel: SignUpViewModel, didValidateFirstName result: SignUpViewModel.ValidationResult) {
        firstNameTextField.validationState = result.textFieldValidationState
    }

    func signUpViewModel(_ signUpViewModel: SignUpViewModel, didValidateLastName result: SignUpViewModel.ValidationResult) {
        lastNameTextField.validationState = result.textFieldValidationState
    }

    func signUpViewModel(_ signUpViewModel: SignUpViewModel, didValidateOrganizationName result: SignUpViewModel.ValidationResult) {
        organizationTextField.validationState = result.textFieldValidationState
    }

    func signUpViewModel(_ signUpViewModel: SignUpViewModel, didUpdateSignUpEnabled enabled: Bool) {
        signUpButton.isEnabled = enabled
    }
}

// MARK: - KeyboardObserving
extension SignUpViewController: KeyboardObserving {

    func keyboardWillShow(notification: Notification) {

    }

    func keyboardWillHide(notification: Notification) {

    }
}

// MARK: - SignUpViewModel.ValidationResult extension
extension SignUpViewModel.ValidationResult {

    var textFieldValidationState: SignInTextField.ValidationState {
        switch self {
        case .valid:
            return .valid
        case .invalid:
            return .invalid
        case .empty:
            return .normal
        }
    }
}
