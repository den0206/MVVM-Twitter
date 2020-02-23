//
//  ExploreController.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/02/23.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class ExploreController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Explore"
  
    }
}
