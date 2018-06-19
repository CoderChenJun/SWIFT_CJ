//
//  CJPagingCollectionView.swift
//  SWIFT_CJ
//
//  Created by CoderChenJun on 2018/4/23.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import UIKit

let CJPagingCollectionViewH           = 200
let CJPagingCollectionViewOnePageNums = 8



@objc protocol CJPagingCollectionViewDelegate: NSObjectProtocol {
    @objc optional func pagingCollectionView(_ pagingCollectionView: CJPagingCollectionView?, pages: Int, nums: Int, name: String?)
}




class CJPagingCollectionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, CJPagingCollectionGroupDelegate {
    
    
    public weak var delegate: CJPagingCollectionViewDelegate?
    
    public var pagingModels: NSMutableArray? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    public func reloadData() {
        self.collectionView.reloadData()
        self.pageControl.currentPage = 0
    }
    
    
    
    
    
    
    private lazy var collectionView: UICollectionView = {
        
        let X: CGFloat = 0
        let Y: CGFloat = 0
        let W: CGFloat = self.width
        let H: CGFloat = self.height - 30
        let layout = UICollectionViewFlowLayout()
        layout.itemSize                = CGSize(width: W, height: H)
        layout.minimumLineSpacing      = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection         = .horizontal;
        
        let tempCollectionView = UICollectionView(frame: CGRect(x: X, y: Y, width: W, height: H), collectionViewLayout: layout)
        tempCollectionView.dataSource                     = self
        tempCollectionView.delegate                       = self
        tempCollectionView.showsHorizontalScrollIndicator = false
        tempCollectionView.isPagingEnabled                = true;
        tempCollectionView.backgroundColor                = UIColor.white
        tempCollectionView.register(CJPagingCollectionGroup.self, forCellWithReuseIdentifier: CJPagingCollectionGroupID)
        
        return tempCollectionView
    }()
    
    
    
    
    
    
    private lazy var pageControl: UIPageControl = {
        
        let tempPageControl = UIPageControl()
//        tempPageControl.pageIndicatorTintColor        = UIColor.white
        tempPageControl.pageIndicatorTintColor        = UIColor.gray
        tempPageControl.currentPageIndicatorTintColor = CJColor(r: 51, g: 204, b: 255, a: 1)
        tempPageControl.isUserInteractionEnabled      = false
        tempPageControl.setValue(UIImage(named: "cj_ad_selected_7x7_"), forKeyPath: "_currentPageImage")
        tempPageControl.setValue(UIImage(named: "cj_ad_normal_7x7_"),   forKeyPath: "_pageImage")
        
        return tempPageControl
    }()
    
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.collectionView)
        self.collectionView.x      = 0
        self.collectionView.y      = 0
        self.collectionView.width  = self.width
        self.collectionView.height = self.height - 30
        
        self.addSubview(self.pageControl)
        self.pageControl.width  = self.width
        self.pageControl.height = 30
        self.pageControl.x      = self.width - self.pageControl.width
        self.pageControl.y      = self.height - self.pageControl.height
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 1.获取滚动的偏移量
        let offsexX: CGFloat = scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5
        // 2.计算pageControl的currentIndex
        self.pageControl.currentPage = Int(offsexX / scrollView.bounds.size.width)
    }
    
    
    
    
    
    
    // MARK: - ===============================UICollectionViewDataSource===============================
    // MARK: - ===============================UICollectionViewDataSource===============================
    // MARK: - ===============================UICollectionViewDataSource===============================
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.pagingModels == nil {
            return 0
        }
        let pageNum = ((self.pagingModels?.count)! - 1) / Int(CJPagingCollectionViewOnePageNums) + 1
        // MARK: - 设置pageControl.numberOfPages
        pageControl.numberOfPages = pageNum
        return pageNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CJPagingCollectionGroupID, for: indexPath) as? CJPagingCollectionGroup
        self.setupCellData(cell: cell, at: indexPath)
        cell?.superIndexPath = indexPath
        cell?.delegate = self
        
        return cell!
    }
    // MARK: - ===============================UICollectionViewDataSource===============================
    // MARK: - ===============================UICollectionViewDataSource===============================
    // MARK: - ===============================UICollectionViewDataSource===============================
    
    
    
    func setupCellData(cell: CJPagingCollectionGroup?, at indexPath: IndexPath?) {
        // 0页 : 0 ~ 7
        // 1页 : 8 ~ 15
        // 2页 : 16 ~ 23
        // 1.取出起始位置 & 终点位置
        let startIndex = (indexPath?.item)! * Int(CJPagingCollectionViewOnePageNums)
        var endIndex   = ((indexPath?.item)! + 1) * Int(CJPagingCollectionViewOnePageNums) - 1
        
        // 2.判断越界问题
        if (endIndex > (self.pagingModels?.count)! - 1) {
            endIndex = (self.pagingModels?.count)! - 1
        }
        // 3.取出数据,并且赋值给Cell
        cell?.pagingModels = NSMutableArray.init()
        for i in startIndex..<endIndex + 1 {
            cell?.pagingModels?.add(self.pagingModels![i])
        }
    }
    
    
    
    
    
    
    // MARK: - ===============================CJMotionMenuGroupCellCellDelegate===============================
    // MARK: - ===============================CJMotionMenuGroupCellCellDelegate===============================
    // MARK: - ===============================CJMotionMenuGroupCellCellDelegate===============================
    func pagingCollectionViewGroup(_ pagingCollectionViewGroup: CJPagingCollectionGroup?, pages: Int, nums: Int, name: String?) {
        if (self.delegate != nil) &&
           (self.delegate?.responds(to: #selector(CJPagingCollectionViewDelegate.pagingCollectionView(_:pages:nums:name:))))! {
            self.delegate?.pagingCollectionView!(self, pages: pages, nums: nums, name: name)
        }
    }
    // MARK: - ===============================CJMotionMenuGroupCellCellDelegate===============================
    // MARK: - ===============================CJMotionMenuGroupCellCellDelegate===============================
    // MARK: - ===============================CJMotionMenuGroupCellCellDelegate===============================

    
    
    
    
    
    
}












