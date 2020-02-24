//
//  UserService.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/02/24.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation
import Firebase

class UserService {
    static let shared = UserService()
    
    func fetchUser(uid : String, completion : @escaping(User) -> Void) {
        
        firebaseReferences(.User).document(uid).getDocument { (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            
            if snapshot.exists {
                let user = User(uid: uid, dictionary: snapshot.data()!)
                completion(user)
            }
        }
        
    }

    
}
