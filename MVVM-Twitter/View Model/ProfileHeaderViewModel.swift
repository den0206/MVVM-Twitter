//
//  ProfileHeaderViewModel.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/02/28.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//



import UIKit

enum ProfileFilterOptions : Int, CaseIterable {
    case tweet
    case replies
    case likes
    
    var description : String {
        switch self {
        case .tweet: return "Tweets"
        case .replies : return "Replies"
        case .likes : return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    
    private let user : User
    
    let usernameText : String
    
    var followersString : NSAttributedString? {
        return attributText(withValue: user.stats?.followers ?? 0, text: "followers")
    }
    
    var followeingString : NSAttributedString? {
        return attributText(withValue: user.stats?.following ?? 0, text: "following")
    }
    
    var actuionButtonTitle : String {
        if user.isCurrentUser {
            return "Edit Profile"
        }
        
        if !user.isFollowed {
            return "Follow"
        }
        
        if user.isFollowed {
            return "UnFollow"
        }
        
        return "Loading"
    }
    
    
    
    init(user : User) {
        self.user = user
        
        self.usernameText = "@" + user.username
    }
    
    
    fileprivate func attributText(withValue value : Int, text : String) -> NSAttributedString {
        
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        
        attributedTitle.append(NSMutableAttributedString(string: " \(text)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray ]))
        
        return attributedTitle
    }
    
}
