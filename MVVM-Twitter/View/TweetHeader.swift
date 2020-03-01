//
//  TweetHeader.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/02/29.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class TweetHeader : UICollectionReusableView {
    
    var tweet : Tweet? {
        didSet {
            configure()
        }
    }
    
    //MARK: - Parts
    
    private lazy var profileImageView : UIImageView = {
        
        let iv = UIImageView()
        //        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .twitterBlue
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.addTarget(self, action: #selector(handleProfileImageTapped))
        
        iv.addGestureRecognizer(tapGesture)
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    private let fullnameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "full name"
        return label
    }()
    
    private let usernameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "SpiderMan"
        
        return label
    }()
    
    private let captionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "test Caption"
        return label
    }()
    
    private let dateLabel : UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.text = "6:33 PM - 1/28/2020"
        return label
    }()
    
    private lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return button
    }()
    
    private let replyLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.text = "test Reply"
        return label
    }()
    
    private lazy var retweetsLabel = UILabel()
    private lazy var likesLabel = UILabel()
    
    private lazy var statsView : UIView = {
        let view = UIView()
        
        // separate Line
        
        let divider1 = UIView()
        divider1.backgroundColor = .systemGroupedBackground
        view.addSubview(divider1)
        divider1.anchor(top: view.topAnchor, left :view.leftAnchor, right: view.rightAnchor, paddingLeft: 8, height: 1.0)
        
        let stack = UIStackView(arrangedSubviews: [retweetsLabel, likesLabel])
        stack.axis = .horizontal
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.centerY(inView: view)
        stack.anchor(left : view.leftAnchor, paddingLeft: 16)
        
        
        // separate Line
        let divider2 = UIView()
        divider2.backgroundColor = .systemGroupedBackground
        view.addSubview(divider2)
        divider2.anchor( left :view.leftAnchor, bottom : view.bottomAnchor ,right: view.rightAnchor, paddingLeft: 8, height: 1.0)
        
        return view
    }()
    
    //MARK: - Buttons
    
    private lazy var commentButton : UIButton = {
        let button = createButton(withImage: #imageLiteral(resourceName: "comment"))
        return button
    }()
    
    private lazy var reTweetButton : UIButton = {
        let button = createButton(withImage: #imageLiteral(resourceName: "share"))
        return button
    }()
    
    private lazy var likeButton : UIButton = {
        let button = createButton(withImage: #imageLiteral(resourceName: "like"))
        return button
    }()
    
    private lazy var shareButton : UIButton = {
        let button = createButton(withImage: #imageLiteral(resourceName: "retweet"))
        return button
    }()
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
            
        let labelStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        labelStack.axis = .vertical
        labelStack.spacing = -6
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, labelStack])
        imageCaptionStack.spacing = 12
        
        let stack = UIStackView(arrangedSubviews: [replyLabel, imageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillProportionally
        
        addSubview(stack)
        stack.anchor(top : topAnchor, left : leftAnchor, paddingTop:  16, paddingLeft: 16)
        
        addSubview(captionLabel)
       captionLabel.anchor(top: stack.bottomAnchor, left: leftAnchor, right: rightAnchor,
                                  paddingTop: 12, paddingLeft: 16, paddingRight: 16)
        
        addSubview(dateLabel)
        dateLabel.anchor(top : captionLabel.bottomAnchor, left : leftAnchor, paddingTop: 20, paddingLeft: 16)
        
        addSubview(optionsButton)
        optionsButton.centerY(inView: stack)
        optionsButton.anchor(right : rightAnchor, paddingLeft: 8)
        
        addSubview(statsView)
        statsView.anchor(top : dateLabel.bottomAnchor, left: leftAnchor, right: rightAnchor,paddingTop: 12, height: 40)
        
        let buttonStack = UIStackView(arrangedSubviews: [commentButton, reTweetButton,likeButton, shareButton])
        
        buttonStack.spacing = 72
        addSubview(buttonStack)
        buttonStack.centerX(inView: self)
        buttonStack.anchor(top : statsView.bottomAnchor, paddingTop: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Action
    
    @objc func handleProfileImageTapped() {
        
    }
    
    @objc func showActionSheet() {
        
    }
    
    
    //MARK: - Helper
    
    private func configure() {
        guard let tweet = tweet else {return}
        let viewModel = TweetViewModel(tweet: tweet)
        
        captionLabel.text = tweet.caption
        fullnameLabel.text = viewModel.fullnameText
        usernameLabel.text =  viewModel.usernameText
        profileImageView.sd_setImage(with: viewModel.profileImageUrl, completed: nil)
        dateLabel.text = viewModel.headerTimeStamp
        
        
        
        
    }
    
    private func createButton(withImage image : UIImage) -> UIButton {
        
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        return button
        
    }
    
    
    
}
