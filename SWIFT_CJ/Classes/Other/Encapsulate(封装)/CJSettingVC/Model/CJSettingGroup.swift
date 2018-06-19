//
//  CJSettingGroup.swift
//  SWIFT_CJ
//
//  Created by CoderChenJun on 2018/4/25.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import UIKit

class CJSettingGroup: NSObject {
    
    /** 头部标题 */
    public var header: String = ""
    /** 头部标题View */
    public var headerView: UIView?
    
    /** 尾部标题 */
    public var footer: String = ""
    /** 尾部标题View */
    public var footerView: UIView?
   
   
    /** 存放着这组中所有行的模型数据(这个数组中都是CJSettingItem对象) */
    public var items: NSMutableArray = {
        let items = NSMutableArray.init()
        return items
    }()
    
    public init(items: NSMutableArray) {
        self.items = items
    }
    
    override init() {
        super.init()
    }
    
    
}




