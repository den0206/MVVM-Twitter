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
    
    func fetxhSingleTweet(withTweetId tweetId : String, completion : @escaping(Tweet) -> Void) {
        
        firebaseReferences(.Tweet).document(tweetId).getDocument { (snapshot, error) in

            guard let snapshot = snapshot else {return}

            if snapshot.exists {
                let dictionary = snapshot.data()!
                let uid = dictionary[kUSERID] as! String
           
                UserService.shared.fetchUser(uid: uid) { (user) in
                    let tweet = Tweet(user: user, tweetId: tweetId, dictionary: dictionary)
                    
                    completion(tweet)
                }
            }
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
    
    func fetchReply(tweetId : String, completion : @escaping([Tweet]) -> Void) {
        
        var replies = [Tweet]()
        
        tweetReplyRreference(tweetId: tweetId).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {return}
            
            if !snapshot.isEmpty {
                for document in snapshot.documents {
                    let dictionary = document.data()
                    
                    self.fetchTweetOfUser(userId: dictionary[kUSERID] as! String) { (user) in
                        let reply = Tweet(user: user, tweetId: tweetId, dictionary: dictionary)
                        replies.append(reply)
                        
                        completion(replies)
                    }
                }
            }
        }
    }
    
    func likeTweet(tweet : Tweet, completion : @escaping(Error?) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        // adjust Count
        let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
        firebaseReferences(.Tweet).document(tweet.tweetId).updateData([kLIKES : likes])
        
        if tweet.didLike {
            // remove Like
            firebaseReferences(.Tweet).document(tweet.tweetId).collection(kLIKES).document(currentUid).delete { (error) in
                completion(error)
            }
        } else {
            // add Like
            firebaseReferences(.Tweet).document(tweet.tweetId).collection(kLIKES).document(currentUid).setData([kTIMESTAMP : Int(NSDate().timeIntervalSince1970)]) { (error) in
                completion(error)
            }
        }
        
        
        
        
    }
    
    func checkIfUserLikedTweet(_ tweet : Tweet, completion : @escaping(Bool) -> Void) {
       guard let currentUid = Auth.auth().currentUser?.uid else {return}
        firebaseReferences(.Tweet).document(tweet.tweetId).collection(kLIKES).document(currentUid).getDocument { (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            
            completion(snapshot.exists)
        }

    }
    
    //MARK: - Helper
    
    func fetchTweetOfUser(userId : String, completion : @escaping(User) -> Void) {
        
        firebaseReferences(.User).document(userId).getDocument { (snapshot, error) in
            guard let snapshot = snapshot else {return}
            if snapshot.exists {
                let dictionary = snapshot.data() as! [String : Any]
                let user = User(uid: snapshot.documentID, dictionary: dictionary)
                completion(user)
            }
        }
    }
    
    
}
