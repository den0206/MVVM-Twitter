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
    
    func fetchUsers(completion : @escaping([User]) -> Void) {
        
        var users = [User]()
        
        firebaseReferences(.User).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {return}
            
            if !snapshot.isEmpty {
                for document in snapshot.documents {
                    let dictionary = document.data()
                    let user = User(uid: document.documentID, dictionary: dictionary)
                    
                    users.append(user)
                    
                }
                completion(users)
            }
        }
    }
    
    func fetchUserIsFollowed(uid : String, completion : @escaping(Bool) -> Void) {
        guard let currentId = Auth.auth().currentUser?.uid else {return}
        

        userFollowingReference(userId: currentId).document(uid).addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else {return}
            
            completion(snapshot.exists)
        }
        
    }
    
    func fetchStats(userId : String, completion : @escaping(UserRelationStats?) -> Void) {
        firebaseReferences(.User).document(userId).addSnapshotListener{ (snapshot, error) in
            guard let snapshot = snapshot else {return}
            
            if snapshot.exists {
                let dictionary = snapshot.data()!
                
                let following = dictionary[kFOLLOWING] as? Int ?? 0
                let follwers = dictionary[kFOLLOWERS] as? Int ?? 0
                
                let stats = UserRelationStats(followers: follwers, following: following)
                completion(stats)
            
            } else {
                completion(nil)
            }
        }
    }
    
    func fetchFollowingIDs(uid : String, completion : @escaping([String]) -> Void) -> ListenerRegistration? {
        var followingIds = [uid]
        
        return firebaseReferences(.User).document(uid).collection(kFOLLOWING).addSnapshotListener { (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            
            if !snapshot.isEmpty {
                
                
                snapshot.documentChanges.forEach { diff in
                    
                    
                    if (diff.type == .added) {
                        
                        let followingId = diff.document.documentID
                        followingIds.append(followingId)
                    }
                    
                    if (diff.type == .removed) {
                        let unFollowingId = diff.document.documentID
                        followingIds.remove(at: followingIds.firstIndex(of: unFollowingId)!)
                    }
                  
                }
                completion(followingIds)
            } else {
                completion([uid])
            }
            
        }
        
    }
    
   

    
}
