//
//  ExploreController.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/02/23.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

private let reuserIdentifer = "userCell"

class SearchController : UITableViewController {
    
    private var users = [User]()
    
    
    init() {
        super.init(style: .plain)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Explore"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: reuserIdentifer)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
  
    }
    
    //MARK: - FireStore
    
    func fetchUsers() {
        UserService.shared.fetchUsers { (users) in
            self.users = users
        }
    }
    
}

//MARK: - TableVIew Delegate

extension SearchController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuserIdentifer, for: indexPath) as! UserCell
        
        return cell
    }
}
