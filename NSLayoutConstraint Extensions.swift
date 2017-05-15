//
//  NSLayoutConstraint Extensions.swift
//  
//
//  Created by Roselle Tanner on 4/20/17.
//
//

import UIKit

// remember view.translatesAutoresizingMaskIntoConstraints = false


extension NSLayoutConstraint {
    
    
    class func centerHorizontally(_ view: UIView) -> NSLayoutConstraint {
        let center =  NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: view.superview, attribute: .centerX, multiplier: 1, constant: 0)
        center.identifier = "centerHorizontally"
        return center
    }
    
    class func centerVertically(_ view: UIView) -> NSLayoutConstraint {
        let center = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: view.superview, attribute: .centerY, multiplier: 1, constant: 0)
        center.identifier = "centerVertically"
        return center
    }
    
    class func centerHorizontallyVertically(_ view: UIView) -> [NSLayoutConstraint] {
        let horizontal = centerHorizontally(view)
        let vertical = centerVertically(view)
        return [horizontal, vertical]
    }
    
    class func bindTop(_ view: UIView) -> NSLayoutConstraint {
        let top =  NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: view.superview, attribute: .top, multiplier: 1.0, constant: 0)
        top.identifier = "bindTop"
        return top
    }
    
    class func bindBottom(_ view: UIView) -> NSLayoutConstraint {
        let bottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: view.superview, attribute: .bottom, multiplier: 1.0, constant: 0)
        bottom.identifier = "bindBottom"
        return bottom
    }
    
    class func bindLeft(_ view: UIView) -> NSLayoutConstraint {
        let left = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: view.superview, attribute: .left, multiplier: 1.0, constant: 0)
        left.identifier = "bindLeft"
        return left
    }
    
    class func bindRight(_ view: UIView) -> NSLayoutConstraint {
        let right = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: view.superview, attribute: .right, multiplier: 1.0, constant: 0)
        right.identifier = "bindRight"
        return right
    }
    
    class func bindLeftRight(_ view: UIView) -> [NSLayoutConstraint] {
        let left = NSLayoutConstraint.bindLeft(view)
        let right = NSLayoutConstraint.bindRight(view)
        return [left, right]
    }
    class func bindTopBottom(_ view: UIView) -> [NSLayoutConstraint] {
        let top = NSLayoutConstraint.bindTop(view)
        let bottom = NSLayoutConstraint.bindBottom(view)
        return [top, bottom]
    }
    
    class func bindTopBottomLeftRight(_ view: UIView) -> [NSLayoutConstraint] {
        return bindTopBottom(view) + bindLeftRight(view)
    }
    
    class func bindHorizontal(viewLeft: UIView, viewRight: UIView) -> NSLayoutConstraint  {
        let horizontal = NSLayoutConstraint(item: viewLeft, attribute: .trailing, relatedBy: .equal, toItem: viewRight, attribute: .leading, multiplier: 1, constant: 0)
        horizontal.identifier = "bindHorizontal"
        return horizontal
    }
    
    class func bindVertical(topView: UIView, bottomView: UIView) -> NSLayoutConstraint  {
        let vertical = NSLayoutConstraint(item: topView, attribute: .bottom, relatedBy: .equal, toItem: bottomView, attribute: .top, multiplier: 1, constant: 0)
        vertical.identifier = "bindVertical"
        return vertical
    }
    
    /// constraints that bind the top, left and right to the superview, and constrains the height to the topLayoutGuide height
    ///
    /// - parameters:
    ///   - view: the view you want to constrain, add this as a subview first and remember .translatesAutoresizingMaskIntoConstraints = false
    ///   - topLayoutGuide: get this from your UIViewController
    class func matchTopGuide(_ view: UIView, topLayoutGuide: UILayoutSupport) -> [NSLayoutConstraint] {
        let top = NSLayoutConstraint.bindTop(view)
        let leftRight = NSLayoutConstraint.bindLeftRight(view)
        let height = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: topLayoutGuide, attribute: .height, multiplier: 1.0, constant: 0)
        return leftRight + [top, height]
    }
    
    /// constraints that bind the bottom, left and right to the superview, and constrains the height to the bottomLayoutGuide height
    ///
    /// - parameters:
    ///   - view: the view you want to constrain, add this as a subview first and remember .translatesAutoresizingMaskIntoConstraints = false
    ///   - bottomLayoutGuide: get this from your UIViewController
    class func matchBottomGuide(_ view: UIView, bottomLayoutGuide: UILayoutSupport) -> [NSLayoutConstraint] {
        let bottom = NSLayoutConstraint.bindBottom(view)
        let leftRight = NSLayoutConstraint.bindLeftRight(view)
        let height = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: bottomLayoutGuide, attribute: .height, multiplier: 1.0, constant: 0)
        return leftRight + [bottom, height]
    }
    
    class func equalRatio(_ view: UIView) -> NSLayoutConstraint {
        let ratio = NSLayoutConstraint(item: view, attribute: .width, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .height, multiplier: 1, constant: 0)
        ratio.identifier = "equalRatio"
        return ratio
    }
    
    class func keepWidth(_ view: UIView) -> NSLayoutConstraint {
        let width = NSLayoutConstraint(item: view, attribute: .width, relatedBy: NSLayoutRelation.equal, toItem: view.superview, attribute: .width, multiplier: 1, constant: 0)
        width.identifier = "keepWidth"
        return width
    }
    
    class func keepHeight(_ view: UIView) -> NSLayoutConstraint {
        let height = NSLayoutConstraint(item: view, attribute: .height, relatedBy: NSLayoutRelation.equal, toItem: view.superview, attribute: .height, multiplier: 1, constant: 0)
        height.identifier = "keepHeight"
        return height
    }
    
    class func keepWidthAndHeight(_ view: UIView) -> [NSLayoutConstraint] {
        let width = NSLayoutConstraint.keepWidth(view)
        let height = NSLayoutConstraint.keepHeight(view)
        return [width, height]
    }
    
    class func keepHeightWithRatio(_ view: UIView, ratio: CGFloat) -> NSLayoutConstraint {
        let height = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: view.superview, attribute: .height, multiplier: ratio, constant: 0)
        height.identifier = "keepHeightWithRatio"
        return height
    }
    
    class func keepWidthWithRatio(_ view: UIView, ratio: CGFloat) -> NSLayoutConstraint {
        let width = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: view.superview, attribute: .width, multiplier: ratio, constant: 0)
        width.identifier = "keepWidthWithRatio"
        return width
    }
    
    class func equalWidths(_ views: [UIView]) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        for i in 1..<views.count {
            let width = NSLayoutConstraint(item: views[i], attribute: .width, relatedBy: .equal, toItem: views[i-1], attribute: .width, multiplier: 1, constant: 0)
            width.identifier = "equalWidths"
            constraints.append(width)
        }
        return constraints
    }
    
    class func equalHeights(_ views: [UIView]) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        for i in 1..<views.count {
            let height = NSLayoutConstraint(item: views[i], attribute: .height, relatedBy: .equal, toItem: views[i-1], attribute: .height, multiplier: 1, constant: 0)
            height.identifier = "equalHeights"
            constraints.append(height)
        }
        return constraints
    }
    
    class func equalWidthsHeights(_ views: [UIView]) -> [NSLayoutConstraint] {
        let widths = equalWidths(views)
        let heights = equalHeights(views)
        return widths + heights
    }
    
    
    class func equalWidthTo(_ view: UIView, to referenceView: UIView, multiplier: CGFloat) -> NSLayoutConstraint {
        let width = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: referenceView, attribute: .width, multiplier: multiplier, constant: 0)
        width.identifier = "equalWidthTo"
        return width
    }
    
    class func equalHeightTo(_ view: UIView, to referenceView: UIView, multiplier: CGFloat) -> NSLayoutConstraint {
        let height = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: referenceView, attribute: .height, multiplier: multiplier, constant: 0)
        height.identifier = "equalHeightTo"
        return height
    }
    
    class func equalWidthHeightTo(_ view: UIView, to referenceView: UIView, multiplier: CGFloat) -> [NSLayoutConstraint] {
        let width = equalWidthTo(view, to: referenceView, multiplier:multiplier)
        let height = equalHeightTo(view, to: referenceView, multiplier: multiplier)
        return [width, height]
    }
    
    class func equalWidthsTo(_ views: [UIView], to referenceView: UIView, multiplier: CGFloat) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        for view in views {
            let width = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: referenceView, attribute: .width, multiplier: multiplier, constant: 0)
            width.identifier = "equalWidthsTo"
            constraints.append(width)
        }
        return constraints
    }
    
    class func equalHeightsTo(_ views: [UIView], to referenceView: UIView, multiplier: CGFloat) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        for view in views {
            let height = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: referenceView, attribute: .height, multiplier: multiplier, constant: 0)
            height.identifier = "equalWidthsTo"
            constraints.append(height)
        }
        return constraints
    }
    
    /// H:|[view1][view2][view3]|
    class func bindHorizontally(_ views: [UIView]) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        for i in 0..<views.count {
            let view = views[i]
            
            // leading
            var leading: NSLayoutConstraint
            if i == 0 { // bind first leading to superview
                leading = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.leading, relatedBy: .equal, toItem: view.superview, attribute: .leading, multiplier: 1, constant: 0)
                leading.identifier = "bindHorizontally.leading.first"
            } else {    // bind all others to the previous view
                leading = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: views[i-1], attribute: .trailing, multiplier: 1, constant: 0)
                leading.identifier = "bindHorizontally.leading"
            }
            constraints.append(leading)
        }
        
        if views.last != nil {
            let trailing = NSLayoutConstraint(item: views.last!, attribute: .trailing, relatedBy: .equal, toItem: views.last!.superview, attribute: .trailing, multiplier: 1, constant: 0)
            trailing.identifier = "bindHorizontally.trailing.last"
            constraints.append(trailing)
        }
        
        return constraints
    }
    
    /// V:|[view1][view2][view3]|
    class func bindVertically(_ views: [UIView]) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        for i in 0..<views.count {
            let view = views[i]
            
            // top
            var top: NSLayoutConstraint
            if i == 0 {
                
                // bind first top to superview
                top = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.top, relatedBy: .equal, toItem: view.superview, attribute: .top, multiplier: 1, constant: 0)
                top.identifier = "bindVertically.top.first"
            } else {
                
                // bind all others to the previous view
                top = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: views[i-1], attribute: .bottom, multiplier: 1, constant: 0)
                top.identifier = "bindVertically.top"
            }
            constraints.append(top)
        }
        
        // bottom
        var bottom: NSLayoutConstraint
        if views.last != nil {
            // bind last bottom to superview
            bottom = NSLayoutConstraint(item: views.last!, attribute: .bottom, relatedBy: .equal, toItem: views.last!.superview, attribute: .bottom, multiplier: 1, constant: 0)
            bottom.identifier = "bindVertically.last count: \(views.count)"
            constraints.append(bottom)
        }
        
        return constraints
    }
    
    class func makeHorizontalScrollViewAndActivate(items: [UIView], container: UIView, numOfItemsInBounds: CGFloat) -> UIScrollView {
        
        // make a scrollview
        let scrollView = UIScrollView()
        container.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(NSLayoutConstraint.bindTopBottomLeftRight(scrollView))
        
        // add the items
        for item in items {
            scrollView.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate(NSLayoutConstraint.bindTopBottom(item))
        }
        let oneAfterAnother = NSLayoutConstraint.bindHorizontally(items)
        let widths = NSLayoutConstraint.equalWidthsTo(items, to: container, multiplier: 1/numOfItemsInBounds)
        let heights = NSLayoutConstraint.equalHeightsTo(items, to: container, multiplier: 1.0)
        NSLayoutConstraint.activate(oneAfterAnother + widths + heights)
        
        return scrollView
    }
}
