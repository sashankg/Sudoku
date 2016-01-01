//
//  BoardView.swift
//  Sudoku
//
//  Created by Sashank Gogula on 12/7/15.
//  Copyright © 2015 sashankg. All rights reserved.
//

import Foundation
import UIKit
@available(iOS 9.0, *)
class BoardView: UIView {
	
	@IBOutlet var stacks: [UIStackView]!
	var controller: GameViewController!
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
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func drawNumbersForSquares(squares: [Square])
	{
		for stack in stacks
		{
			for square in stack.subviews
			{
				square.removeFromSuperview()
			}
		}
		var sorted = squares.sort { s1, s2 in (s1.x * 9) + s1.y < (s2.x * 9) + s2.y }
		for x in 0..<9
		{
			for y in 0..<9
			{
				var value: Int = 0
				if let square = sorted.first
				{
					if square.x == x+1 && square.y == y+1
					{
						value = square.value
						sorted.removeFirst()
					}
				}
				let squareView = SquareView(value: value)
				squareView.controller = controller
				stacks[y].addArrangedSubview(squareView)
			}
		}
	}
}