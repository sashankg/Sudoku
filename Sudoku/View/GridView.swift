//
//  GridView.swift
//  Sudoku
//
//  Created by Sashank Gogula on 1/1/16.
//  Copyright © 2016 sashankg. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable class GridView: UIView {
	override func drawRect(rect: CGRect) {
		let context = UIGraphicsGetCurrentContext()
		CGContextSetRGBStrokeColor(context, 0, 0, 0, 1.0)
		
		CGContextSetLineWidth(context, 5)
		CGContextStrokeRect(context, rect)
		
		CGContextSetLineWidth(context, 1)
		for i in 1..<9 {
			let i = CGFloat(i)
			CGContextMoveToPoint(context, rect.origin.x, i * rect.size.height/9)
			CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, i * rect.size.height/9)
			CGContextMoveToPoint(context, i * rect.size.width/9, rect.origin.y)
			CGContextAddLineToPoint(context, i * rect.size.width/9, rect.origin.y + rect.size.height)
		}
		CGContextStrokePath(context)
		
		CGContextSetLineWidth(context, 2)
		for i in 0...2 {
			let i = CGFloat(i)
			CGContextMoveToPoint(context, rect.origin.x, i * rect.size.height/3)
			CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, i * rect.size.height/3)
			CGContextMoveToPoint(context, i * rect.size.width/3, rect.origin.y)
			CGContextAddLineToPoint(context, i * rect.size.width/3, rect.origin.y + rect.size.height)
		}
		CGContextStrokePath(context)
	}
}