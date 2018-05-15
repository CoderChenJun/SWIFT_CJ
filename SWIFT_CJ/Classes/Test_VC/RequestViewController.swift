//
//  RequestViewController.swift
//  SWIFT_CJ
//
//  Created by CoderChenJun on 2018/5/9.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import UIKit

class SOAPViewController: CJBaseViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.green
        
        //self.getHTTPRequest()
        
        self.getSOAPRequest()
        
        
        
        
        CJAuthorityToolkit.camera(useController: self) {
            self.view.frame.size.width = 10;
            self.view.width = 10;
        }
        
    }
    
    
    
    @objc func getSOAPRequest() {
        var keys = ["staffAreaId", "currentPage", "staffId"]
        let params = [keys[0] : "1", keys[1] : "1", keys[2] : "6"] as [String : Any]
        self.generateSOAPRequest(methodName: "findAlarmEventByProject",
                                 keys: keys as NSArray,
                                 params: params as NSDictionary,
                                 target: self,
                                 errorAction: #selector(getSOAPRequest))
    }
    
    override func handleSOAPResponse(_ data: Data?) {
        super.handleSOAPResponse(data)
        print("SOAPRequest   \(String(describing: self.responseJsonDict))")
    }
    
    
    
}





















class HTTPViewController: CJBaseViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.green
        
        //self.getHTTPRequest()
        
        self.getHTTPRequest()
        
    }
    
    
    @objc func getHTTPRequest() {
        
        //// POST-URL外漏
        let params  = ["a" : "test",
                       "b" : "test2"]
        
        self.generateHTTPRequest(service: "aac5ddb832bbca6d2db00a7557152d5c",
                                 methodName: "aa",
                                 params: params as NSDictionary,
                                 target: self,
                                 errorAction: #selector(getHTTPRequest))
        
    }
    override func handleHTTPResponse(_ data: Data?) {
        super.handleHTTPResponse(data)
        print("HTTPRequest   \(String(describing: self.responseJsonDict))")
    }
    
    
    //苹果绿 颜色 ，护眼模式。色调：55，饱和度：123，亮度：205，红：199，绿：237，蓝：204）。
    
}










