//
//  LoginVC.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/02/23.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class LoginVC : UIViewController {
    
    //MARK: - Parts
    
    private let logoImageView : UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "TwitterLogo"))
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    private lazy var emailContainerView : UIView = {
        let view = UIView().inputContainerView(withImage: #imageLiteral(resourceName: "ic_mail_outline_white_2x-1"), textField: emailTextField)
        return view
    }()
    
    private lazy var emailTextField : UITextField = {
        let tf = UITextField().textField(withPlaceHolder: "Email", isSecureType: false)
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
    
    private let loginButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.white])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.white]))
        
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignup), for: .touchUpInside)
        return button
    }()
    
    
    
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    private func configureUI() {
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        view.backgroundColor = .twitterBlue
        
        // logo Image
        
        view.addSubview(logoImageView)
        logoImageView.anchor(top: view.topAnchor, paddingTop: 42, width: 200, height: 200)
        logoImageView.centerX(inView: view)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,passwordContainerView, loginButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 24
        
        view.addSubview(stack)
        stack.anchor(top :logoImageView.bottomAnchor, left : view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 16,paddingRight: 16)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, height: 12)

    }
    
    //MARK: - Actions
    
    // Lopg in
    
    @objc func handleLogin() {
        
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        shouldPresentLoadingView(true)
        
        AuthService.shared.loginUser(email: email, password: password) { (result, error) in
            
            if error != nil {
                print(error!.localizedDescription)
                self.shouldPresentLoadingView(false)
                return
            }
            
            // no Error
            
            // safe way
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {return}
            guard let tab = window.rootViewController as? MainTabController else {return}
            
            tab.checkUserIsLogin()
            
            self.dismiss(animated: true) {
                self.shouldPresentLoadingView(false)
            }
            
            
        }
    }
    
    @objc func handleShowSignup() {
        let signUpVC = SignUpVC()
        
        navigationController?.pushViewController(signUpVC, animated: true)
    }
}
