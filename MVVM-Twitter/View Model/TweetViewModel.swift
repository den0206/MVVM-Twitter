//
//  TweetViewModel.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/02/26.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation
import UIKit

struct TweetViewModel {
    let tweet : Tweet
    let user : User
    
    var profileImageUrl : URL? {
        return tweet.user.profileImageUrl
    }
    
    var fullnameText : String {
        return "\(user.fullname)"
    }
    
    var usernameText : String {
        return "@\(user.username)"
    }
    
    var headerTimeStamp : String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a · MM/dd/yyyy"
        return formatter.string(from: tweet.timestamp)
    }
    
    var retweetAttributedString : NSAttributedString? {
        return attributedText(withValue: tweet.retweetCount, text: "Retweets")
    }
    
    var likesAttributedString : NSAttributedString? {
        return attributedText(withValue: tweet.likes, text: "Likes")
    }
    
    var timestamp : String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        
        let now = Date()
        return formatter.string(from: tweet.timestamp, to: now) ?? "2m"
    }
    
    var userInfoText : NSAttributedString {
      let title = NSMutableAttributedString(string: user.fullname, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        
        title.append(NSAttributedString(string: "@\(user.username)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14),  .foregroundColor: UIColor.lightGray]))
        
        title.append(NSAttributedString(string: " · \(timestamp)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14),  .foregroundColor: UIColor.lightGray]))
        
        return title
    }
    
    init(tweet : Tweet ) {
        self.tweet = tweet
        self.user = tweet.user
        
    }
    
    //MARK: - Helper
    
    func size (forWidth width : CGFloat) -> CGSize{
        let measurementLabel = UILabel()
        measurementLabel.text = tweet.caption
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
    }
    
    fileprivate func attributedText(withValue value : Int , text :String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)])
        
        attributedTitle.append(NSAttributedString(string: " \(text)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray]))
        
        return attributedTitle
        
    }
}
