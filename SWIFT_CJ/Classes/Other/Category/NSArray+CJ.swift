//
//  NSArray+CJ.swift
//  SWIFT_CJ
//
//  Created by CoderChenJun on 2018/4/17.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import UIKit

extension NSArray {
    
    /**
     * iOS开发中，判断数组是否为空的方法
     *
     * @param array 传入数组
     * @return nil、NULL、NSNull、count=0 都是YES   剩下为NO
     */
    public static func isBlankArray(_ array: [Any]?) -> Bool {
        if array == nil || array == nil {
            return true
        }
        if (array is NSNull) {
            return true
        }
        if array?.count == 0 {
            return true
        }
        return false
    }
    
    
    
}
