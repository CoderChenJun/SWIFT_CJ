//
//  CJRequestToolkit.swift
//  SWIFT_CJ
//
//  Created by CoderChenJun on 2018/4/18.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import UIKit

class CJRequestToolkit: NSObject {
    
    
    /**
     *  生成SOAP请求消息，无需请求标签
     *
     *  @param methodName 请求的接口名
     *  @param keys       参数名数组
     *  @param params     参数
     *
     *  @return 返回SOAP请求信息
     */
    class func generateSOAPMessage(methodName: String, keys: NSArray?, params: NSDictionary?) -> String? {
        
//        //let keys: NSArray = (params?.allKeys)! as NSArray
//
//        var soapMessage = ""
//        soapMessage += "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
//        soapMessage += "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
//        soapMessage += "<soap:Body>"
//        soapMessage += "<ws:\(methodName) xmlns=\"http://tempuri.org/\">"
//
//        soapMessage = "<soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:ws=\"http://ws.ssp.honest.com/\"><soap:Header/><soap:Body><ws:\(methodName)>"
//
//
//        for key: String? in (keys as? [String?])! {
//            soapMessage += "<\(key!)>"
//            soapMessage += params?.object(forKey: key as Any) as! String
//            soapMessage += "</\(key!)>"
//        }
//
//        soapMessage += "</ws:\(methodName)>"
//        soapMessage += "</soap:Body>"
//        soapMessage += "</soap:Envelope>"
//
//        print(soapMessage)
//
//        return soapMessage
        
        
        
        
        
        var soapMessage: NSString = NSString.init()
        soapMessage = soapMessage.appendingFormat("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")
        soapMessage = soapMessage.appendingFormat("<soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\" xmlns:ws=\"http://ws.ssp.honest.com/\">\n")
        soapMessage = soapMessage.appendingFormat("<soap:Header>\n")
        soapMessage = soapMessage.appendingFormat("</soap:Header>\n")
        soapMessage = soapMessage.appendingFormat("<soap:Body>\n")
        soapMessage = soapMessage.appendingFormat("<ws:%@>\n", methodName)
        
        
        for i in 0 ..< (keys?.count)! {
            let key = keys?.object(at: i)
            soapMessage = soapMessage.appendingFormat("<arg%d>", i)
            soapMessage = soapMessage.appendingFormat(params?.object(forKey: key as Any) as! NSString)
            soapMessage = soapMessage.appendingFormat("</arg%d>\n", i)
        }
        
        soapMessage = soapMessage.appendingFormat("</ws:%@>\n", methodName)
        soapMessage = soapMessage.appendingFormat("</soap:Body>\n")
        soapMessage = soapMessage.appendingFormat("</soap:Envelope>\n")
        
        //print(soapMessage)
        
        return soapMessage as String
        
        
        
    }
    
    /**
     *  生成加签值，包括time和ticket
     *
     *  @param keys   按接口参数名顺序的参数数组，比如接口GiveScoreCorpration(string pid, string cid, string score, string time, string ticket)，那个这个参数传进来的一个数组为[NSArray arrayWithObjects:@"pid", @"cid", @"score", @"time", @"ticket"]
     *  @param params 不包括time和ticket的参数键值对
     *
     *  @return 包含time和ticket值的新参数
     */
    class func generateTimeStampParams(oldParams: NSDictionary?) -> NSDictionary? {
        let oldKeys: NSArray = (oldParams?.allKeys)! as NSArray
        var sign:    String  = String()
        
        for i in 0 ..< (oldKeys.count) {
            if ((oldKeys.object(at: i) as! String) == "time") ||
               ((oldKeys.object(at: i) as! String) == "ticket") {
                continue
            }
            sign += oldParams?.object(forKey: oldKeys.object(at: i) as! String) as! String
            sign += "_"
        }
        let time: TimeInterval = Date.init().timeIntervalSince1970
        sign += String(format: "%.0f", time)
        
        let newParams = NSMutableDictionary.init(dictionary: oldParams!)
        newParams.setValue(CJEncrptToolkit.getMD5LowerCaseFromString(sign), forKey: "ticket")
        newParams.setValue(String(format: "%.0f", time),                    forKey: "time")
        
        return newParams
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}















