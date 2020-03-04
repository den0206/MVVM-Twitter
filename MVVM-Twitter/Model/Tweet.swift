//
//  Tweet.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/02/24.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation

struct Tweet {
    let caption : String
    let tweetId : String
    var likes : Int
    var timestamp : Date!
    let retweetCount : Int
    let uid : String
    let user : User
    var didLike = false
    
    
    
    init(user : User, tweetId : String, dictionary : [String : Any]) {
        
        self.user = user
        
        self.tweetId = tweetId
        self.uid = dictionary[kUSERID] as? String ?? ""
        self.caption = dictionary[kCAPTION] as? String ?? ""
        self.likes = dictionary[kLIKES] as? Int ?? 0
        self.retweetCount = dictionary[kRETWEETS] as? Int ?? 0
        
        if let timestamp = dictionary[kTIMESTAMP] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        
    }
}
