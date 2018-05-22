//
//  TestTableViewVC.swift
//  TestTabBarController
//
//  Created by CoderChenJun on 2018/4/23.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import UIKit

class TestTableViewVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CJPagingCollectionViewDelegate {
    
    
    private lazy var tableView: CJBaseTableView = {
        let tableView = CJBaseTableView.init(frame: CGRect.init(x: 0.0,
                                                                y: 0.0,
                                                                width: self.view.width,
                                                                height: UISCREEN_HEIGHT - HEIGHT_STATUSBAR - HEIGHT_NAVBAR - HEIGHT_TABBAR),
                                             tableViewStyle: .plain,
                                             tableCellClass: UITableViewCell.self,
                                             forCellReuseIdentifier: "cell",
                                             target: self,
                                             refreshSelector: {
                                                self.refresh()
        })
        tableView.delegate   = self
        tableView.dataSource = self
        
        tableView.mj_header.beginRefreshing()
        
        return tableView
    }()
    
    
    
    private lazy var pagingCollectionView: CJPagingCollectionView = {
        
        let pagingCollectionView = CJPagingCollectionView(frame: CGRect(x: 0,
                                                                        y: HEIGHT_STATUSBAR + HEIGHT_NAVBAR,
                                                                        width: self.view.width,
                                                                        height: CGFloat(CJPagingCollectionViewH)))
        pagingCollectionView.delegate = self
        
        
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
        
//        print(pagingCollectionView.pagingModels as Any)
//        for model in array as! [Any] {
//            print((model as! CJPagingCollectionModel).name as Any)
//        }
        
        pagingCollectionView.reloadData()
        pagingCollectionView.backgroundColor = UIColor.white
        
        return pagingCollectionView
    }()
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.tableView)
        
        self.tableView.addSubview(self.pagingCollectionView)
        
        
        
        
        
        
        
        
        self.pagingCollectionView.y = -self.pagingCollectionView.height - 10;
        
        let ignoreHeight = 10 + self.pagingCollectionView.height;
        
        self.tableView.contentInset = UIEdgeInsetsMake(ignoreHeight, 0, 0, 0);
        self.tableView.mj_header.ignoredScrollViewContentInsetTop = ignoreHeight;
        

        
        
    }
    
    
    
    
    
    
    
    
    
    
    @objc func refresh() {
        
        let time: TimeInterval = 1.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            //code
            print("1 秒后输出")
            
            self.tableView.endRefresh()
            
//            self.present(UIViewController(), animated: true, completion: {
//                
//            })
            
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let temp = Int(arc4random_uniform(100))+1
        return temp
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "indexPath\(indexPath.row)"
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    
    
    
    
    
}








