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
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        buttonView?.layer.borderColor = tintColor.cgColor
        titleLabel?.textColor = tintColor
    }
    
    fileprivate var buttonView: UIView?
    var titleLabel: UILabel?
    var imageView: UIImageView?
    
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
    fileprivate func addButtonView() {
        let button = UIView(frame: CGRect.zero)
        button.backgroundColor = UIColor.clear
        button.layer.borderWidth = borderWidth
        button.layer.borderColor = tintColor.cgColor
        button.layer.cornerRadius = bounds.width / 2
        self.addToFitInside(subview: button)
        buttonView = button
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
            buttonView?.addToEqualSize(subview: selectedBackgroundView)
            self.selectedBackgroundView = selectedBackgroundView
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
            buttonView?.addToEqualSize(subview: selectedContainerView)
            self.selectedContainerView = selectedContainerView
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
        superview.addToEqualSize(subview: titleLabel)
        
        return titleLabel
    }
    
    func addImageViewTo(_ superview: UIView) -> UIImageView {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.image = image
        imageView.contentMode = UIViewContentMode.center
        imageView.clipsToBounds = true
        superview.addToFitInsideRound(subview: imageView)
        
        return imageView
    }
    
    func addTitleAndImageViewTo(_ superview: UIView) -> (containerView: UIView, titleLabel: UILabel, imageView: UIImageView) {
        let containerView = UIView(frame: CGRect.zero)
        containerView.tag = 1
        containerView.backgroundColor = UIColor.clear
        
        superview.addToFitInsideRound(subview: containerView)
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
        containerView.add(upperSubview: imageView, lowerSubview: titleLabel, lowerViewRatio: 0.33)
        
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
}

extension UIView {
    fileprivate func addToEqualSize(subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        subview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    fileprivate func addToFitInside(subview: UIView) {
        let fittingWidth = bounds.width > bounds.height ? bounds.height : bounds.width
        add(subview: subview, toFitWidth: fittingWidth)
    }
    
    fileprivate func addToFitInsideRound(subview: UIView) {
        let fittingWidth = sqrt(2) / 2 * bounds.width
        add(subview: subview, toFitWidth: fittingWidth)
    }
    
    private func add(subview: UIView, toFitWidth width: CGFloat) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        subview.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        subview.widthAnchor.constraint(equalToConstant: width).isActive = true
        subview.heightAnchor.constraint(equalTo: subview.widthAnchor).isActive = true
    }
    
    fileprivate func add(upperSubview: UIView, lowerSubview: UIView, lowerViewRatio: CGFloat) {
        addSubview(upperSubview)
        addSubview(lowerSubview)
        
        upperSubview.translatesAutoresizingMaskIntoConstraints = false
        upperSubview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        upperSubview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        upperSubview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        upperSubview.bottomAnchor.constraint(equalTo: lowerSubview.topAnchor).isActive = true
        
        let lowerViewHeight = bounds.height * lowerViewRatio
        lowerSubview.translatesAutoresizingMaskIntoConstraints = false
        lowerSubview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        lowerSubview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        lowerSubview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        lowerSubview.heightAnchor.constraint(equalToConstant: lowerViewHeight).isActive = true
    }
}
