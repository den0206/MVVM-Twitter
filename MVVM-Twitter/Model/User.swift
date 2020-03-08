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
    var isFollowed = false
    var stats : UserRelationStats?
    var bio : String?
    
    var isCurrentUser : Bool {return Auth.auth().currentUser?.uid == uid}
    
    
    init(uid : String, dictionary : [String : Any]) {
        self.uid = uid
        
        self.fullname = dictionary[kFULLNAME] as? String ?? ""
        self.username = dictionary[kUSERNAME] as? String ?? ""
        self.email = dictionary[kEMAIL] as? String ?? ""
        
        if let bio = dictionary[kBIO] as? String {
            self.bio = bio
        }
        
        if let profileImageUrlString = dictionary[kPROFILE_IMAGE] as? String {
            guard let url = URL(string: profileImageUrlString) else {return}
            self.profileImageUrl = url
        }
    }
    
    func follow() {
        let date = Int(NSDate().timeIntervalSince1970)
        guard let currentID = Auth.auth().currentUser?.uid else {return}
        
        userFollowingReference(userId: currentID).document(self.uid).setData([kTIMESTAMP : date])
        userFollowesReference(userId: self.uid).document(currentID).setData([kTIMESTAMP : date])
        
        // Count Increment
        
        firebaseReferences(.User).document(currentID).updateData([ kFOLLOWING: FieldValue.increment((Int64(1)))])
        
        firebaseReferences(.User).document(self.uid).updateData([ kFOLLOWERS: FieldValue.increment((Int64(1)))])
        
        
    }
    
    func unFollow() {
        guard let currentID = Auth.auth().currentUser?.uid else {return}
        
        userFollowingReference(userId: currentID).document(self.uid).delete()
        userFollowesReference(userId: self.uid).document(currentID).delete()
        
        // Count Decrement

        
        firebaseReferences(.User).document(currentID).updateData([ kFOLLOWING: FieldValue.increment((Int64(-1)))])
               
               firebaseReferences(.User).document(self.uid).updateData([ kFOLLOWERS: FieldValue.increment((Int64(-1)))])
               
        
    }
}

struct UserRelationStats {
    var followers : Int
    var following : Int
}
