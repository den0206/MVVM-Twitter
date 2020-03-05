//
//  ProfileController.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/02/26.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation
import UIKit

private let reuserIdentifier = "tweetCell"
private let headerIdentifier = "profileHeader"

class ProfileController : UICollectionViewController {
    
    private var user : User
    
    private var tweets = [Tweet]()
    
    
    
    init(user : User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        fetchTweets()
        fetchIfUsersFollowed()
        fetchUserStats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true

    }
    
    //MARK: - Helpers
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuserIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
    
    //MARK: - FireStore
    
    private func fetchTweets() {
        TweetService.shared.fetchTweetsForUser(user: user) { (tweets) in
            
            self.tweets = tweets.sorted(by: { $0.timestamp >  $1.timestamp })
            self.collectionView.reloadData()
        }
    }
    
    private func fetchIfUsersFollowed() {
        UserService.shared.fetchUserIsFollowed(uid: user.uid) { (isFollowed) in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    private func fetchUserStats() {
        
        UserService.shared.fetchStats(userId: user.uid) { (stats) in
            self.user.stats = stats
            self.collectionView.reloadData()
        }
    }
    
    
    
}

//MARK: - Collectionview Delegate

extension ProfileController {
    
    // data Source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuserIdentifier, for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.item]
        
        return cell
    }
    
    // delegate
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        
        header.delegate = self
        header.user = user
        return header
    }
}

//MARK: - CollectionVIew Delegate Flowlayout



extension ProfileController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 120)
        
    }
}

//MARK: - Profile Header Delegate

extension ProfileController : ProfileHeaderDelegate {
 
    
    func handleDismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    func handleEditProfileFollow(_ header: ProfileHeader) {
        if user.isCurrentUser {
            print("Edit")
            return
        }
        
        if user.isFollowed {
            user.isFollowed = false
            user.unFollow()
        } else {
            user.isFollowed = true
            user.follow()
            
            // Notification
            
            NotificationService.shared.uploadNotification(toUser: self.user, type: .follow)
        }
    }
    
    func handleFollowingLabelTapped() {
         print("Following")
     }
     
     func handleFollowerLabelTapped() {
         print("Follower")
     }
     
    
    
}
