//
//  CJSystemToolkit.swift
//  SWIFT_CJ
//
//  Created by CoderChenJun on 2018/4/13.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import UIKit

class CJSystemToolkit: NSObject {
    
    
    /** iOS系统版本 */
    public static func systemVersion() -> String? {
        return UIDevice.current.systemVersion
    }
    
    /** app名称 */
    public static func appName() -> String? {
        return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
    }
    
    
    /** app版本 */
    public static func appVersion() -> String? {
        let infoDict = Bundle.main.infoDictionary
        let appVersion = infoDict?["CFBundleShortVersionString"] as? String
        return appVersion
    }
    
    public static func isAppStoreVersion(_ versionOnAppStore: String?, newerThanLocalVersion currentVersion: String?) -> Bool {
        let appStoreVersion_int = Int(versionOnAppStore?.replacingOccurrences(of: ".", with: "") ?? "") ?? 0
        let currentVersion_int = Int(currentVersion?.replacingOccurrences(of: ".", with: "") ?? "") ?? 0
        if appStoreVersion_int > currentVersion_int {
            return true
        }
        return false
    }
    
    
    /** app检查更新 */
    public static func checkUpdate() {
        
        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
            // 耗时的操作
            
            //获取本地版本号
            let infoDictionary = Bundle.main.infoDictionary
            let currentVersion = infoDictionary?["CFBundleShortVersionString"] as? String
            
            
            //获取appStore网络版本号
            let url:             NSURL        = NSURL(string: "http://itunes.apple.com/cn/lookup?id=\(AppID)")!
            guard let data:      NSData       = NSData(contentsOf: url as URL) else {
                return
            }
            let json:            NSDictionary = try! JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as! NSDictionary
            
            let resultsDict:     NSDictionary = (json.object(forKey: "results") as! NSArray).firstObject as! NSDictionary
            let appStoreVersion: String       = resultsDict.object(forKey: "version") as! String
            
            DispatchQueue.main.async(execute: {() -> Void in
                
                if self.isAppStoreVersion(appStoreVersion, newerThanLocalVersion: currentVersion) {
                    
                    UIAlertController.initWithSuperController(UIViewController.appRootViewController()!,
                                                              title: "检测更新",
                                                              message: "检测到新版本(\(appStoreVersion))可用，是否立即更新？",
                                                              preferredStyle: .alert,
                                                              cancelButtonTitle: "取消",
                                                              defaultButtonTitle: "更新",
                                                              cancelBlock: { (action) in
                                                                
                                                            },
                                                              defaultBlock: { (action) in
                                                                let url = URL.init(string: "http://itunes.apple.com/cn/app/id\(AppID)")
                                                                UIApplication.shared.openURL(url: url!, successBlock: nil)
                                                            })
                    
                } else {
                    //NSLog(@"无需更新");
                }
                
            })//dispatch_async(dispatch_get_main_queue()
            
        })//dispatch_async(dispatch_get_global_queue
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}










