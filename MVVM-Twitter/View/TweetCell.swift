//
//  TweetCell.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/02/25.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

protocol TweetCellDelegate {
    
    func handleProfileImageTapped(cell : TweetCell)
    
    func handleRetweetTapped(cell : TweetCell)

}

class TweetCell: UICollectionViewCell {
    
    var tweet : Tweet? {
        didSet {
            configureCell()
        }
    }
    
    var delegate : TweetCellDelegate?
    
    
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
    
    private let captionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "test Caption"
        return label
    }()
    
    //MARK: - Buttons
    
    private lazy var commentButton : UIButton = {
        let button = createButton(withImage: #imageLiteral(resourceName: "comment"))
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return button
        
    }()
    
    private lazy var reTweetButton : UIButton = {
        let button = createButton(withImage: #imageLiteral(resourceName: "retweet"))
        button.addTarget(self, action: #selector(handlereTweetTapped), for: .touchUpInside)

        return button
    }()
    
    private lazy var likeButton : UIButton = {
        let button = createButton(withImage: #imageLiteral(resourceName: "like"))
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)

        return button
    }()
    
    private lazy var shareButton : UIButton = {
        let button = createButton(withImage: #imageLiteral(resourceName: "share"))
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)

        return button
    }()
    
    private let infoLabel = UILabel()
    
    
    //MARK: - init Cell
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top : topAnchor, left:  leftAnchor,paddingTop: 8,paddingLeft: 8)
        
        let captionStack = UIStackView(arrangedSubviews: [infoLabel,captionLabel])
        captionStack.axis = .vertical
        captionStack.distribution = .fillProportionally
        captionStack.spacing = 4
        
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        infoLabel.text = "textt infolabel"
        
        addSubview(captionStack)
        captionStack.anchor(top : profileImageView.topAnchor, left: profileImageView.rightAnchor,right: rightAnchor,paddingLeft: 12,paddingRight: 12)
        
        let buttonStack = UIStackView(arrangedSubviews: [commentButton,reTweetButton,likeButton,shareButton])
        
        buttonStack.axis = .horizontal
        buttonStack.spacing = 72
        
        addSubview(buttonStack)
        buttonStack.centerX(inView: self)
        buttonStack.anchor(bottom : bottomAnchor, paddingBottom: 8)
        
        let underlineView = UIView()
        underlineView.backgroundColor = .systemGroupedBackground
        addSubview(underlineView)
        underlineView.anchor(left : leftAnchor, bottom: bottomAnchor,right: rightAnchor,height: 1)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func handleProfileImageTapped() {
        delegate?.handleProfileImageTapped(cell: self)
    }
    
    @objc func handleCommentTapped() {
        
    }
    
    @objc func handlereTweetTapped() {
        delegate?.handleRetweetTapped(cell: self)
    }
    
    @objc func handleLikeTapped() {
        
    }
    
    @objc func handleShareTapped() {
        
    }
    
    //MARK: - Helper
    
    func configureCell() {
        guard let tweet = tweet else {return}
        captionLabel.text = tweet.caption
        let viewModel = TweetViewModel(tweet: tweet)
        
        
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl, completed: nil)
        infoLabel.attributedText = viewModel.userInfoText
       
    }
    
    func createButton(withImage : UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(withImage, for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        return button
    }
}
