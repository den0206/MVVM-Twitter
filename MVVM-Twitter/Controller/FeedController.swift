//
//  FeedController.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/02/23.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class FeedController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    func configureUI() {
        view.backgroundColor = .white
        
        // naviogationBar LOGO Image
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
        
        
        
        
    }
}
