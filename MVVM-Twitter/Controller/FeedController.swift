//
//  FeedController.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/02/23.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

private let reuserIdentifier = "tweetCell"

class FeedController : UICollectionViewController {
    
    var user : User? {
        didSet {
           configureLeftButton()
        }
    }
    
    private var followingIDs = [String]()
    var followingListner : ListenerRegistration?
    
    private var tweets = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    deinit {
        followingListner?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchFollowingIDs()
//        fetchTweets()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuserIdentifier)
        
        collectionView.backgroundColor = .white
        
        // naviogationBar LOGO Image
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
        
        let refreshController = UIRefreshControl()
        collectionView.refreshControl = refreshController
        refreshController.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(habdleTappedImage))
        profileImageView.addGestureRecognizer(tap)
    }
    
    func fetchFollowingIDs() {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        collectionView.refreshControl?.beginRefreshing()
        
        // when Login
        if followingListner == nil {  collectionView.refreshControl?.endRefreshing()}
        
        // get followingIds
        var feedTweets = [Tweet]()
        
        followingListner =  UserService.shared.fetchFollowingIDs(uid: currentUid) { (followingIDs) in
            self.followingIDs = followingIDs
            
            for uid in self.followingIDs {
                UserService.shared.fetchUser(uid: uid) { (user) in
                    TweetService.shared.fetchTweetsForUser(user: user) { (tweets) in
                        feedTweets += tweets
                        self.tweets = feedTweets.sorted(by: { $0.timestamp >  $1.timestamp })
                        self.checkifUserLikedTweet()
                        
                        self.collectionView.refreshControl?.endRefreshing()
                    }
                }
            }
        }
        
       
    }
    
    func fetchTweets() {
        TweetService.shared.fetchTweets { (tweets) in
            
            self.tweets = tweets.sorted(by: { $0.timestamp >  $1.timestamp })
            self.checkifUserLikedTweet()
            
          
//            self.collectionView.reloadData()
        }
    }
    private func checkifUserLikedTweet() {
        self.tweets.forEach { (tweet) in
            TweetService.shared.checkIfUserLikedTweet(tweet) { (didLike) in
                // remove un Like
                guard didLike == true else {return}
                
                if let index = self.tweets.firstIndex(where: {$0.tweetId == tweet.tweetId}) {
                    self.tweets[index].didLike = true
                }
            }
        }
    }
    
    @objc func handleRefresh() {
        fetchFollowingIDs()
    }
    
    @objc func habdleTappedImage() {
        guard let user = user else {return}
        
        let profileVC = ProfileController(user: user)
        navigationController?.pushViewController(profileVC, animated: true)
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let tweet = tweets[indexPath.row]
        
        let tweetVC = TweetController(tweet: tweet)
        
        navigationController?.pushViewController(tweetVC, animated: true)
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension FeedController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewModel = TweetViewModel(tweet: tweets[indexPath.row])
        let captionSize = viewModel.size(forWidth: view.frame.width).height
        
        return CGSize(width: view.frame.width, height: captionSize + 72)
    }
    
}

//MARK: - Tweet Cell Delegate

extension FeedController : TweetCellDelegate {
  
  
    func handleProfileImageTapped(cell: TweetCell) {
        
        guard let user = cell.tweet?.user else {return}
        
        let profileVC = ProfileController(user: user)
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    func handleRetweetTapped(cell: TweetCell) {
    
        guard let tweet = cell.tweet else {return}
        let replyController = UploadTweetController(user: tweet.user, config: .reply(tweet))
        let nav = UINavigationController(rootViewController: replyController)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
        
      }
    
    func handleLikeTapped(cell: TweetCell) {
        guard let tweet = cell.tweet else {return}
        
        TweetService.shared.likeTweet(tweet: tweet) { (error) in
            cell.tweet?.didLike.toggle()
            // cell instance
            let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
            cell.tweet?.likes = likes
            
            // Notification
            guard !tweet.didLike else {return}
            NotificationService.shared.uploadNotification(toUser: tweet.user, type: .like)
            
        }
        
      }
      
      
    
    
}
