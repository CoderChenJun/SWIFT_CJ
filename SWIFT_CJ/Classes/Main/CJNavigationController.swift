//
//  CJNavigationController.swift
//  TestTabBarController
//
//  Created by CoderChenJun on 2018/4/25.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation

class CJNavigationController: UINavigationController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - 沿用系统NavigationController的侧滑手势
        // 沿用系统NavigationController的侧滑手势
        if responds(to: #selector(getter: self.interactivePopGestureRecognizer)) {
            interactivePopGestureRecognizer?.delegate = self as UIGestureRecognizerDelegate
        }
        interactivePopGestureRecognizer?.isEnabled = true
        
        //#warning - MARK 界面Y值,从navigationBar高度,64开始
        navigationBar.isTranslucent = false
    }
    
    
    
    
    
    
    /**
     * 系统在第一次使用这个类的时候调用(一个类只会调用一次)
     */
    func initialize() {
        // 1.设置导航栏的主题
        self.setupNavBarTheme()
    }
    
    /**
     *  设置导航栏的主题
     */
    func setupNavBarTheme() {
//        let navBar = UINavigationBar.appearance() as? UINavigationBar
//        // 设置返回箭头字的颜色！！！
//        navBar?.tintColor = UIColor.white
//        navBar?.isTranslucent = false
//        navBar?.cj_setBackgroundColor(CJNavigationBarTintColor)
//        // 设置标题文字颜色
//        var attrs = [AnyHashable: Any]()
//        attrs[NSForegroundColorAttributeName] = UIColor.white
//        if let aSize = UIFont(name: ThemeFontNameBold, size: 18.0) {
//            attrs[NSFontAttributeName] = aSize
//        }
//        navBar?.titleTextAttributes = attrs
//        // MARK: - 下面两行是去掉Nav导航栏最底下的一条分割线
//        navBar?.setBackgroundImage(UIImage(), for: .default)
//        navBar?.shadowImage = UIImage()
//        // MARK: - 上面两行是去掉Nav导航栏最底下的一条分割线
    }
    
    
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            
//            // MARK: - 自定义返回按钮
//            let backButton = UIButton(type: .roundedRect)
//            backButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
//            backButton.setImage(UIImage(named: "nav_bar_back_button"), for: .normal)
//            backButton.addTarget(self, action: #selector(self.NavBackToLastViewController), for: .touchUpInside)
//            backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
//            let customView = UIView(frame: backButton.bounds)
//            customView.addSubview(backButton)
//            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: customView)
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc func navBackToLastViewController() {
        popViewController(animated: true)
    }
    
    
    
    
}













