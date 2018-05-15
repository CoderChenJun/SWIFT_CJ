//
//  NSString+CJ.swift
//  TestTabBarController
//
//  Created by CoderChenJun on 2018/4/13.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import UIKit

extension NSString {
    /**
     * IOS开发中判断字符串是否为空字符的方法
     *
     * @param string 传入字符串
     * @return nil、NULL、NSNull、length=0 都是YES   剩下为NO
     */
    public static func isBlankString(_ string: String?) -> Bool {
        if string == nil || string == nil {
            return true
        }
        if (string is NSNull) {
            return true
        }
        if string?.trimmingCharacters(in: CharacterSet.whitespaces).count == 0 {
            return true
        }
        return false
    }

    
    
    
    
    /** 返回字符串所占用的尺寸
     *
     *  font    字体
     *  maxSize 最大尺寸
     *
     * @return 字符串所占用的尺寸
     */
    func size(font: UIFont?, maxSize: CGSize) -> CGSize {
        let attributes = NSDictionary(object: font as Any,
                                      forKey: NSAttributedStringKey.font as NSCopying)
        return boundingRect(with: maxSize,
                            options: .usesLineFragmentOrigin,
                            attributes: (attributes as! [NSAttributedStringKey : Any]),
                            context: nil).size
    }
    
    /** 返回字符串所占用的尺寸
     *
     *  font     字体
     *  maxWidth 最大宽度
     *
     * @return 字符串所占用的尺寸
     */
    func size(font: UIFont?, maxWidth: CGFloat) -> CGSize {
        let maxSize = CGSize(width: maxWidth,
                             height: CGFloat(MAXFLOAT))
        
        let attribute : NSDictionary = [NSAttributedStringKey.font : font as Any]
        
        return boundingRect(with: maxSize,
                            options: .usesLineFragmentOrigin,
                            attributes: (attribute as! [NSAttributedStringKey : Any]),
                            context: nil).size
    }
    
    
    
    
    
}







