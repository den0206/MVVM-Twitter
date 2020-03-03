//
//  ActionSheetrViewModel.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/03/03.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation

class ActionSheetViewModel {
    
    var options : [ActionSheetOptions] {
        
        var results = [ActionSheetOptions]()
        
        if user.isCurrentUser {
            results.append(.delete)
        } else {
            let followOption : ActionSheetOptions
            
            if user.isFollowed {
                followOption = .unfollow(user)
            } else {
                followOption = .follow(user)
            }
            
            results.append(followOption)
        }
        
        results.append(.report)
        
        return results
    }
    
    private let user : User
    
    init(user : User) {
        self.user = user
    }
}

enum ActionSheetOptions {
    case follow(User)
    case unfollow(User)
    case report
    case delete
    
    var description : String {
        switch  self {
        
        case .follow(let user):
            return "Follow @\(user.fullname)"
        case .unfollow(let user):
            return "Unfollow @\(user.fullname)"
        case .report:
            return "Report Tweet"
        case .delete:
            return "Delete Tweet"
      
        }
    }
}
