//
//  RoundBorderedButton.swift
//  RoundBorderedButton
//
//  Created by 구범모 on 2015. 4. 10..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import UIKit

@IBDesignable class RoundBorderedButton: UIControl {
    // MARK: Default value
    private static let defaultBorderWidth: CGFloat = 2
    
    // MARK: Property
    @IBInspectable var title: String? {
        didSet {
            if buttonView != nil {
                addTitleAndImageView()
            }
        }
    }
    
    @IBInspectable var image: UIImage? {
        didSet {
            if buttonView != nil {
                addTitleAndImageView()
            }
        }
    }
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if buttonView == nil {
            addButtonView()
            addTitleAndImageView()
        }
    }
    
    // MARK: Button
    private var buttonView: UIView?
    var titleLabel: UILabel?
    var imageView: UIImageView?
    
    private func addButtonView() {
        let button = UIView(frame: CGRectZero)
        button.backgroundColor = UIColor.clearColor()
        button.layer.borderWidth = borderWidth
        button.layer.borderColor = tintColor.CGColor
        button.layer.cornerRadius = bounds.width / 2
        addSubview(button)
        buttonView = button
        
        addConstraintsFor(button, toFitInside: self)
        layoutIfNeeded()
    }
    
    private func addTitleAndImageView() {
        removeSubviewsFor(buttonView!)
        
        switch (title, image) {
        case (nil, nil): return
        case (_, nil):
            if self.titleLabel == nil {
                let titleLabel = addTitleViewTo(buttonView!)
                self.titleLabel = titleLabel
            }
        case (nil, _):
            if self.imageView == nil {
                let imageView = addImageViewTo(buttonView!)
                self.imageView = imageView
            }
        case (_, _):
            if self.titleLabel == nil && self.imageView == nil {
                let subview = addTitleAndImageViewTo(buttonView!)
                self.titleLabel = subview.titleLabel
                self.imageView = subview.imageView
            }
        default: return
        }
        
        addSelectedView()
        if selected == true {
            showSelectedView()
        } else {
            hideSelectedView()
        }
    }
    
    // MARK: Apperance
    @IBInspectable var borderWidth = RoundBorderedButton.defaultBorderWidth
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        buttonView?.layer.borderColor = tintColor.CGColor
        titleLabel?.textColor = tintColor
    }
    
    // MARK: Touch
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        if self.pointInside(point, withEvent: event) == true {
            return self
        } else {
            return super.hitTest(point, withEvent: event)
        }
    }
    
    // MARK: Selected state
    private var selectedBackgroundView: UIView?
    private var selectedContainerView: UIView?
    private var selectedTitleLabel: UILabel?
    private var selectedImageView: UIImageView?
    private var selectedContainerMaskView: UIView?
    
    private var showSelectedViewDuration = 0.75
    private var showSelectedViewDamping: CGFloat = 0.6
    private var showSelectedViewVelocity: CGFloat = 0.9
    private var hideSelectedViewDuration = 0.3
    private var hideSelectedViewDamping: CGFloat = 0.9
    private var hideSelectedViewVelocity: CGFloat = 0.9
    
    override var selected: Bool {
        willSet {
            if newValue == true {
                showSelectedView()
            } else {
                hideSelectedView()
            }
        }
    }
    
    private func addSelectedView() {
        func addSelectedBacgroundView() {
            let selectedBackgroundView = UIView(frame: CGRectZero)
            selectedBackgroundView.backgroundColor = tintColor
            selectedBackgroundView.layer.cornerRadius = bounds.width / 2
            buttonView?.addSubview(selectedBackgroundView)
            self.selectedBackgroundView = selectedBackgroundView
            
            addConstraintsFor(selectedBackgroundView, toEqualSizeOf: buttonView!)
        }
        
        func addSelectedContainerView() {
            let selectedContainerMaskView = UIView(frame: buttonView!.bounds)
            selectedContainerMaskView.backgroundColor = UIColor.blackColor()
            selectedContainerMaskView.layer.cornerRadius = buttonView!.bounds.width / 2
            self.selectedContainerMaskView = selectedContainerMaskView
            
            if let selectedContainerView = self.selectedContainerView {
                selectedContainerView.removeFromSuperview()
            }
            
            let selectedContainerView = UIView(frame: buttonView!.bounds)
            selectedContainerView.tag = 1
            selectedContainerView.backgroundColor = UIColor.clearColor()
            selectedContainerView.maskView = selectedContainerMaskView
            buttonView?.addSubview(selectedContainerView)
            self.selectedContainerView = selectedContainerView
            
            addConstraintsFor(selectedContainerView, toEqualSizeOf: buttonView!)
            layoutIfNeeded()
            
            switch (title, image) {
            case (nil, nil): return
            case (_, nil):
                let titleLabel = addTitleViewTo(selectedContainerView)
                titleLabel.textColor = UIColor.whiteColor()
                self.selectedTitleLabel = titleLabel
            case (nil, _):
                let imageView = addImageViewTo(selectedContainerView)
                imageView.tintColor = UIColor.whiteColor()
                self.imageView = imageView
            case (_, _):
                let subviews = addTitleAndImageViewTo(selectedContainerView)
                subviews.titleLabel.textColor = UIColor.whiteColor()
                subviews.imageView.tintColor = UIColor.whiteColor()
                self.titleLabel = subviews.titleLabel
                self.imageView = subviews.imageView
            default: return
            }
        }
        
        selectedBackgroundView?.removeFromSuperview()
        selectedContainerView?.removeFromSuperview()
        addSelectedBacgroundView()
        addSelectedContainerView()
    }
    
    private func captureTitleAndImageView() -> UIImage? {
        titleLabel?.textColor = UIColor.whiteColor()
        imageView?.tintColor = UIColor.whiteColor()
        buttonView?.layer.borderColor = UIColor.clearColor().CGColor
        
        UIGraphicsBeginImageContextWithOptions(buttonView!.bounds.size, false, 0)
        buttonView?.drawViewHierarchyInRect(buttonView!.bounds, afterScreenUpdates: true)
        titleLabel?.drawViewHierarchyInRect(buttonView!.bounds, afterScreenUpdates: true)
        imageView?.drawViewHierarchyInRect(buttonView!.bounds, afterScreenUpdates: true)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        titleLabel?.textColor = tintColor
        imageView?.tintColor = tintColor
        buttonView?.layer.borderColor = tintColor.CGColor
        
         return snapshot
    }
    
    private func setSelectedViewToVisibleState() {
        selectedBackgroundView?.alpha = 1
        selectedBackgroundView?.transform = CGAffineTransformIdentity
        selectedContainerMaskView?.transform = CGAffineTransformIdentity
        selectedContainerView?.hidden = false
    }
    
    private func setSelectedViewToHiddenState() {
        selectedBackgroundView?.alpha = 0
        selectedBackgroundView?.transform = CGAffineTransformMakeScale(0.01, 0.01)
        selectedContainerMaskView?.transform = CGAffineTransformMakeScale(0.01, 0.01)
        selectedContainerView?.hidden = true
    }
    
    private func showSelectedView() {
        setSelectedViewToHiddenState()
        userInteractionEnabled = false
        
        UIView.animateWithDuration(showSelectedViewDuration, delay: 0,
            usingSpringWithDamping: showSelectedViewDamping, initialSpringVelocity: showSelectedViewVelocity,
            options: UIViewAnimationOptions.CurveLinear,
            animations: { () -> Void in
                self.setSelectedViewToVisibleState()
        }) { (finished) -> Void in
            self.userInteractionEnabled = true
        }
    }
    
    private func hideSelectedView() {
        setSelectedViewToVisibleState()
        userInteractionEnabled = false
        
        UIView.animateWithDuration(hideSelectedViewDuration, delay: 0,
            usingSpringWithDamping: hideSelectedViewDamping, initialSpringVelocity: hideSelectedViewVelocity,
            options: UIViewAnimationOptions.CurveLinear,
            animations: { () -> Void in
                self.setSelectedViewToHiddenState()
        }) { (finished) -> Void in
            self.userInteractionEnabled = true
        }
    }
    
    // MARK: Add subview helper
    func addTitleViewTo(superview: UIView) -> UILabel {
        let titleLabel = UILabel(frame: CGRectZero)
        titleLabel.text = title
        titleLabel.textColor = tintColor
        titleLabel.textAlignment = NSTextAlignment.Center
        superview.addSubview(titleLabel)
        
        addConstraintsFor(titleLabel, toEqualSizeOf: buttonView!)
        
        return titleLabel
    }
    
    func addImageViewTo(superview: UIView) -> UIImageView {
        let imageView = UIImageView(frame: CGRectZero)
        imageView.image = image
        imageView.contentMode = UIViewContentMode.Center
        imageView.clipsToBounds = true
        superview.addSubview(imageView)
        
        addConstraintFor(imageView, toFitInsideRound: buttonView!)
        
        return imageView
    }
    
    func addTitleAndImageViewTo(superview: UIView) -> (containerView: UIView, titleLabel: UILabel, imageView: UIImageView) {
        let containerView = UIView(frame: CGRectZero)
        containerView.tag = 1
        containerView.backgroundColor = UIColor.clearColor()
        superview.addSubview(containerView)
        
        addConstraintFor(containerView, toFitInsideRound: buttonView!)
        layoutIfNeeded()
        
        let containerWidth = sqrt(2) / 2 * bounds.width
        
        let titleLabel = UILabel(frame: CGRectZero)
        titleLabel.text = title
        titleLabel.textColor = tintColor
        titleLabel.textAlignment = NSTextAlignment.Center
        containerView.addSubview(titleLabel)
        
        let imageView = UIImageView(frame: CGRectZero)
        imageView.image = image
        imageView.contentMode = UIViewContentMode.Center
        imageView.clipsToBounds = true
        containerView.addSubview(imageView)
        
        addConstraintFor(imageView, lowerSubview: titleLabel, superview: containerView, lowerViewRatio: 0.33)
        
        return (containerView, titleLabel, imageView)
    }
    
    func removeSubviewsFor(view: UIView) {
        for view in view.subviews {
            if view.tag == 1 {
                for subview in view.subviews {
                    subview.removeFromSuperview()
                }
                view.removeFromSuperview()
            }
        }
        titleLabel?.removeFromSuperview()
        imageView?.removeFromSuperview()
        titleLabel = nil
        imageView = nil
    }
    
    // MARK: Auto layout helper
    private func addConstraintsFor(subview: UIView, toEqualSizeOf superview: UIView) {
        let topConstraint = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: superview, attribute: NSLayoutAttribute.Top,
            multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: superview, attribute: NSLayoutAttribute.Bottom,
            multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: superview, attribute: NSLayoutAttribute.Left,
            multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: superview, attribute: NSLayoutAttribute.Right,
            multiplier: 1, constant: 0)
        subview.setTranslatesAutoresizingMaskIntoConstraints(false)
        superview.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
    }
    
    private func addConstraintsFor(subview: UIView, toFitInside superview: UIView) {
        let fittingWidth = superview.bounds.width > superview.bounds.height ? superview.bounds.height : superview.bounds.width
        addConstraintFor(subview, toFitInsde: superview, width: fittingWidth)
    }
    
    private func addConstraintFor(subview: UIView, toFitInsideRound superview: UIView) {
        let fittingWidth = sqrt(2) / 2 * superview.bounds.width
        addConstraintFor(subview, toFitInsde: superview, width: fittingWidth)
    }
    
    private func addConstraintFor(subview: UIView, toFitInsde superview: UIView, width: CGFloat) {
        let widthConstraint = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1, constant: width)
        let ratioConstraint = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: subview, attribute: NSLayoutAttribute.Width,
            multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.CenterY,
            relatedBy: NSLayoutRelation.Equal,
            toItem: superview, attribute: NSLayoutAttribute.CenterY,
            multiplier: 1, constant: 0)
        let horizontalConstraint = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: superview, attribute: NSLayoutAttribute.CenterX,
            multiplier: 1, constant: 0)
        subview.setTranslatesAutoresizingMaskIntoConstraints(false)
        superview.addConstraints([widthConstraint, ratioConstraint, verticalConstraint, horizontalConstraint])
    }
    
    private func addConstraintFor(upperSubview: UIView, lowerSubview: UIView, superview: UIView, lowerViewRatio: CGFloat) {
        let lowerViewHeight = superview.bounds.height * lowerViewRatio
        
        let upperViewTopConstraint = NSLayoutConstraint(item: upperSubview, attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: superview, attribute: NSLayoutAttribute.Top,
            multiplier: 1, constant: 0)
        let upperViewBottomConstraint = NSLayoutConstraint(item: upperSubview, attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: lowerSubview, attribute: NSLayoutAttribute.Top,
            multiplier: 1, constant: 0)
        let upperViewLeftConstraint = NSLayoutConstraint(item: upperSubview, attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: superview, attribute: NSLayoutAttribute.Left,
            multiplier: 1, constant: 0)
        let upperViewRightConstraint = NSLayoutConstraint(item: upperSubview, attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: superview, attribute: NSLayoutAttribute.Right,
            multiplier: 1, constant: 0)
        upperSubview.setTranslatesAutoresizingMaskIntoConstraints(false)
        superview.addConstraints([upperViewTopConstraint, upperViewBottomConstraint, upperViewLeftConstraint, upperViewRightConstraint])
        
        let lowerViewHeightConstraint = NSLayoutConstraint(item: lowerSubview, attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1, constant: lowerViewHeight)
        let lowerViewBottomConstraint = NSLayoutConstraint(item: lowerSubview, attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: superview, attribute: NSLayoutAttribute.Bottom,
            multiplier: 1, constant: 0)
        let lowerViewLeftConstraint = NSLayoutConstraint(item: lowerSubview, attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: superview, attribute: NSLayoutAttribute.Left,
            multiplier: 1, constant: 0)
        let lowerViewRightConstraint = NSLayoutConstraint(item: lowerSubview, attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: superview, attribute: NSLayoutAttribute.Right,
            multiplier: 1, constant: 0)
        lowerSubview.setTranslatesAutoresizingMaskIntoConstraints(false)
        superview.addConstraints([lowerViewHeightConstraint, lowerViewBottomConstraint, lowerViewLeftConstraint, lowerViewRightConstraint])
    }
}
