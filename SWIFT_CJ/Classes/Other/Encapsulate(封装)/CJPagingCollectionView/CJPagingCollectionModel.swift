//
//  CJPagingCollectionModel.swift
//  SWIFT_CJ
//
//  Created by CoderChenJun on 2018/4/23.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import UIKit

class CJPagingCollectionModel: NSObject {
    
    var name: String? = nil
    var icon: String? = nil
    
    init(name: String, icon: String) {
        self.name = name
        self.icon = icon
    }
    
}
