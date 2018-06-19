//
//  UIViewController+CJ.swift
//  SWIFT_CJ
//
//  Created by CoderChenJun on 2018/4/17.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    public static func appRootViewController() -> UIViewController? {
        let appRootVC: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        var topVC: UIViewController? = appRootVC
        while ((topVC?.presentedViewController) != nil) {
            topVC = topVC?.presentedViewController
        }
        return topVC
    }
    
    
}
