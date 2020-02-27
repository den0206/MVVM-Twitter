//
//  ProfileHeaderView.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/02/27.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

private let reuserIdentifier = "profileFilterCell"

protocol ProfileFilterViewDelegate : class {
    func filterView(_ view : ProfileFilterView, didSelect index: IndexPath)
}

class ProfileFilterView : UIView {
    
    weak var delegate : ProfileFilterViewDelegate?
    
    
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
//    private let underLineView : UIView = {
//        let view = UIView()
//        view.backgroundColor = . twitterBlue
//        return view
//    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(ProfileFilterCell.self, forCellWithReuseIdentifier: reuserIdentifier)
        
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProfileFilterView : UICollectionViewDataSource {

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuserIdentifier, for: indexPath) as! ProfileFilterCell
        
        return cell
    }

    
}

extension ProfileFilterView : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath)
//        let xPosition = cell?.frame.origin.x ?? 0
//
//        UIView.animate(withDuration: 0.3) {
//            self.underLineView.frame.origin.x = xPosition
//        }
        
        delegate?.filterView(self, didSelect: indexPath)
    }

}


extension ProfileFilterView : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 3, height: frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
