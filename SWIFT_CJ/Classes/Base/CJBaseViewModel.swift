//
//  CJBaseViewModel.swift
//  TestTabBarController
//
//  Created by CoderChenJun on 2018/5/4.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class CJBaseViewModel {
    static let sharedInstance = CJBaseViewModel()//设置单例
    private init() {}
    
    /// HTTP通信
    ///
    /// - Parameters:
    ///   - type:         get\post
    ///   - service:      服务名（拼接在IP端口后面）
    ///   - methodName:   方法名
    ///   - params:       params参数字典
    ///   - successBlock: 请求成功回调
    ///   - failureBlock: 请求失败回调
    public static func httpRequest(type            : HTTPMethod,
                                   service         : String,
                                   methodName      : String,
                                   params          : NSDictionary,
                                   successBlock    : @escaping (_ result : Any)   -> (),
                                   failureBlock    : @escaping (_ error  : Error) -> ()) {
        
        let URLString: String = HTTP_ADDRESS + service
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            //"Accept": "text/javascript",
            //"Accept": "text/html",
            //"Accept": "text/plain"
        ]
        
        Alamofire.request(URLString,
                          method     : type,
                          parameters : (params as! [String : Any]),
                          encoding   : JSONEncoding.default,
                          headers    : headers).responseData { response in
                            
                            switch response.result {
                            case .success:
                                if let result = response.result.value {
                                    successBlock(result)
                                    //print("result:\(result)")
                                }
                            case .failure(let error):
                                failureBlock(error)
                                //print("error:\(error)")
                            }
        }
    }
    
    
    
    
    
    /// SOAP通信
    ///
    /// - Parameters:
    ///   - methodName:   方法名
    ////  - keys          参数标签数组
    ///   - params:       params参数字典
    ///   - successBlock: 请求成功回调
    ///   - failureBlock: 请求失败回调
    public static func soapRequest(methodName   : String,
                                   keys         : NSArray,
                                   params       : NSDictionary,
                                   successBlock : @escaping (_ result : Any)   -> (),
                                   failureBlock : @escaping (_ error  : Error) -> ()) {
        
        let url: NSURL = NSURL.init(string: "http://\(WEBSERVICE_IPADDRESS):\(WEBSERVICE_PORT)/\(WEBSERVICE_PAGE)")!
        
        let soapMessage: String = CJRequestToolkit.generateSOAPMessage(methodName: methodName, keys: keys, params: params)!
        
        var theRequest: URLRequest = URLRequest(url: url as URL)
        theRequest.setValue("application/soap+xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.setValue("\(soapMessage.count)",                forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod      = "POST"
        theRequest.httpBody        = soapMessage.data(using: String.Encoding.utf8)
        theRequest.timeoutInterval = 30
        
        Alamofire.request(theRequest).responseData { response in
            switch response.result {
            case .success:
                if let result = response.result.value {
                    successBlock(result)
                    //print("result:\(result)")
                }
            case .failure(let error):
                failureBlock(error)
                //print("error:\(error)")
            }
        }
        
    }
    
//    /// SOAP通信
//    ///
//    /// - Parameters:
//    ///   - service:      服务名（拼接在IP端口后面）
//    ///   - methodName:   方法名
//    ///   - keys:         key值数组
//    ///   - params:       params参数字典
//    ///   - successBlock: 请求成功回调
//    ///   - failureBlock: 请求失败回调
//    public static func soapRequest(service      : String,
//                                   methodName   : String,
//                                   keys         : NSArray,
//                                   params       : NSDictionary,
//                                   successBlock : @escaping (_ result : Any) -> (),
//                                   failureBlock : @escaping (_ error: Error) -> ()) {
//
//        let url: NSURL = NSURL.init(string: "http://\(WEBSERVICE_IPADDRESS):\(WEBSERVICE_PORT)/\(WEBSERVICE_PAGE)")!
//
//        let soapMessage: String = CJRequestToolkit.generateSOAPMessage(methodName: methodName, keys: keys, params: params)!
//
//        var theRequest: URLRequest = URLRequest(url: url as URL)
//        theRequest.setValue("application/soap+xml; charset=utf-8",      forHTTPHeaderField: "Content-Type")
//        theRequest.setValue("\(soapMessage.count)",                     forHTTPHeaderField: "Content-Length")
//        theRequest.httpMethod      = "POST"
//        theRequest.httpBody        = soapMessage.data(using: String.Encoding.utf8)
//        theRequest.timeoutInterval = 30
//
//        Alamofire.request(theRequest).responseData { response in
//            switch response.result {
//            case .success:
//                if let result = response.result.value {
//                    successBlock(result)
//                    //print("result:\(result)")
//                }
//            case .failure(let error):
//                failureBlock(error)
//                //print("error:\(error)")
//            }
//        }
//
//    }
    
    
    
    
}













