//
//  NumberPickerViewController.swift
//  Sudoku
//
//  Created by Sashank Gogula on 1/1/16.
//  Copyright © 2016 sashankg. All rights reserved.
//

import Foundation
import UIKit
class NumberPickerViewController: UIViewController {
	@IBOutlet var buttons: [NumberButton]!
	private var squareView: SquareView?
	var controller: GameViewController!
	func editSquareView(squareView: SquareView)
	{
		self.squareView = squareView
		squareView.highlight()
		buttons.forEach { button in
			button.unhighlight()
		}
		if squareView.square.value != 0
		{
			buttons[squareView.square.value - 1].highlight()
		}
	}
	
	@IBAction func buttonPressed(button: NumberButton)
	{
		let squareView = self.squareView!
		let square = squareView.square
		if square.value == button.value
		{
			squareView.label.text = ""
			squareView.square = Square(value: 0, x: square.x, y: square.y)
		}
		else
		{
			squareView.label.text = String(button.value)
			squareView.square = Square(value: Int(button.value), x: square.x, y: square.y)
		}
		
		controller.viewModel.updateSquare(squareView.square)
		squareView.unhighlight()
		controller.hideControl()
		if controller.viewModel.playerSquares.count + controller.viewModel.puzzle.count == 81
		{
			controller.showBars()
		}
		controller.viewModel.saveGame()
	}
	
}

class NumberButton: UIButton {
	@IBInspectable var value: NSNumber!
	
	func highlight()
	{
		setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
	}
	
	func unhighlight()
	{
		setTitleColor(UIColor.blackColor(), forState: .Normal)
	}
}