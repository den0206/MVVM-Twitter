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
}

func firebaseReferences(_ reference : References) -> CollectionReference {
    return Firestore.firestore().collection(reference.rawValue)
}


