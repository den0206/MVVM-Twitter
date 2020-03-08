//
//  EditProfileController.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/03/07.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class EditProfileController : UITableViewController {
    
    private var user : User
    private lazy var header = EditProfileHeader(user: user)
    private let imagePicker = UIImagePickerController()
 
    
    init(user : User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        print(user)
        
        configureNavigationController()
        configureTableview()
        
    }
    
    private func configureNavigationController() {
        navigationController?.navigationBar.barTintColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.title = "EditProfile"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    private func configureTableview() {
        tableView.tableHeaderView = header
        header.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        header.delegate = self
        
    }
    
    //MARK: - Actions
    
    @objc func handleSave() {
        print("Save")
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension EditProfileController : EditProfileHeaderDelegate {
    func handlePhotoButton() {
        print("Photo")
    }
}
