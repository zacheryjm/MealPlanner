//
//  UserRegistrationViewController.swift
//  MealPlanner
//
//  Created by Zachery Miller on 3/15/19.
//  Copyright © 2019 Zachery Miller. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class UserRegistrationViewController: UIViewController {
    
    let stackViewPadding = UIEdgeInsets(top: 0, left: 48, bottom: 0, right: 48)
    
    let registrationViewModel = RegistrationViewModel()
    
    //MARK: UI Components
    let registeringHUD = JGProgressHUD()
    
    lazy var stackView = UIStackView(arrangedSubviews: [
        selectPhotoButton,
        fullNameTextField,
        emailTextField,
        passwordTextField,
        registerButton])
    
    let selectPhotoButton : UIButton = {
        let button = UIButton()
        
        button.setTitle("Profile Photo", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = .white
        
        button.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        
        button.addTarget(self, action: #selector(handleSelectPhotoButtonPress), for: .touchUpInside)
        
        return button
    }()
    
    let fullNameTextField : CustomTextField = {
        let textField = CustomTextField(placeholderText : "Enter Full Name")
        textField.backgroundColor = .white
        textField.addTarget(self, action: #selector(handleTextFieldChange), for: .editingChanged)
        
        return textField
    }()
    
    let emailTextField : CustomTextField = {
        let textField = CustomTextField(placeholderText : "Enter Email")
        textField.backgroundColor = .white
        textField.addTarget(self, action: #selector(handleTextFieldChange), for: .editingChanged)
        
        return textField
    }()
    
    let passwordTextField : CustomTextField = {
        let textField = CustomTextField(placeholderText : "Enter Password")
        textField.backgroundColor = .white
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(handleTextFieldChange), for: .editingChanged)
        
        return textField
    }()
    
    let registerButton : UIButton = {
        
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
        
        button.setTitleColor(.darkGray, for: .disabled)
        button.setTitleColor(.white, for: .normal)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .light)

        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        
        button.addTarget(self, action: #selector(handleRegisterButtonPress), for: .touchUpInside)
        
        return button
    }()
    
    @objc fileprivate func handleRegisterButtonPress() {
        self.view.endEditing(true) //Remove keyboard

        registrationViewModel.performRegistration(completion : {[unowned self] (err) in
            if let e = err {
                self.showHudWithError(error: e)
                return
            }
            
            self.showHudForUserCreatedSuccess()
        })
    }
    
    fileprivate func showHudForUserCreatedSuccess() {
        let hud = JGProgressHUD()
        hud.textLabel.text = "User Created!"
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 2)
    }
    
    fileprivate func showHudWithError(error : Error) {
        let hud = JGProgressHUD()
        hud.textLabel.text = "Failed to create user"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 3)
    }
    
    @objc fileprivate func handleSelectPhotoButtonPress() {
        view.endEditing(true)
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    
    }
    
    //MARK: Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradient()
        setupLayout()
        setupNotificationObserver()
        setUpTapGestureToMinimizeKeyboard()
        setupRegistrationViewModelObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNotificationObserver()
    }
    
    //MARK: Fileprivate functions
    fileprivate func setupLayout() {
        stackView.axis = .vertical
        stackView.spacing = 8
        
        view.addSubview(stackView)
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: stackViewPadding)
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    fileprivate func setupGradient() {
        
        let gradient = CAGradientLayer()
        
        let topColor = #colorLiteral(red: 0.9889099002, green: 0.3612048626, blue: 0.3796544075, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8969689012, green: 0.1098366156, blue: 0.4653301239, alpha: 1)
        
        gradient.colors = [topColor.cgColor, bottomColor.cgColor]
        gradient.locations = [0.5, 1.0]
        
        view.layer.addSublayer(gradient)
        gradient.frame = view.bounds

    }
    
    fileprivate func setupRegistrationViewModelObservers() {
        registrationViewModel.bindableIsFormValid.bind {[unowned self] (isFormValid) in
            guard let valid = isFormValid else {return}
            
            if(valid) {
                
                self.registerButton.isEnabled = true
                self.registerButton.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
                self.registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
            }
            else {
                self.registerButton.isEnabled = false
                self.registerButton.backgroundColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
                
            }
        }
        
        registrationViewModel.bindableImage.bind {[unowned self] (image) in
            self.selectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        registrationViewModel.bindableIsRegistering.bind { (isRegistering) in
            if let reg = isRegistering {
                if(reg) {
                    self.registeringHUD.textLabel.text = "Registering User"
                    self.registeringHUD.show(in: self.view)
                }
                else {
                    self.registeringHUD.dismiss()
                }
            }
        }
    }
    
    fileprivate func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc fileprivate func handleKeyboardShow(notification : Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
            else {return}
        
        let keyboardFrame = value.cgRectValue
        
        let bottomSpace = view.frame.height - stackView.frame.origin.y - stackView.frame.height
        let distanceForViewToMove = bottomSpace - keyboardFrame.height
        
        self.view.transform = CGAffineTransform(translationX: 0, y: distanceForViewToMove)
    }
    
    @objc fileprivate func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.view.transform = .identity
        })
    }
    
    fileprivate func setUpTapGestureToMinimizeKeyboard() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismissGesture)))
    }
    
    @objc fileprivate func handleTapDismissGesture() {
        self.view.endEditing(true) //removes keyboard
    }
    
    @objc fileprivate func handleTextFieldChange(textField : UITextView) {
        
        switch textField {
        case fullNameTextField:
            registrationViewModel.fullName = textField.text
        case emailTextField:
            registrationViewModel.email = textField.text
        case passwordTextField:
            registrationViewModel.password = textField.text
        default:
            ()
        }
    }
}

extension UserRegistrationViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as? UIImage
        
        registrationViewModel.bindableImage.value = image
        dismiss(animated: true)
    }
    
}
