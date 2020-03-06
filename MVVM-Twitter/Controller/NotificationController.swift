//
//  NotificationController.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/02/23.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

private let reuserIdentifer = "NotificationCell"

class NotificationController : UITableViewController {
    
    private var notifications = [Notification]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchNotification()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Notification"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuserIdentifer)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
        let refreshController = UIRefreshControl()
        tableView.refreshControl = refreshController
        refreshController.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
    }
    
    @objc func handleRefresh() {
        fetchNotification()
    }
    
    // fetch Notification
    
    private func fetchNotification() {
        refreshControl?.beginRefreshing()
        
        NotificationService.shared.fetchNotification { (notifications) in
            
            self.refreshControl?.endRefreshing()
            self.notifications = notifications.sorted(by: { $0.timeStamp >  $1.timeStamp })
            
            self.notifications = notifications
            self.checkIfUserIsFollwed(notifications: notifications)
            
        }
        
    }
    
    func checkIfUserIsFollwed(notifications : [Notification]) {
        guard !notifications.isEmpty else {return}
        
        notifications.forEach { (notification) in
            
            guard case .follow = notification.type else {return}
            let user = notification.user
            
            UserService.shared.fetchUserIsFollowed(uid: user.uid) { (isFollowed) in
                if let index = self.notifications.firstIndex(where: {$0.user.uid == notification.user.uid}) {
                    self.notifications[index].user.isFollowed = isFollowed
                }
            }
        }
    }
    
    
}

//MARK: - TableView Delegate


extension NotificationController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuserIdentifer, for: indexPath) as! NotificationCell
        
        cell.delegate = self
        cell.notification = notifications[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let notification = notifications[indexPath.row]
        
        // if notification has "Tweet ID"
        guard let tweetId = notification.tweetId else {
            print("No TweetID")
            return}
        
        TweetService.shared.fetxhSingleTweet(withTweetId: tweetId) { (tweet) in
            let tweetVC = TweetController(tweet: tweet)
            self.navigationController?.pushViewController(tweetVC, animated: true)
        }
        
        
    }
    
}

//MARK: - Notification Delegate

extension NotificationController : NotificationCellDelegate {
    func handleProfilaImageTapped(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else {return}
        
        let profileVC = ProfileController(user: user)
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    func handleFollowButtonTapped(_ cell: NotificationCell) {
        
        guard let user = cell.notification?.user else {return}
        
        if user.isFollowed {
            user.unFollow()
            cell.notification?.user.isFollowed = false
        } else {
            user.follow()
            cell.notification?.user.isFollowed = true
        }
    }
    
    
}
