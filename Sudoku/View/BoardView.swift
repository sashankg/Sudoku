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
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func drawNumbersForSquares(given: [Square], found: [Square])
	{
		for stack in stacks
		{
			for square in stack.subviews
			{
				square.removeFromSuperview()
			}
		}
		var sorted = (given + found).sort { s1, s2 in (s1.x * 9) + s1.y < (s2.x * 9) + s2.y }
		for x in 0..<9
		{
			for y in 0..<9
			{
				var value: Int {
					if let square = sorted.first
					{
						if square.x == x && square.y == y
						{
							sorted.removeFirst()
							return square.value
						}
					}
					return 0
				}
				let square = Square(value: value, x: x, y: y)
				let squareView = SquareView(square: square, given: given.contains(square))
				squareView.controller = controller
				stacks[y].addArrangedSubview(squareView)
			}
		}
	}
	
	func deselectAllSquares()
	{
		for stack in stacks
		{
			for subview in stack.subviews
			{
				let square = subview as! SquareView
				square.unhighlight()
			}
		}
	}
}