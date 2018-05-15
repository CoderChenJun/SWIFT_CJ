//
//  CJPagingCollectionCell.swift
//  TestTabBarController
//
//  Created by CoderChenJun on 2018/4/19.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import UIKit

let CJPagingCollectionCellID = "CJPagingCollectionCellID"



class CJPagingCollectionCell: UICollectionViewCell {
    
    public var title: String? {
        didSet {
            self.titleLabel?.text = title
            self.titleLabel?.sizeToFit()
            self.titleLabel?.frame = CGRect.init(x: 0.0,
                                                 y: (self.titleLabel?.frame.origin.y)!,
                                                 width: self.width,
                                                 height: (self.titleLabel?.frame.size.height)!)
        }
    }
    public var imageName: String? {
        didSet {
            if NSString.isBlankString(imageName) {
                self.imageView?.image = UIImage.init(named: "home_more_btn")
            } else {
                self.imageView?.image = UIImage.init(named: imageName!)
            }
        }
    }
    
    
    
    
    
    private var imageView: UIImageView?
    private var titleLabel: UILabel?
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    
    
    
    func sharedInit() {
        self.backgroundColor = UIColor.clear
        //    CGFloat padding = 10.0f;
        //    CGFloat widthForImage = frame.size.width * 0.6f;
        //    CGFloat widthForImage        = self.height <= 80.0f ? 50.0f : self.height / 2.3f;
        let widthForImage:  CGFloat = self.height <= 80.0 ? 50.0 : (self.height*0.45)
        let padding:        CGFloat = self.height <= 80.0 ? 5.0 : CGFloat(sqrtf(Float(self.height)))
        let heightForLabel: CGFloat = 20.0
        let fontSize:       CGFloat = self.height <= 80.0 ? 14.0 : CGFloat(sqrtf(Float(self.height))+4.0)
        self.imageView = UIImageView.init(frame: CGRect.init(x: (self.width-widthForImage)/2,
                                                             y: (self.height-widthForImage-heightForLabel)/2,
                                                             width: widthForImage,
                                                             height: widthForImage))
        self.addSubview(self.imageView!)
        
        
        
        
        let offsetY: CGFloat = self.height-heightForLabel-padding > 20.0 ? self.imageView!.frame.origin.y+self.imageView!.height+padding : self.height-heightForLabel-padding
        self.titleLabel = UILabel.init(frame: CGRect.init(x: 0.0,
                                                          y: offsetY,
                                                          width: self.width,
                                                          height: heightForLabel))
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.textColor     = UIColor.gray
        self.titleLabel?.font          = UIFont.systemFont(ofSize: fontSize)
        self.titleLabel?.sizeToFit()
        self.titleLabel?.frame = CGRect.init(x: 0.0,
                                             y: offsetY,
                                             width: self.width,
                                             height: (self.titleLabel?.frame.size.height)!)
        self.addSubview(self.titleLabel!)
    }
    
    
    
    
    
    func redefineImageNeed(_ needImage: Bool, imageSize sizeForImage: CGSize, labelNeed needLabel: Bool) {
        if needImage {
            var frame: CGRect = self.imageView!.frame
            if needLabel {
                frame.size.width = sizeForImage.width
                frame.size.height = sizeForImage.height
                frame.origin.x = (self.width-frame.size.width)/2
                frame.origin.y = (self.height-(self.titleLabel?.height)!-frame.size.height-10.0)/2
            } else {
                frame.size.width = self.width
                frame.size.height = self.height
                frame.origin.x = 0.0
                frame.origin.y = 0.0
                
            }
            self.imageView?.frame = frame
        } else {
            self.imageView?.removeFromSuperview()
            
        }
        if needLabel {
            var frame: CGRect = self.titleLabel!.frame
            if !needImage {
                frame.size.width = self.width
                frame.size.height = self.height
                frame.origin.x = 0.0
                frame.origin.y = 0.0
            }
            self.titleLabel?.frame = frame
        }
    }
    

    
    
    
    
    
    
    
    
    
    
    
}










