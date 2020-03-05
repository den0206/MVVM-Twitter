//
//  NotificationService.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/03/04.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Firebase

struct NotificationService {
    static let shared = NotificationService()
    
    func uploadNotification(toUser user : User, type : NotificationType, tweetID : String? = nil) {
        guard let  currentID = Auth.auth().currentUser?.uid else {return}
        
        var values : [String : Any] = [
            kTIMESTAMP : Int(NSDate().timeIntervalSince1970),
            kUSERID : currentID,
            kTYPE : type.rawValue
        ]
        
        if let tweetID = tweetID {
            values[kTWEETID] = tweetID
        }
        
        firebaseReferences(.User).document(user.uid).collection(kNOTIFICATION).document().setData(values)
        
    }
    
    func fetchNotification(completion : @escaping([Notification]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        var notifications = [Notification]()
        
        firebaseReferences(.User).document(uid).collection(kNOTIFICATION).getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            
            if !snapshot.isEmpty {
                for document in snapshot.documents {
                    let dictionary = document.data()
                    let uid = dictionary[kUSERID] as! String
                    
                    UserService.shared.fetchUser(uid: uid) { (user) in
                        
                        let notification = Notification(user: user, dictionary: dictionary)
                        notifications.append(notification)
                        completion(notifications)
                         
                    }
                }
            }
        }
        
    }
}
