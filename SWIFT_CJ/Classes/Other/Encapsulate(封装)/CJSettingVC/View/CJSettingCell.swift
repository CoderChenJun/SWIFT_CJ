//
//  CJSettingCell.swift
//  SWIFT_CJ
//
//  Created by CoderChenJun on 2018/4/25.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import Foundation
import UIKit

class CJSettingCell: UITableViewCell {
    
    
    public var item: CJSettingItem?
    
    public var isLastRowInSection: Bool = false {
        didSet {
            self.divider?.isHidden = isLastRowInSection;
        }
    }
    
    
    public static func `init`(tableView: UITableView?) -> CJSettingCell {

        // 1.创建cell
        let ID = "CJSettingCellID"
        // 从缓存池中取cell
        var cell = tableView?.dequeueReusableCell(withIdentifier: ID) as? CJSettingCell
        // 如果缓存池中没有，则重新创建
        if cell == nil {
            cell = CJSettingCell(style: .value1, reuseIdentifier: ID)
        }
        return cell!

    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /** 箭头 */
    private var arrawView: UIImageView? = {
        let arrawView = UIImageView.init(image: UIImage.init(named: "cj_table_view_cell_arrow_7x12_"))
        return arrawView;
    }()
    
    
    /** 开关 */
    private  var switchView: UISwitch? = {
        let switchView = UISwitch.init()
        switchView.addTarget(self, action: #selector(switchStateChange), for: .valueChanged)
        return switchView
    }()
    /** 监听开关状态的改变 */
    @objc private func switchStateChange() {
        let defaults = UserDefaults.standard
        defaults.set(switchView?.isOn, forKey: "CJSettingCell_\(String(describing: item?.title))_switchView.isOn")
        defaults.synchronize()
    }
    
    /** 标签 */
    private var labelView: UILabel? = {
        let labelView = UILabel.init()
        labelView.bounds          = CGRect.init()
        labelView.backgroundColor = UIColor.red
        return labelView
    }()
    
    /** 标签 */
    private var divider: UIView?
    
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 初始化操作
        // 1.初始化背景
        self.setupBackground()
        // 2.初始化子控件
        self.setupSubviews()
        
    }
    
    /** 初始化背景 */
    private func setupBackground() {
        // 1.默认背景
        let background = UIView()
        background.backgroundColor = UIColor.white
        self.backgroundView = background
        // 2.选中背景
        let selectedBackground = UIView()
        selectedBackground.backgroundColor = CJColor(r: 237, g: 233, b: 218)
        self.selectedBackgroundView = selectedBackground
    }
    /** 初始化子控件 */
    private func setupSubviews() {
        // 清除textLabel的背景颜色
        self.textLabel?.backgroundColor = UIColor.clear
        self.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
        // 清除detailTextLabel的背景颜色
        self.detailTextLabel?.backgroundColor = UIColor.clear
        self.detailTextLabel?.font = UIFont.systemFont(ofSize: 12.0)
    }

    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /** 设置子控件的frame */
    override func layoutSubviews() {
        super.layoutSubviews()
        // 1.设置数据
        self.setupData()
        // 2.设置右边的内容
        self.setupRightContent()
    }
    
    /** 设置数据 */
    private func setupData() {
        // 1.图片
        if (self.item!.icon != nil) {
            self.imageView?.image = UIImage(named: (item?.icon)!)
            self.textLabel?.textAlignment = .left
        } else {
            self.imageView?.image = nil
            if self.item?.textAlignment == .center {
                self.textLabel?.textAlignment = .center
                self.textLabel?.frame = bounds
            }
        }
        // 2.Title
        self.textLabel?.text = self.item?.title
        // 3.SubTitle
        self.detailTextLabel?.text = self.item?.subtitle
        self.detailTextLabel?.y = (height - (detailTextLabel?.height)!) * 0.5
    }
    
    
    /** 设置右边的内容 */
    private func setupRightContent() {
        
        if (self.item is CJSettingArrowItem) {
            self.accessoryView = arrawView
            self.selectionStyle = .default
            //当是箭头的时候，该行能被点击
        } else if (self.item is CJSettingSwitchItem) {
            self.accessoryView = switchView
            self.selectionStyle = .none
            //当是开关的时候，该行不能被点击
            // 设置开关的状态
            let defaults = UserDefaults.standard
            self.switchView?.isOn = defaults.bool(forKey: "CJSettingCell_\(String(describing: item?.title))_switchView.isOn")
        } else if (self.item is CJSettingLabelItem) {
            accessoryView = labelView
            selectionStyle = .default
            //当是标签的时候，该行能被点击
        } else {
            self.arrawView?.removeFromSuperview()
            self.accessoryView = nil
            self.selectionStyle = .default
        }
        
    }
    
    
    
}









