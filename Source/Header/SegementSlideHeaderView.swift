//
//  SegementSlideHeaderView.swift
//  SegementSlide
//
//  Created by Jiar on 2018/12/7.
//  Copyright © 2018 Jiar. All rights reserved.
//

import UIKit

public protocol SegmentSlideHeaderViewDelegate: class {
  func hitTest(_ headerView: SegementSlideHeaderView, point: CGPoint, with event: UIEvent?) -> UIView?
}

public class SegementSlideHeaderView: UIView {
  
  public weak var delegate: SegmentSlideHeaderViewDelegate?
  
  private weak var lastHeaderView: UIView?
  private weak var segementSlideContentView: SegementSlideContentView?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  private func setup() {
    backgroundColor = .clear
  }
  
  internal func config(_ headerView: UIView?, segementSlideContentView: SegementSlideContentView) {
    guard headerView != lastHeaderView else { return }
    if let lastHeaderView = lastHeaderView {
      lastHeaderView.removeAllConstraints()
      lastHeaderView.removeFromSuperview()
    }
    guard let headerView = headerView else { return }
    self.segementSlideContentView = segementSlideContentView
    addSubview(headerView)
    headerView.constraintToSuperview()
    lastHeaderView = headerView
  }
  
  public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let view = super.hitTest(point, with: event)
    
    if let delegate = self.delegate {
      return delegate.hitTest(self, point: point, with: event)
    }
    
    guard let segementSlideContentView = segementSlideContentView else {
      return view
    }
    
    guard let selectedIndex = segementSlideContentView.selectedIndex,
          let segementSlideContentScrollViewDelegate = segementSlideContentView.dequeueReusableViewController(at: selectedIndex)
    else {
      return view
    }
    if view is UIControl {
      return view
    }
    if !(view?.gestureRecognizers?.isEmpty ?? true) {
      return view
    }
    return segementSlideContentScrollViewDelegate.scrollView
  }
}
