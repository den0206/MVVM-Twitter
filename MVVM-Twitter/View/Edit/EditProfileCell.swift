//
//  EditProfileCell.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/03/08.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

protocol EditProfileCellDelegate : class{
    func handleUpdateUserInfo(_ cell : EditProfileCell)
}

class EditProfileCell : UITableViewCell {
    
    var viewmodel : EditProfileViewModel? {
        didSet {
            configure()
        }
    }
    
    weak var delegate : EditProfileCellDelegate?
    
    //MARK: - Parts
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var infoTextField : UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.textAlignment = .left
        tf.textColor = .twitterBlue
        tf.addTarget(self, action: #selector(handleUpdateUserInfo), for: .editingDidEnd)
        tf.text = "Tset attribution"
        return tf
    }()
    
    let bioTextView : InputTextView = {
        let tv = InputTextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.textColor = .twitterBlue
        tv.placegholderLabel.text = "Bio"
        return tv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(titleLabel)
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.anchor(top : topAnchor, left: leftAnchor,paddingTop: 12, paddingLeft: 16)
        
        addSubview(infoTextField)
        infoTextField.anchor(top : topAnchor, left: titleLabel.rightAnchor,bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 16, paddingRight: 8)
        
        addSubview(bioTextView)
        bioTextView.anchor(top : topAnchor, left: titleLabel.rightAnchor,bottom: bottomAnchor, right: rightAnchor, paddingTop: 4,paddingLeft: 14, paddingRight: 8)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateUserInfo), name: UITextView.textDidEndEditingNotification, object: nil)
        
        
        
    }
    
    private func configure() {
        guard let viewmodel = viewmodel else {return}
        
        infoTextField.isHidden = viewmodel.shouldHideTextField
        bioTextView.isHidden = viewmodel.shouldHideTextView
        
        titleLabel.text = viewmodel.titleText
        
        infoTextField.text = viewmodel.optionLabel
        
        bioTextView.placegholderLabel.isHidden = viewmodel.shouldHidePlaceholderlabel
        bioTextView.text = viewmodel.optionLabel
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleUpdateUserInfo() {
        delegate?.handleUpdateUserInfo(self)
    }
    
    
    
}
