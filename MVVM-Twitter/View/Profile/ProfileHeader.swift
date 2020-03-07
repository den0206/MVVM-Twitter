//
//  ProfileHeader.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/02/26.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

protocol ProfileHeaderDelegate : class{
    func handleDismiss()
    func handleEditProfileFollow(_ header : ProfileHeader)
    func didSelect(filter : ProfileFilterOptions)
    func handleFollowingLabelTapped()
    func handleFollowerLabelTapped()
}

class ProfileHeader  : UICollectionReusableView {
    
    weak var delegate : ProfileHeaderDelegate?
    
    var user : User? {
        didSet {
            configure()
        }
    }
    
    //MARK: - Parts
    
    private lazy var containerView : UIView = {
        let view  = UIView()
        view.backgroundColor = .twitterBlue
        
        view.addSubview(backButton)
        backButton.anchor(top : view.topAnchor, left:  view.leftAnchor, paddingTop:  42, paddingLeft: 16)
        backButton.setDimensions(width: 30, height: 30)
        return view
    }()
    
    private lazy var backButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_white_24dp").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
//        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4
        return iv
    }()
    
    private lazy var editProfileFollowButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 1.25
        button.setTitleColor(.twitterBlue, for: .normal)
        button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return button
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray

        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 3
        label.text = "User"

        return label
    }()
    
//    private let underlineView : UIView = {
//        let view = UIView()
//        view.backgroundColor = .twitterBlue
//        return view
//    }()
    
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(handleFollowingLabelTapped))
        
//        tap.cancelsTouchesInView = false
        
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true

        return label
    }()
    
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleFollowerLabelTapped))
        
//        tap.cancelsTouchesInView = false

        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    private let filterBar = ProfileFilterView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(containerView)
        containerView.anchor(top : topAnchor, left: leftAnchor, right: rightAnchor , height: 108)
        
        addSubview(profileImageView)
        profileImageView.anchor(top : containerView.bottomAnchor, left:  leftAnchor,paddingTop: -24, paddingLeft: 8)
        profileImageView.setDimensions(width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top : containerView.bottomAnchor, right: rightAnchor, paddingTop: 12, paddingRight: 12)
        editProfileFollowButton.setDimensions(width: 100, height: 36)
        editProfileFollowButton.layer.cornerRadius = 36 / 2
        
        let userDetailStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel, bioLabel])
        
        userDetailStack.axis = .vertical
        userDetailStack.distribution = .fillProportionally
        userDetailStack.spacing = 4
        
        addSubview(userDetailStack)
        userDetailStack.anchor(top : profileImageView.bottomAnchor, left:  leftAnchor,right: rightAnchor, paddingTop: 8, paddingLeft : 12 ,paddingRight: 12)
        
        let followStack = UIStackView(arrangedSubviews: [followingLabel, followersLabel])
        
        followStack.axis = .horizontal
        followStack.distribution = .fillEqually
        followStack.spacing = 8
        
        
        addSubview(followStack)
        followStack.anchor(top : userDetailStack.bottomAnchor, left:  leftAnchor,paddingTop: 8, paddingLeft: 12)
        
        addSubview(filterBar)
        filterBar.delegate = self
        filterBar.anchor(left : leftAnchor, bottom:  bottomAnchor, right:  rightAnchor, height:  50)
        
     
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selector
    
    @objc func handleDismiss() {
        delegate?.handleDismiss()
    }
    
    @objc func handleEditProfileFollow() {
        
        delegate?.handleEditProfileFollow(self)
    }
    
    @objc func handleFollowingLabelTapped() {
        
        delegate?.handleFollowingLabelTapped()
        
    }
    
    @objc func handleFollowerLabelTapped() {
        
        delegate?.handleFollowerLabelTapped()
    }
    
    private func configure() {
        guard let user = user else {return}
        let viewModel = ProfileHeaderViewModel(user: user)
    
        
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        followersLabel.attributedText = viewModel.followersString
        
        followingLabel.attributedText = viewModel.followeingString
        
        editProfileFollowButton.setTitle(viewModel.actuionButtonTitle, for: .normal)
        
        fullnameLabel.text = user.fullname
        usernameLabel.text = viewModel.usernameText
        
        
    }
    
}

extension ProfileHeader : ProfileFilterViewDelegate {
    func filterView(_ view: ProfileFilterView, didSelect index: Int) {
        guard let filter = ProfileFilterOptions(rawValue: index) else {return}
        delegate?.didSelect(filter: filter)
        
    }
    
    
}
