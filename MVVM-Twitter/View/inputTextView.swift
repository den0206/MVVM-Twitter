//
//  inputTextView.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/02/24.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class InputTextView : UITextView {
    
    let placegholderLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "What are you doing?"
        
        return label
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 16)
        isScrollEnabled = false
        
        heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        addSubview(placegholderLabel)
        placegholderLabel.anchor(top : topAnchor, left: leftAnchor,paddingTop: 8,paddingLeft: 4)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func handleTextChange() {
        placegholderLabel.isHidden = !text.isEmpty
    }
    
    
}
