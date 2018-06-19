//
//  UIApplication+CJ.swift
//  SWIFT_CJ
//
//  Created by CoderChenJun on 2018/5/2.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation


extension UIApplication {
    
    
    
    /** UIApplication.openURL方法封装
     */
    public func openURL(url: URL,
                        successBlock: (() -> Void)? = nil) {
        
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                DispatchQueue.main.async(execute: {() -> Void in
                    if (successBlock != nil) {
                        successBlock!()
                    }
                })
            })
        }
        else {
            let success = UIApplication.shared.openURL(url)
            if success {
                DispatchQueue.main.async(execute: {() -> Void in
                    if (successBlock != nil) {
                        successBlock!()
                    }
                })
            }
        }
        
    }
    
    
    
}
