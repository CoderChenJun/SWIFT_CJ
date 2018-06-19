//
//  CJAuthorityToolkit.swift
//  SWIFT_CJ
//
//  Created by CoderChenJun on 2018/5/2.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import AVFoundation
import Photos

class CJAuthorityToolkit: NSObject {
    
    
    static let sharedInstance = CJAuthorityToolkit()//设置单例
    private override init() {}
    
    
    
    
    
    let locationManager = CLLocationManager()
    
    /**
     * 判断能否使用相机(硬件\权限)
     *
     * @param useController 使用相机的控制器
     * @param useBlock      使用相机的Block
     */
    public static func camera(useController: Any?,
                              useBlock: (() -> Void)? = nil) {
        
        // 1、获取摄像设备
        let device = AVCaptureDevice.default(for: .video)
        
        if (device != nil) {
            
            let status: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
            
            if status == .notDetermined { // 用户还没有做出选择
                
                AVCaptureDevice.requestAccess(for: .video, completionHandler: {(_ granted: Bool) -> Void in
                    if granted { // 用户第一次同意了访问相机权限
                        CJLog("当前线程 - - \(Thread.current)")
                        CJLog("用户第一次同意了访问相机权限")
                        DispatchQueue.main.async(execute: {() -> Void in
                            if (useBlock != nil) {
                                useBlock!()
                            }
                        })
                    }
                    else { // 用户第一次拒绝了访问相机权限
                        CJLog("用户第一次拒绝了访问相机权限")
                    }
                })
                
            }
            else if status == .authorized { // 用户允许当前应用访问相机
                DispatchQueue.main.async(execute: {() -> Void in
                    if (useBlock != nil) {
                        useBlock!()
                    }
                })
            }
            else if status == .denied { // 用户拒绝当前应用访问相机
                UIAlertController.initWithSuperController(useController as! UIViewController,
                                                          title: "⚠️无法使用相机",
                                                          message: "请在iPhone的 [ 设置 - 隐私 - 相机 ] 打开访问开关",
                                                          preferredStyle: .alert,
                                                          cancelButtonTitle: "取消",
                                                          defaultButtonTitle: "设置",
                                                          cancelBlock: nil,
                                                          defaultBlock: { (action) in
                                                            let url = URL.init(string: UIApplicationOpenSettingsURLString)
                                                            UIApplication.shared.openURL(url: url!, successBlock: nil)
                })
            }
            else if status == .restricted { // 由于系统原因无法访问相机
                UIAlertController.initWithSuperController(useController as! UIViewController,
                                                          title: "温馨提示",
                                                          message: "由于系统原因, 无法访问相机",
                                                          preferredStyle: .alert,
                                                          cancelButtonTitle: "确定",
                                                          cancelBlock: nil)
                CJLog("因为系统原因, 无法访问相机");
            }
            
        }
        else { // 未检测到您的摄像头
            UIAlertController.initWithSuperController(useController as! UIViewController,
                                                      title: "温馨提示",
                                                      message: "未检测到您的摄像头",
                                                      preferredStyle: .alert,
                                                      cancelButtonTitle: "确定",
                                                      cancelBlock: nil)
        }//AVCaptureDevice.default(for: .video) else 结束
        
    }
    
    
    
    
    
    
    /**
     * 判断能否使用相册(权限)
     *
     * @param useController 使用相册的控制器
     * @param useBlock      使用相册的Block
     */
    public static func album(useController: Any?,
                             useBlock: (() -> Void)? = nil) {
    
        // 判断授权状态
        let status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        
        if status == .notDetermined { // 用户还没有做出选择
            // 弹框请求用户授权
            PHPhotoLibrary.requestAuthorization({(_ status: PHAuthorizationStatus) -> Void in
                if status == .authorized { // 用户第一次同意了访问相册权限
                    CJLog("当前线程 - - \(Thread.current)")
                    CJLog("用户第一次同意了访问相册权限")
                    DispatchQueue.main.async(execute: {() -> Void in
                        if (useBlock != nil) {
                            useBlock!()
                        }
                    })
                }
                else { // 用户第一次拒绝了访问相册权限
                    CJLog("用户第一次拒绝了访问相册权限")
                }
            })
        }
        else if status == .authorized { // 用户允许当前应用访问相册
            DispatchQueue.main.async(execute: {() -> Void in
                if (useBlock != nil) {
                    useBlock!()
                }
            })
        }
        else if status == .denied { // 用户拒绝当前应用访问相册
            UIAlertController.initWithSuperController(useController as! UIViewController,
                                                      title: "⚠️无法使用相册",
                                                      message: "请在iPhone的 [ 设置 - 隐私 - 相册 ] 打开访问开关",
                                                      preferredStyle: .alert,
                                                      cancelButtonTitle: "取消",
                                                      defaultButtonTitle: "设置",
                                                      cancelBlock: nil,
                                                      defaultBlock: { (action) in
                                                        let url = URL.init(string: UIApplicationOpenSettingsURLString)
                                                        UIApplication.shared.openURL(url: url!, successBlock: nil)
            })
        }
        else if status == .restricted { // 由于系统原因无法访问相册
            UIAlertController.initWithSuperController(useController as! UIViewController,
                                                      title: "温馨提示",
                                                      message: "由于系统原因, 无法访问相册",
                                                      preferredStyle: .alert,
                                                      cancelButtonTitle: "确定",
                                                      cancelBlock: nil)
        }
    
    }
    
    
    
    
    
    
    /**
     * 判断能否使用麦克风(权限)
     *
     * @param useController 使用麦克风的控制器
     * @param useBlock      使用麦克风的Block
     */
    public static func microphone(useController: Any?,
                                  useBlock: (() -> Void)? = nil) {
        
        // 判断授权状态
        let permissionStatus: AVAudioSessionRecordPermission = AVAudioSession.sharedInstance().recordPermission()
        
        if permissionStatus == .undetermined { // 用户还没有做出选择
            AVAudioSession.sharedInstance().requestRecordPermission({(_ granted: Bool) -> Void in
                if granted { // 用户第一次同意了访问麦克风权限
                    CJLog("当前线程 - - \(Thread.current)")
                    CJLog("用户第一次同意了访问麦克风权限")
                    DispatchQueue.main.async(execute: {() -> Void in
                        if (useBlock != nil) {
                            useBlock!()
                        }
                    })
                }
                else { // 用户第一次拒绝了访问麦克风权限
                    CJLog("用户第一次拒绝了访问麦克风权限")
                }
            })
        }
        else if permissionStatus == .granted { // 用户允许当前应用访问麦克风
            DispatchQueue.main.async(execute: {() -> Void in
                if (useBlock != nil) {
                    useBlock!()
                }
            })
        }
        else if permissionStatus == .denied { // 用户拒绝当前应用访问麦克风
            UIAlertController.initWithSuperController(useController as! UIViewController,
                                                      title: "⚠️无法使用麦克风",
                                                      message: "请在iPhone的 [ 设置 - 隐私 - 麦克风 ] 打开访问开关",
                                                      preferredStyle: .alert,
                                                      cancelButtonTitle: "取消",
                                                      defaultButtonTitle: "设置",
                                                      cancelBlock: nil,
                                                      defaultBlock: { (action) in
                                                        let url = URL.init(string: UIApplicationOpenSettingsURLString)
                                                        UIApplication.shared.openURL(url: url!, successBlock: nil)
            })
        }
        
    
    }
    
    
    
    
    
    
    //kCLAuthorizationStatusNotDetermined：       用户尚未做出决定是否启用定位服务
    //kCLAuthorizationStatusRestricted：          没有获得用户授权使用定位服务
    //kCLAuthorizationStatusDenied ：             用户已经明确禁止应用使用定位服务或者当前系统定位服务处于关闭状态
    //kCLAuthorizationStatusAuthorizedAlways：    应用获得授权可以一直使用定位服务，即使应用不在使用状态
    //kCLAuthorizationStatusAuthorizedWhenInUse： 使用此应用过程中允许访问定位服务
    
    //kCLAuthorizationStatusNotDetermined       //定位服务授权状态是用户没有决定是否使用定位服务。
    //kCLAuthorizationStatusRestricted          //定位服务授权状态是受限制的。可能是由于活动限制定位服务，用户不能改变。这个状态可能不是用户拒绝的定位服务。
    //kCLAuthorizationStatusDenied              //定位服务授权状态已经被用户明确禁止，或者在设置里的定位服务中关闭。
    //kCLAuthorizationStatusAuthorizedAlways    //定位服务授权状态已经被用户允许在任何状态下获取位置信息。包括监测区域、访问区域、或者在有显著的位置变化的时候。
    //kCLAuthorizationStatusAuthorizedWhenInUse //定位服务授权状态仅被允许在使用应用程序的时候。
    /**
     * 判断能否使用定位服务(权限)
     *
     * @param controller 使用定位服务的控制器
     * @param useBlock   使用定位服务的Block
     */
    public static func location(useController: Any?,
                                useBlock: (() -> Void)? = nil) {
        
        let toolkit = CJAuthorityToolkit.sharedInstance
        toolkit.locationManager.requestAlwaysAuthorization()
        toolkit.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
//            Int(CLLocationManager.authorizationStatus().rawValue) < 3
            
            if CLLocationManager.authorizationStatus() == .notDetermined { // 用户还没有做出选择
                UIAlertController.initWithSuperController(useController as! UIViewController,
                                                          title: "⚠️无法使用定位服务",
                                                          message: "请在iPhone的 [ 设置 - 隐私 - 定位服务 ] 打开访问开关",
                                                          preferredStyle: .alert,
                                                          cancelButtonTitle: "取消",
                                                          defaultButtonTitle: "设置",
                                                          cancelBlock: nil,
                                                          defaultBlock: { (action) in
                                                            let url = URL.init(string: UIApplicationOpenSettingsURLString)
                                                            UIApplication.shared.openURL(url: url!, successBlock: nil)
                })
            }
            else if CLLocationManager.authorizationStatus() == .restricted { // 定位服务授权状态是受限制的
//                UIAlertController.initWithSuperController(useController as! UIViewController,
//                                                          title: "⚠️无法使用定位服务",
//                                                          message: "定位服务授权状态是受限制的。可能是由于活动限制定位服务，用户不能改变。这个状态可能不是用户拒绝的定位服务。",
//                                                          preferredStyle: .alert,
//                                                          cancelButtonTitle: "确定",
//                                                          cancelBlock: nil)
                UIAlertController.initWithSuperController(useController as! UIViewController,
                                                          title: "⚠️无法使用定位服务",
                                                          message: "请在iPhone的 [ 设置 - 隐私 - 定位服务 ] 打开访问开关",
                                                          preferredStyle: .alert,
                                                          cancelButtonTitle: "取消",
                                                          defaultButtonTitle: "设置",
                                                          cancelBlock: nil,
                                                          defaultBlock: { (action) in
                                                            let url = URL.init(string: UIApplicationOpenSettingsURLString)
                                                            UIApplication.shared.openURL(url: url!, successBlock: nil)
                })
            }
            else if CLLocationManager.authorizationStatus() == .denied { // 明确拒绝
                UIAlertController.initWithSuperController(useController as! UIViewController,
                                                          title: "⚠️无法使用定位服务",
                                                          message: "请在iPhone的 [ 设置 - 隐私 - 定位服务 ] 打开访问开关",
                                                          preferredStyle: .alert,
                                                          cancelButtonTitle: "取消",
                                                          defaultButtonTitle: "设置",
                                                          cancelBlock: nil,
                                                          defaultBlock: { (action) in
                                                            let url = URL.init(string: UIApplicationOpenSettingsURLString)
                                                            UIApplication.shared.openURL(url: url!, successBlock: nil)
                })
            }
            else if CLLocationManager.authorizationStatus() == .authorizedAlways { // 可以一直使用定位服务
                DispatchQueue.main.async(execute: {() -> Void in
                    if (useBlock != nil) {
                        useBlock!()
                    }
                })
            }
            else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse { // 过程中允许访问定位服务
                DispatchQueue.main.async(execute: {() -> Void in
                    if (useBlock != nil) {
                        useBlock!()
                    }
                })
            }
        }
        else { // 定位服务DISABLE
//            UIAlertController.initWithSuperController(useController as! UIViewController,
//                                                      title: "温馨提示",
//                                                      message: "定位服务不可使用",
//                                                      preferredStyle: .alert,
//                                                      cancelButtonTitle: "确定",
//                                                      cancelBlock: nil)
            UIAlertController.initWithSuperController(useController as! UIViewController,
                                                      title: "⚠️无法使用定位服务",
                                                      message: "请在iPhone的 [ 设置 - 隐私 - 定位服务 ] 打开访问开关",
                                                      preferredStyle: .alert,
                                                      cancelButtonTitle: "取消",
                                                      defaultButtonTitle: "设置",
                                                      cancelBlock: nil,
                                                      defaultBlock: { (action) in
                                                        let url = URL.init(string: UIApplicationOpenSettingsURLString)
                                                        UIApplication.shared.openURL(url: url!, successBlock: nil)
            })
        }//CLLocationManager.locationServicesEnabled() else 结束
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
}










