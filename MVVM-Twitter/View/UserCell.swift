//
//  UserCell.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/02/29.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    var user : User? {
        didSet { configure()}
    }
    
    private lazy var profileImageView : UIImageView = {
        return UIImageView().profilImageView()
    }()
    
    private let usernameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "userName"
        return label
    }()
    
    private let fullnamelabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "full Name"
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, fullnamelabel])
        stack.axis = .vertical
        stack.spacing = 2
        
        addSubview(stack)
        stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        guard let user = user else {return}
        print(user.fullname)
    }
}
