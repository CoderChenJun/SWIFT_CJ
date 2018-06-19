//
//  CJBaseViewController.swift
//  SWIFT_CJ
//
//  Created by CoderChenJun on 2018/5/3.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation

class CJBaseViewController: UIViewController {
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        //#warning - MARK 界面Y值,从navigationBar高度,64开始
        self.navigationController?.navigationBar.isTranslucent = false
    
    
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    public  var requestMethodName : String = ""
    public  var responseJsonDict  : NSDictionary?
    private var coverView         : UIView?
    private var btnErrorTip       : UIButton?
    
    
    /**
     * SOAP请求
     *
     * @param methodName 传入方法名
     * @param keys       参数标签数组
     * @param params     传入参数
     * @param target     调用控制器
     * @param selector   请求失败回调
     */
    public func generateSOAPRequest(methodName : String,
                                    keys       : NSArray,
                                    params     : NSDictionary,
                                    target     : UIViewController,
                                    errorAction selector: Selector?) {
        
        self.requestMethodName = methodName
        
        //// SOAP封装
        CJBaseViewModel.soapRequest(methodName   : methodName,
                                    keys         : keys,
                                    params       : params as NSDictionary,
                                    successBlock : { (resultValue) in
                                        
                                        guard let resultData = resultValue as? Data else {return print("resultData == nil")}
                                        
                                        self.handleSOAPResponse(resultData)
                                        
        }, failureBlock: { (error) in
            print("GetError:\(error)")
            
            MBProgressHUD.hideHUD()
            self.showErrorTipButton(on: self.view, target: target, action: selector)
            let errorCode: Int? = (error as NSError?)?.code
            var errorMessage: String? = nil
            if errorCode == -1001 {
                errorMessage = ERROR_MESSAGE_REQUEST_TIMEOUT
            } else if errorCode == -1004 {
                errorMessage = ERROR_MESSAGE_SERVER_NOTCONNECT
            } else {
                errorMessage = ERROR_MESSAGE_SERVER_ERROR
            }
            MBProgressHUD.showTip(errorMessage)
            
        })
        
    }
    
    public func handleSOAPResponse(_ data: Data?) {
        self.removeErrorTipButton()
        MBProgressHUD.hideHUD()
        
        let document: GDataXMLDocument = try! GDataXMLDocument(data: data as Data?, encoding: String.Encoding.utf8.rawValue)
        guard let rootElement = document.rootElement() else {
            return print("rootElement == nil")
        }
        guard let soapBody = rootElement.elements(forName: "S:Body") else {
            return print("soapBody == nil")
        }
        guard let response = (soapBody[0] as? GDataXMLElement)?.elements(forName: ("ns2:\(self.requestMethodName)Response")) else {
            return print("response == nil")
        }
        guard let result = (response[0] as? GDataXMLElement)?.elements(forName: "return") else {
            return print("result == nil")
        }
        guard let string = (result[0] as? GDataXMLElement) else {
            return print("string == nil")
        }
        //print(string.stringValue())
        self.responseJsonDict = CJEncrptToolkit.getDictionaryFromJSONString(string.stringValue())
    }
    
    
    
    /**
     * HTTP请求
     *
     * @param service    传入服务名
     * @param methodName 传入方法名
     * @param params     传入参数
     * @param target     调用控制器
     * @param selector   请求失败回调
     */
    public func generateHTTPRequest(service   : String,
                                    methodName: String,
                                    params    : NSDictionary,
                                    target    : UIViewController,
                                    errorAction selector: Selector?) {
        
        self.requestMethodName = methodName
        
        //// POST封装
        CJBaseViewModel.httpRequest(type         : .post,
                                    service      : service,
                                    methodName   : methodName,
                                    params       : params,
                                    successBlock : { (resultValue) in
                                        
                                        guard let resultData = resultValue as? Data else {return print("resultData == nil")}
                                        self.handleHTTPResponse(resultData)
                                        
        }, failureBlock: { (error) in
            print("GetError:\(error)")
            
            MBProgressHUD.hideHUD()
            self.showErrorTipButton(on: self.view, target: target, action: selector)
            let errorCode: Int? = (error as NSError?)?.code
            var errorMessage: String? = nil
            if errorCode == -1001 {
                errorMessage = ERROR_MESSAGE_REQUEST_TIMEOUT
            } else if errorCode == -1004 {
                errorMessage = ERROR_MESSAGE_SERVER_NOTCONNECT
            } else {
                errorMessage = ERROR_MESSAGE_SERVER_ERROR
            }
            MBProgressHUD.showTip(errorMessage)
            
        })
        
    }
   
    public func handleHTTPResponse(_ data: Data?) {
        self.removeErrorTipButton()
        MBProgressHUD.hideHUD()
        guard let resultString = CJEncrptToolkit.getJSONStringFromData(data! as NSData) else {return print("resultString == nil")}
        self.responseJsonDict = CJEncrptToolkit.getDictionaryFromJSONString(resultString)
    }
    
    
    
    
    
    
    
    
    
    private func showErrorTipButton(on view: UIView?, target: Any?, action selector: Selector?) {
        if selector == nil {
            if coverView == nil {
                coverView = UIView(frame: UIScreen.main.bounds)
                coverView?.backgroundColor = self.view.backgroundColor
                view?.addSubview(coverView!)
            }
            if btnErrorTip == nil {
                btnErrorTip = UIButton(frame: CGRect(x: 0.0, y: (self.view.height - 40.0) / 2, width: self.view.width, height: 40.0))
                btnErrorTip?.setTitle("点我重新加载", for: .normal)
                btnErrorTip?.setTitleColor(UIColor.darkGray, for: .normal)
                btnErrorTip?.addTarget(target, action: selector!, for: .touchUpInside)
                view?.addSubview(btnErrorTip!)
            }
        }
    }

    private func removeErrorTipButton() {
        if (btnErrorTip != nil) {
            btnErrorTip?.removeFromSuperview()
            btnErrorTip = nil
        }
        if (coverView != nil) {
            coverView?.removeFromSuperview()
            coverView = nil
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}








