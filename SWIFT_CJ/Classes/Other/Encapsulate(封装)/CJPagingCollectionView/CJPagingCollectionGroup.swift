//
//  CJPagingCollectionGroup.swift
//  TestTabBarController
//
//  Created by CoderChenJun on 2018/4/23.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import UIKit

let CJPagingCollectionGroupID = "CJPagingCollectionGroupID"

@objc protocol CJPagingCollectionGroupDelegate: NSObjectProtocol {
    @objc optional func pagingCollectionViewGroup(_ pagingCollectionViewGroup: CJPagingCollectionGroup?, pages: Int, nums: Int, name: String?)
}




class CJPagingCollectionGroup: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, CJPagingCollectionGroupDelegate {
    
    
    public weak var delegate: CJPagingCollectionGroupDelegate?
    public var superIndexPath: IndexPath?
    
    public var pagingModels: NSMutableArray? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    
    
    
    
    
    private lazy var collectionView: UICollectionView = {
        
        let X: CGFloat = 0
        let Y: CGFloat = 0
        let W: CGFloat = self.width
        let H: CGFloat = self.height
        let layout = UICollectionViewFlowLayout()
        let itemW: CGFloat = W / 4
        let itemH: CGFloat = H / 2
        layout.itemSize = CGSize(width: itemW, height: itemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let tempCollectionView = UICollectionView(frame: CGRect(x: X, y: Y, width: W, height: H), collectionViewLayout: layout)
        tempCollectionView.dataSource                     = self
        tempCollectionView.delegate                       = self
        tempCollectionView.showsHorizontalScrollIndicator = false
        tempCollectionView.backgroundColor                = UIColor.white
        tempCollectionView.register(CJPagingCollectionCell.self, forCellWithReuseIdentifier: CJPagingCollectionCellID)
        
        return tempCollectionView
    }()
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pagingModels!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model: CJPagingCollectionModel = (self.pagingModels?.object(at: indexPath.item) as? CJPagingCollectionModel)!
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CJPagingCollectionCellID, for: indexPath) as? CJPagingCollectionCell
        cell?.title     = model.name
        cell?.imageName = model.icon
        // 4.超出部分裁剪(下面横线)
        cell?.clipsToBounds = true
        
        return cell!
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model: CJPagingCollectionModel = (self.pagingModels?.object(at: indexPath.item) as? CJPagingCollectionModel)!
        
        if (self.delegate != nil) &&
           (self.delegate?.responds(to: #selector(CJPagingCollectionGroupDelegate.pagingCollectionViewGroup(_:pages:nums:name:))))! {
            self.delegate?.pagingCollectionViewGroup!(self, pages: (self.superIndexPath?.item)!, nums: indexPath.item, name: model.name)
        }
    }
    
    
    
    


}






