//
//  ActionSheetCell.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/03/02.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit



class ActionSheetCell : UITableViewCell {
    var option : ActionSheetOptions? {
        didSet {
            configure()
        }
    }
    
    //MARK: - Parts
    
    private let optionImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "twitter_logo_blue")
        return iv
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Test Option"
        return label
    }()
    
    
    //MARK: - Ini
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // anchor
        addSubview(optionImageView)
        optionImageView.centerY(inView: self)
        optionImageView.anchor(left : leftAnchor, paddingLeft: 8)
        optionImageView.setDimensions(width: 36, height: 36)
        
        addSubview(titleLabel)
        titleLabel.centerY(inView: optionImageView)
        titleLabel.anchor(left : optionImageView.rightAnchor, paddingLeft: 12)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configure() {
        self.titleLabel.text = option?.description
    }
}
