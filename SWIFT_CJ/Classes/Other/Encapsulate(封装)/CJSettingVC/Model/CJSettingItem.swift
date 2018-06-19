//
//  CJSettingItem.swift
//  SWIFT_CJ
//
//  Created by CoderChenJun on 2018/4/25.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import UIKit

enum CJTextAlignment : Int {
    case left = 0
    // Visually left aligned default
    case center = 1
}

//typealias CJSettingItemOption = (_ optionItem: CJSettingItem?) -> Void






class CJSettingItem: NSObject {
    
    /** titleLabel位置：居左\居中 */
    public var textAlignment: CJTextAlignment = .left

    /** cell具体的值 */
    public var keyValue: String = ""
   
    /**图标 */
    public var icon: String?
   
    /** 标题 */
    public var title: String?
    
    /** 子标题 */
    public var subtitle: String?
    
    
//    /** 点击对应的cell需要做什么事情 */
//    var option: CJSettingItemOption() = {}
    
    public var option: (() -> Void)? = nil
    
    
    
    
    
    public init(icon: String?, title: String?) {
        self.icon  = icon
        self.title = title
    }
    
    public init(title: String?) {
        self.title = title
    }
    
    

    override init() {
        super.init()
    }
    
    
    
    
}





