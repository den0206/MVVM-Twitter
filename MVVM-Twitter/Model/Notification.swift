//
//  Notification.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/03/04.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation

enum NotificationType : Int{
    case follow
    case like
    case reply
    case mention
}

struct Notification {
    
    let tweetId : String?
    var timeStamp : Date!
    let user : User
    let tweet : Tweet?
    var type : NotificationType!
    
    init(user : User, tweet : Tweet?, dictionary : [String : Any]) {
        self.user = user
        self.tweet = tweet
        
        self.tweetId = dictionary[kTWEETID] as? String ?? ""
        
        if let timestamp = dictionary[kTIMESTAMP] as? Double {
            self.timeStamp = Date(timeIntervalSince1970: timestamp)
        }
        
        if let type = dictionary[kTYPE] as? Int {
            self.type = NotificationType(rawValue: type)
        }
    }
    
}
