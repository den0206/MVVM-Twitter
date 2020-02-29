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
    private var filterUser = [User]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var isSearchMode : Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
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
        configureSaerchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    
    //MARK: - Helpers
    
    private func configureUI() {
        
        view.backgroundColor = .white
        navigationItem.title = "Explore"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: reuserIdentifer)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
    }
    
    private func configureSaerchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a User"
        navigationItem.searchController = searchController
        definesPresentationContext = false
        
    }
    
    //MARK: - FireStore
    
    private func fetchUsers() {
        UserService.shared.fetchUsers { (users) in
            
            self.users = users
           
        }
    }

    
}

//MARK: - TableView delegate
extension SearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchMode {
            return filterUser.count
        } else {
            return users.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var user : User
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuserIdentifer, for: indexPath) as! UserCell
        
        if isSearchMode {
            user = filterUser[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        cell.user = user
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var user : User
        
        if isSearchMode {
            user = filterUser[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        
        let profileVC = ProfileController(user: user)
        navigationController?.pushViewController(profileVC, animated: true)
        
        
    }
}

//MARK: - UISearchResultsUpdating Delegate

extension SearchController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {return}
        filterUser = users.filter({ $0.username.contains(searchText)})
    }

}

