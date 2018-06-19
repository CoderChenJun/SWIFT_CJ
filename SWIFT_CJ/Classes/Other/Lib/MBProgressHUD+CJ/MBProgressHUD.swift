//
//  MBProgressHUD.swift
//  SWIFT_CJ
//
//  Created by CoderChenJun on 2018/3/30.
//  Copyright © 2018年 奥奈斯特（宁波）软件技术有限公司. All rights reserved.
//

import UIKit
import Foundation
import CoreGraphics

//enum MBProgressHUDMode : Int {
//    /** Progress is shown using an UIActivityIndicatorView. This is the default. */
//    case MBProgressHUDModeIndeterminate
//    /** Progress is shown using a round, pie-chart like, progress view. */
//    case MBProgressHUDModeDeterminate
//    /** Progress is shown using a horizontal progress bar */
//    case MBProgressHUDModeDeterminateHorizontalBar
//    /** Progress is shown using a ring-shaped progress view. */
//    case MBProgressHUDModeAnnularDeterminate
//    /** Shows a custom view */
//    case MBProgressHUDModeCustomView
//    /** Shows only labels */
//    case MBProgressHUDModeText
//}
//
//enum MBProgressHUDAnimation : Int {
//    /** Opacity animation */
//    case MBProgressHUDAnimationFade
//    /** Opacity + scale animation */
//    case MBProgressHUDAnimationZoom
//    static let MBProgressHUDAnimationZoomOut: MBProgressHUDAnimation = MBProgressHUDAnimationZoom
//    case MBProgressHUDAnimationZoomIn
//}


enum MBProgressHUDMode : Int {
    /** Progress is shown using an UIActivityIndicatorView. This is the default. */
    case indeterminate
    /** Progress is shown using a round, pie-chart like, progress view. */
    case determinate
    /** Progress is shown using a horizontal progress bar */
    case determinateHorizontalBar
    /** Progress is shown using a ring-shaped progress view. */
    case annularDeterminate
    /** Shows a custom view */
    case customView
    /** Shows only labels */
    case text
}
enum MBProgressHUDAnimation : Int {
    /** Opacity animation */
    case fade
    /** Opacity + scale animation */
    case zoom
    static let zoomOut: MBProgressHUDAnimation = .zoom
    case zoomIn
}

#if NS_BLOCKS_AVAILABLE
    typealias MBProgressHUDCompletionBlock = () -> Void
#endif

private let kPadding: CGFloat = 4.0
private let kLabelFontSize: CGFloat = 16.0
private let kDetailsLabelFontSize: CGFloat = 12.0















// 声明设置代理方法
@objc protocol MBProgressHUDDelegate: NSObjectProtocol {
    /**
     * Called after the HUD was fully hidden from the screen.
     */
    @objc optional func hudWasHidden(_ hud: MBProgressHUD)
}







class MBProgressHUD: UIView {

    private var indicator: UIView?
    private var graceTimer: Timer?
    private var minShowTimer: Timer?
    private var showStarted: Date?
    private var size: CGSize?
    
    private var useAnimation: Bool?
    private var methodForExecution: Selector?
    private var targetForExecution: Any?
    private var objectForExecution: Any?
    private var label: UILabel?
    private var detailsLabel: UILabel?
    private var isFinished: Bool?
    private var rotationTransform: CGAffineTransform?
    
    
    
    
    /**
     * MBProgressHUD operation mode. The default is MBProgressHUDModeIndeterminate.
     *
     * @see MBProgressHUDMode
     */
    var mode: MBProgressHUDMode? {
        didSet {
            updateIndicators()
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    /**
     * The animation type that should be used when the HUD is shown and hidden.
     *
     * @see MBProgressHUDAnimation
     */
    var animationType: MBProgressHUDAnimation?
    
    /**
     * The UIView (e.g., a UIImageView) to be shown when the HUD is in MBProgressHUDModeCustomView.
     * For best results use a 37 by 37 pixel view (so the bounds match the built in indicator bounds).
     */
    var customView: UIView? {
        didSet {
            updateIndicators()
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    /**
     * The HUD delegate object.
     *
     * @see MBProgressHUDDelegate
     */
    weak var delegate: MBProgressHUDDelegate?
    
    /**
     * An optional short message to be displayed below the activity indicator. The HUD is automatically resized to fit
     * the entire text. If the text is too long it will get clipped by displaying "..." at the end. If left unchanged or
     * set to @"", then no message is displayed.
     */
    var labelText: NSString? {
        didSet {
            label?.text = labelText! as String
            setNeedsLayout()
            setNeedsDisplay()
            
        }
    }
    
    /**
     * An optional details message displayed below the labelText message. This message is displayed only if the labelText
     * property is also set and is different from an empty string (@""). The details text can span multiple lines.
     */
    var detailsLabelText: NSString? {
        didSet {
            detailsLabel?.text = detailsLabelText! as String
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    /**
     * The opacity of the HUD window. Defaults to 0.8 (80% opacity).
     */
    var opacity: CGFloat?
    
    /**
     * The color of the HUD window. Defaults to black. If this property is set, color is set using
     * this UIColor and the opacity property is not used.  using retain because performing copy on
     * UIColor base colors (like [UIColor greenColor]) cause problems with the copyZone.
     */
    var color: UIColor?
    
    /**
     * The x-axis offset of the HUD relative to the centre of the superview.
     */
    var xOffset: CGFloat?
    
    /**
     * The y-axis offset of the HUD relative to the centre of the superview.
     */
    var yOffset: CGFloat?
    
    /**
     * The amount of space between the HUD edge and the HUD elements (labels, indicators or custom views).
     * Defaults to 20.0
     */
    var margin: CGFloat?
    
    /**
     * Cover the HUD background view with a radial gradient.
     */
    var isDimBackground: Bool?
    
    /**
     * Grace period is the time (in seconds) that the invoked method may be run without
     * showing the HUD. If the task finishes before the grace time runs out, the HUD will
     * not be shown at all.
     * This may be used to prevent HUD display for very short tasks.
     * Defaults to 0 (no grace time).
     * Grace time functionality is only supported when the task status is known!
     * @see taskInProgress
     */
    var graceTime: CGFloat?
    
    /**
     * The minimum time (in seconds) that the HUD is shown.
     * This avoids the problem of the HUD being shown and than instantly hidden.
     * Defaults to 0 (no minimum show time).
     */
    var minShowTime: CGFloat?
    
    /**
     * Indicates that the executed operation is in progress. Needed for correct graceTime operation.
     * If you don't set a graceTime (different than 0.0) this does nothing.
     * This property is automatically set when using showWhileExecuting:onTarget:withObject:animated:.
     * When threading is done outside of the HUD (i.e., when the show: and hide: methods are used directly),
     * you need to set this property when your task starts and completes in order to have normal graceTime
     * functionality.
     */
    var isTaskInProgress: Bool?
    
    /**
     * Removes the HUD from its parent view when hidden.
     * Defaults to NO.
     */
    var isRemoveFromSuperViewOnHide: Bool?
    
    /**
     * Font to be used for the main label. Set this property if the default is not adequate.
     */
    var labelFont: UIFont? {
        didSet {
            label?.font = labelFont
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    /**
     * Font to be used for the details label. Set this property if the default is not adequate.
     */
    var detailsLabelFont: UIFont? {
        didSet {
            detailsLabel?.font = detailsLabelFont
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    /**
     * The progress of the progress indicator, from 0.0 to 1.0. Defaults to 0.0.
     */
    var progress: Float? {
        didSet {
            if (indicator?.responds(to: #selector(setter: UIProgressView.progress)))! {
//                ((indicator as? Any)? as AnyObject).progress = progress
                (indicator as? UIProgressView)?.progress = progress!
            }
            return
//            setNeedsLayout()
//            setNeedsDisplay()
        }
    }
    
    /**
     * The minimum size of the HUD bezel. Defaults to CGSizeZero (no minimum size).
     */
    var minSize:CGSize?
    
    /**
     * Force the HUD dimensions to be equal if possible.
     */
    var isSquare: Bool?
    
    
    
    
    
    
    
    
    
    
    
    

    
    /**
     * Creates a new HUD, adds it to provided view and shows it. The counterpart to this method is hideHUDForView:animated:.
     *
     * @param view The view that the HUD will be added to
     * @param animated If set to YES the HUD will appear using the current animationType. If set to NO the HUD will not use
     * animations while appearing.
     * @return A reference to the created HUD.
     *
     * @see hideHUDForView:animated:
     * @see animationType
     */
    class func showHUDAdded(to view: UIView?, animated: Bool) -> MBProgressHUD? {
        let hud = MBProgressHUD.init(view: view!)
        view?.addSubview(hud)
        hud.show(animated)
        return hud
    }
    
    /**
     * Finds the top-most HUD subview and hides it. The counterpart to this method is showHUDAddedTo:animated:.
     *
     * @param view The view that is going to be searched for a HUD subview.
     * @param animated If set to YES the HUD will disappear using the current animationType. If set to NO the HUD will not use
     * animations while disappearing.
     * @return YES if a HUD was found and removed, NO otherwise.
     *
     * @see showHUDAddedTo:animated:
     * @see animationType
     */
    class func hideHUD(for view: UIView?, animated: Bool) -> Bool {
        var view = view   //变量参数可变
        if view == nil {
            view = UIApplication.shared.windows.last!
        }
        let hud = MBProgressHUD.HUD(for: view)
        if hud != nil {
            hud?.isRemoveFromSuperViewOnHide = true
            hud?.hide(animated)
            return true
        }
        return false
    }
    
    /**
     * Finds all the HUD subviews and hides them.
     *
     * @param view The view that is going to be searched for HUD subviews.
     * @param animated If set to YES the HUDs will disappear using the current animationType. If set to NO the HUDs will not use
     * animations while disappearing.
     * @return the number of HUDs found and removed.
     *
     * @see hideHUDForView:animated:
     * @see animationType
     */
    class func hideAllHUDs(for view: UIView?, animated: Bool) -> Int {
        var view = view   //变量参数可变
        if view == nil {
            view = UIApplication.shared.windows.last!
        }
        let huds: NSArray = MBProgressHUD.allHUDs(for: view)! as NSArray
        for tempHud in huds {
            let hud = tempHud as! MBProgressHUD
            hud.isRemoveFromSuperViewOnHide = true
            hud.hide(animated)
        }
        return huds.count
    }
    
    /**
     * Finds the top-most HUD subview and returns it.
     *
     * @param view The view that is going to be searched.
     * @return A reference to the last HUD subview discovered.
     */
    class func HUD(for view: UIView?) -> MBProgressHUD? {
        for subview: UIView in (view?.subviews)! {
            if (subview.isKind(of: self)) {
                return subview as? MBProgressHUD
            }
        }
        return nil
    }
    
    /**
     * Finds all HUD subviews and returns them.
     *
     * @param view The view that is going to be searched.
     * @return All found HUD views (array of MBProgressHUD objects).
     */
    class func allHUDs(for view: UIView?) -> [Any]? {
        var huds = [AnyHashable]()
        for subview: UIView in (view?.subviews)! {
            if (subview.isKind(of: self)) {
                huds.append(subview)
            }
        }
        return huds
    }
    
    
    
    
    
    
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Set default values for properties
        animationType = .fade
        mode          = .indeterminate
        labelText = ""
        detailsLabelText = ""
        opacity = 0.8
        color = nil
        labelFont = UIFont.boldSystemFont(ofSize: kLabelFontSize)
        detailsLabelFont = UIFont.boldSystemFont(ofSize: kDetailsLabelFontSize)
        xOffset = 0.0
        yOffset = 0.0
        isDimBackground = false
        margin = 20.0
        graceTime = 0.0
        minShowTime = 0.0
        isRemoveFromSuperViewOnHide = false
        minSize = CGSize.zero
        isSquare = false
        autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
        
        isOpaque = false
        backgroundColor = UIColor.clear
        // Make it invisible for now
        alpha = 0.0
        isTaskInProgress = false
        rotationTransform = .identity
        
        
        setupLabels()
        updateIndicators()
        registerForNotifications()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    /**
     * A convenience constructor that initializes the HUD with the window's bounds. Calls the designated constructor with
     * window.bounds as the parameter.
     *
     * @param window The window instance that will provide the bounds for the HUD. Should be the same instance as
     * the HUD's superview (i.e., the window that the HUD will be added to).
     */
    convenience init?(window: UIWindow?) {
        if let aWindow = window {
            self.init(view: aWindow)
        }
        return nil
    }
    
    /**
     * A convenience constructor that initializes the HUD with the view's bounds. Calls the designated constructor with
     * view.bounds as the parameter
     *
     * @param view The view instance that will provide the bounds for the HUD. Should be the same instance as
     * the HUD's superview (i.e., the view that the HUD will be added to).
     */
    convenience init(view: UIView) {
//        NSAssert(view, "View must not be nil.")
        self.init(frame: view.bounds)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    deinit {
        unregisterFromNotifications()
//        #if !__has_feature(objc_arc)
//
//            #if NS_BLOCKS_AVAILABLE
//
//            #endif
//
//        #endif
    }
    
    
    
    
    
    
    
    
    
    
    
    
    //pragma mark - Show & hide
    /**
     * Display the HUD. You need to make sure that the main thread completes its run loop soon after this method call so
     * the user interface can be updated. Call this method when your task is already set-up to be executed in a new thread
     * (e.g., when using something like NSOperation or calling an asynchronous call like NSURLRequest).
     *
     * @param animated If set to YES the HUD will appear using the current animationType. If set to NO the HUD will not use
     * animations while appearing.
     *
     * @see animationType
     */
    func show(_ animated: Bool) {
        useAnimation = animated
        // If the grace time is set postpone the HUD display
        if graceTime! > 0.0 {
            graceTimer = Timer.scheduledTimer(timeInterval: TimeInterval(graceTime!),
                                                    target: self,
                                                  selector: Selector(("handleGraceTimer:")),
                                                  userInfo: nil,
                                                   repeats: false)
        } else {
            setNeedsDisplay()
            show(usingAnimation: useAnimation!)
        }
    }
    
    /**
     * Hide the HUD. This still calls the hudWasHidden: delegate. This is the counterpart of the show: method. Use it to
     * hide the HUD when your task completes.
     *
     * @param animated If set to YES the HUD will disappear using the current animationType. If set to NO the HUD will not use
     * animations while disappearing.
     *
     * @see animationType
     */
    func hide(_ animated: Bool) {
        useAnimation = animated
        // If the minShow time is set, calculate how long the hud was shown,
        // and pospone the hiding operation if necessary
        if minShowTime! > 0.0 && (showStarted != nil) {
            let interv: TimeInterval = Date().timeIntervalSince(showStarted!)
            if CGFloat(interv) < minShowTime! {
                minShowTimer = Timer.scheduledTimer(timeInterval: TimeInterval(minShowTime! - CGFloat(interv)), target: self, selector: #selector(handleMinShow(_:)), userInfo: nil, repeats: false)
                return
            }
        }
        // ... otherwise hide the HUD immediately
        hide(usingAnimation: useAnimation!)
    }
    
    /**
     * Hide the HUD after a delay. This still calls the hudWasHidden: delegate. This is the counterpart of the show: method. Use it to
     * hide the HUD when your task completes.
     *
     * @param animated If set to YES the HUD will disappear using the current animationType. If set to NO the HUD will not use
     * animations while disappearing.
     * @param delay Delay in seconds until the HUD is hidden.
     *
     * @see animationType
     */
    func hide(_ animated: Bool, afterDelay delay: TimeInterval) {
        perform(#selector(hideDelayed(_:)), with: animated, afterDelay: delay)
    }
    
    
    @objc private func hideDelayed(_ animated: NSNumber?) {
        hide((animated != 0))
    }
    
    
    private func handleGraceTimer(_ theTimer: Timer?) {
        // Show the HUD only if the task is still running
        if isTaskInProgress! {
            setNeedsDisplay()
            show(usingAnimation: useAnimation!)
        }
    }
    
    @objc private func handleMinShow(_ theTimer: Timer?) {
        hide(usingAnimation: useAnimation!)
    }
    
    
    
    override func didMoveToSuperview() {
        // We need to take care of rotation ourselfs if we're adding the HUD to a window
        if (superview is UIWindow) {
            self.setTransformForCurrentOrientation(false)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Internal show & hide operations
    private func show(usingAnimation animated: Bool) {
        if animated && animationType == .zoomIn {
            transform = (rotationTransform?.concatenating(CGAffineTransform(scaleX: 0.5, y: 0.5)))!
        } else if animated && animationType == .zoomOut {
            transform = (rotationTransform?.concatenating(CGAffineTransform(scaleX: 1.5, y: 1.5)))!
        }
        showStarted = Date()
        // Fade in
        if animated {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.30)
            alpha = 1.0
            if animationType == .zoomIn || animationType == .zoomOut {
                transform = rotationTransform!
            }
            UIView.commitAnimations()
        } else {
            alpha = 1.0
        }
    }
    private func hide(usingAnimation animated: Bool) {
        // Fade out
        if animated && (showStarted != nil) {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.30)
            UIView.setAnimationDelegate(self)
            UIView.setAnimationDidStop(#selector(animationFinished(_:finished:context:)))
            
            // 0.02 prevents the hud from passing through touches during the animation the hud will get completely hidden
            // in the done method
            if animationType == .zoomIn {
                transform = (rotationTransform?.concatenating(CGAffineTransform(scaleX: 1.5, y: 1.5)))!
            } else if animationType == .zoomOut {
                transform = (rotationTransform?.concatenating(CGAffineTransform(scaleX: 0.5, y: 0.5)))!
            }
            alpha = 0.02
            UIView.commitAnimations()
        } else {
            alpha = 0.0
            done()
        }
        showStarted = nil
    }
    
    @objc private func animationFinished(_ animationID: String?, finished: Bool, context: UnsafeMutableRawPointer?) {
        done()
    }
    
    private func done() {
        isFinished = true
        alpha = 0.0
//        //代理没有完成
//        if (delegate?.responds(to: #selector(MBProgressHUDDelegate.hudWasHidden(_:))))! {
//            delegate?.perform(#selector(MBProgressHUDDelegate.hudWasHidden(_:)), with: self)
//        }
        
        
        #if NS_BLOCKS_AVAILABLE
            if completionBlock() {
                completionBlock()()
                completionBlock() = nil
            }
        #endif
        if isRemoveFromSuperViewOnHide! {
            removeFromSuperview()
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //#pragma mark - Threading
    /**
     * Shows the HUD while a background task is executing in a new thread, then hides the HUD.
     *
     * This method also takes care of autorelease pools so your method does not have to be concerned with setting up a
     * pool.
     *
     * @param method The method to be executed while the HUD is shown. This method will be executed in a new thread.
     * @param target The object that the target method belongs to.
     * @param object An optional object to be passed to the method.
     * @param animated If set to YES the HUD will (dis)appear using the current animationType. If set to NO the HUD will not use
     * animations while (dis)appearing.
     */
    func showWhileExecuting(_ method: Selector, onTarget target: Any?, withObject object: Any?, animated: Bool) {
        methodForExecution = method
        targetForExecution = target
        objectForExecution = object
        // Launch execution in new thread
        isTaskInProgress = true
        Thread.detachNewThreadSelector(#selector(launchExecution), toTarget: self, with: nil)
        // Show HUD view
        show(animated)
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

#if NS_BLOCKS_AVAILABLE
    /**
     * Shows the HUD while a block is executing on a background queue, then hides the HUD.
     *
     * @see showAnimated:whileExecutingBlock:onQueue:completionBlock:
     */
    func show(animated: Bool, whileExecutingBlock block: () -> ()) {
        let queue = DispatchQueue.global(qos: .default)
        show(animated: animated, whileExecutingBlock: block, on: queue, completionBlock: nil)
    }
    /**
     * Shows the HUD while a block is executing on a background queue, then hides the HUD.
     *
     * @see showAnimated:whileExecutingBlock:onQueue:completionBlock:
     */
    func show(animated: Bool, whileExecutingBlock block: () -> (), completionBlock completion: @escaping () -> Void) {
        let queue = DispatchQueue.global(qos: .default)
        show(animated: animated, whileExecutingBlock: block, on: queue, completionBlock: completion)
    }
    /**
     * Shows the HUD while a block is executing on the specified dispatch queue, then hides the HUD.
     *
     * @see showAnimated:whileExecutingBlock:onQueue:completionBlock:
     */
    func show(animated: Bool, whileExecutingBlock block: () -> (), on queue: DispatchQueue) {
        show(animated: animated, whileExecutingBlock: block, on: queue, completionBlock: nil)
    }
    
    /**
     * Shows the HUD while a block is executing on the specified dispatch queue, executes completion block on the main queue, and then hides the HUD.
     *
     * @param animated If set to YES the HUD will (dis)appear using the current animationType. If set to NO the HUD will
     * not use animations while (dis)appearing.
     * @param block The block to be executed while the HUD is shown.
     * @param queue The dispatch queue on which the block should be executed.
     * @param completion The block to be executed on completion.
     *
     * @see completionBlock
     */
    func show(animated: Bool, whileExecutingBlock block: () -> (), on queue: DispatchQueue, completionBlock completion: MBProgressHUDCompletionBlock) {
        taskInProgress = true
        completionBlock() = completion
        queue.async(execute: {(_: Void) -> Void in
            block()
            DispatchQueue.main.async(execute: {(_: Void) -> Void in
            self.cleanUp()
            })
        })
        show(animated)
    }

    /**
     * A block that gets called after the HUD was completely hidden.
     */
    var completionBlock = MBProgressHUDCompletionBlock()
#endif
    
    
    
    
    //  Converted to Swift 4 by Swiftify v4.1.6659 - https://objectivec2swift.com/
    @objc func launchExecution() {
        autoreleasepool {
            //clang diagnostic push
            //clang diagnostic ignored "-Warc-performSelector-leaks"
            // Start executing the requested task
            (targetForExecution as! NSObjectProtocol).perform(methodForExecution, with: objectForExecution)
            //clang diagnostic pop
            // Task completed, update view in main thread (note: view operations should
            // be done only in the main thread)
            performSelector(onMainThread: #selector(cleanUp), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func cleanUp() {
        isTaskInProgress = false
        indicator = nil
//        #if !__has_feature(objc_arc)
//
//        #else
//            targetForExecution = nil
//            objectForExecution = nil
//        #endif
        
        
        targetForExecution = nil
        objectForExecution = nil
        
        hide(useAnimation!)
    }
    
    
    // MARK: - UI
    func setupLabels() {
        label = UILabel(frame: bounds)
        label?.adjustsFontSizeToFitWidth = false
        label?.textAlignment             = .center
        label?.isOpaque                  = false
        label?.backgroundColor           = UIColor.clear
        label?.textColor                 = UIColor.white
        label?.font                      = labelFont
        label?.text                      = labelText! as String
        addSubview(label!)
        
        detailsLabel = UILabel(frame: bounds)
        detailsLabel?.adjustsFontSizeToFitWidth = false
        detailsLabel?.textAlignment             = .center
        detailsLabel?.isOpaque                  = false
        detailsLabel?.backgroundColor           = UIColor.clear
        detailsLabel?.textColor                 = UIColor.white
        detailsLabel?.numberOfLines             = 0
        detailsLabel?.font                      = detailsLabelFont
        detailsLabel?.text                      = detailsLabelText! as String
        addSubview(detailsLabel!)
        
    }

    
    
    
    
    func updateIndicators() {
        let isActivityIndicator: Bool = indicator is UIActivityIndicatorView
        let isRoundIndicator: Bool = indicator is MBRoundProgressView
        if mode == .indeterminate && !isActivityIndicator {
            // Update to indeterminate indicator
            indicator?.removeFromSuperview()
            indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            (indicator as? UIActivityIndicatorView)?.startAnimating()
            addSubview(indicator!)
        } else if mode == .determinateHorizontalBar {
            // Update to bar determinate indicator
            indicator?.removeFromSuperview()
            indicator = MBBarProgressView()
            addSubview(indicator!)
        }
        else if mode == .determinate || mode == .annularDeterminate {
            if !isRoundIndicator {
                // Update to determinante indicator
                indicator?.removeFromSuperview()
                indicator = MBRoundProgressView()
                addSubview(indicator!)
            }
            if mode == .annularDeterminate {
                (indicator as? MBRoundProgressView)?.isAnnular = true
            }
        } else if mode == .customView && customView != indicator {
            // Update custom view indicator
            indicator?.removeFromSuperview()
            indicator = customView
            addSubview(indicator!)
        } else if mode == .text {
            indicator?.removeFromSuperview()
            indicator = nil
        }
        
    }

    
    
    
    // MARK: - Layout
    override func layoutSubviews() {
        // Entirely cover the parent view
        let parent: UIView? = superview
        if parent != nil {
            frame = (parent?.bounds)!
        }
        let bounds: CGRect = self.bounds
        // Determine the total widt and height needed
        let maxWidth: CGFloat = bounds.size.width - 4 * margin!
        var totalSize = CGSize.zero
        var indicatorF: CGRect = indicator!.bounds
        indicatorF.size.width = min(indicatorF.size.width, maxWidth)
        totalSize.width = max(totalSize.width, indicatorF.size.width)
        totalSize.height += indicatorF.size.height
        
        var labelSize: CGSize = label!.text!.size(withAttributes: [NSAttributedStringKey.font: label!.font])
        labelSize.width = min(labelSize.width, maxWidth)
        totalSize.width = max(totalSize.width, labelSize.width)
        totalSize.height += labelSize.height
        if labelSize.height > 0.0 && indicatorF.size.height > 0.0 {
            totalSize.height += kPadding
        }
        let remainingHeight: CGFloat = bounds.size.height - totalSize.height - kPadding - 4 * margin!
        let maxSize = CGSize(width: maxWidth, height: remainingHeight)

        
        let attribute : NSDictionary = [NSAttributedStringKey.font : detailsLabel?.font as Any]
        var detailsLabelSize: CGSize = (detailsLabel?.text!.boundingRect(with: maxSize, options: [.truncatesLastVisibleLine, .usesLineFragmentOrigin, .usesFontLeading], attributes: (attribute as! [NSAttributedStringKey : Any]), context: nil).size)!
        
// detailsLabelSize = CGSize.zero
// detailsLabelSize = CGSize.zero
// detailsLabelSize = CGSize.zero
        if detailsLabel?.text == nil || detailsLabel?.text == "" {
            detailsLabelSize = CGSize.zero
        }
        
        totalSize.width = max(totalSize.width, detailsLabelSize.width)
        totalSize.height += detailsLabelSize.height
        if detailsLabelSize.height > 0.0 && (indicatorF.size.height > 0.0 || labelSize.height > 0.0) {
            totalSize.height += kPadding
        }
        totalSize.width += 2 * margin!
        totalSize.height += 2 * margin!

        
        // Position elements
        var yPos: CGFloat = CGFloat(roundf(Float((bounds.size.height - totalSize.height) / 2))) + margin! + yOffset!
        let xPos: CGFloat = CGFloat(xOffset!)
        indicatorF.origin.y = yPos
        indicatorF.origin.x = CGFloat(roundf(Float((bounds.size.width - indicatorF.size.width) / 2))) + xPos
        indicator?.frame = indicatorF
        yPos += indicatorF.size.height
        if labelSize.height > 0.0 && indicatorF.size.height > 0.0 {
            yPos += kPadding
        }
        var labelF = CGRect.zero
        labelF.origin.y = yPos
        labelF.origin.x = CGFloat(roundf(Float((bounds.size.width - labelSize.width) / 2))) + xPos
        labelF.size = labelSize
        label?.frame = labelF
        yPos += labelF.size.height

        if detailsLabelSize.height > 0.0 && (indicatorF.size.height > 0.0 || labelSize.height > 0.0) {
            yPos += kPadding
        }
        var detailsLabelF = CGRect.zero
        detailsLabelF.origin.y = yPos
        detailsLabelF.origin.x = CGFloat(roundf(Float((bounds.size.width - detailsLabelSize.width) / 2))) + xPos
        detailsLabelF.size = detailsLabelSize
        detailsLabel?.frame = detailsLabelF

        //Enforce minsize and quare rules
        if isSquare! {
            let maxWH: CGFloat = max(totalSize.width, totalSize.height)
            if maxWH <= bounds.size.width - 2 * margin! {
                totalSize.width = maxWH
            }
            if maxWH <= bounds.size.height - 2 * margin! {
                totalSize.height = maxWH
            }
        }
        if totalSize.width < (minSize?.width)! {
            totalSize.width = (minSize?.width)!
        }
        if totalSize.height < (minSize?.height)! {
            totalSize.height = (minSize?.height)!
        }
        size = totalSize
        
    }
    
    
    
    
    
    
    
    // MARK: BG Drawing
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        UIGraphicsPushContext(context!)
        
        if isDimBackground! {
            //Gradient colours
            let colorSpace                    = CGColorSpaceCreateDeviceRGB()
            let gradColors       : [CGFloat]  = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.75]
            let gradLocations    : [CGFloat]  = [0.0, 1.0]
            let gradLocationsNum : size_t     = 2
            let gradient = CGGradient(colorSpace: colorSpace, colorComponents: gradColors, locations: gradLocations, count: gradLocationsNum)
            
            
            //Gradient center
            let gradCenter = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
            //Gradient radius
            let gradRadius: CGFloat = min(bounds.size.width, bounds.size.height)
            //Gradient draw
            context!.drawRadialGradient(gradient!, startCenter: gradCenter, startRadius: 0, endCenter: gradCenter, endRadius: gradRadius, options: .drawsAfterEndLocation)
        }

        
        // Set background rect color
        if (color != nil) {
            context?.setFillColor((color?.cgColor)!)
        } else {
            context?.setFillColor(gray: 0.0, alpha: opacity!)
        }
        
        // Center HUD
        let allRect: CGRect = bounds
        // Draw rounded HUD backgroud rect
        let boxRect = CGRect(x: CGFloat(roundf(Float((allRect.size.width - (size?.width)!) / 2))) + xOffset!,
                             y: CGFloat(roundf(Float((allRect.size.height - (size?.height)!) / 2))) + yOffset!,
                             width: (size?.width)!,
                             height: (size?.height)!)
        let radius: CGFloat = 10.0
        context?.beginPath()
        context?.move(to: CGPoint(x: boxRect.minX + radius,
                                  y: boxRect.minY))
        context?.addArc(center: CGPoint(x: boxRect.maxX - radius,
                                        y: boxRect.minY + radius),
                        radius: radius,
                        startAngle: CGFloat.pi * 3 / 2,
                        endAngle: 0,
                        clockwise: false)
        context?.addArc(center: CGPoint(x: boxRect.maxX - radius,
                                        y: boxRect.maxY - radius),
                        radius: radius,
                        startAngle: 0,
                        endAngle: CGFloat.pi / 2,
                        clockwise: false)
        context?.addArc(center: CGPoint(x: boxRect.minX + radius,
                                        y: boxRect.maxY - radius),
                        radius: radius,
                        startAngle:CGFloat.pi / 2,
                        endAngle: CGFloat.pi,
                        clockwise: false)
        context?.addArc(center: CGPoint(x: boxRect.minX + radius,
                                        y: boxRect.minY + radius),
                        radius: radius,
                        startAngle: CGFloat.pi,
                        endAngle: CGFloat.pi * 3 / 2,
                        clockwise: false)

        context?.closePath()
        context?.fillPath()

        UIGraphicsPopContext()
        
    }

    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Notifications
    func registerForNotifications() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(deviceOrientationDidChange(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func unregisterFromNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func deviceOrientationDidChange(_ notification: Notification?) {
        let superview: UIView? = self.superview
        if superview == nil {
            return
        } else if (superview is UIWindow) {
            self.setTransformForCurrentOrientation(true)
        } else {
            bounds = (self.superview?.bounds)!
            setNeedsDisplay()
        }
    }
    
    
    
    
    
    func setTransformForCurrentOrientation(_ animated: Bool) {
        // Stay in sync with the superview
        if (superview != nil) {
            bounds = (superview?.bounds)!
            setNeedsDisplay()
        }
        let orientation: UIInterfaceOrientation = UIApplication.shared.statusBarOrientation
        var radians: CGFloat = 0
        if UIInterfaceOrientationIsLandscape(orientation) {
            if orientation == .landscapeLeft {
                radians = -CGFloat.pi/2
            } else {
                radians = CGFloat.pi/2
            }
            // Window coordinates differ!
            bounds = CGRect(x: 0, y: 0, width: bounds.size.height, height: bounds.size.width)
        } else {
            if orientation == .portraitUpsideDown {
                radians = CGFloat.pi
            } else {
                radians = 0
            }
        }
        
        rotationTransform = CGAffineTransform(rotationAngle: radians)
        if animated {
            UIView.beginAnimations(nil, context: nil)
        }
        transform = rotationTransform!
        if animated {
            UIView.commitAnimations()
        }
    }

    
    
    
}




















// ============================================= MBRoundProgressView =============================================
// ============================================= MBRoundProgressView =============================================
// ============================================= MBRoundProgressView =============================================
// ============================================= MBRoundProgressView =============================================
// ============================================= MBRoundProgressView =============================================
/**
 * A progress view for showing definite progress by filling up a circle (pie chart).
 */
class MBRoundProgressView: UIView {
    
    /**
     * Progress (0.0 to 1.0)
     */
    var progress: CGFloat? {
        didSet {
            setNeedsDisplay()
        }
    }
    /**
     * Indicator progress color.
     * Defaults to white [UIColor whiteColor]
     */
    var progressTintColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    /**
     * Indicator background (non-progress) color.
     * Defaults to translucent white (alpha 0.1)
     */
    var backgroundTintColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    /*
     * Display mode - NO = round or YES = annular. Defaults to round.
     */
    var isAnnular: Bool? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    
    
    
    
    
    
    
    convenience init() {
        self.init(frame: CGRect(x: 0.0, y: 0.0, width: 37.0, height: 37.0))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        isOpaque = false
        progress = 0.0
        isAnnular = false
        progressTintColor = UIColor(white: 1.0, alpha: 1.0)
        backgroundTintColor = UIColor(white: 1.0, alpha: 0.1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Drawing
    override func draw(_ rect: CGRect) {
        let allRect: CGRect = bounds
        let circleRect: CGRect = allRect.insetBy(dx: 2.0, dy: 2.0)
        let context = UIGraphicsGetCurrentContext()
        
        
        if isAnnular! {
            // Draw background
            let lineWidth: CGFloat = 5.0
            let processBackgroundPath = UIBezierPath()
            processBackgroundPath.lineWidth = lineWidth
            processBackgroundPath.lineCapStyle = .round
            let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
            let radius: CGFloat = (bounds.size.width - lineWidth) / 2
            let startAngle = -CGFloat.pi/2
            // 90 degrees
            var endAngle: CGFloat = (2 * CGFloat.pi) + startAngle
            processBackgroundPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            backgroundTintColor?.set()
            processBackgroundPath.stroke()
            
            // Draw progress
            let processPath = UIBezierPath()
            processPath.lineCapStyle = .round
            processPath.lineWidth = lineWidth
            endAngle = (progress! * 2 * CGFloat.pi) + startAngle
            processPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            progressTintColor?.set()
            processPath.stroke()

        }
        else {
            // Draw background
            progressTintColor?.setStroke()
            backgroundTintColor?.setFill()
            context?.setLineWidth(2.0)
            context?.fillEllipse(in: circleRect)
            context?.strokeEllipse(in: circleRect)
            // Draw progress
            let center = CGPoint(x: allRect.size.width / 2, y: allRect.size.height / 2)
            let radius: CGFloat = (allRect.size.width - 4) / 2
            let startAngle = -CGFloat.pi/2
            // 90 degrees
            let endAngle: CGFloat = (progress! * 2 * CGFloat.pi) + startAngle
            context?.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            // white
            context?.move(to: CGPoint(x: center.x, y: center.y))
            context?.addArc(center: CGPoint(x: center.x, y: center.y), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            context?.closePath()
            context?.fillPath()
        }
    }
    
    
    
}













// ============================================= MBBarProgressView =============================================
// ============================================= MBBarProgressView =============================================
// ============================================= MBBarProgressView =============================================
// ============================================= MBBarProgressView =============================================
// ============================================= MBBarProgressView =============================================
/**
 * A flat bar progress view.
 */
class MBBarProgressView: UIView {
    
    /**
     * Progress (0.0 to 1.0)
     */
    var progress: CGFloat? {
        didSet {
            setNeedsDisplay()
        }
    }
    /**
     * Bar border line color.
     * Defaults to white [UIColor whiteColor].
     */
    var lineColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    /**
     * Bar background color.
     * Defaults to clear [UIColor clearColor];
     */
    var progressRemainingColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    /**
     * Bar progress color.
     * Defaults to white [UIColor whiteColor].
     */
    var progressColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    convenience init() {
        self.init(frame: CGRect(x: 0.0, y: 0.0, width: 120.0, height: 20.0))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        progress = 0.0
        lineColor = UIColor.white
        progressColor = UIColor.white
        progressRemainingColor = UIColor.clear
        backgroundColor = UIColor.clear
        isOpaque = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        // setup properties
        context?.setLineWidth(2)
        context?.setStrokeColor((lineColor?.cgColor)!)
        context?.setFillColor((progressRemainingColor?.cgColor)!)
        
        
        // draw line border
        var radius: CGFloat = (rect.size.height / 2) - 2
        
        context?.move(to: CGPoint(x: 2,
                                  y: rect.size.height / 2))
        
        context?.addArc(tangent1End: CGPoint(x: 2, y: 2),
                        tangent2End: CGPoint(x: radius + 2,
                                             y: 2),
                        radius: radius)
        
        context?.addLine(to: CGPoint(x: rect.size.width - radius - 2,
                                     y: 2))
        
        context?.addArc(tangent1End: CGPoint(x: rect.size.width - 2,
                                             y: 2),
                        tangent2End: CGPoint(x: rect.size.width - 2,
                                             y: rect.size.height / 2),
                        radius: radius)
        
        context?.addArc(tangent1End: CGPoint(x: rect.size.width - 2,
                                             y: rect.size.height - 2),
                        tangent2End: CGPoint(x: rect.size.width - radius - 2,
                                             y: rect.size.height - 2),
                        radius: radius)
        
        context?.addLine(to: CGPoint(x: radius + 2,
                                     y: rect.size.height - 2))
        
        context?.addArc(tangent1End: CGPoint(x: 2,
                                             y: rect.size.height - 2),
                        tangent2End: CGPoint(x: 2,
                                             y: rect.size.height / 2),
                        radius: radius)
        
        context?.fillPath()
        
        
        // draw progress background
        context?.move(to: CGPoint(x: 2,
                                  y: rect.size.height / 2))
        
        context?.addArc(tangent1End: CGPoint(x: 2,
                                             y: 2),
                        tangent2End: CGPoint(x: radius + 2,
                                             y: 2),
                        radius: radius)
        
        context?.addLine(to: CGPoint(x: rect.size.width - radius - 2,
                                     y: 2))
        
        context?.addArc(tangent1End: CGPoint(x: rect.size.width - 2,
                                             y: 2),
                        tangent2End: CGPoint(x: rect.size.width - 2,
                                             y: rect.size.height / 2),
                        radius: radius)
        
        context?.addArc(tangent1End: CGPoint(x: rect.size.width - 2,
                                             y: rect.size.height - 2),
                        tangent2End: CGPoint(x: rect.size.width - radius - 2,
                                             y: rect.size.height - 2),
                        radius: radius)
        
        context?.addLine(to: CGPoint(x: radius + 2,
                                     y: rect.size.height - 2))
        
        context?.addArc(tangent1End: CGPoint(x: 2,
                                             y: rect.size.height - 2),
                        tangent2End: CGPoint(x: 2,
                                             y: rect.size.height / 2),
                        radius: radius)
        
        context?.strokePath()
        
        
        
        // setup to draw progress color
        context?.setFillColor((progressColor?.cgColor)!)
        radius = radius - 2
        let amount: CGFloat = progress! * rect.size.width

        
        
        
        // if progress is in the middle area
        if amount >= radius + 4 && amount <= (rect.size.width - radius - 4) {
            
            // top
            context?.move(to: CGPoint(x: 4,
                                      y: rect.size.height / 2))
            
            context?.addArc(tangent1End: CGPoint(x: 4,
                                                 y: 4),
                            tangent2End: CGPoint(x: radius + 4,
                                                 y: 4),
                            radius: radius)
            
            context?.addLine(to: CGPoint(x: Int(amount),
                                         y: 4))
            
            context?.addLine(to: CGPoint(x: amount,
                                         y: radius + 4))
            // bottom
            context?.move(to: CGPoint(x: 4,
                                      y: rect.size.height / 2))
            
            context?.addArc(tangent1End: CGPoint(x: 4,
                                                 y: rect.size.height - 4),
                            tangent2End: CGPoint(x: radius + 4,
                                                 y: rect.size.height - 4),
                            radius: radius)
            
            context?.addLine(to: CGPoint(x: amount,
                                         y: rect.size.height - 4))
            
            context?.addLine(to: CGPoint(x: amount,
                                         y: radius + 4))
            
            context?.fillPath()
        }
        
        // progress is in the right arc
        else if amount > radius + 4 {
            
            let x: CGFloat = amount - (rect.size.width - radius - 4)
            
            // top
            context?.move(to: CGPoint(x: 4, y: rect.size.height / 2))
           
            context?.addArc(tangent1End: CGPoint(x: 4,
                                                 y: 4),
                            tangent2End: CGPoint(x: Int(radius + 4),
                                                 y: 4),
                            radius: radius)
            
            context?.addLine(to: CGPoint(x: rect.size.width - radius - 4,
                                         y: 4))
            
            var angle: CGFloat = -(acos(x / radius))
            if angle.isNaN {
                angle = 0
            }
           
            context?.addArc(center: CGPoint(x: rect.size.width - radius - 4,
                                            y: rect.size.height / 2),
                            radius: radius,
                            startAngle: CGFloat.pi,
                            endAngle: CGFloat(angle),
                            clockwise: false)
            
            context?.addLine(to: CGPoint(x: amount,
                                         y: rect.size.height / 2))
            
            // bottom
            context?.move(to: CGPoint(x: 4, y: rect.size.height / 2))
            
            context?.addArc(tangent1End: CGPoint(x: 4,
                                                 y: rect.size.height - 4),
                            tangent2End: CGPoint(x: radius + 4,
                                                 y: rect.size.height - 4),
                            radius: radius)
            
            context?.addLine(to: CGPoint(x: rect.size.width - radius - 4,
                                         y: rect.size.height - 4))
            
            angle = acos(x / radius)
            if angle.isNaN {
                angle = 0
            }
            
            context?.addArc(center: CGPoint(x: rect.size.width - radius - 4,
                                            y: rect.size.height / 2),
                            radius: radius,
                            startAngle: -CGFloat.pi,
                            endAngle: CGFloat(angle),
                            clockwise: true)
            
            context?.addLine(to: CGPoint(x: amount,
                                         y: rect.size.height / 2))
            
            context?.fillPath()
        }
        // progress is in the left arc
        else if amount < radius + 4 && amount > 0 {
            
            // top
           context?.move(to: CGPoint(x: 4,
                                      y: rect.size.height / 2))

            context?.addArc(tangent1End: CGPoint(x: 4,
                                                 y: 4),
                            tangent2End: CGPoint(x: Int(radius + 4),
                                                 y: 4),
                            radius: radius)
            
            context?.addLine(to: CGPoint(x: radius + 4,
                                         y: rect.size.height / 2))
            
            // bottom
            context?.move(to: CGPoint(x: 4,
                                      y: rect.size.height / 2))
            
            context?.addArc(tangent1End: CGPoint(x: 4,
                                                 y: rect.size.height - 4),
                            tangent2End: CGPoint(x: radius + 4,
                                                 y: rect.size.height - 4),
                            radius: radius)
            
            context?.addLine(to: CGPoint(x: radius + 4,
                                         y: rect.size.height / 2))
            
            context?.fillPath()
        }

    }
    
    
    
    
    
    
    
    
}





















