//
//  EditProfileHeader.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/03/08.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

protocol EditProfileHeaderDelegate : class {
    func handlePhotoButton()
}

class EditProfileHeader : UIView {
    
    private let user : User
    var delegate : EditProfileHeaderDelegate?
    
    //MARK: - Parts
    
    lazy var profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.lightGray.cgColor
        iv.layer.cornerRadius = 3.0
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePhotoButton))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        
        return iv
    }()
    
    
    private let changePhotoButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Photo", for: .normal)
        button.addTarget(self, action: #selector(handlePhotoButton), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    init(user : User) {
        self.user = user
        super.init(frame: .zero)
        
        backgroundColor = .twitterBlue
        
        addSubview(profileImageView)
        profileImageView.center(inView: self, yConstant: -16)
        profileImageView.setDimensions(width: 100, height: 100)
        profileImageView.layer.cornerRadius = 100 / 2
        
        addSubview(changePhotoButton)
        changePhotoButton.centerX(inView: self, topAnchor: profileImageView.bottomAnchor, paddingTop: 8)
        
        // set image
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handlePhotoButton() {
        delegate?.handlePhotoButton()
    }
}
