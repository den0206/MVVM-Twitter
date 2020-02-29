//
//  SearchController.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/02/29.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

private let reuserIdentifer = "userCell"

class SearchController : UITableViewController {
    
    private var users = [User]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    init() {
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchUsers()
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        
        view.backgroundColor = .white
        
        tableView.register(UserCell.self, forCellReuseIdentifier: reuserIdentifer)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
    }
    
    //MARK: - FireStore
    
    private func fetchUsers() {
        UserService.shared.fetchUsers { (users) in
            
            self.users = users
            print(users.count)
        }
    }

    
}

//MARK: - TableView delegate
extension SearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuserIdentifer, for: indexPath) as! UserCell
        cell.user = users[indexPath.row]
        return cell
    }
}

