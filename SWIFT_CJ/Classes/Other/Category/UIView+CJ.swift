//
//  UIView+CJ.swift
//  SWIFT_CJ
//
//  Created by CoderChenJun on 2018/4/13.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    /**
     * self.frame.origin.x
     */
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newX) {
            var frame = self.frame
            frame.origin.x = newX
            self.frame = frame
        }
    }
    
    /**
     * self.frame.origin.y
     */
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(newY) {
            var frame = self.frame
            frame.origin.y = newY
            self.frame = frame
        }
    }
    
    /**
     * self.frame.size.width
     */
    public var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set(newWidth) {
            var frame = self.frame
            frame.size.width = newWidth
            self.frame = frame
        }
    }
    
    /**
     * self.frame.size.height
     */
    public var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set(newHeight) {
            var frame = self.frame
            frame.size.height = newHeight
            self.frame = frame
        }
    }
    
    
    
    /**
     * left
     */
    public var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newLeft) {
            var frame = self.frame
            frame.origin.x = newLeft
            self.frame = frame
        }
    }
    
    /**
     * top
     */
    public var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        
        set(newTop) {
            var frame = self.frame
            frame.origin.y = newTop
            self.frame = frame
        }
    }
    
    /**
     * right
     */
    public var right: CGFloat {
        get {
            return self.left + self.width
        }
    }
    
    /**
     * bottom
     */
    public var bottom: CGFloat {
        get {
            return self.top + self.height
        }
    }
    
    
    
    
    
    /**
     * centerX
     */
    public var centerX:CGFloat {
        get {
            return self.center.x
        }
        set(newCenterX) {
            var center = self.center
            center.x = newCenterX
            self.center = center
        }
    }
    
    /**
     * centerY
     */
    public var centerY:CGFloat {
        get {
            return self.center.y
        }
        set(newCenterY) {
            var center = self.center
            center.y = newCenterY
            self.center = center
        }
    }
    
    
    
}
