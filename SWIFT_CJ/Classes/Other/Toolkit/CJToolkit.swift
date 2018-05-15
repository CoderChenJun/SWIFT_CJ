//
//  CJToolkit.swift
//  TestTabBarController
//
//  Created by CoderChenJun on 2018/4/17.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import UIKit

class CJToolkit: NSObject {
    
    
    /**
     * 判断一个点，是否在一个矩形内部
     *
     * @param polygonPoints    矩形坐标点数组，按顺序连接，里面存的是NSStringFromCGPoint(CGPointMake(x, y))
     * @param calculatePoint   一个待判断的点
     * @return                 YES:在内; NO:在外
     */
    public static func polygonPoints(polygonPoints: [CGPoint]?, calculate calculatePoint: CGPoint) -> Bool {
        var minX: CGFloat = 0.0
        var maxX: CGFloat = 0.0
        var minY: CGFloat = 0.0
        var maxY: CGFloat = 0.0
        
        for setPoint: CGPoint in polygonPoints! {
            minX = (setPoint.x < minX) ? setPoint.x : minX
            maxX = (setPoint.x > maxX) ? setPoint.x : maxX
            minY = (setPoint.y < minY) ? setPoint.y : minY
            maxY = (setPoint.y > maxY) ? setPoint.y : maxY
        }
        
        // 1.首先判断是否超过 XY最大值 或最小值
        if calculatePoint.x < minX || calculatePoint.x > maxX || calculatePoint.y < minY || calculatePoint.y > maxY {
            // 这个测试都过不了。。。直接返回false；
            return false
        }
        // 2、核心，横向计算
        var indexI:    Int  = 0
        var indexJ:    Int  = polygonPoints!.count - 1
        var boolValue: Bool = false
        
        while indexI < (polygonPoints?.count)! {
            let setPoint_i: CGPoint = polygonPoints![indexI]
            let setPoint_j: CGPoint = polygonPoints![indexJ]
            if ((setPoint_i.y > calculatePoint.y) != (setPoint_j.y > calculatePoint.y)) && (calculatePoint.x < (setPoint_j.x - setPoint_i.x) * (calculatePoint.y - setPoint_i.y) / (setPoint_j.y - setPoint_i.y) + setPoint_i.x) {
                boolValue = !boolValue
            }
            indexJ = indexI
            indexI += 1
        }
        
        return boolValue
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
}









