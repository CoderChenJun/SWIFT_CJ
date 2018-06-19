//
//  TestAuthenticationViewController.swift
//  SWIFT_CJ
//
//  Created by CoderDream on 2018/6/19.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import LocalAuthentication

class TestAuthenticationViewController: UIViewController {
    
    
    private lazy var laContent: LAContext = {
        let laContent = LAContext.init()
        return laContent
    }()
    
    
    
    
    private lazy var lblMsg: UILabel = {
        
        let label : UILabel = UILabel.init()
        label.frame  = CGRect.init(x: 30, y: 30, width: self.view.width - 60, height: 40)
        label.layer.borderColor  = UIColor.black.cgColor
        label.layer.borderWidth  = 2
        label.layer.cornerRadius = 5
        
        return label;
    }()
    
    private lazy var btnCheck: UIButton = {
        
        let button : UIButton = UIButton.init()
        button.setImage(UIImage.init(named: "CJ_HUD"), for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle(title! as String, for: .normal)
        button.frame  = CGRect.init(x: 30, y: 80, width: self.view.width - 60, height: 40)
        button.layer.borderColor  = UIColor.black.cgColor
        button.layer.borderWidth  = 2
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(didClickBtnCheck), for: .touchUpInside)
        
        return button;
    }()
    
    // MARK: -------------------- private actions --------------------
    // 开始验证按钮点击事件
    @objc func didClickBtnCheck() {
        let myLocalizedReasonString = "验证"
        laContent.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString, reply: { success, error in
//            if success {
//                print("身份验证成功！")
//                self.showAlertView("验证成功")
//            } else {
//                // 做特定的错误判断处理逻辑。
//                //print("身份验证失败！------errorCode : \(Int((error! as NSError).code)), errorMsg : \(error?.localizedDescription ?? "")")
//                // error 参考 LAError.h
//                //self.showAlertView("身份验证失败！\nerrCode : \(Int((error! as NSError).code))\nerrorMsg : \(error?.localizedDescription ?? "")")
//            }
            
            
            
            if error == nil {
                print("身份验证成功！")
                self.showAlertView("验证成功")
            }
                
            else if Int((error! as NSError).code) == kLAErrorAuthenticationFailed {
                print("//身份验证不成功，因为用户无法提供有效的凭据。")
            } else if Int((error! as NSError).code) == kLAErrorUserCancel {
                print("//认证被用户取消(例如了取消按钮)。")
            } else if Int((error! as NSError).code) == kLAErrorUserFallback {
                print("//认证被取消了,因为用户利用回退按钮(输入密码)。")
                UIAlertController.initWithSuperController(self, title: "输入密码", message: nil, preferredStyle: .alert, cancelButtonTitle: "取消", defaultButtonTitle: "确定", cancelBlock: { (_ action: UIAlertAction) in
                    
                }, defaultBlock: { (_ action: UIAlertAction) in
                    
                })
                
            } else if Int((error! as NSError).code) == kLAErrorSystemCancel {
                print("//身份验证被系统取消了(如另一个应用程序去前台)。")
            } else if Int((error! as NSError).code) == kLAErrorPasscodeNotSet {
                print("//身份验证无法启动,因为设备没有设置密码。")
            } else if Int((error! as NSError).code) == kLAErrorTouchIDNotAvailable {
                print("//身份验证无法启动,因为触摸ID不可用在设备上。")
            } else if Int((error! as NSError).code) == kLAErrorTouchIDNotEnrolled {
                print("//身份验证无法启动,因为没有登记的手指触摸ID。")
            } else if Int((error! as NSError).code) == kLAErrorTouchIDLockout {
                print("//验证不成功,因为有太多的失败的触摸ID尝试和触///摸现在ID是锁着的" +
                    "//解锁TouchID必须要使用密码，例如调用LAPolicyDeviceOwnerAuthenti//cationWithBiometrics的时候密码是必要条件。" +
                    "//身份验证不成功，因为有太多失败的触摸ID尝试和触摸ID现在被锁定")
                self.laContent.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "重新输入密码以验证ID", reply: { success, error in
                    if success {
                    }
                })
                
            } else if Int((error! as NSError).code) == kLAErrorAppCancel {
                print("//应用程序取消了身份验证（例如在进行身份验证时调用了无效）。")
            } else if Int((error! as NSError).code) == kLAErrorInvalidContext {
                print("//LAContext传递给这个调用之前已经失效。")
            } else if Int((error! as NSError).code) == kLAErrorBiometryNotAvailable {
                print("//身份验证无法启动,因为生物识别验证在当前这个设备上不可用。")
            } else if Int((error! as NSError).code) == kLAErrorBiometryNotEnrolled {
                print("//身份验证无法启动，因为生物识别没有录入信息。")
            } else if Int((error! as NSError).code) == kLAErrorBiometryLockout {
                print("//身份验证不成功，因为太多次的验证失败并且生物识别验证是锁定状态。此时，必须输入密码才能解锁。例如LAPolicyDeviceOwnerAuthenticationWithBiometrics时候将密码作为先决条件。")
            } else if Int((error! as NSError).code) == kLAErrorNotInteractive {
                print("//身份验证失败。因为这需要显示UI已禁止使用interactionNotAllowed属性。  据说是beta版本")
            }
            
            
            
            
            
        })
    }
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.lblMsg)
        self.view.addSubview(self.btnCheck)
        
        
        // 检测设备是否支持TouchID或者FaceID
        
        if #available(iOS 8.0, *) {
            
            var authError:           NSError? = nil
            let isCanEvaluatePolicy: Bool     = laContent.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError)
            
            if authError == nil {
                if isCanEvaluatePolicy {
                    if #available(iOS 11.0, *) {
                        switch laContent.biometryType {
                        case .none:
                            justSupportBiometricsType(0)
                        case .touchID:
                            justSupportBiometricsType(1)
                        case .faceID:
                            justSupportBiometricsType(2)
                        default: print(""); break
                        }
                    } else {// #available(iOS 11.0, *) ------ Fallback on earlier versions
                        print("iOS 11之前不需要判断 biometryType")
                        // 因为iPhoneX起始系统版本都已经是iOS11.0，所以iOS11.0系统版本下不需要再去判断是否支持faceID，直接走支持TouchID逻辑即可。
                        justSupportBiometricsType(1)
                    }
                } else {
                    justSupportBiometricsType(0)
                }
            }
            
            else if Int((authError! as NSError).code) == kLAErrorAuthenticationFailed {
                print("//身份验证不成功，因为用户无法提供有效的凭据。")
            } else if Int((authError! as NSError).code) == kLAErrorUserCancel {
                print("//认证被用户取消(例如了取消按钮)。")
            } else if Int((authError! as NSError).code) == kLAErrorUserFallback {
                print("//认证被取消了,因为用户利用回退按钮(输入密码)。")
                UIAlertController.initWithSuperController(self, title: "输入密码", message: nil, preferredStyle: .alert, cancelButtonTitle: "取消", defaultButtonTitle: "确定", cancelBlock: { (_ action: UIAlertAction) in
                    
                }, defaultBlock: { (_ action: UIAlertAction) in
                    
                })
            } else if Int((authError! as NSError).code) == kLAErrorSystemCancel {
                print("//身份验证被系统取消了(如另一个应用程序去前台)。")
            } else if Int((authError! as NSError).code) == kLAErrorPasscodeNotSet {
                print("//身份验证无法启动,因为设备没有设置密码。")
            } else if Int((authError! as NSError).code) == kLAErrorTouchIDNotAvailable {
                print("//身份验证无法启动,因为触摸ID不可用在设备上。")
            } else if Int((authError! as NSError).code) == kLAErrorTouchIDNotEnrolled {
                print("//身份验证无法启动,因为没有登记的手指触摸ID。")
            } else if Int((authError! as NSError).code) == kLAErrorTouchIDLockout {
                print("//验证不成功,因为有太多的失败的触摸ID尝试和触///摸现在ID是锁着的" +
                      "//解锁TouchID必须要使用密码，例如调用LAPolicyDeviceOwnerAuthenti//cationWithBiometrics的时候密码是必要条件。" +
                      "//身份验证不成功，因为有太多失败的触摸ID尝试和触摸ID现在被锁定")
                laContent.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "重新输入密码以验证ID", reply: { success, error in
                        if success {
                            
                        }
                    })
                
            } else if Int((authError! as NSError).code) == kLAErrorAppCancel {
                print("//应用程序取消了身份验证（例如在进行身份验证时调用了无效）。")
            } else if Int((authError! as NSError).code) == kLAErrorInvalidContext {
                print("//LAContext传递给这个调用之前已经失效。")
            } else if Int((authError! as NSError).code) == kLAErrorBiometryNotAvailable {
                print("//身份验证无法启动,因为生物识别验证在当前这个设备上不可用。")
            } else if Int((authError! as NSError).code) == kLAErrorBiometryNotEnrolled {
                print("//身份验证无法启动，因为生物识别没有录入信息。")
            } else if Int((authError! as NSError).code) == kLAErrorBiometryLockout {
                print("//身份验证不成功，因为太多次的验证失败并且生物识别验证是锁定状态。此时，必须输入密码才能解锁。例如LAPolicyDeviceOwnerAuthenticationWithBiometrics时候将密码作为先决条件。")
            } else if Int((authError! as NSError).code) == kLAErrorNotInteractive {
                print("//身份验证失败。因为这需要显示UI已禁止使用interactionNotAllowed属性。  据说是beta版本")
            }
            
        }
        else {// #available(iOS 8.0, *) ------ Fallback on earlier versions
            justSupportBiometricsType(0)
        }

    }
    
    
    
    // MARK: -------------------- common methods --------------------
    // 判断生物识别类型，更新UI
    func justSupportBiometricsType(_ biometryType: Int) {
        switch biometryType {
        case 0:
            print("该设备支持不支持FaceID和TouchID")
            lblMsg.text = "该设备支持不支持FaceID和TouchID"
            lblMsg.textColor = UIColor.red
            btnCheck.isEnabled = false
        case 1:
            print("该设备支持TouchID")
            lblMsg.text = "该设备支持Touch ID"
            btnCheck.setTitle("点击开始验证Touch ID", for: .normal)
            btnCheck.isEnabled = true
        case 2:
            print("该设备支持Face ID")
            lblMsg.text = "该设备支持Face ID"
            btnCheck.setTitle("点击开始验证Face ID", for: .normal)
            btnCheck.isEnabled = true
        default:
            break
        }
    }

    
    
    // 弹框
    func showAlertView(_ msg: String?) {
        //print("\(msg ?? "")")
        if #available(iOS 8.0, *) {
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            let alertController = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
            alertController.addAction(okAction)
            present(alertController, animated: true)
        } else {
            // Fallback on earlier versions
            let alertView = UIAlertView(title: "", message: msg!, delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "")
            alertView.show()
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}








