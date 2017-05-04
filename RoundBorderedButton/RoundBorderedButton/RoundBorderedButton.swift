//
//  RoundBorderedButton.swift
//  RoundBorderedButton
//
//  Created by 구범모 on 2015. 4. 10..
//  Copyright (c) 2015년 gbmKSquare. All rights reserved.
//

import UIKit

@IBDesignable class RoundBorderedButton: UIControl {
    fileprivate static let defaultBorderWidth: CGFloat = 2
    
    @IBInspectable var borderWidth = RoundBorderedButton.defaultBorderWidth
    
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
    
    override var isSelected: Bool {
        willSet {
            if newValue == true {
                showSelectedView()
            } else {
                hideSelectedView()
            }
        }
    }
    
    fileprivate var selectedBackgroundView: UIView?
    fileprivate var selectedContainerView: UIView?
    fileprivate var selectedTitleLabel: UILabel?
    fileprivate var selectedImageView: UIImageView?
    fileprivate var selectedContainerMaskView: UIView?
    
    fileprivate var showSelectedViewDuration = 0.75
    fileprivate var showSelectedViewDamping: CGFloat = 0.6
    fileprivate var showSelectedViewVelocity: CGFloat = 0.9
    fileprivate var hideSelectedViewDuration = 0.3
    fileprivate var hideSelectedViewDamping: CGFloat = 0.9
    fileprivate var hideSelectedViewVelocity: CGFloat = 0.9
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
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
    fileprivate var buttonView: UIView?
    var titleLabel: UILabel?
    var imageView: UIImageView?
    
    fileprivate func addButtonView() {
        let button = UIView(frame: CGRect.zero)
        button.backgroundColor = UIColor.clear
        button.layer.borderWidth = borderWidth
        button.layer.borderColor = tintColor.cgColor
        button.layer.cornerRadius = bounds.width / 2
        addSubview(button)
        buttonView = button
        
        addConstraintsFor(button, toFitInside: self)
        layoutIfNeeded()
    }
    
    fileprivate func addTitleAndImageView() {
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
        }
        
        addSelectedView()
        if isSelected == true {
            showSelectedView()
        } else {
            hideSelectedView()
        }
    }
    
    // MARK: Apperance
    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        buttonView?.layer.borderColor = tintColor.cgColor
        titleLabel?.textColor = tintColor
    }
    
    // MARK: Touch
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.point(inside: point, with: event) == true {
            return self
        } else {
            return super.hitTest(point, with: event)
        }
    }
    
    // MARK: Selected state
    fileprivate func addSelectedView() {
        func addSelectedBacgroundView() {
            let selectedBackgroundView = UIView(frame: CGRect.zero)
            selectedBackgroundView.backgroundColor = tintColor
            selectedBackgroundView.layer.cornerRadius = bounds.width / 2
            buttonView?.addSubview(selectedBackgroundView)
            self.selectedBackgroundView = selectedBackgroundView
            
            addConstraintsFor(selectedBackgroundView, toEqualSizeOf: buttonView!)
        }
        
        func addSelectedContainerView() {
            let selectedContainerMaskView = UIView(frame: buttonView!.bounds)
            selectedContainerMaskView.backgroundColor = UIColor.black
            selectedContainerMaskView.layer.cornerRadius = buttonView!.bounds.width / 2
            self.selectedContainerMaskView = selectedContainerMaskView
            
            if let selectedContainerView = self.selectedContainerView {
                selectedContainerView.removeFromSuperview()
            }
            
            let selectedContainerView = UIView(frame: buttonView!.bounds)
            selectedContainerView.tag = 1
            selectedContainerView.backgroundColor = UIColor.clear
            selectedContainerView.mask = selectedContainerMaskView
            buttonView?.addSubview(selectedContainerView)
            self.selectedContainerView = selectedContainerView
            
            addConstraintsFor(selectedContainerView, toEqualSizeOf: buttonView!)
            layoutIfNeeded()
            
            switch (title, image) {
            case (nil, nil): return
            case (_, nil):
                let titleLabel = addTitleViewTo(selectedContainerView)
                titleLabel.textColor = UIColor.white
                self.selectedTitleLabel = titleLabel
            case (nil, _):
                let imageView = addImageViewTo(selectedContainerView)
                imageView.tintColor = UIColor.white
                self.imageView = imageView
            case (_, _):
                let subviews = addTitleAndImageViewTo(selectedContainerView)
                subviews.titleLabel.textColor = UIColor.white
                subviews.imageView.tintColor = UIColor.white
                self.titleLabel = subviews.titleLabel
                self.imageView = subviews.imageView
            }
        }
        
        selectedBackgroundView?.removeFromSuperview()
        selectedContainerView?.removeFromSuperview()
        addSelectedBacgroundView()
        addSelectedContainerView()
    }
    
    fileprivate func captureTitleAndImageView() -> UIImage? {
        titleLabel?.textColor = UIColor.white
        imageView?.tintColor = UIColor.white
        buttonView?.layer.borderColor = UIColor.clear.cgColor
        
        UIGraphicsBeginImageContextWithOptions(buttonView!.bounds.size, false, 0)
        buttonView?.drawHierarchy(in: buttonView!.bounds, afterScreenUpdates: true)
        titleLabel?.drawHierarchy(in: buttonView!.bounds, afterScreenUpdates: true)
        imageView?.drawHierarchy(in: buttonView!.bounds, afterScreenUpdates: true)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        titleLabel?.textColor = tintColor
        imageView?.tintColor = tintColor
        buttonView?.layer.borderColor = tintColor.cgColor
        
         return snapshot
    }
    
    fileprivate func setSelectedViewToVisibleState() {
        selectedBackgroundView?.alpha = 1
        selectedBackgroundView?.transform = CGAffineTransform.identity
        selectedContainerMaskView?.transform = CGAffineTransform.identity
        selectedContainerView?.isHidden = false
    }
    
    fileprivate func setSelectedViewToHiddenState() {
        selectedBackgroundView?.alpha = 0
        selectedBackgroundView?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        selectedContainerMaskView?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        selectedContainerView?.isHidden = true
    }
    
    fileprivate func showSelectedView() {
        setSelectedViewToHiddenState()
        isUserInteractionEnabled = false
        
        UIView.animate(withDuration: showSelectedViewDuration, delay: 0,
            usingSpringWithDamping: showSelectedViewDamping, initialSpringVelocity: showSelectedViewVelocity,
            options: UIViewAnimationOptions.curveLinear,
            animations: { () -> Void in
                self.setSelectedViewToVisibleState()
        }) { (finished) -> Void in
            self.isUserInteractionEnabled = true
        }
    }
    
    fileprivate func hideSelectedView() {
        setSelectedViewToVisibleState()
        isUserInteractionEnabled = false
        
        UIView.animate(withDuration: hideSelectedViewDuration, delay: 0,
            usingSpringWithDamping: hideSelectedViewDamping, initialSpringVelocity: hideSelectedViewVelocity,
            options: UIViewAnimationOptions.curveLinear,
            animations: { () -> Void in
                self.setSelectedViewToHiddenState()
        }) { (finished) -> Void in
            self.isUserInteractionEnabled = true
        }
    }
    
    // MARK: Add subview helper
    func addTitleViewTo(_ superview: UIView) -> UILabel {
        let titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.text = title
        titleLabel.textColor = tintColor
        titleLabel.textAlignment = NSTextAlignment.center
        superview.addSubview(titleLabel)
        
        addConstraintsFor(titleLabel, toEqualSizeOf: buttonView!)
        
        return titleLabel
    }
    
    func addImageViewTo(_ superview: UIView) -> UIImageView {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.image = image
        imageView.contentMode = UIViewContentMode.center
        imageView.clipsToBounds = true
        superview.addSubview(imageView)
        
        addConstraintFor(imageView, toFitInsideRound: buttonView!)
        
        return imageView
    }
    
    func addTitleAndImageViewTo(_ superview: UIView) -> (containerView: UIView, titleLabel: UILabel, imageView: UIImageView) {
        let containerView = UIView(frame: CGRect.zero)
        containerView.tag = 1
        containerView.backgroundColor = UIColor.clear
        superview.addSubview(containerView)
        
        addConstraintFor(containerView, toFitInsideRound: buttonView!)
        layoutIfNeeded()
        
        let containerWidth = sqrt(2) / 2 * bounds.width
        
        let titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.text = title
        titleLabel.textColor = tintColor
        titleLabel.textAlignment = NSTextAlignment.center
        containerView.addSubview(titleLabel)
        
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.image = image
        imageView.contentMode = UIViewContentMode.center
        imageView.clipsToBounds = true
        containerView.addSubview(imageView)
        
        addConstraintFor(imageView, lowerSubview: titleLabel, superview: containerView, lowerViewRatio: 0.33)
        
        return (containerView, titleLabel, imageView)
    }
    
    func removeSubviewsFor(_ view: UIView) {
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
    fileprivate func addConstraintsFor(_ subview: UIView, toEqualSizeOf superview: UIView) {
        let topConstraint = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.top,
            relatedBy: NSLayoutRelation.equal,
            toItem: superview, attribute: NSLayoutAttribute.top,
            multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.bottom,
            relatedBy: NSLayoutRelation.equal,
            toItem: superview, attribute: NSLayoutAttribute.bottom,
            multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.left,
            relatedBy: NSLayoutRelation.equal,
            toItem: superview, attribute: NSLayoutAttribute.left,
            multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.right,
            relatedBy: NSLayoutRelation.equal,
            toItem: superview, attribute: NSLayoutAttribute.right,
            multiplier: 1, constant: 0)
        subview.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
    }
    
    fileprivate func addConstraintsFor(_ subview: UIView, toFitInside superview: UIView) {
        let fittingWidth = superview.bounds.width > superview.bounds.height ? superview.bounds.height : superview.bounds.width
        addConstraintFor(subview, toFitInsde: superview, width: fittingWidth)
    }
    
    fileprivate func addConstraintFor(_ subview: UIView, toFitInsideRound superview: UIView) {
        let fittingWidth = sqrt(2) / 2 * superview.bounds.width
        addConstraintFor(subview, toFitInsde: superview, width: fittingWidth)
    }
    
    fileprivate func addConstraintFor(_ subview: UIView, toFitInsde superview: UIView, width: CGFloat) {
        let widthConstraint = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.width,
            relatedBy: NSLayoutRelation.equal,
            toItem: nil, attribute: NSLayoutAttribute.notAnAttribute,
            multiplier: 1, constant: width)
        let ratioConstraint = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: subview, attribute: NSLayoutAttribute.width,
            multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.centerY,
            relatedBy: NSLayoutRelation.equal,
            toItem: superview, attribute: NSLayoutAttribute.centerY,
            multiplier: 1, constant: 0)
        let horizontalConstraint = NSLayoutConstraint(item: subview, attribute: NSLayoutAttribute.centerX,
            relatedBy: NSLayoutRelation.equal,
            toItem: superview, attribute: NSLayoutAttribute.centerX,
            multiplier: 1, constant: 0)
        subview.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints([widthConstraint, ratioConstraint, verticalConstraint, horizontalConstraint])
    }
    
    fileprivate func addConstraintFor(_ upperSubview: UIView, lowerSubview: UIView, superview: UIView, lowerViewRatio: CGFloat) {
        let lowerViewHeight = superview.bounds.height * lowerViewRatio
        
        let upperViewTopConstraint = NSLayoutConstraint(item: upperSubview, attribute: NSLayoutAttribute.top,
            relatedBy: NSLayoutRelation.equal,
            toItem: superview, attribute: NSLayoutAttribute.top,
            multiplier: 1, constant: 0)
        let upperViewBottomConstraint = NSLayoutConstraint(item: upperSubview, attribute: NSLayoutAttribute.bottom,
            relatedBy: NSLayoutRelation.equal,
            toItem: lowerSubview, attribute: NSLayoutAttribute.top,
            multiplier: 1, constant: 0)
        let upperViewLeftConstraint = NSLayoutConstraint(item: upperSubview, attribute: NSLayoutAttribute.left,
            relatedBy: NSLayoutRelation.equal,
            toItem: superview, attribute: NSLayoutAttribute.left,
            multiplier: 1, constant: 0)
        let upperViewRightConstraint = NSLayoutConstraint(item: upperSubview, attribute: NSLayoutAttribute.right,
            relatedBy: NSLayoutRelation.equal,
            toItem: superview, attribute: NSLayoutAttribute.right,
            multiplier: 1, constant: 0)
        upperSubview.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints([upperViewTopConstraint, upperViewBottomConstraint, upperViewLeftConstraint, upperViewRightConstraint])
        
        let lowerViewHeightConstraint = NSLayoutConstraint(item: lowerSubview, attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: nil, attribute: NSLayoutAttribute.notAnAttribute,
            multiplier: 1, constant: lowerViewHeight)
        let lowerViewBottomConstraint = NSLayoutConstraint(item: lowerSubview, attribute: NSLayoutAttribute.bottom,
            relatedBy: NSLayoutRelation.equal,
            toItem: superview, attribute: NSLayoutAttribute.bottom,
            multiplier: 1, constant: 0)
        let lowerViewLeftConstraint = NSLayoutConstraint(item: lowerSubview, attribute: NSLayoutAttribute.left,
            relatedBy: NSLayoutRelation.equal,
            toItem: superview, attribute: NSLayoutAttribute.left,
            multiplier: 1, constant: 0)
        let lowerViewRightConstraint = NSLayoutConstraint(item: lowerSubview, attribute: NSLayoutAttribute.right,
            relatedBy: NSLayoutRelation.equal,
            toItem: superview, attribute: NSLayoutAttribute.right,
            multiplier: 1, constant: 0)
        lowerSubview.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints([lowerViewHeightConstraint, lowerViewBottomConstraint, lowerViewLeftConstraint, lowerViewRightConstraint])
    }
}
