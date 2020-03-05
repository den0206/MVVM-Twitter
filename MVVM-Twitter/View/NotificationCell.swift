//
//  NotificationCell.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/03/05.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

protocol NotificationCellDelegate : class{
    
    func handleProfilaImageTapped(_ cell : NotificationCell)
    func handleFollowButtonTapped(_ cell : NotificationCell)
}

class NotificationCell : UITableViewCell {
    
    weak var delegate : NotificationCellDelegate?
    
    var notification : Notification? {
        didSet {
            configure()
        }
    }
    
    //MARK: - Parts
    
    private lazy var profileImegeView : UIImageView = {
        let iv = UIImageView().profilImageView()
        iv.setDimensions(width: 40, height: 40)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfilaImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    private lazy var followButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.setTitleColor( .twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(handleFollowButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    let notificationLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Some notifivcation Message"
        
        return label
    }()
    
    
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stack = UIStackView(arrangedSubviews: [profileImegeView, notificationLabel])
        stack.spacing = 8
        stack.alignment = .center
        
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        stack.anchor(right : rightAnchor, paddingRight: 12)
        
        addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.setDimensions(width: 92, height: 32)
        followButton.layer.cornerRadius = 32 / 2
        followButton.anchor(right : rightAnchor, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func configure() {
        guard let notification = notification else {return}
        
        
    }
    
    //MARK: - Actions
    
    @objc func handleProfilaImageTapped() {
        delegate?.handleProfilaImageTapped(self)
    }
    
    @objc func handleFollowButtonTapped() {
        delegate?.handleFollowButtonTapped(self)
    }
    
}
