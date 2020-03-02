//
//  ActionSheetLauncher.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/03/01.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

private let reuseIdentifer = "ActionSheetCell"

class ActionSheetLauncher : NSObject {
    
    private let user : User
    private let tableview = UITableView()
    private var window : UIWindow?
    
    private var tableViewHeight : CGFloat?
    
    //MARK: - Parts
    
    
    
    init(user : User) {
        self.user = user
        super.init()
        
        configureTableView()
    }
    
    private lazy var blackView : UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    private lazy var footerView : UIView = {
        
        let view = UIView()
        view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.anchor(left : view.leftAnchor, right: view.rightAnchor,paddingLeft: 12,paddingRight: 12)
        cancelButton.centerY(inView: view)
        cancelButton.layer.cornerRadius = 50 / 2
        
        return view
    }()
    
    private lazy var cancelButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGroupedBackground
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    
    func show() {
        print("AactionSheet\(user.fullname)")
        
        guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else {return}
        
        self.window = window
        
        window.addSubview(blackView)
        blackView.frame = window.frame
        
        window.addSubview(tableview)
        let height = CGFloat(3 * 60)
        tableview.frame = CGRect(x: 0, y: window.frame.height , width: window.frame.width, height: height)
        
        // show black view
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
            self.tableview.frame.origin.y -= height
            
        }
        
        
    }
    
    
    func configureTableView() {
        tableview.backgroundColor = .white
        tableview.delegate = self
        tableview.dataSource = self
        
        tableview.rowHeight = 40
        tableview.separatorStyle = .none
        tableview.layer.cornerRadius = 5
        tableview.isScrollEnabled = false
        
        tableview.register(ActionSheetCell.self, forCellReuseIdentifier: reuseIdentifer)
        
    }
    
    //MARK: - Actions
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.tableview.frame.origin.y += 300
        }
    }
}

extension ActionSheetLauncher : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! ActionSheetCell
        
        return cell
    }
    
    //MARK: - Footer Delegate
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    
}
