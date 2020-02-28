//
//  User.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/02/24.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation
import Firebase


struct User {
    
    var fullname : String
    let email : String
    var username : String
    var profileImageUrl : URL?
    let uid : String
    
    var isCurrentUser : Bool {return Auth.auth().currentUser?.uid == uid}
    
    
    init(uid : String, dictionary : [String : Any]) {
        self.uid = uid
        
        self.fullname = dictionary[kFULLNAME] as? String ?? ""
        self.username = dictionary[kUSERNAME] as? String ?? ""
        self.email = dictionary[kEMAIL] as? String ?? ""
        
        if let profileImageUrlString = dictionary[kPROFILE_IMAGE] as? String {
            guard let url = URL(string: profileImageUrlString) else {return}
            self.profileImageUrl = url
        }
    }
}
