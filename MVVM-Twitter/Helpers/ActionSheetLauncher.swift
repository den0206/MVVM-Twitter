//
//  ActionSheetLauncher.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/03/01.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation

class ActionSheetLauncher : NSObject {
    
    private let user : User
    
    init(user : User) {
        self.user = user
        super.init()
    }
    
    func show() {
        print("AactionSheet\(user.fullname)")
    }
}
