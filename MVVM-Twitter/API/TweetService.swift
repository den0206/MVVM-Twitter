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
    
    var newTweetListner : ListenerRegistration?
    
    
    func uploadTweet(caption : String, type : UploadTweetConfiguration,  completion : @escaping(Error?) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let tweetId = UUID().uuidString
        
        var values = [kUSERID : uid,
                      kCAPTION : caption,
                      kRETWEETS : 0,
                      kLIKES : 0,
                      kTWEETID : tweetId,
                      kTIMESTAMP : Int(NSDate().timeIntervalSince1970)] as [String : Any]
        
        
        switch type {
        case .tweet:
            firebaseReferences(.Tweet).document(tweetId).setData(values, completion: completion)
            
        case .reply(let tweet) :
            values[kREPLYINGTO] = tweet.user.username
            
            // create retweet Collection eaxh tweet
            tweetReplyRreference(tweetId: tweet.tweetId).document(tweetId).setData(values, completion: completion)
            
            // retweet count Increment
            firebaseReferences(.Tweet).document(tweet.tweetId).updateData([kRETWEETS : FieldValue.increment((Int64(1)))])
            
        }
        
        
    }
    
    func fetchTweets(completion : @escaping([Tweet]) -> Void) {
        
        var tweets = [Tweet]()
        
//        firebaseReferences(.Tweet).getDocuments { (snapshot, error) in
//            guard let snapshot = snapshot else {return}
//
//            if !snapshot.isEmpty {
//                for document in snapshot.documents {
//                    let tweetDictionary = document.data()
//                    let tweet = Tweet(tweetId: document.documentID, dictionary: tweetDictionary)
//
//                    tweets.append(tweet)
//
//                }
//
//                print(tweets.count)
//                completion(tweets)
//            }
//        }
        
        newTweetListner = firebaseReferences(.Tweet).addSnapshotListener { (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            
            if !snapshot.isEmpty {
                snapshot.documentChanges.forEach { (diff) in
                    if (diff.type == .added) {
                        guard let uid = diff.document.data()[kUSERID] as? String else {return}
                        
                        
                        UserService.shared.fetchUser(uid: uid) { (user) in
                            let tweet = Tweet(user: user, tweetId: diff.document.documentID, dictionary: diff.document.data())
                            tweets.append(tweet)
                            
                            completion(tweets)
                        }
                        
                    }
                }
//                completion(tweets)
            }
        }
        
        
    }
    
    func fetchTweetsForUser(user : User, completion : @escaping([Tweet]) -> Void) {
        
        var tweets = [Tweet]()
        
        firebaseReferences(.Tweet).whereField(kUSERID, isEqualTo: user.uid ).getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            
            if !snapshot.isEmpty {
                for document in snapshot.documents {
                    let dictionary = document.data()
                    let tweet = Tweet(user: user, tweetId: document.documentID, dictionary: dictionary)
                    
                    tweets.append(tweet)
                    
                }
                
                completion(tweets)
            }
        }
    }
    
    
}
