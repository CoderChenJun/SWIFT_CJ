//
//  CJNetworkToolkit.swift
//  TestTabBarController
//
//  Created by CoderChenJun on 2018/4/18.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


class CJNetworkToolkit {
    static let sharedInstance = CJNetworkToolkit()//设置单例
    private init() {}
    
    
//    open func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Swift.Void)? = nil)
    
    /// HTTP通信
    ///
    /// - Parameters:
    ///   - type:         get\post
    ///   - URLString:    http的url
    ///   - params:       params参数字典
    ///   - successBlock: 请求成功回调
    public func requestData(type : HTTPMethod,
                            URLString       : String,
                            params          : NSDictionary,
                            successBlock    :  @escaping (_ result : Any) -> ()) {
        Alamofire.request(URLString,
                          method:     type,
                          parameters: (params as! [String : Any])).responseJSON { (response) in
            guard let result = response.result.value else {
                MBProgressHUD.showTip("网络请求发生了错误")
                print(response.result.error ?? " --- 网络请求发生了错误 --- ")
                return
            }
            successBlock(result)
        }
    }
    
    
    
    
    
    
    
    
    /// SOAP通信
    ///
    /// - Parameters:
    ///   - service:      服务名（拼接在IP端口后面）
    ///   - methodName:   方法名
    ///   - keys:         key值数组
    ///   - params:       params参数字典
    ///   - successBlock: 请求成功回调
    public func soapRequest(service:      String,
                            methodName:   String,
                            keys:         NSArray,
                            params:       NSDictionary,
                            successBlock: @escaping (_ responseData: NSData) -> ()){
        
        let url: NSURL = NSURL.init(string: ("http://112.15.166.42:8096/"+service))!
        
        let soapMessage: String = CJRequestToolkit.generateSOAPMessage(methodName: methodName, keys: keys,params: params)!
        
        var theRequest: URLRequest = URLRequest(url: url as URL)
        theRequest.setValue("application/soap+xml; charset=utf-8",      forHTTPHeaderField: "Content-Type")
        theRequest.setValue("\(soapMessage.count)",                     forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod      = "POST"
        theRequest.httpBody        = soapMessage.data(using: String.Encoding.utf8)
        theRequest.timeoutInterval = 30
        
        Alamofire.request(theRequest).responseData { response in
            switch response.result {
            case .success:
                print(CJEncrptToolkit.getJSONStringFromData(response.data! as NSData) as Any)
                successBlock(response.data! as NSData)
            case .failure(let error):
                print("GetErrorUrl:\(String(describing: response.request))")
                print("GetError:\(error)")
            }
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
}

























