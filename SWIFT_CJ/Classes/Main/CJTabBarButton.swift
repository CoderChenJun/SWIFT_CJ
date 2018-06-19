//
//  CJTabBarButton.swift
//  SWIFT_CJ
//
//  Created by CoderChenJun on 2018/3/29.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//


// 图标的比例
let CJTabBarButtonImageRatio = 0.7
// 按钮的默认状态下文字的颜色
let CJTabBarButtonTitleNormalColor = CJColor(r:128, g:128, b:128)
// 按钮的选中状态下文字的颜色
let CJTabBarButtonTitleSelectedColor = CJColor(r:1, g:157, b:228)




import UIKit





class CJTabBarButton: UIButton {

    
    // 懒加载badgeButton
    private lazy var badgeButton: CJBadgeButton = {
        return CJBadgeButton()
    }()
    
    
    
    /** 只要覆盖了这个方法，按钮就不存在高亮状态 */
    func setHighlighted(_ highlighted: Bool) {
        // 将父类的方法清空
        // [super setHighlighted:highlighted];
    }
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 设置按钮图片居中
        imageView?.contentMode = .center
        // 设置按钮文字大小 居中 颜色
        if let size = UIFont(name: ThemeFontName, size: 10.0) {
            titleLabel?.font = size
        }
        titleLabel?.textAlignment = .center
        setTitleColor(CJTabBarButtonTitleNormalColor, for: .normal)
        setTitleColor(CJTabBarButtonTitleSelectedColor, for: .selected)
        // 添加一个提醒数字 按钮
        let badgeButton = CJBadgeButton()
        // badgeButton 的尺寸跟随 CJTabBarButton 的尺寸变化而变化
        badgeButton.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        addSubview(badgeButton)
        self.badgeButton = badgeButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    /** 重写 badgeValue 的 set 方法,将传递过来的 badgeValue 的值进行设置 */
    var item: UITabBarItem? {
        didSet {
            setTitle(self.item?.title, for: .normal)
            setTitle(self.item?.title, for: .selected)
            // 图片
            setImage(self.item?.image, for: .normal)
            setImage(self.item?.selectedImage, for: .selected)
            // 提醒数字
            self.badgeButton.badgeValue = self.item?.badgeValue
            let badgeX = CGFloat((self.frame.size.width * 0.5 + 10))
            let badgeY: CGFloat = 2
            var badgeFrame: CGRect = self.badgeButton.frame
            badgeFrame.origin.x = badgeX
            badgeFrame.origin.y = badgeY
            self.badgeButton.frame = badgeFrame
            
        }
        
    }
    
    
    
    
    
    
    /** 内部图片的 frame */
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let imageW: CGFloat = contentRect.size.width
        let imageH = CGFloat((contentRect.size.height * CGFloat(CJTabBarButtonImageRatio)))
        return CGRect(x: 0, y: 0, width: imageW, height: imageH)
    }
    
    /** 内部文字的 frame */
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleY = CGFloat((contentRect.size.height * CGFloat(CJTabBarButtonImageRatio)))
        let titleW: CGFloat = contentRect.size.width
        let titleH: CGFloat = contentRect.size.height * (1 - CGFloat(CJTabBarButtonImageRatio))
        return CGRect(x: 0, y: titleY, width: titleW, height: titleH)
    }
    


}










