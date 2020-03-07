//
//  FirestoreReferences.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/02/23.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum References : String {
    case User
    case Tweet
//    case Reply
    case Following
    case Follower
    case Notification
    case likes
}

func firebaseReferences(_ reference : References) -> CollectionReference {
    
    return Firestore.firestore().collection(reference.rawValue)
}

func userFollowingReference(userId : String) -> CollectionReference {
    return firebaseReferences(.User).document(userId).collection(kFOLLOWING)
}

func userFollowesReference(userId : String) -> CollectionReference {
    return firebaseReferences(.User).document(userId).collection(kFOLLOWERS)
}

func tweetReplyRreference(tweetId : String) -> CollectionReference {
    return firebaseReferences(.Tweet).document(tweetId).collection(kRETWEETS)
}


