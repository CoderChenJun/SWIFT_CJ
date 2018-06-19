//
//  CJStringToolkit.swift
//  SWIFT_CJ
//
//  Created by CoderChenJun on 2018/4/13.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import UIKit

class CJStringToolkit: NSObject {
    
    /**
     *  删除字符串中的 空格
     *
     *  @param str 传入带空格的字符串
     *
     *  @return 删除完空格的字符串
     */
    public static func clearEmpty(_ str: String?) -> String? {
        var resultString: String
        if Int((str as NSString?)?.range(of: " ").location ?? 0) != NSNotFound {
            // 包含空格 需要去除
            resultString = str?.uppercased().replacingOccurrences(of: " ", with: "") ?? ""
        } else {
            // 不包含空格
            resultString = str ?? ""
        }
        return resultString
    }
    
    
    /**
     *  将服务器返回的<null>值替换成空字符串@""
     *
     *  @param str 从服务器获取的时间
     *
     *  @return 空字符串@""
     */
    public static func replaceNullToEmpty(_ str: Any?) -> String? {
        if (str is NSNull) {
            return ""
        } else {
            return self.stringTrimWhiteSpace(self.parseObjectType(toString: str))
        }
    }
    
    /**
     *  去除字符串两边的空格
     *
     *  @param needTrim 需要去空格的字符串
     *
     *  @return 去除空格后的字符串
     */
    public static func stringTrimWhiteSpace(_ needTrim: String?) -> String? {
        if needTrim != nil {
            return needTrim?.trimmingCharacters(in: CharacterSet.whitespaces)
        } else {
            return ""
        }
    }
    
    /**
     *  将服务器返回的long类型的数字从字典中取出后，变成字符串类型
     *
     *  @param obj 需要转换成字符串类型的long类型数字
     *
     *  @return 变成字符串类型的数字
     */
    public static func parseObjectType(toString obj: Any?) -> String? {
        return "\(obj ?? "")"
    }
    
    
    
    
    
    
    
    
    
}










