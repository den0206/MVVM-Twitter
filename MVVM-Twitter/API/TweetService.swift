//
//  TweetService.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/02/24.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation
import Firebase

class TweetService {
    static let shared = TweetService()
    
    
    func uploadTweet(caption : String, completion : @escaping(Error?) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let tweetId = UUID().uuidString
        
        let values = [kUSERID : uid,
                      kCAPTION : caption,
                      kRETWEETS : 0,
                      kLIKES : 0,
                      kTWEETID : tweetId,
                      kTIMESTAMP : Int(NSDate().timeIntervalSince1970)] as [String : Any]
        
        firebaseReferences(.Tweet).document(tweetId).setData(values, completion: completion)
        
    }
    
    func fetchTweets(completion : @escaping([Tweet]) -> Void) {
        
        var tweets = [Tweet]()
        
        firebaseReferences(.Tweet).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {return}

            if !snapshot.isEmpty {
                for document in snapshot.documents {
                    let tweetDictionary = document.data()
                    let tweet = Tweet(tweetId: document.documentID, dictionary: tweetDictionary)

                    tweets.append(tweet)

                }

                print(tweets.count)
                completion(tweets)
            }
        }
        
//        firebaseReferences(.Tweet).addSnapshotListener { (snapshot, error) in
//
//            guard let snapshot = snapshot else {return}
//
//            if !snapshot.isEmpty {
//                snapshot.documentChanges.forEach { (diff) in
//                    if (diff.type == .added) {
//                        let tweet = Tweet(tweetId: diff.document.documentID, dictionary: diff.document.data())
//                        tweets.append(tweet)
//                    }
//                }
//                print(tweets.count)
//            }
//        }
        
    }
    
    
}
