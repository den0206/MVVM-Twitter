//
//  EditProfileFooter.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/03/08.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

protocol EditProfileFooterDelegate : class {
    func handleLogout()
}

class EditProfileFooter : UIView {
    
    var delegate : EditProfileFooterDelegate?
    
    //MARK: - Parts
    
    private lazy var logoutButton :UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        button.backgroundColor = .red
        button.layer.cornerRadius = 5
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(logoutButton)
        logoutButton.anchor(left : leftAnchor, right: rightAnchor, paddingLeft: 16,paddingRight: 16)
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logoutButton.centerY(inView: self)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleLogout() {
        delegate?.handleLogout()
    }
    
}
