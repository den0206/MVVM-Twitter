//
//  NotificationViewModel.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/03/06.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import FirebaseAuth

struct NotificationViewModel {
    
    private let notification : Notification
    private let type : NotificationType
    private let user : User
    
    var profileImageUrl : URL? {
        return user.profileImageUrl
    }
    
    var timeStampString : String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        
        let now = Date()
        return formatter.string(from: notification.timeStamp, to: now)
    }
    
    var notificationMessage : String {
        switch type {
        
        case .follow:
            return " started following you"
        case .like:
             return " liked your tweet"
        case .reply:
            return " replied to your tweet"
        case .mention:
            return " mentioned you in a tweet"
      
        }
    }
    
    var notificationText: NSAttributedString? {
        guard let timestamp = timeStampString else { return nil }
        let attributedText = NSMutableAttributedString(string: user.username,
                                                       attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
        attributedText.append(NSAttributedString(string: notificationMessage,
                                                 attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
        attributedText.append(NSAttributedString(string: " \(timestamp)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        
        return attributedText
    }
    
    var shouldHideFollowButton : Bool {
        let currentUid = Auth.auth().currentUser?.uid
        
        if user.uid == currentUid || type != .follow {
            return true
        }
        
        return false
    }
    
    var followButtonText : String {
        return user.isFollowed ? "Following" : "Follow"
    }
    
    
    
    init(notification : Notification) {
        self.notification = notification
        self.type = notification.type
        self.user = notification.user
    }
}
