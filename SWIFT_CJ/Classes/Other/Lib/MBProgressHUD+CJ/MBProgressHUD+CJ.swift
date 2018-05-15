//
//  MBProgressHUD+CJ.swift
//  TestTabBarController
//
//  Created by CoderChenJun on 2018/4/12.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import UIKit


let MBProgressHUD_CJ_HideTime = 1.5

enum HUDType : Int {
    case null = 0
    // 没图片
    case success = 1
    // 正确-"打钩图"
    case error = 2
    // 错误-"打叉图"
    case smile = 3
    // 笑脸图
    case cry = 4
}







extension MBProgressHUD {
    
    // MARK: - hideHUDForView
    class func hideHUD(for view: UIView?) {
        var view = view   //变量参数可变
        if view == nil {
            view = UIApplication.shared.keyWindow
        }
        self.hideHUD(for: view, animated: true)
    }
    // MARK: - hideHUD
    class func hideHUD() {
        self.hideHUD(for: nil)
    }
    
    
    
    
    
    
    
    // MARK: 显示信息
    class func show(_ text: String?, icon: String?, view: UIView?) {
        var view = view   //变量参数可变
        self.hideHUD(for: view)
        if view == nil {
            view = UIApplication.shared.keyWindow
        }
        // 快速显示一个提示信息
        let hud = MBProgressHUD.showHUDAdded(to: view, animated: true)
        hud?.labelText = text! as NSString
        // 设置图片
        hud?.customView = UIImageView(image: UIImage(named: "MBProgressHUD.bundle/\(icon ?? "")"))
        // 再设置模式
        hud?.mode = .customView
        // 隐藏时候从父控件中移除
        hud?.isRemoveFromSuperViewOnHide = true
        // 1秒之后再消失
        hud?.hide(true, afterDelay: MBProgressHUD_CJ_HideTime)
    }
    
    
    
    
    
    
    // MARK: 显示 自定义类型 信息:(没图片、打钩、打叉、笑脸、哭脸)
    class func showHUDText(_ text: String?, for HUDType: HUDType, to view: UIView?) {
        var icon: String? = nil
        switch HUDType {
        case .null:
            icon = nil
        case .success:
            icon = "success.png"
        case .error:
            icon = "error.png"
        case .smile:
            icon = "smile.png"
        case .cry:
            icon = "cry.png"
        default:
            break
        }
        self.show(text, icon: icon, view: view)
    }
    class func showHUDText(_ text: String?, for HUDType: HUDType) {
        self.showHUDText(text, for: HUDType, to: nil)
    }
    
    
    
    
    
    
    // MARK: 显示 "旋转-菊花" 信息
    class func showMessage(_ message: String?, to view: UIView?) -> MBProgressHUD? {
        var view = view   //变量参数可变
        self.hideHUD(for: view)
        if view == nil {
            view = UIApplication.shared.keyWindow
        }
        // 快速显示一个提示信息
        let hud = MBProgressHUD.showHUDAdded(to: view, animated: true)
        hud?.labelText = message! as NSString
        // 隐藏时候从父控件中移除
        hud?.isRemoveFromSuperViewOnHide = true
        // YES代表需要蒙版效果
        hud?.isDimBackground = true
        return hud
    }
    class func showMessage(_ message: String?) -> MBProgressHUD? {
        return self.showMessage(message, to: nil)
    }

    
    
    
    
    
    class func showError(_ error: String?, to view: UIView?) {
        self.show(error, icon: "error.png", view: view)
    }
    class func showError(_ error: String?) {
        self.showError(error, to: nil)
    }
    
    
    
    // MARK: 显示正确信息
    class func showSuccess(_ success: String?, to view: UIView?) {
        self.show(success, icon: "success.png", view: view)
    }
    class func showSuccess(_ success: String?) {
        self.showSuccess(success, to: nil)
    }
    
    
    
    // MARK: 显示不带图标信息
    class func showTip(_ tip: String?, to view: UIView?) {
        self.show(tip, icon: nil, view: view)
    }
    class func showTip(_ tip: String?) {
        self.showTip(tip, to: nil)
    }
    
    
}

