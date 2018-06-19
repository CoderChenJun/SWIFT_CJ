//
//  CJBadgeButton.swift
//  SWIFT_CJ
//
//  Created by CoderChenJun on 2018/3/29.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import UIKit

class CJBadgeButton: UIButton {
    
    /**
     *  重写 badgeValue 的 set 方法,将传递过来的 badgeValue 的值进行设置
     */
    open var badgeValue: String? {
        didSet {
            if (badgeValue != nil) && !(badgeValue == "0") {
                isHidden = false
                // 设置文字
                setTitle(badgeValue, for: .normal)
                // 设置 frame
                var frame: CGRect = self.frame
                let badgeH: CGFloat? = currentBackgroundImage?.size.height
                var badgeW: CGFloat? = currentBackgroundImage?.size.width
                if (badgeValue?.count ?? 0) > 1 {
                    var attrs = [AnyHashable: Any]()
                    attrs[NSAttributedStringKey.font] = titleLabel?.font
                    let badgeSize: CGSize? = badgeValue?.size(withAttributes: (attrs as! [NSAttributedStringKey : Any]))
                    badgeW = (badgeSize?.width)! + 10
                }
                frame.size.width = badgeW!
                frame.size.height = badgeH!
                self.frame = frame
            } else {
                isHidden = true
            }
        }
    }

    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        isUserInteractionEnabled = false
        setBackgroundImage(UIImage.resizedImage(name: "main_badge"), for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 11)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    

}
