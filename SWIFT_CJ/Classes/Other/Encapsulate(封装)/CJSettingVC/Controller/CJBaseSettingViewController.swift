//
//  CJBaseSettingViewController.swift
//  TestTabBarController
//
//  Created by CoderChenJun on 2018/4/25.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import UIKit

class CJBaseSettingViewController: UITableViewController {
    
    public var data: NSMutableArray? = {
        let data = NSMutableArray.init()
        return data
    }()

    
    /**
     *  重写init方法，使用Group分组Style
     */
    init() {
        super.init(style: .grouped)
    }
    
    /**
     *  重写initStyle方法，使用Group分组Style
     */
    override init(style: UITableViewStyle) {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
         *  设置所有Setting的背景图片
         */
        // 因为优先级 : backgroundView > backgroundColor，所以须清空backgroundView，才能看见backgroundColor
        self.tableView.backgroundView = nil
        if let image = UIImage(named: "bg") {
            self.tableView.backgroundColor = UIColor(patternImage: image)
        }
        // 设置分割线格式左边顶到头
        if self.tableView.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return data!.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group: CJSettingGroup? = data?[section] as? CJSettingGroup
        return (group?.items.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group: CJSettingGroup? = data?[indexPath.section] as? CJSettingGroup
        let item: CJSettingItem? = group?.items[indexPath.row] as? CJSettingItem
        // 1.创建cell
        let cell = CJSettingCell.init(tableView: tableView)
        // 2.给cell传递模型数据
        cell.item = item
        cell.isLastRowInSection = group?.items.count == indexPath.row + 1
        
        // 3.返回cell
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1.取消选中这行
        tableView.deselectRow(at: indexPath, animated: true)
        // 2.模型数据
        let group: CJSettingGroup? = data?[indexPath.section] as? CJSettingGroup
        let item: CJSettingItem? = group?.items[indexPath.row] as? CJSettingItem
        
        if item?.option != nil {
            item?.option!()
        }
        else if (item is CJSettingArrowItem) {
            let arrowItem = item as? CJSettingArrowItem
            // 如果没有需要跳转的控制器
            if arrowItem?.destVcClass == nil {
                return
            }
            let vc: UIViewController? = (arrowItem?.destVcClass!.alloc())! as? UIViewController
            vc?.title = arrowItem?.title
            if let aVc = vc {
                navigationController?.pushViewController(aVc, animated: true)
            }
            
        }
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let group: CJSettingGroup? = data?[section] as? CJSettingGroup
        return group?.headerView
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let group: CJSettingGroup? = data?[section] as? CJSettingGroup
        return group?.footerView
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let group: CJSettingGroup? = data?[section] as? CJSettingGroup
        return group?.header
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let group: CJSettingGroup? = data?[section] as? CJSettingGroup
        return group?.footer
    }

    
    
    
    
    
    
    
    
    
    
    
}

















