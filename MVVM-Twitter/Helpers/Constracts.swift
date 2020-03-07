//
//  Constracts.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/02/23.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation
import Firebase



public let kSTOROGE_REF = Storage.storage().reference()
public let kSTOROGE_PROFILE_REF = kSTOROGE_REF.child(kPROFILE_IMAGE)


//MARK: - User

public let kUSERID = "userID"
public let kEMAIL = "email"
public let kPASSWORD = "password"
public let kPROFILE_IMAGE = "profileImage"
public let kUSERNAME = "username"
public let kFULLNAME = "fullname"
public let kFOLLOWING = "FOLLOWING"
public let kFOLLOWERS = "FOLLOWER"

//MARK: - Tweet

public let kTIMESTAMP = "timestamp"
public let kLIKES = "likes"
public let kRETWEETS = "retweets"
public let kCAPTION = "caption"
public let kTWEETID = "tweetId"
public let kREPLYINGTO = "replyingTo"
public let kUSERIDTO = "userIDTo"

public let kNOTIFICATION = "NOTIFICATION"
public let  kTYPE = "type"




