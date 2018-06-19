//
//  UIAlertController+CJ.swift
//  SWIFT_CJ
//
//  Created by CoderChenJun on 2018/4/17.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
//
    public static func initWithSuperController(_ superController: UIViewController,
                                        title: String?,
                                        message: String?,
                                        preferredStyle: UIAlertControllerStyle,
                                        cancelButtonTitle: String?,
                                        defaultButtonTitle: String?,
                                        cancelBlock: ((_ action: UIAlertAction?) -> Void)? = nil,
                                        defaultBlock: ((_ action: UIAlertAction?) -> Void)? = nil) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            if (cancelBlock != nil) {
                cancelBlock!(action)
            }
        })

        let confirmAction = UIAlertAction(title: defaultButtonTitle, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            if (defaultBlock != nil) {
                defaultBlock!(action)
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        superController.present(alertController, animated: true) {() -> Void in }

    }







    public static func initWithSuperController(_ superController: UIViewController,
                                        title: String?,
                                        message: String?,
                                        preferredStyle: UIAlertControllerStyle,
                                        cancelButtonTitle: String?,
                                        cancelBlock: ((_ action: UIAlertAction?) -> Void)? = nil) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            if (cancelBlock != nil) {
                cancelBlock!(action)
            }
        })
        alertController.addAction(cancelAction)
        superController.present(alertController, animated: true) {() -> Void in }

    }
    
    
    
    
    
//    convenience init(superController: UIViewController,
//                                        title: String?,
//                                        message: String?,
//                                        preferredStyle: UIAlertControllerStyle,
//                                        cancelButtonTitle: String?,
//                                        defaultButtonTitle: String?,
//                                        cancelBlock: ((_ action: UIAlertAction?) -> Void)? = nil,
//                                        defaultBlock: ((_ action: UIAlertAction?) -> Void)? = nil) {
//
//        self.init(title: title, message: message, preferredStyle: preferredStyle)
//
//        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
//            if (cancelBlock != nil) {
//                cancelBlock!(action)
//            }
//        })
//
//        let confirmAction = UIAlertAction(title: defaultButtonTitle, style: .default, handler: {(_ action: UIAlertAction) -> Void in
//            if (defaultBlock != nil) {
//                defaultBlock!(action)
//            }
//        })
//        self.addAction(cancelAction)
//        self.addAction(confirmAction)
//        superController.present(self, animated: true) {() -> Void in }
//
//    }
//
//    convenience init(superController: UIViewController,
//         title: String?,
//         message: String?,
//         preferredStyle: UIAlertControllerStyle,
//         cancelButtonTitle: String?,
//         cancelBlock: ((_ action: UIAlertAction?) -> Void)? = nil) {
//
//        self.init(title: title, message: message, preferredStyle: preferredStyle)
//        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
//            if (cancelBlock != nil) {
//                cancelBlock!(action)
//            }
//        })
//        self.addAction(cancelAction)
//        superController.present(self, animated: true) {() -> Void in }
//
//    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}












