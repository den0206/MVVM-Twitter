//
//  MainTabController.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/02/23.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class MainTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
    }
    
    
    func configureViewController() {
        
        let feedVC = FeedController()
        let nav1 = templateNavigationController(image: #imageLiteral(resourceName: "home_unselected"), rootViewController: feedVC)
    
        
        let exploreVC = ExploreController()
        let nav2 = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: exploreVC)

        let notificationVC = NotificationController()
        let nav3 = templateNavigationController(image: UIImage(named: "like_unselected"), rootViewController: notificationVC)
       
        
        let converastionVC = ConversationController()
        let nav4 = templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController: converastionVC)
        
        viewControllers = [nav1,nav2,nav3,nav4]
        
    }
    
    // retrun Navigation Controller
    
    func templateNavigationController(image: UIImage?, rootViewController : UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        
        return nav
    }
    
    

}
