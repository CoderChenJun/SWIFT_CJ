//
//  NSDate+CJ.swift
//  SWIFT_CJ
//
//  Created by CoderChenJun on 2018/4/25.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import UIKit

extension NSDate {
    
    
    /**
     *  通过传入string，返回NSDate对象
     *
     *  @param string 传入string
     *  @param dateFormat 自定义时间格式---若传入空 默认yyyy-MM-dd HH:mm:ss
     *  @return NSDate;
     */
    public static func `init`(dateString: String?, dateFormat: String?) -> NSDate {
        var dateFormat = dateFormat   //变量参数可变
        if dateFormat == nil {
            dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
        
        let df: DateFormatter = DateFormatter()
        df.dateFormat = dateFormat
        
        return df.date(from: dateString!)! as NSDate
    }
    
    
}








