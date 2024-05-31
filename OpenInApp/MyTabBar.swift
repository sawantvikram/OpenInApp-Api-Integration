//
//  MyTabBar.swift
//  OpenInApp
//
//  Created by Touchzing media on 24/04/24.
//

import Foundation
import UIKit
@IBDesignable
class MyTabBar: UITabBar {

    private var shapeLayer: CALayer?
    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        
        //The below 4 lines are for shadow above the bar. you can skip them if you do not want a shadow
        shapeLayer.shadowOffset = CGSize(width:0, height:0)
        shapeLayer.shadowRadius = 10
        shapeLayer.shadowColor = UIColor.gray.cgColor
        shapeLayer.shadowOpacity = 0.3

        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    override func draw(_ rect: CGRect) {
        self.addShape()
    }
    func createPath() -> CGPath {
        let curveHeight: CGFloat = 50.0 // Height of the curve above the tab bar
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        let tabBarHeight = self.frame.height
        
        // Move to the top left corner of the tab bar
        path.move(to: CGPoint(x: 0, y: 0))
        
        // Line to the starting point of the curve
        path.addLine(to: CGPoint(x: centerWidth - 40, y: 0))
        
        // Curve to the middle point above the tab bar
        path.addQuadCurve(to: CGPoint(x: centerWidth + 40, y: 0), controlPoint: CGPoint(x: centerWidth, y: -curveHeight))
        
        // Line to the top right corner of the tab bar
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        
        // Line to the top right corner of the tab bar
        path.addLine(to: CGPoint(x: self.frame.width, y: tabBarHeight))
        
        // Line to the top left corner of the tab bar
        path.addLine(to: CGPoint(x: 0, y: tabBarHeight))
        
        // Close the path
        path.close()
        
        return path.cgPath
    }


    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
            for member in subviews.reversed() {
                let subPoint = member.convert(point, from: self)
                guard let result = member.hitTest(subPoint, with: event) else { continue }
                return result
            }
            return nil
        }
}
