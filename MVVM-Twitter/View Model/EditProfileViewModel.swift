//
//  EditProfileViewModel.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/03/08.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation

enum EditProfileOptions : Int, CaseIterable {
    case fullname
    case username
    case bio
    
    var description : String {
        switch self {
            
        case .fullname:
            return "Fullname"
        case .username:
            return "Username"
        case .bio:
            return "Bio"
       
        }
    }
}

struct EditProfileViewModel {
    
    private let user : User
    let option : EditProfileOptions
    
    var titleText : String {
        return option.description
    }
    
    var optionLabel : String? {
        switch option {
            
        case .fullname:
            return user.fullname
        case .username:
            return user.username
        case .bio:
            return user.bio
  
        }
    }
    
    var shouldHideTextField : Bool {
        return option == .bio
    }
    
    var shouldHideTextView : Bool {
        return option != .bio
    }
    
    var shouldHidePlaceholderlabel : Bool {
        return user.bio != nil
    }
    
    init(user : User, option : EditProfileOptions) {
        
        self.user = user
        self.option = option
    }
    
    
}

