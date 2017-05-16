//
//  SScrollControl.swift
//  ScrollControl
//
//  Created by Roselle Tanner on 5/11/17.
//  Copyright © 2017 Roselle Tanner. All rights reserved.
//


import UIKit


protocol ScrollControlProtocol {
    /// called when the user scrolls to a new item
    func scrollControl(_ scrollControl:ScrollControl,  didSelectItem: Int)
}

/// Swipe back and forth horizontally to see/select different UIView's. To use, set the items property after layout.  The view fades to the right and left, leaving the selection in focus in the middle. Sample items will be shown in interface builder only.

@IBDesignable class ScrollControl: UIView {
    var delegate: ScrollControlProtocol? = nil
    fileprivate var items: [UIView]? = nil
    fileprivate var leadingConstraints: [NSLayoutConstraint]? = nil
    fileprivate var trailingConstraint: NSLayoutConstraint? = nil
    fileprivate var currentItemIndex: Int = 0
    fileprivate var activeWidth: CGFloat { return self.frame.width/numOfItemsInBounds }
    fileprivate var inset: CGFloat { return (self.frame.width - activeWidth)/2 }
    fileprivate var scrollView = UIScrollView()
    
    /// The number of items that fit in the bounds of the scrollControl.
    /// - example: If set to 3, one will be in focus in the center, one will fade to the left and one will fade to the right.
    @IBInspectable var numOfItemsInBounds: CGFloat = 3 {
        didSet {
            if items != nil {
                setupAll()
                if items!.count > 0 {
                    selectItem(atIndex: currentItemIndex)
                }
            } else {
                #if TARGET_INTERFACE_BUILDER
                    setItems([UILabel(text: "one"), UILabel(text: "two"), UILabel(text: "three"), UILabel(text: "four"), UILabel(text: "five")])
                #endif
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


// MARK: Setup

extension ScrollControl {
    fileprivate func setupAll() {
        resetConstraints()
        setupScrollView()
        setupItems()
        setupGradient()
    }
    
    fileprivate func setupScrollView() {
        
        // constraints
        self.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(NSLayoutConstraint.bindTopBottomLeftRight(scrollView))
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        // attributes
        scrollView.backgroundColor = UIColor.darkGray
        scrollView.contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    
    fileprivate func setupItems() {
        assert(items != nil, "setupItems items = nil")
        guard let items = items, let last = items.last else { return }
        
        // add the items, set the constant constraints
        for item in items {
            scrollView.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
            let topBottom = NSLayoutConstraint.bindTopBottom(item)
            let width = NSLayoutConstraint.equalWidthTo(item, to: self, multiplier: 1/numOfItemsInBounds)
            let height = NSLayoutConstraint.equalHeightTo(item, to: self, multiplier: 1.0)
            NSLayoutConstraint.activate(topBottom + [width, height])
        }
        
        // set the changing constraints
        leadingConstraints = [NSLayoutConstraint]()
        for i in 0..<items.count {
            let item = items[i]
            
            // leading
            var leading: NSLayoutConstraint
            if i == 0 { // bind first leading to superview
                leading = NSLayoutConstraint.bindLeft(item)
            } else {    // bind all others to the previous view
                leading = NSLayoutConstraint.bindHorizontal(viewLeft: items[i-1], viewRight: item)
            }
            leadingConstraints!.append(leading)
        }
        
        // trailing
        trailingConstraint = NSLayoutConstraint.bindRight(last)
        
        // activate
        NSLayoutConstraint.activate(leadingConstraints! + [trailingConstraint!])
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    fileprivate func setupGradient() {
        assert(items != nil, "setupGradient items = nil")
        guard let items = items else { return }
        
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
        let viewInset = inset
        let leftStop = viewInset/self.frame.width
        let rightStop = 1 - leftStop
        gradient.locations = [0, NSNumber(value: Float(leftStop)), NSNumber(value: Float(rightStop)), 1.0]
        self.layer.mask = gradient
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func resetConstraints() {
        items?.forEach({$0.removeFromSuperview()})
        scrollView.removeFromSuperview()
        leadingConstraints = nil
        trailingConstraint = nil
    }
}

// MARK: Item Management (Public methods)

extension ScrollControl {
    
    func getCurrentItemIndex() -> Int {
        return self.currentItemIndex
    }
    
    func getItems() -> [UIView]? {
        return self.items
    }
    
    func setItems(_ items: [UIView], andSelectIndex index: Int = 0) {
        self.resetItemsAndConstraints()
        self.items = items
        setupAll()
        if items.count > 0 {
            selectItem(atIndex: index)
        }
    }
    

    func resetItemsAndConstraints() {
        resetConstraints()
        items = nil
        currentItemIndex = 0
    }
    
    func selectItem(atIndex index: Int) {
        assert(items == nil || (items != nil && index >= 0 && index < items!.count), "selectItem out of bounds")
        guard let items = items, index < items.count, index >= 0 else { return }
        if index != currentItemIndex { self.currentItemIndex = index }
        scrollView.scrollRectToVisible(items[index].frame, animated: false)
    }
    
    func appendItem(_ item: UIView) {
        insertItem(item, atIndex: items?.count ?? 0)
    }
    
    func insertItem(_ item: UIView, atIndex index: Int) {
        assert((items == nil && index == 0) || (items != nil && index >= 0 && index <= items!.count), "insertItem out of bounds")
        guard let items = items, items.count > 0 else {
            setItems([item])
            return
        }
        guard index <= items.count, index >= 0, let leadingConstraints = leadingConstraints, leadingConstraints.count == items.count, let trailingConstraint = trailingConstraint else { return }
        
        let isFirst = index == 0
        let isLast = index == items.count
        
        // add the items, set the constant constraints
        scrollView.insertSubview(item, at: index)
        item.translatesAutoresizingMaskIntoConstraints = false
        let topBottom = NSLayoutConstraint.bindTopBottom(item)
        let width = NSLayoutConstraint.equalWidthTo(item, to: self, multiplier: 1/numOfItemsInBounds)
        let height = NSLayoutConstraint.equalHeightTo(item, to: self, multiplier: 1.0)
        NSLayoutConstraint.activate(topBottom + [width, height])
        
        // trailing constraint, replace
        let oldTrailing: NSLayoutConstraint
        let trailing: NSLayoutConstraint
        if isLast {
            oldTrailing = trailingConstraint
            trailing = NSLayoutConstraint.bindRight(item)
            self.trailingConstraint! = trailing
        } else {
            oldTrailing = leadingConstraints[index]
            trailing = NSLayoutConstraint.bindHorizontal(viewLeft: item, viewRight: items[index])
            self.leadingConstraints![index] = trailing
        }
        
        // leading constraint, insert new
        let leading: NSLayoutConstraint
        if isFirst {
            leading = NSLayoutConstraint.bindLeft(item)
        } else {
            leading = NSLayoutConstraint.bindHorizontal(viewLeft: items[index - 1], viewRight: item)
        }
        self.leadingConstraints!.insert(leading, at: index)
        
        self.items!.insert(item, at: index)
        NSLayoutConstraint.deactivate([oldTrailing])
        NSLayoutConstraint.activate([leading, trailing])
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func removeItem(atIndex index: Int) -> UIView? {
        assert(items != nil && index >= 0 && index < items!.count, "removeItem out of bounds")
        guard let items = items, items.count > 0, index < items.count else { return nil }
        guard let leadingConstraints = leadingConstraints, leadingConstraints.count == items.count, let trailingConstraint = trailingConstraint else { print("removeItem constraints issue"); return nil }////throw
        if items.count == 1 {
            if index == 0 {
                let item = items[0]
                resetItemsAndConstraints()
                return item
            } else {
                return nil
            }
        }
        
        let isFirst = index == 0
        let isLast = index == items.count - 1
        
        let oldLeading = self.leadingConstraints!.remove(at: index)
        let oldTrailing: NSLayoutConstraint
        let trailing: NSLayoutConstraint
        if isFirst {
            oldTrailing = leadingConstraints[0]
            trailing = NSLayoutConstraint.bindLeft(items[1])
            self.leadingConstraints![0] = trailing
        } else if isLast {
            oldTrailing = trailingConstraint
            trailing = NSLayoutConstraint.bindRight(items[index - 1])
            self.trailingConstraint! = trailing
        } else {
            oldTrailing = leadingConstraints[index]
            trailing = NSLayoutConstraint.bindHorizontal(viewLeft: items[index - 1], viewRight: items[index + 1])
            self.leadingConstraints![index] = trailing
        }
        NSLayoutConstraint.deactivate([oldLeading, oldTrailing])
        NSLayoutConstraint.activate([trailing])
        
        let item = self.items!.remove(at: index)
        item.removeFromSuperview()
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        return item
    }
}


// MARK: UIScrollViewDelegate Methods

extension ScrollControl: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let centerTarget = targetContentOffset.pointee.x + 0.5 * scrollView.frame.width
        currentItemIndex = Int(centerTarget/activeWidth)
        targetContentOffset.pointee.x = CGFloat(currentItemIndex) * activeWidth - scrollView.contentInset.left
        delegate?.scrollControl(self, didSelectItem: currentItemIndex)
    }
}

extension UILabel {
    convenience init(text: String) {
        self.init(frame: CGRect.zero)
        self.text = text
        self.textAlignment = .center
        self.textColor = .white
    }
}
