//
//  SignUpVC.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/02/23.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//


import UIKit

class SignUpVC : UIViewController {
    
    private let imagePicker = UIImagePickerController()
    private var profileImage : UIImage?
    //MARK: - Parts
    
    private let plusPhotoButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(tappedPlusButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailContainerView : UIView = {
        let view = UIView().inputContainerView(withImage: #imageLiteral(resourceName: "ic_mail_outline_white_2x-1"), textField: emailTextField)
        return view
    }()
    
    private lazy var emailTextField : UITextField = {
        let tf = UITextField().textField(withPlaceHolder: "Email", isSecureType: false)
        return tf
    }()
    
    
    private lazy var fullnameContainerView : UIView = {
        let view = UIView().inputContainerView(withImage: #imageLiteral(resourceName: "ic_mail_outline_white_2x-1"), textField: fullnameTextField)
        return view
    }()
    
    private lazy var fullnameTextField : UITextField = {
        let tf = UITextField().textField(withPlaceHolder: "FullName", isSecureType: false)
        return tf
    }()
    
    private lazy var usernameContainerView : UIView = {
        let view = UIView().inputContainerView(withImage: #imageLiteral(resourceName: "ic_mail_outline_white_2x-1"), textField: usernameTextField)
        return view
    }()
    
    private lazy var usernameTextField : UITextField = {
        let tf = UITextField().textField(withPlaceHolder: "UserName", isSecureType: false)
        return tf
    }()
    
    
    private lazy var passwordContainerView : UIView = {
        let view = UIView().inputContainerView(withImage: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
        return view
    }()
    
    private lazy var passwordTextField : UITextField = {
        let tf = UITextField().textField(withPlaceHolder: "Password", isSecureType: true)
        return tf
    }()
    
    let signUpButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    
    let alreadyAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "already have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.white])
        
        attributedTitle.append(NSAttributedString(string: "Log In", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.white]))
        
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()

    }
    
    //MARK: - Life Cycle
    
    private func configureUI() {
        view.backgroundColor = .twitterBlue
        
        // set imagePicker Delegate
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 16)
        plusPhotoButton.setDimensions(width: 150, height: 150)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,fullnameContainerView,usernameContainerView,passwordContainerView, signUpButton])
        
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top :plusPhotoButton.bottomAnchor, left : view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 16,paddingRight: 16)
        
        // already Have Button
        
        view.addSubview(alreadyAccountButton)
        alreadyAccountButton.centerX(inView: view)
        alreadyAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, height: 12)

    }
    
    //MARK: - Actions
    
    @objc func handleSignUp() {
        guard let profileImage = self.profileImage else {
            print("No exist Profile image")
            return}
        guard let email = emailTextField.text else {return}
        guard let fullName = fullnameTextField.text else {return}
        guard let userName = usernameTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        // init credential Model
        let credentials = AuthCredentials(email: email, password: password, fullname: fullName, userName: userName, profileImage: profileImage)
        
        // Start Indicator
        
        self.shouldPresentLoadingView(true)
        
        AuthService.shared.registerUser(credential: credentials) { (error) in
            
            
            if error != nil {
                self.shouldPresentLoadingView(false)
                return
            }
            
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {return }
            guard let tab = window.rootViewController as? MainTabController else {return}
            
            tab.checkUserIsLogin()
            
            self.dismiss(animated: true, completion: {
                self.shouldPresentLoadingView(false)
            })
        }
        
    }
    
    @objc func tappedPlusButton() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    
}

extension SignUpVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let profileImage = info[.editedImage] as? UIImage else {return}
        self.profileImage = profileImage
        
        // replace Image
        
        plusPhotoButton.layer.cornerRadius = 150 / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
        plusPhotoButton.imageView?.clipsToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 2
        
        plusPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        self.dismiss(animated: true, completion: nil)
        
    }
}
