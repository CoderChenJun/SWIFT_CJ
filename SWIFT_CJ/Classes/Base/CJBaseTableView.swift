//
//  CJBaseTableView.swift
//  SWIFT_CJ
//
//  Created by CoderChenJun on 2018/4/23.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import UIKit



private var kDefaultPageCount: Int = 20
private var kOffsetForLoadMore: CGFloat = 50.0
private var kDefaultReuseIdentifier: String = "DefaultReuseIdentifier"
private var kTextsCellIdentifier: String = "textsCell"




class CJBaseTableView: UITableView, EmptyDataSetDelegate, EmptyDataSetSource {
    public var currentPage:      Int  = 0
    public var pageCount:        Int  = 0
    public var totalPage:        Int  = 0
    public var isLoadingMore:    Bool = false
    public var stringForNoData:  String = ""
    
    public var loadMoreTarget:   UIViewController?
    public var loadMoreSelector: () -> Void = {}
    public var showEmptyDataSet: Bool       = false
    
    //public var labelLoadMore:    UILabel?
    //public var isNeedLoadMore:   Bool = false
    //public var isLast:           Bool = false
    //public var indicatorLoadMoreSpinner: UIActivityIndicatorView?
    //public var originYPosition:  CGFloat    = 0.0
    
    
    
    
    
    public func showEmptyData() {
        if mj_header.isRefreshing {
            mj_header.endRefreshing()
        } else if mj_footer.isRefreshing {
            mj_footer.endRefreshing()
        }
        showEmptyDataSet = true
    }
    
    public func hideEmptyData() {
        showEmptyDataSet = false
    }
    
    
    public func endRefresh() {
        if totalPage == 0 {
            showEmptyData()
        } else {
            if showEmptyDataSet {
                hideEmptyData()
            }
        }
        reloadData()
        // noticeNoMoreData方法不在最后调用的原因：如果有两页及以上，在上拉刷新加载完毕后调用noticeNoMoreData方法则仍旧显示上拉箭头
        if !isLoadingMore {
            mj_header.endRefreshing()
            if currentPage >= totalPage {
                mj_footer.endRefreshingWithNoMoreData()
            } else {
                mj_footer.endRefreshing()
            }
        } else {
            isLoadingMore = false
            if currentPage >= totalPage {
                mj_footer.endRefreshingWithNoMoreData()
            } else {
                mj_footer.endRefreshing()
            }
        }
        
        
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    
    
//    open func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Swift.Void)? = nil)
    
    public init(frame: CGRect,
                tableViewStyle style: UITableViewStyle,
                tableCellClass cellClass: AnyClass,
                forCellReuseIdentifier identifier: String?,
                target: UIViewController,
                refreshSelector selector: (() -> Swift.Void)? = nil) {
        
        super.init(frame: frame, style: style)
        
        //let tableView = CJBaseTableView.init(frame: frame, style: style)
        self.register(cellClass, forCellReuseIdentifier: identifier!)
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator   = false
        self.backgroundColor                = UIColor.clear
        
        self.loadMoreTarget                 = target
        self.loadMoreSelector               = selector!
        
        
        
        self.stringForNoData = "无数据"
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator   = false
        self.backgroundColor = UIColor.clear
        self.tableFooterView = UIView()
        
        self.currentPage = 1
        self.pageCount = kDefaultPageCount
        
        self.emptyDataSetDelegate = self
        self.emptyDataSetSource   = self
        
        
        
        
        let header = MJRefreshNormalHeader(refreshingTarget: self,
                                           refreshingAction: #selector(self.beginRefresh))
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放刷新", for: .pulling)
        header?.setTitle("正在加载", for: .refreshing)
        self.mj_header = header
        

        //    MJRefreshFooter
        //    MJRefreshBackFooter
        //    MJRefreshBackNormalFooter
        //    MJRefreshAutoFooter
        //    MJRefreshAutoNormalFooter
        //    MJRefreshBackGifFooter

        //#warning mark - 距离底部...的时候，自动加载更多
        //    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(beginLoadMore)];
        //    footer.triggerAutomaticallyRefreshPercent = -MJRefreshFooterHeight;

        let footer = MJRefreshBackNormalFooter(refreshingTarget: self,
                                               refreshingAction: #selector(self.beginLoadMore))
        footer?.setTitle("上拉加载更多", for: .idle)
        footer?.setTitle("释放加载更多", for: .pulling)
        footer?.setTitle("正在加载更多", for: .refreshing)
        footer?.setTitle("没有更多了", for: .noMoreData)
        self.mj_footer = footer
        
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    @objc private func beginRefresh() {
        currentPage = 1
        loadTargetSelector()
    }

    
    @objc private func beginLoadMore() {
        isLoadingMore = true
        if currentPage < totalPage {
            currentPage += 1
            loadTargetSelector()
        } else {
            endRefresh()
        }
    }
    
    private func loadTargetSelector() {
        if (loadMoreTarget != nil) {
            loadMoreSelector()
        } else {
            print("loadMoreTarget以及loadMoreSelector未指定，无法加载更多")
        }
    }
    
    
    
    
    
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return showEmptyDataSet
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "No_Data")
        //return UIImage(named: "No_Data")?.imageResize(newSize: CGSize.init(width: 50.0, height: 50.0))
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        var attributes = [AnyHashable: Any]()
        attributes[NSAttributedStringKey.font]            = UIFont.systemFont(ofSize: 16.0)
        attributes[NSAttributedStringKey.foregroundColor] = UIColor.lightGray
        
        return NSAttributedString(string: stringForNoData, attributes: (attributes as! [NSAttributedStringKey : Any]))
    }
    
    
    
    
    

}














