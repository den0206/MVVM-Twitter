//
//  File.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/02/23.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation
import Firebase

struct AuthCredentials {
    let email : String
    let password : String
    let fullname : String
    let userName : String
    let profileImage : UIImage
}

class AuthService {
    
    static let shared = AuthService()
    
    //MARK: - Login User
    
    func loginUser(email :String, password : String, completion : AuthDataResultCallback?) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
        
    }
    
    //MARK: - Register User
    
    func registerUser (credential : AuthCredentials, completion : @escaping(Error?) -> Void) {
        
        let email = credential.email
        let userName = credential.userName
        let fullName = credential.fullname
        let password = credential.password
        
        
        // profile Image
        guard let imageData = credential.profileImage.jpegData(compressionQuality: 0.3) else {return}
        
        let fileName = NSUUID().uuidString
        let storogeRef = kSTOROGE_PROFILE_REF.child(fileName)
        
        // Put Storoge
        storogeRef.putData(imageData, metadata: nil) { (meta, error) in
            
            storogeRef.downloadURL { (url, error) in
                guard let profileImageURL = url?.absoluteString else {return}
                
                // Create User
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    
                    if error != nil {
                        return
                    }
                    
                    guard let uid = result?.user.uid else {return}
                    
                    let values : Dictionary = [
                        kEMAIL : email,
                        kUSERNAME : userName,
                        kFULLNAME : fullName,
                        kUSERID : uid,
                        kPROFILE_IMAGE : profileImageURL
                    ]
                    
                    // set fireStore
                    firebaseReferences(.User).document(uid).setData(values, completion: completion)
                    
                }
            }
        }
    
    }
    
}
