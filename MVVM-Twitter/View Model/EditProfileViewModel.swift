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
}

struct EditProfileViewMdel {
    
    private let user : User
    let option : EditProfileOptions
    
    init(user : User, option : EditProfileOptions) {
        
        self.user = user
        self.option = option
    }
    
}

