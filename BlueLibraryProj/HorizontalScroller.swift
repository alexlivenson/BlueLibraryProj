//
//  HorizontalScroller.swift
//  BlueLibraryProj
//
//  Created by alex livenson on 9/14/15.
//  Copyright (c) 2015 alex livenson. All rights reserved.
//

import UIKit

@objc protocol HorizontalScrollerDelegate: NSObjectProtocol {
    // ask the delegate how many views it wants to present insdie the scroller
    func numberOfViewsForHorizontalScroller(scroller: HorizontalScroller) -> Int
    
    // ask the delegate to return the view that should appert at <index>
    func horizontalScroller(scroller: HorizontalScroller, viewAtIndex index: Int) -> UIView
    
    // inform the delegate what the view at <index> has been clicked
    func horizontalScroller(scroller: HorizontalScroller, clickedViewAtIndex index: Int)
    
    // ask the delegate for the index of the initial view to display. This method is optional
    // and defaults to 0 if not implemented by the delegate
    optional func initialViewIndexForHorizontalScroller(scroller: HorizontalScroller) -> Int
}

class HorizontalScroller: UIView {
    
    private let VIEW_PADDING = 10 as CGFloat
    private let VIEW_DIMENSIONS = 100 as CGFloat
    private let VIEWS_OFFSET = 100 as CGFloat
    
    private let scroller: UIScrollView
    var delegate: HorizontalScrollerDelegate?
    
    
    override init(frame: CGRect) {
        scroller = UIScrollView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        
        super.init(frame: frame)
        
        // NOTE: cannot use self until super is called
        scroller.delegate = self
        self.addSubview(scroller)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "scrollerTapped:")
        scroller.addGestureRecognizer(tapRecognizer)
    }
    
    override func didMoveToSuperview() {
        reload()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reload() {
        if let d = self.delegate {
            // 1 - remove all subviews
            for view in scroller.subviews {
                view.removeFromSuperview()
            }
            
            // 2 - xValue is startign point of the view inside scroller
            var xValue = VIEWS_OFFSET
            for var i = 0; i < self.delegate?.numberOfViewsForHorizontalScroller(self); i++ {
                
                // 3 - add a view at the right position
                xValue += VIEW_PADDING
                var view = self.delegate?.horizontalScroller(self, viewAtIndex: i)
                
                view?.frame = CGRectMake(xValue, VIEW_PADDING, VIEW_DIMENSIONS, VIEW_DIMENSIONS)
                
                if let view = view {
                    scroller.addSubview(view)
                }
                
                xValue += VIEW_DIMENSIONS + VIEW_PADDING
                
                // 4
                scroller.contentSize = CGSizeMake(xValue + VIEWS_OFFSET, self.frame.size.height)
                
                // 6 - if an initial view is defined, center the scroller on it
                if let initialView = d.initialViewIndexForHorizontalScroller?(self) {
                    scroller.contentOffset = CGPointMake(CGFloat(initialView) * (VIEW_DIMENSIONS + 2 * VIEW_PADDING), 0)
                }
            }
            
        }
    }
    
    func scrollerTapped(gesture: UITapGestureRecognizer) {
        var location = gesture.locationInView(gesture.view)
        
        // Enumerate over only the subviews that we added
        for var i = 0; i < self.delegate?.numberOfViewsForHorizontalScroller(self); i++ {
            var view = scroller.subviews[i] as? UIView
            
            if let view = view {
                if CGRectContainsPoint(view.frame, location) {
                    self.delegate?.horizontalScroller(self, clickedViewAtIndex: i)
                    
                    // center the view
                    let point = CGPointMake(view.frame.origin.x  - frame.size.width / 2 + view.frame.size.width / 2, 0)
                    scroller.setContentOffset(point, animated: true)
                    break
                }
            }
        }
    }
    
    func centerCurrentView() {
        var xFinal = scroller.contentOffset.x + (VIEWS_OFFSET / 2) + VIEW_PADDING
        var viewIndex = xFinal / (VIEW_DIMENSIONS + 2 * VIEW_PADDING)
        scroller.setContentOffset(CGPointMake(xFinal, 0), animated: true)
        self.delegate?.horizontalScroller(self, clickedViewAtIndex: Int(viewIndex))
    }
    
}

extension HorizontalScroller: UIScrollViewDelegate {
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            centerCurrentView()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        centerCurrentView()
    }
}
