//
//  UploadTweetController.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/02/24.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import ActiveLabel


class UploadTweetController : UIViewController {
    
    private let user : User
    
    private let config : UploadTweetConfiguration
    private lazy var viewModel = UploadTweetViewModel(config: config)
    
    //MARK: - Parts
    
    private lazy var actionButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweet", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.titleLabel?.textAlignment = .center
        
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        button.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var replyLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.mentionColor = .twitterBlue
        label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        return label
    }()
    
    private let profileImage : UIImageView = {
        let iv = UIImageView()
//        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .twitterBlue
        return iv
    }()
    
    private let captionTextView = InputTextView()
    
    
    
    //MARK: - Life Cycle
    
    init(user : User, config : UploadTweetConfiguration) {
        
        self.user = user
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        handleMentionTapped()
    }
    
    //MARK: - Actions
    
    @objc func handleUploadTweet() {
        
        guard let caption = captionTextView.text else {return}
        
        guard caption != " ", !caption.isEmpty else {
            
            // validation
            print("No Word Validation")
            return}
        
  
        
        TweetService.shared.uploadTweet(caption: caption, type: config) { (error) in
            
            if error != nil {
                print(error!.localizedDescription)
           
                return
            }
            
            // notification Reply
            
            if case .reply(let tweet) = self.config {
                NotificationService.shared.uploadNotification(toUser: tweet.user, type: .reply, tweetID: tweet.tweetId)
            }
            
            
            
            self.dismiss(animated: true)
        }
        
        
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        
        
     
          let imageCaptionStack = UIStackView(arrangedSubviews: [profileImage, captionTextView])
          imageCaptionStack.axis = .horizontal
          imageCaptionStack.spacing = 12
          imageCaptionStack.alignment = .leading
          
          let stack = UIStackView(arrangedSubviews: [replyLabel, imageCaptionStack])
          stack.axis = .vertical
          stack.spacing = 12
          
          view.addSubview(stack)
          stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                       right: view.rightAnchor, paddingTop: 16, paddingLeft: 16,
                       paddingRight: 16)
          
          profileImage.sd_setImage(with: user.profileImageUrl, completed: nil)
          
          actionButton.setTitle(viewModel.actionButtonTitle, for: .normal)
          captionTextView.placegholderLabel.text = viewModel.placeholderText
          
          replyLabel.isHidden = !viewModel.sholdShowReplylabel
          guard let replyText = viewModel.replyText else { return }
          replyLabel.text = replyText
        
        
    }
    private func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
    
    func handleMentionTapped() {
        replyLabel.handleMentionTap { (mention) in
            print(mention)
        }
    }
}
