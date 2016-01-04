//
//  SquareView.swift
//  Sudoku
//
//  Created by Sashank Gogula on 12/13/15.
//  Copyright © 2015 sashankg. All rights reserved.
//

import Foundation
import UIKit
@available(iOS 9.0, *)
class SquareView: UIView {
	var customConstraints: [NSLayoutConstraint]!
	var controller: GameViewController!
	var square: Square!
	var given: Bool!
	@IBOutlet weak var label: UILabel!
	
	init(square: Square, given: Bool)
	{
		super.init(frame: CGRectMake(0, 0, 0, 0))
		self.square = square
		if let view = NSBundle.mainBundle().loadNibNamed("SquareView", owner: self, options: nil).first as? UIView {
			addSubview(view)
			view.translatesAutoresizingMaskIntoConstraints = false
			addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view":view]))
			addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view":view]))
		}
		
		label.text = String(square.value)
		
		if !given
		{
			label.font = UIFont(name: "Dosis-Regular", size: 40)
		}
		self.given = given

		if label.text == "0"
		{
			label.text = ""
		}
		label.adjustsFontSizeToFitWidth = true
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	@IBAction func tapGesture(sender: UITapGestureRecognizer) {
		if !given
		{
			controller.editSquareView(self)
		}
	}
	
	func highlight()
	{
		UIView.animateWithDuration(0.2) {
			self.backgroundColor = UIColor.lightGrayColor()
		}
	}
	
	func unhighlight()
	{
		UIView.animateWithDuration(0.2) {
			self.backgroundColor = UIColor.clearColor()
		}
	}
}