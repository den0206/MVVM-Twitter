//
//  FeedController.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/02/23.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import SDWebImage

private let reuserIdentifier = "tweetCell"

class FeedController : UICollectionViewController {
    
    var user : User? {
        didSet {
           configureLeftButton()
        }
    }
    
    private var tweets = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchTweets()
    }
    
    
    func configureUI() {
        view.backgroundColor = .white
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuserIdentifier)
        
        collectionView.backgroundColor = .white
        
        // naviogationBar LOGO Image
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
    
    func configureLeftButton() {
        guard let user = user else {return}
        
        let profileImageView = UIImageView()
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.isUserInteractionEnabled = true
        
        // set Profile Image
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
    
    func fetchTweets() {
        TweetService.shared.fetchTweets { (tweets) in
            
            self.tweets = tweets.sorted(by: { $0.timestamp >  $1.timestamp })
            
//            self.collectionView.reloadData()
        }
    }
    
}

//MARK: - UicollectionView Delegate


extension FeedController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuserIdentifier, for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.item]
        cell.delegate = self
        
        return cell
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension FeedController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 120)
    }
    
}

//MARK: - Tweet Cell Delegate

extension FeedController : TweetCellDelegate {
    func handleProfileImageTapped(cell: TweetCell) {
        
        guard let user = cell.tweet?.user else {return}
        
        let profileVC = ProfileController()
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    
}
