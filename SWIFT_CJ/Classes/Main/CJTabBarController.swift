//
//  CJTabBarController.swift
//  TestTabBarController
//
//  Created by CoderChenJun on 2018/3/29.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import UIKit

class CJTabBarController: UITabBarController, CJTabBarDelegate {
    
    
    var chooseSelectedIndex: Int = 0
    /**
     *  自定义的tabbar
     */
    var myTabBar: CJTabBar?
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        for child: UIView in tabBar.subviews {
            if (child.isKind(of: NSClassFromString("UITabBarButton")!)) {
                child.removeFromSuperview()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 删除系统自动生成的UITabBarButton
        for child: UIView in tabBar.subviews {
            if (child is UIControl) {
                child.removeFromSuperview()
            }
        }
        super.viewWillAppear(animated)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        
        setupAllChildViewControllers()
        
    }
    
    
    
    
    
    
    
    
    /**
     *  初始化 tabBar
     */
    func setupTabBar() {
        let myTabBar = CJTabBar()
        myTabBar.frame             = tabBar.bounds
        myTabBar.frame.size.height = CGFloat(HEIGHT_TABBAR)
        myTabBar.delegate          = self
        tabBar.backgroundColor     = UIColor.white
        tabBar.addSubview(myTabBar)
        self.myTabBar = myTabBar
        // MARK: - 下面两行是去掉TabBar最顶部的一条分割线
        //    [self.tabBar setBackgroundImage:[[UIImage alloc] init]];
        //    [self.tabBar setShadowImage:[[UIImage alloc] init]];
        // MARK: - 上面两行是去掉TabBar最顶部的一条分割线
    }
    
    
    
    
    
    
    
    /**
     *  初始化所有的子控制器
     */
    func setupAllChildViewControllers() {
        // 1.预订
        let new1 = TestCollectionViewVC()
        setupChildViewController(new1, tabTitle: "预订", navTitle: "预订", imageName: "tabbar_icon_home_normal_30x30_", selectedImageName: "tabbar_icon_home_selected_30x30_")
        
        
        // 2.发现
        let new2 = TestTableViewVC()
        setupChildViewController(new2, tabTitle: "发现", navTitle: "发现", imageName: "tabbar_icon_faxian_normal_30x30_", selectedImageName: "tabbar_icon_faxian_selected_30x30_")
        
        
        
        // 2.发现
        let new3 = TestSettingVC()
        setupChildViewController(new3, tabTitle: "设置", navTitle: "设置", imageName: "tabbar_icon_faxian_normal_30x30_", selectedImageName: "tabbar_icon_faxian_selected_30x30_")
        
    }
    
    
    
    
    
    
    
    
    
    
    
    /**
     *  重构的初始化一个子控制器
     *
     *  @param childVc           需要初始化的子控制器
     *  @param tabTitle          tab标题
     *  @param navTitle          Nav标题
     *  @param imageName         图标
     *  @param selectedImageName 选中时的图标
     */
    func setupChildViewController(_ childVc: UIViewController?, tabTitle: String?, navTitle: String?, imageName: String?, selectedImageName: String?) {
        // 1.设置控制器的属性
        childVc?.tabBarItem.title = tabTitle
        childVc?.navigationItem.title = navTitle
        // 设置图标
        childVc?.tabBarItem.image = UIImage(named: imageName ?? "")
        // 设置选中的 tabBar 图标
        let selectedImage = UIImage(named: selectedImageName ?? "")
        // 设置不渲染效果
        childVc?.tabBarItem.selectedImage = selectedImage?.withRenderingMode(.alwaysOriginal)
        // 2.包装一个导航控制器
        var nav: CJNavigationController? = nil
        if let aVc = childVc {
            nav = CJNavigationController(rootViewController: aVc)
        }
        if let aNav = nav {
            addChildViewController(aNav)
        }
        // 3.添加tabbar内部的按钮
        myTabBar?.addTabBar(with: childVc?.tabBarItem)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    func selectedTabBar(_ tabBar: CJTabBar?) -> Int {
        self.selectedIndex = self.chooseSelectedIndex;
        return self.selectedIndex + 1;
    }
    
    func tabBar(_ tabBar: CJTabBar?, from: Int, to: Int) {
        self.selectedIndex = to;
        
//        MBProgressHUD.showSuccess("成功")
//
//        let abcstring: NSString = "asdaf"
//        let stringSize: CGSize = abcstring.size(font: UIFont.systemFont(ofSize: 10), maxWidth: CGFloat(MAXFLOAT))
//        print(stringSize)
        
        
        
        
//        let point: CGPoint = CGPoint.init(x: 2.0, y: 2.0)
//        var points: [CGPoint] = NSMutableArray.init() as! [CGPoint]
//
//        points.append(CGPoint.init(x: 0, y: 0))
//        points.append(CGPoint.init(x: 0, y: 3))
//        points.append(CGPoint.init(x: 1, y: 1))
//        points.append(CGPoint.init(x: 3, y: 0))
//
//        let isIn: Bool = CJToolkit.polygonPoints(polygonPoints: points, calculate: point)
//
//        print("数组：", points, "\n判断点：", point, "\n是否在圈内：", isIn)
        
        
        
        
        
//        let array = NSArray.init(objects: "abc", "def")
//        let string = CJEncrptToolkit.getJSONStringFromArray(array)
//        print("array -> stirng：", CJEncrptToolkit.getJSONStringFromArray(array))
//        print("string -> array：", CJEncrptToolkit.getArrayFromJSONString(string))
        
        
        
        
//        let dict = NSDictionary.init(object: array, forKey: "key" as NSCopying)
//        let string = CJEncrptToolkit.getJSONStringFromDictionary(dict)
//        print("dictionaty -> stirng：", CJEncrptToolkit.getJSONStringFromDictionary(dict))
//        print("stirng -> dictionaty：", CJEncrptToolkit.getDictionaryFromJSONString(string))
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    

}
