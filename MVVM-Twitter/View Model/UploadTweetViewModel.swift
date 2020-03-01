//
//  UploadTweetViewModel.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/03/01.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

enum UploadTweetConfiguration {
    case tweet
    case reply(Tweet)
}

struct UploadTweetViewModel {
    let actionButtonTitle : String
    let placeholderText : String
    var sholdShowReplylabel : Bool
    var replyText : String?
    
    init(config : UploadTweetConfiguration) {
        switch config {
        case .tweet:
            actionButtonTitle = "Tweet"
            placeholderText = "何してる？？"
            sholdShowReplylabel = false
        case .reply(let tweet) :
            actionButtonTitle = "Reply"
            placeholderText = "Tweet For reply"
            sholdShowReplylabel = true
            replyText = "Replying to \(tweet.user.fullname)"
        }
    }
    
}
