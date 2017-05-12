//
//  SScrollControl.swift
//  ScrollControl
//
//  Created by Roselle Tanner on 5/11/17.
//  Copyright © 2017 Roselle Tanner. All rights reserved.
//


import UIKit


/// Swipe back and forth horizontally to see/select different UIView's. To use, set the items property.  The view fades to the right and left, leaving the selection in focus in the middle. Sample items will be shown in interface builder only.

@IBDesignable class ScrollControl: UIView {
    var items: [UIView]? = nil { didSet { setup() } }
    var currentItem: Int = 0
    fileprivate var activeWidth: CGFloat { return self.frame.width/numOfItemsInBounds }
    fileprivate var inset: CGFloat { return (self.frame.width - activeWidth)/2 }
    fileprivate var scrollView: UIScrollView? = nil
    @IBInspectable var numOfItemsInBounds: CGFloat = 2.0 {
        didSet {
            // set sample items for IB
            #if TARGET_INTERFACE_BUILDER
                items = [UILabel(text: "one"), UILabel(text: "two"), UILabel(text: "three"), UILabel(text: "four"), UILabel(text: "five")]
            #else
            setup()
            #endif
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func reset() {
        self.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    func setup() {
        guard let items = items, items.count > 0 else { return }
        reset()
        
        // setup scrollView
        scrollView = NSLayoutConstraint.addToHorizontalScrollViewAndActivate(items: items, container: self, numOfItemsInBounds: numOfItemsInBounds)
        scrollView!.backgroundColor = UIColor.darkGray
        scrollView!.contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        scrollView!.delegate = self
        scrollView!.showsHorizontalScrollIndicator = false
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        
        // setup the gradient on edges
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
        let viewInset = (self.frame.width - items[0].frame.width)/2
        let leftStop = viewInset/self.frame.width
        let rightStop = 1 - leftStop
        gradient.locations = [0, NSNumber(value: Float(leftStop)), NSNumber(value: Float(rightStop)), 1.0]
        self.layer.mask = gradient
        
        // select the initial item
        selectItem(0)
    }
    
    func selectItem(_ item: Int) {
        guard let items = items, item < items.count, let scrollView = scrollView else { return }
        self.currentItem = item
        scrollView.scrollRectToVisible(items[item].frame, animated: false)
    }
}

extension ScrollControl: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let centerTarget = targetContentOffset.pointee.x + 0.5 * scrollView.frame.width
        currentItem = Int(centerTarget/activeWidth)
        print("offset: \(targetContentOffset.pointee.x), scrollView.width: \(scrollView.frame.width), activeWidth: \(activeWidth), centerTarget: \(centerTarget), currentItem: \(currentItem)")
        targetContentOffset.pointee.x = CGFloat(currentItem) * activeWidth - scrollView.contentInset.left
        print("newOffset: \(targetContentOffset.pointee.x)")
    }
}

extension UILabel {
    convenience init(text: String) {
        self.init(frame: CGRect.zero)
        self.text = text
        self.textAlignment = .center
    }
}
