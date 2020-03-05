//
//  NotificationController.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/02/23.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

private let reuserIdentifer = "NotificationCell"

class NotificationController : UITableViewController {
    
    private var notifications = [Notification]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchNotification()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Notification"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuserIdentifer)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
    }
    
    // fetch Notification
    
    private func fetchNotification() {
        
        NotificationService.shared.fetchNotification { (notifications) in
            self.notifications = notifications
        }
        
    }
    
    
}

//MARK: - TableView Delegate


extension NotificationController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuserIdentifer, for: indexPath) as! NotificationCell
        
        cell.delegate = self
        cell.notification = notifications[indexPath.row]
        
        return cell
    }
    
}

//MARK: - Notification Delegate

extension NotificationController : NotificationCellDelegate {
    func handleProfilaImageTapped(_ cell: NotificationCell) {
        print("image")
    }
    
    func handleFollowButtonTapped(_ cell: NotificationCell) {
        print("Button")
    }
    
    
}
