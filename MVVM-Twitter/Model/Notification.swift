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
    
    var tweetId : String?
    var timeStamp : Date!
    var user : User
    var tweet : Tweet?
    var type : NotificationType!
    
    init(user : User,  dictionary : [String : Any]) {
        self.user = user
       
        
        if let tweetId = dictionary[kTWEETID] as? String {
            self.tweetId = tweetId
        }
        
        if let timestamp = dictionary[kTIMESTAMP] as? Double {
            self.timeStamp = Date(timeIntervalSince1970: timestamp)
        }
        
        if let type = dictionary[kTYPE] as? Int {
            self.type = NotificationType(rawValue: type)
        }
    }
    
}
