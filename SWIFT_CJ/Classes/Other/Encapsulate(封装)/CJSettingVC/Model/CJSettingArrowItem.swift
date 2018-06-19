//
//  CJSettingArrowItem.swift
//  SWIFT_CJ
//
//  Created by CoderChenJun on 2018/4/25.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation

class CJSettingArrowItem: CJSettingItem {
    
    /** 点击这行cell需要跳转的控制器 */
    var destVcClass: AnyClass?

    
    init(icon: String?, title: String?, destVcClass: AnyClass?) {
        super.init()
        self.icon  = icon
        self.title = title
        self.destVcClass = destVcClass
        
    }
    
    init(title: String?, destVcClass: AnyClass?) {
        super.init()
        self.title = title
        self.destVcClass = destVcClass
    }
    
}
