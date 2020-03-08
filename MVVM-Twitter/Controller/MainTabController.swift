//
//  MainTabController.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/02/23.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {
    
    //MARK: - Parts
    
    var user : User? {
        didSet {
            guard let nav = viewControllers?[0] as? UINavigationController else {return}
            guard let feed = nav.viewControllers.first as? FeedController else {return}
            
            feed.user = user
            
        }
    }
    
    let actionButton : UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .twitterBlue
//        handleLogout()
        checkUserIsLogin()
        
        
    }
    
    func configureUI() {
        
        view.addSubview(actionButton)
        actionButton.anchor(bottom : view.safeAreaLayoutGuide.bottomAnchor,right: view.rightAnchor, paddingBottom: 64, paddingRight: 16)
        actionButton.setDimensions(width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
        
        
    }
    
    
    func configureViewController() {
        
        let feedVC = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav1 = templateNavigationController(image: #imageLiteral(resourceName: "home_unselected"), rootViewController: feedVC)
    
        
        let exploreVC = SearchController(config: .searchUser)
        let nav2 = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: exploreVC)

        let notificationVC = NotificationController()
        let nav3 = templateNavigationController(image: UIImage(named: "like_unselected"), rootViewController: notificationVC)
       
        
        let converastionVC = ConversationController()
        let nav4 = templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController: converastionVC)
        
        viewControllers = [nav1,nav2,nav3,nav4]
        
    }
    
    //MARK: - Actions
      
      @objc func actionButtonTapped() {
        guard let user = self.user else {return}
          
        let controller = UploadTweetController(user: user, config: .tweet)
        
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
      }
      
    
    //MARK: - Helpers
    
    func checkUserIsLogin() {
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginVC())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } else {
            configureViewController()
            configureUI()
            fetchCurrentUser()
        }
        
    }
    
    private func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        UserService.shared.fetchUser(uid: uid) { (user) in
            self.user = user
        }
        
        
        
    }
    
    // retrun Navigation Controller
    
    func templateNavigationController(image: UIImage?, rootViewController : UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        
        return nav
    }
//
    func handleLogout() {
        do {
            try Auth.auth().signOut()
            let nav = UINavigationController(rootViewController: LoginVC())
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } catch let error {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
}
