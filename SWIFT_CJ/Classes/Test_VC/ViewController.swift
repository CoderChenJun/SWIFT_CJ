//
//  ViewController.swift
//  SWIFT_CJ
//
//  Created by CoderChenJun on 2018/3/29.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import UIKit

class ViewController: CJBaseViewController {

    func HUDButton(title : NSString?, center : CGPoint?) -> UIButton {

        let button : UIButton = UIButton.init()
        button.setImage(UIImage.init(named: "CJ_HUD"), for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle(title! as String, for: .normal)
        button.sizeToFit()
        button.center = center!
        button.bounds = CGRect.init(x: 0, y: 0, width: button.bounds.size.width + 10, height: button.bounds.size.height + 10)
        button.layer.borderColor  = UIColor.black.cgColor
        button.layer.borderWidth  = 2
        button.layer.cornerRadius = 5

        return button;
    }




    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red

        let smileButton = self.HUDButton(title: "-笑脸", center: CGPoint.init(x: UISCREEN_WIDTH * 0.5, y: 100))
        self.view.addSubview(smileButton)
        smileButton.addTarget(self, action: #selector(smileAction(_:)), for: .touchUpInside)



        let cryButton = self.HUDButton(title: "-哭脸", center: CGPoint.init(x: UISCREEN_WIDTH * 0.5, y: 175))
        self.view.addSubview(cryButton)
        cryButton.addTarget(self, action: #selector(cryAction(_:)), for: .touchUpInside)



        let errorButton = self.HUDButton(title: "-打叉", center: CGPoint.init(x: UISCREEN_WIDTH * 0.5, y: 250))
        self.view.addSubview(errorButton)
        errorButton.addTarget(self, action: #selector(errorAction(_:)), for: .touchUpInside)



        let successButton = self.HUDButton(title: "-打钩", center: CGPoint.init(x: UISCREEN_WIDTH * 0.5, y: 325))
        self.view.addSubview(successButton)
        successButton.addTarget(self, action: #selector(successAction(_:)), for: .touchUpInside)



        let nullButton = self.HUDButton(title: "-没图", center: CGPoint.init(x: UISCREEN_WIDTH * 0.5, y: 400))
        self.view.addSubview(nullButton)
        nullButton.addTarget(self, action: #selector(nullAction(_:)), for: .touchUpInside)



        let ingButton = self.HUDButton(title: "-菊花（转圈）", center: CGPoint.init(x: UISCREEN_WIDTH * 0.5, y: 475))
        self.view.addSubview(ingButton)
        ingButton.addTarget(self, action: #selector(ingAction(_:)), for: .touchUpInside)






    }





    @objc private func smileAction(_ button: UIButton?) {
        MBProgressHUD.showHUDText("就算回家种田，依然保持微笑", for: .smile)

        CJAuthorityToolkit.album(useController: self, useBlock: {
            CJLog("相册权限")
        })

    }
    @objc private func cryAction(_ button: UIButton?) {
        MBProgressHUD.showHUDText("就算回家种田，依然保持微笑", for: .cry)

        CJAuthorityToolkit.camera(useController: self, useBlock: {
            CJLog("相机权限")
        })

    }
    @objc private func errorAction(_ button: UIButton?) {
        MBProgressHUD.showHUDText("就算回家种田，依然保持微笑", for: .error)

        CJAuthorityToolkit.microphone(useController: self, useBlock: {
            CJLog("麦克风权限")
        })

    }
    @objc private func successAction(_ button: UIButton?) {
//        MBProgressHUD.showHUDText("就算回家种田，依然保持微笑", for: .success)

        CJAuthorityToolkit.location(useController: self, useBlock: {
            CJLog("定位权限")
        })

    }
    @objc private func nullAction(_ button: UIButton?) {
        MBProgressHUD.showHUDText("就算回家种田，依然保持微笑", for: .null)
    }
    @objc private func ingAction(_ button: UIButton?) {
//        MBProgressHUD.showMessage("就算回家种田，依然保持微笑")
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0) {
//            MBProgressHUD.hideHUD()
//        }



    }
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    
    
    
    
    
    


}

