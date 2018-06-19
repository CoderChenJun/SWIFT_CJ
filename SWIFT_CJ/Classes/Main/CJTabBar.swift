//
//  CJTabBar.swift
//  SWIFT_CJ
//
//  Created by CoderChenJun on 2018/3/29.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import UIKit

// 声明设置代理方法
@objc protocol CJTabBarDelegate: NSObjectProtocol {
    @objc optional func tabBar(_ tabBar: CJTabBar?, from: Int, to: Int)
    @objc optional func selectedTabBar(_ tabBar: CJTabBar?) -> Int
}



class CJTabBar: UIView {

    
    weak var delegate: CJTabBarDelegate?
    
    
    // 懒加载selectedButton
    private lazy var selectedButton: CJTabBarButton = {
        return CJTabBarButton()
    }()
    
    // 懒加载tabBarButtons
    private lazy var tabBarButtons: [CJTabBarButton] = {
        return (NSMutableArray.init() as! [CJTabBarButton])
    }()
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /** 设置按钮的frame */
    override func layoutSubviews() {
        super.layoutSubviews()
        let w: CGFloat = frame.size.width
        let h: CGFloat = CGFloat(HEIGHT_TABBAR - HEIGHT_TABBAR_SECURITY)
        // 调整 4 个 按钮的 frame
        let buttonW: CGFloat = w / CGFloat(subviews.count)
        let buttonH: CGFloat = h
        let buttonY: CGFloat = 0
        for index in 0...((tabBarButtons.count)-1) {
            // 1.取出 4 个 按钮
            let button: CJTabBarButton? = tabBarButtons[index]
            // 2. 设置 4 个 按钮的 frame
            let buttonX: CGFloat = CGFloat(index) * buttonW
            button?.frame = CGRect(x: buttonX, y: buttonY, width: buttonW, height: buttonH)
            // 3.绑定 4 个 按钮的 tag
            button?.tag = index
        }
    }

    
    
    
    
    
    /** 添加按钮  并且设置数据及监听 */
    func addTabBar(with item: UITabBarItem?) {
        // 1.创建按钮
        let button = CJTabBarButton()
        addSubview(button)
        // 2.添加按钮到数组中去
        tabBarButtons.append(button)
        // 3.设置数据
        button.item = item
        // 4.监听按钮点击
        button.addTarget(self, action:#selector(buttonClick(_:)), for:.touchDown)
        
        // 5.默认选中第0个位置的按钮（点击了这个按钮）
        if tabBarButtons.count == delegate?.selectedTabBar!(self) {
            buttonClick(button)
        }
    }
    
    
    
    /** 监听5个tarBar按钮的点击 */
    @objc func buttonClick(_ button: CJTabBarButton?) {
        // 0.切换子控制器  通知代理
        if (delegate?.responds(to: #selector(CJTabBarDelegate.tabBar(_:from:to:))))! {
            delegate?.tabBar!(self, from: (selectedButton.tag), to: (button?.tag)!)
        }
        
        // 1.让当前选中的按钮取消选状态
        selectedButton.isSelected = false
        // 让当前选中的按钮取消“不能被点击”
        selectedButton.isUserInteractionEnabled = true
        // 2.让新点击的按钮选中
        button?.isSelected = true
        // 让新点击的按钮“不能被点击”
        button?.isUserInteractionEnabled = false
        // 3.让新点击的按钮成为“当前选中按钮”
        selectedButton = button!
    }

    
    
    

}
