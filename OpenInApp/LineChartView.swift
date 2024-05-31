////
////  LineChartView.swift
////  OpenInApp
////
////  Created by Touchzing media on 28/03/24.
////
//
//import Foundation
//import Charts
//import UIKit
//
//class LineChartView: UIView {
//    
//    var dataPoints: [CGFloat] = []
//    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        
//        guard let context = UIGraphicsGetCurrentContext() else { return }
//        
//        // Set up drawing properties
//        context.clear(rect)
//        context.setFillColor(UIColor.white.cgColor)
//        context.fill(rect)
//        
//        // Draw line chart
//        drawLineChart(in: rect, with: context)
//    }
//    
//    private func drawLineChart(in rect: CGRect, with context: CGContext) {
//        guard dataPoints.count > 1 else { return }
//        
//        let stepX = rect.width / CGFloat(dataPoints.count - 1)
//        let stepY = rect.height / (dataPoints.max()! - dataPoints.min()!)
//        
//        context.setStrokeColor(UIColor.blue.cgColor)
//        context.setLineWidth(2.0)
//        
//        // Start drawing the line
//        context.move(to: CGPoint(x: 0, y: rect.height - dataPoints[0] * stepY))
//        
//        for (index, point) in dataPoints.enumerated() {
//            let x = CGFloat(index) * stepX
//            let y = rect.height - point * stepY
//            context.addLine(to: CGPoint(x: x, y: y))
//        }
//        
//        // Draw the path
//        context.strokePath()
//    }
//}
