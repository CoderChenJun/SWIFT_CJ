//
//  TestSettingViewController.swift
//  SWIFT_CJ
//
//  Created by CoderChenJun on 2018/4/25.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation

class TestSettingViewController: CJBaseSettingViewController {
    
    
    
    /**
     *  创建第0组数据
     */
    func setupGroup0() {
        let help  = CJSettingArrowItem.init(icon: "cj_bangqiu_44x44_", title: "MBProgressHUD", destVcClass: ViewController.self)
        let share = CJSettingArrowItem.init(icon: "cj_baolingqiu_44x44_", title: "WebView", destVcClass: nil)
        let soap  = CJSettingArrowItem.init(icon: "cj_chuidiao_44x44_", title: "SOAP请求", destVcClass: SOAPViewController.self)
        let http  = CJSettingArrowItem.init(icon: "cj_chuidiao_44x44_", title: "HTTP请求", destVcClass: HTTPViewController.self)
        let auth  = CJSettingArrowItem.init(icon: "cj_chuidiao_44x44_", title: "Authentication", destVcClass: TestAuthenticationViewController.self)
        
        
        
        share.option = {
            
            let vc = CJWebViewController.init(urlString: "http://www.baidu.com")
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
        let group = CJSettingGroup()
        group.items = [help, share, soap, http, auth]
        self.data?.add(group)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "设置"
        setupGroup0()
        
    }
    
    
    
}
