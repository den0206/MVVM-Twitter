//
//  TweetController.swift
//  MVVM-Twitter
//
//  Created by 酒井ゆうき on 2020/02/29.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

private let headerIdentifer = "TweetHeader"
private let reuserIdentifer = "TweetCell"

class TweetController : UICollectionViewController {
    
    private let  tweet : Tweet
    private let actionSheetLauncher : ActionSheetLauncher
    
    private var replies = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    init(tweet : Tweet) {
        self.tweet = tweet
        self.actionSheetLauncher = ActionSheetLauncher(user: tweet.user)
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        fetchReply()
    }
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuserIdentifer)
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifer)
    }
    
    //MARK: - Heplers
    
    private func fetchReply() {
        TweetService.shared.fetchReply(tweetId: tweet.tweetId) { (tweets) in
            self.replies = tweets
        }
    }
}



//MARK: - CoolectionView Delegate


extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return replies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuserIdentifer, for: indexPath) as! TweetCell
        
        cell.tweet = replies[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifer, for: indexPath) as! TweetHeader
        
        header.delegate = self
        header.tweet = tweet
        
        return header
    }
}

//MARK: - Collectionview FlowLayout

extension TweetController  : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let viewModel = TweetViewModel(tweet: tweet)
        let captionSize = viewModel.size(forWidth: view.frame.width).height
        
        return CGSize(width: view.frame.width, height: captionSize + 260)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewModel = TweetViewModel(tweet: replies[indexPath.item])
        let captionSize = viewModel.size(forWidth: view.frame.width).height

        
        return CGSize(width: view.frame.width, height: captionSize + 60)
    }
    
}

//MARK: - TweetHeader Delegates

extension TweetController : TweetHeaderDelegate {
    
    func handleOptionButtonPressed() {
        actionSheetLauncher.show()
    }

}

