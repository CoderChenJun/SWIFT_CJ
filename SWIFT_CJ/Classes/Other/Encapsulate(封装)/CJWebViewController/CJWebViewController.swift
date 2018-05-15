//
//  CJWebViewController.swift
//  TestTabBarController
//
//  Created by CoderChenJun on 2018/5/3.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation

class CJWebViewController: CJBaseViewController, UIWebViewDelegate, NJKWebViewProgressDelegate {
    
    
    
    public init(urlString: String?, isShowToolBar: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.strUrl = urlString
        self.isNeedToolBar = isShowToolBar
    }
    
    public init(urlString: String?) {
        super.init(nibName: nil, bundle: nil)
        strUrl = urlString
        isNeedToolBar = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        webViewProgress?.webViewProxyDelegate = nil
        webViewProgress?.progressDelegate     = nil
        
        webView?.stopLoading()
        webView?.delegate = nil
        
        webViewProgress = nil
        webView = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    // webView
    private var strUrl: String?
    private var webView: UIWebView?
    
    // 进度条
    private var webViewProgressView: NJKWebViewProgressView?
    private var webViewProgress: NJKWebViewProgress?
    
    // 工具条按钮
    private var isNeedToolBar: Bool = false
    private var btnBack:       UIButton?
    private var btnForward:    UIButton?
    private var btnStop:       UIButton?
    private var btnRefresh:    UIButton?
    private var btnEnlarge:    UIButton?
    private var btnEnsmall:    UIButton?
    /** 缩放比例 150% */
    private var zoomRatio:     CGFloat = 0.0 {
        didSet {
            btnEnsmall?.isEnabled = zoomRatio > 100;
        }
    }
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        self.initAllControls()
    }
    
    
    private func initAllControls() {
        
        var toolBarFrame: CGRect = CGRect.zero
        
        if self.isNeedToolBar {
            toolBarFrame = CGRect(x: 0.0,
                                  y: 0.0,
                                  width: view.width,
                                  height: 40.0)
            
            let numberOfBtns: Int     = 6
            let btnWidth:     CGFloat = 25.0
            let offset:       CGFloat = (view.width - CGFloat(numberOfBtns) * btnWidth) / CGFloat((numberOfBtns + 1))
            
            
            // 工具栏
            let toolBarView = UIView(frame: toolBarFrame)
            toolBarView.backgroundColor = UIColor.groupTableViewBackground
            view.addSubview(toolBarView)
            
            // 导航栏中添加后退，前进，停止加载以及刷新按钮
            // 后退按钮
            btnBack = UIButton(type: .custom)
            btnBack?.setImage(UIImage(named: "webview_button_icon_back"), for: .normal)
            btnBack?.addTarget(self, action: #selector(self.webViewGoBack), for: .touchUpInside)
            toolBarView.addSubview(btnBack!)
            
            // 前进按钮
            btnForward = UIButton(type: .custom)
            btnForward?.setImage(UIImage(named: "webview_button_icon_forward"), for: .normal)
            btnForward?.addTarget(self, action: #selector(self.webViewGoForward), for: .touchUpInside)
            toolBarView.addSubview(btnForward!)
            
            // 停止加载按钮
            btnStop = UIButton(type: .custom)
            btnStop?.setImage(UIImage(named: "webview_button_icon_stop"), for: .normal)
            btnStop?.addTarget(self, action: #selector(self.webViewStopLoading), for: .touchUpInside)
            toolBarView.addSubview(btnStop!)
            
            // 刷新按钮
            btnRefresh = UIButton(type: .custom)
            btnRefresh?.setImage(UIImage(named: "webview_button_icon_refresh"), for: .normal)
            btnRefresh?.addTarget(self, action: #selector(self.webViewRefresh), for: .touchUpInside)
            toolBarView.addSubview(btnRefresh!)
            
            // 缩小按钮
            btnEnsmall = UIButton(type: .custom)
            btnEnsmall?.setImage(UIImage(named: "webview_button_icon_font_delete"), for: .normal)
            btnEnsmall?.addTarget(self, action: #selector(self.webViewEnsmall), for: .touchUpInside)
            toolBarView.addSubview(btnEnsmall!)
            
            // 放大按钮
            btnEnlarge = UIButton(type: .custom)
            btnEnlarge?.setImage(UIImage(named: "webview_button_icon_font_add"), for: .normal)
            btnEnlarge?.addTarget(self, action: #selector(self.webViewEnlarge), for: .touchUpInside)
            toolBarView.addSubview(btnEnlarge!)
            
            btnBack?.x = offset
            btnBack?.y = (toolBarView.height - btnWidth) / 2
            btnBack?.width = btnWidth
            btnBack?.height = btnWidth
            
            btnForward?.x = (btnBack?.right)! + offset
            btnForward?.y = (toolBarView.height - btnWidth) / 2
            btnForward?.width = btnWidth
            btnForward?.height = btnWidth
            
            btnStop?.x = (btnForward?.right)! + offset
            btnStop?.y = (toolBarView.height - btnWidth) / 2
            btnStop?.width = btnWidth
            btnStop?.height = btnWidth
            
            btnRefresh?.x = (btnStop?.right)! + offset
            btnRefresh?.y = (toolBarView.height - btnWidth) / 2
            btnRefresh?.width = btnWidth
            btnRefresh?.height = btnWidth
            
            btnEnsmall?.x = (btnRefresh?.right)! + offset
            btnEnsmall?.y = (toolBarView.height - btnWidth) / 2
            btnEnsmall?.width = btnWidth
            btnEnsmall?.height = btnWidth
            
            btnEnlarge?.x = (btnEnsmall?.right)! + offset
            btnEnlarge?.y = (toolBarView.height - btnWidth) / 2
            btnEnlarge?.width = btnWidth
            btnEnlarge?.height = btnWidth
            
        }
        
        let progressFrame = CGRect(x: 0.0,
                                   y: toolBarFrame.origin.y + toolBarFrame.size.height,
                                   width: view.width,
                                   height: 2.0)
        let webViewFrame = CGRect(x: 0.0,
                                  y: toolBarFrame.origin.y + toolBarFrame.size.height,
                                  width: view.width,
                                  height: UISCREEN_HEIGHT - HEIGHT_STATUSBAR - HEIGHT_NAVBAR - toolBarFrame.size.height)
        
        
        // 进度条代理
        webViewProgress = NJKWebViewProgress()
        webViewProgress?.webViewProxyDelegate = self
        webViewProgress?.progressDelegate     = self
        
        // WebView视图
        webView = UIWebView(frame: webViewFrame)
        webView?.delegate        = webViewProgress
        webView?.scalesPageToFit = true
        webView?.scrollView.keyboardDismissMode = .onDrag
        view.addSubview(webView!)
        
        // 网页加载进度条显示视图
        webViewProgressView = NJKWebViewProgressView(frame: progressFrame)
        webViewProgressView?.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        webViewProgressView?.setProgress(0.0, animated: true)
        view.addSubview(webViewProgressView!)
        
        
        
        
        zoomRatio = 100.0
        
        
        self.loadWebPage()
        
        
        
    }
    
    
    
    private func loadWebPage() {
        if !NSString.isBlankString(strUrl) {
            let url = URL(string: strUrl!)
            let request: URLRequest = URLRequest(url: url!)
            webView?.loadRequest(request)
            
//            //加载
//            NSString *encodedString = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            NSURL *weburl = [NSURL URLWithString:encodedString];
//            [webView loadRequest:[NSURLRequest requestWithURL:weburl]];
        } else {
            MBProgressHUD.showTip("url为空")
        }
    }
    
    
    /** 工具栏--后退 */
    @objc private func webViewGoBack() {
        if (webView?.canGoBack)! {
            webView?.goBack()
        }
    }
    
    /** 工具栏--前进 */
    @objc private func webViewGoForward() {
        if (webView?.canGoForward)! {
            webView?.goForward()
        }
    }
    /** 工具栏--停止加载 */
    @objc private func webViewStopLoading() {
        if (webView?.isLoading)! {
            webView?.stopLoading()
        }
    }
    /** 工具栏--刷新 */
    @objc private func webViewRefresh() {
        webView?.reload()
    }
    /** 工具栏--放大 */
    @objc private func webViewEnlarge() {
        zoomRatio = zoomRatio + 50
        // 网页的字体放大多少倍
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        let js = String(format: "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%.0f%%'", zoomRatio)
        webView?.stringByEvaluatingJavaScript(from: js)
    }
    /** 工具栏--缩小 */
    @objc private func webViewEnsmall() {
        if zoomRatio > 100 {
            zoomRatio = zoomRatio - 50
            // 网页的字体放大多少倍
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            let js = String(format: "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%.0f%%'", zoomRatio)
            webView?.stringByEvaluatingJavaScript(from: js)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        NSLog("开始加载网页")
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        NSLog("网页加载完毕")
    }
    
    func webViewProgress(_ webViewProgress: NJKWebViewProgress!, updateProgress progress: Float) {
        changeWebViewButtonEnabled()
        webViewProgressView?.setProgress(progress, animated: true)
        if !NSString.isBlankString(webView?.stringByEvaluatingJavaScript(from: "document.title")) {
            navigationItem.title = webView?.stringByEvaluatingJavaScript(from: "document.title")
        }
    }
    
    
    
    private func changeWebViewButtonEnabled() {
        btnBack?.isEnabled    = (webView?.canGoBack)!
        btnForward?.isEnabled = (webView?.canGoForward)!
        btnStop?.isEnabled    = (webView?.isLoading)!
    }
    
    
    
    
    
    
    
    
}










