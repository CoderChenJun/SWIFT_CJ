//
//  TestCollectionViewVC.swift
//  TestTabBarController
//
//  Created by CoderChenJun on 2018/4/25.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import UIKit

class TestCollectionViewVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    
    
    
    
    
    
    
    
    private lazy var collectionView: CJBaseCollectionView = {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        let itemW: CGFloat = self.view.width / 4
        let itemH: CGFloat = itemW
        layout.itemSize                = CGSize(width: itemW, height: itemH)
        layout.minimumLineSpacing      = 0
        layout.minimumInteritemSpacing = 0
        
        
        let collectionView: CJBaseCollectionView = CJBaseCollectionView.init(frame: CGRect.init(x: 0,
                                                                                                y: 0,
                                                                                                width: UISCREEN_WIDTH,
                                                                                                height: UISCREEN_HEIGHT - HEIGHT_STATUSBAR - HEIGHT_NAVBAR - HEIGHT_TABBAR),
                                                                             collectionViewLayout: layout,
                                                                             target: self,
                                                                             refreshSelector: {
                                                                                self.refresh()
        })
        
        collectionView.delegate                     = self;
        collectionView.dataSource                   = self;
        collectionView.backgroundColor              = UIColor.clear;
        
        collectionView.register(CJPagingCollectionCell.self, forCellWithReuseIdentifier: "UICollectionViewCellString")
        
        collectionView.mj_header.beginRefreshing()
        
        return collectionView
    }()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ThemeBackgroundColor
        
        
        
        
        self.view.addSubview(self.collectionView)
        
    }
    
    
    
    @objc func refresh() {
        
        let time: TimeInterval = 1.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            //code
            print("1 秒后输出")
            
            self.collectionView.endRefresh()
            
        }
        
    }
    
    
    
    
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCellString", for: indexPath as IndexPath) as? CJPagingCollectionCell
        cell?.title     = "model.name"
        cell?.imageName = "ELive"
        // 4.超出部分裁剪(下面横线)
        cell?.clipsToBounds = true
        
        return cell!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

