//
//  CJHeaderMacro.swift
//  TestTabBarController
//
//  Created by CoderChenJun on 2018/3/29.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import UIKit

let AppID = "1071209444"//AppID

// 3.iOS版本判断
let iOS11 = Int(UIDevice.current.systemVersion) ?? 0 >= 11 ? true : false
let iOS10 = Int(UIDevice.current.systemVersion) ?? 0 >= 10 ? true : false
let iOS9  = Int(UIDevice.current.systemVersion) ?? 0 >= 9 ? true : false
let iOS8  = Int(UIDevice.current.systemVersion) ?? 0 >= 8 ? true : false

// 4.判断屏幕尺寸
let IS_IPHONE_4S    = (UIScreen.main.bounds.size.height == 480) ? true : false
let IS_IPHONE_5     = (UIScreen.main.bounds.size.height == 568) ? true : false
let IS_IPHONE_6     = (UIScreen.main.bounds.size.height == 667) ? true : false
let IS_IPHONE_6plus = (UIScreen.main.bounds.size.height == 736) ? true : false
let IS_IPHONE_X     = (UIScreen.main.bounds.size.height == 812) ? true : false
let IS_IPad         = (UIDevice.current.userInterfaceIdiom == .pad) ? true : false

// 5.一些固定的参数
let UISCREEN_WIDTH   = UIScreen.main.bounds.size.width
let UISCREEN_HEIGHT  = UIScreen.main.bounds.size.height
let HEIGHT_STATUSBAR       = CGFloat(IS_IPHONE_X ? 44 : 20)
let HEIGHT_NAVBAR          = CGFloat(IS_IPHONE_X ? 44 : 44)
let HEIGHT_TABBAR          = CGFloat(IS_IPHONE_X ? 83 : 49)
let HEIGHT_TABBAR_SECURITY = CGFloat(IS_IPHONE_X ? 34 : 0)

// 字体名称
let ThemeFontName     = "HelveticaNeue"
let ThemeFontNameBold = "HelveticaNeue-Bold"
let ThemeColor           = CJColor(r:89, g:143, b:197, a:1.0)
let ThemeBackgroundColor = CJColor(r:240, g:240, b:240, a:1.0)





// 2.自定义Log(DEBUG模式下)
func CJLog<Object>(_ items: Object, filePath: String = #file, rowCount: Int = #line) {
    #if DEBUG
    print("\(items)")
    #endif
}
















