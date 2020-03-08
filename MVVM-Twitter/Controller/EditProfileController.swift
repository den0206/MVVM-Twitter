//
//  EditProfileController.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/03/07.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

private let reuserIdentifer = "EditProfileCell"

protocol EditProfileControllerDelegate : class {
    func handleLogout()
    func reload(_ controller : EditProfileController, user : User)
}

class EditProfileController : UITableViewController {

    
    //MARK: - Vars
    private var user : User
    private lazy var header = EditProfileHeader(user: user)
    private let footerView = EditProfileFooter()
    private let imagePicker = UIImagePickerController()
    private var userinfoCganged = false
    var delegate : EditProfileControllerDelegate?
    
    private  var imageChanged : Bool {
        return selectedImage != nil
    }
    
    private var selectedImage : UIImage? {
        didSet {
            header.profileImageView.image = selectedImage
        }
    }
    
    
    
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
        
        configureImagepicker()
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
        
        tableView.tableFooterView = footerView
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        footerView.delegate = self
        
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: reuserIdentifer)
        
        
    }
    
    private func configureImagepicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    //MARK: - Actions
    
    @objc func handleSave() {
        
        // only Image
        
        if imageChanged && !userinfoCganged {
            print("Image")
        }
        
        // only userinfo
        if userinfoCganged && !imageChanged {
            UserService.shared.saveUserData(user: user) { (error) in
                // reload profileVC
                self.delegate?.reload(self, user: self.user)
            }
        }
        
        // both
        if userinfoCganged && imageChanged {
            print("Both")
        }
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Tableview Delegate

extension EditProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuserIdentifer, for: indexPath) as! EditProfileCell
        cell.delegate = self
        
        guard let option = EditProfileOptions(rawValue: indexPath.row) else {return cell}
        cell.viewmodel = EditProfileViewModel(user: user, option: option)
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let option = EditProfileOptions(rawValue: indexPath.row) else {return 0}
        
        if option == .bio {
            return 100
        }
        
        return 48
    }
}

//MARK: - EditProfileCell Delegate

extension EditProfileController : EditProfileCellDelegate {
    func handleUpdateUserInfo(_ cell: EditProfileCell) {
        
        guard let viewmodel = cell.viewmodel else {return}
        userinfoCganged = true
        navigationItem.rightBarButtonItem?.isEnabled = true
        
        switch viewmodel.option {

        case .fullname:
            guard let fullname = cell.infoTextField.text else {return}
            user.fullname = fullname
        case .username:
            guard let username = cell.infoTextField.text else {return}
            user.username = username
        case .bio :
            user.bio = cell.bioTextView.text
        }
        
    }
    
    
}

//MARK: - EditProfileHeaderDelegate

extension EditProfileController : EditProfileHeaderDelegate {
    func handlePhotoButton() {
        present(imagePicker, animated: true, completion: nil)
    }
}

//MARK: - EditProfileFooterDelegate

extension EditProfileController : EditProfileFooterDelegate {
    func handleLogout() {
        
        let alert = UIAlertController(title: nil, message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        
        // Actions
        
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (_) in
            
            self.dismiss(animated: true) {
                self.delegate?.handleLogout()
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    
}

//MARK: - ImagepickerController Delgate

extension EditProfileController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {return}
        self.selectedImage = image
        
        navigationItem.rightBarButtonItem?.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
}
