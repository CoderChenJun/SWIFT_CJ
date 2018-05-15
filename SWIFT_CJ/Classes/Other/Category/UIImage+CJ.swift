//
//  UIImage+CJ.swift
//  TestTabBarController
//
//  Created by CoderChenJun on 2018/3/29.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    
    /**
     *  对象方法：重新设置图片大小
     */
    public func imageResize(newSize: CGSize) -> UIImage? {
        // Create a graphics image context
        UIGraphicsBeginImageContext(newSize)
        // Tell the old image to draw in this new context, with the desired
        // new size
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        // Get the new image from the context
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        // End the context
        UIGraphicsEndImageContext()
        // Return the new image.
        return newImage
    }
    
//    public static func `init`(newSize: CGSize) -> UIImage? {
//        // Create a graphics image context
//        UIGraphicsBeginImageContext(newSize)
//        // Tell the old image to draw in this new context, with the desired
//        // new size
//        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
//        // Get the new image from the context
//        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
//        // End the context
//        UIGraphicsEndImageContext()
//        // Return the new image.
//        return newImage
//    }
    
    
    
    /**
     *  类方法：通过传递颜色 color 生成纯色图片
     */
    public static func `init`(color: UIColor?) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor((color?.cgColor)!)
        context?.fill(rect)
        let theImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage
    }
    
    
    /**
     *  传入百分比,返回一张自由拉伸的图片
     *
     *  @param name 原始图片
     *  @param left 左边 百分之多少 需要保护
     *  @param top  上边 百分之多少 需要保护
     *
     *  @return 拉伸结果图片
     */
    public static func resizedImage(name: String?, left: CGFloat, top: CGFloat) -> UIImage? {
        // 导入原来图片
        let normal = UIImage(named: name ?? "")
        // 返回
        return normal?.stretchableImage(withLeftCapWidth: Int(((normal?.size.width)! * left)), topCapHeight: Int(((normal?.size.height)! * top)))
    }
    
    /**
     *  返回一张通过最中心点进行拉伸的图片
     *
     *  @param name 原始图片
     *
     *  @return 拉伸结果图片
     */
    public static func resizedImage(name: String?) -> UIImage? {
        return UIImage.resizedImage(name: name, left: 0.5, top: 0.5)
    }
    
    
    
    
    
    
    
    
    
}









