//
//  TestCollectionViewVC.swift
//  TestTabBarController
//
//  Created by CoderChenJun on 2018/4/25.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import UIKit

class TestCollectionViewVC: UIViewController, CJPagingCollectionViewDelegate {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pagingCollectionView = CJPagingCollectionView(frame: CGRect(x: 0,
                                                                        y: HEIGHT_STATUSBAR + HEIGHT_NAVBAR,
                                                                        width: self.view.width,
                                                                        height: CGFloat(CJPagingCollectionViewH)))
        pagingCollectionView.delegate = self
        self.view.addSubview(pagingCollectionView)
        
        
        let array = NSMutableArray.init()
        array.add(CJPagingCollectionModel.init(name: "ELive",       icon: "ELive"))
        array.add(CJPagingCollectionModel.init(name: "EPsychology", icon: "EPsychology"))
        array.add(CJPagingCollectionModel.init(name: "ESchool",     icon: "ESchool"))
        array.add(CJPagingCollectionModel.init(name: "EStore",      icon: "EStore"))
        array.add(CJPagingCollectionModel.init(name: "ERights",     icon: "ERights"))
        array.add(CJPagingCollectionModel.init(name: "EJob",        icon: "EJob"))
        array.add(CJPagingCollectionModel.init(name: "EPolicy",     icon: "EPolicy"))
        array.add(CJPagingCollectionModel.init(name: "EJiFenRuXue", icon: "EJiFenRuXue"))
        array.add(CJPagingCollectionModel.init(name: "EService",    icon: "EService_Zhenhai"))
        pagingCollectionView.pagingModels = array
        
        print(pagingCollectionView.pagingModels as Any)
        
        for model in array as! [Any] {
            print((model as! CJPagingCollectionModel).name as Any)
        }
        
        pagingCollectionView.reloadData()
        pagingCollectionView.backgroundColor = UIColor.white
        
    }
    
    
    
    
    func pagingCollectionView(_ pagingCollectionView: CJPagingCollectionView?, pages: Int, nums: Int, name: String?) {
        print("IndexViewController --- CJpagingCollectionView分页 --- 第\(Int(pages))页 第\(Int(nums))个 \(String(describing: name))")
        
        
        
        CJLog("IndexViewController --- CJpagingCollectionView分页 --- 第\(Int(pages))页 第\(Int(nums))个 \(String(describing: name))")
        print("items: Any...")
    }
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}

