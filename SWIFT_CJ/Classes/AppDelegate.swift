//
//  AppDelegate.swift
//  TestTabBarController
//
//  Created by CoderChenJun on 2018/3/29.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)//显示窗口配置
        self.window?.makeKeyAndVisible()
        //// 判断是否第一次登陆,是否显示新特性
        //[CJToolkit chooseRootController];
        self.window?.rootViewController = CJTabBarController()
        
        
        
        // 检查更新
        CJSystemToolkit.checkUpdate()
        
        
        
        
        
        
        
        //// GET
        let getparameter  = ["foo": "bar"] as NSDictionary
        CJNetworkToolkit.sharedInstance.requestData(type       : .get,
                                                    URLString  : "https://httpbin.org/ip",
                                                    params     : getparameter) { (result) in
                                                        guard let resultDict = result as? [String : Any] else {return}
                                                        print(resultDict)
        }
        
        //// POST-URL外漏
        let parameter  = ["a" : "test",
                          "b" : "test2"] as NSDictionary
        CJNetworkToolkit.sharedInstance.requestData(type       : .post,
                                                    URLString  : "http://post.baibaoyun.com/api/aac5ddb832bbca6d2db00a7557152d5c",
                                                    params     : parameter) { (result) in
                                                        guard let resultDict = result as? [String : Any] else {return}
                                                        print("CJNetworkToolkit---resultDict : \(resultDict)")
        }
        
        //// POST封装
        CJBaseViewModel.httpRequest(type         : .post,
                                    service      : "aac5ddb832bbca6d2db00a7557152d5c",
                                    methodName   : "",
                                    params       : parameter,
                                    successBlock : { (resultValue) in
                                        guard let resultDict = resultValue as? [String : Any] else {return}
                                        print("CJBaseViewModel---httpRequest---resultDict : \(resultDict)")
        }, failureBlock: { (error) in
            
        })
        
        
        
        return true
    
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    
    
    
    
    
    
    
}








