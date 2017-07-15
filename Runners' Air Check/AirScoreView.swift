//
//  AirScoreView.swift
//  Runners' Air Check
//
//  Created by Christine Chang on 7/14/17.
//  Copyright © 2017 Christine Chang. All rights reserved.
//

import UIKit

class AirScoreView: UIView {
    
    var color: UIColor?
    
    // https://www.raywenderlich.com/90690/modern-core-graphics-with-swift-part-1
    override func draw(_ rect: CGRect) {
        var path = UIBezierPath(ovalIn: rect)
        color?.setFill()
        path.fill()
    }

}
