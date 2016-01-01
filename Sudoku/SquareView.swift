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

	@IBOutlet weak var label: UILabel!
	
	init(value: Int)
	{
		super.init(frame: CGRectMake(0, 0, 0, 0))
		if let view = NSBundle.mainBundle().loadNibNamed("SquareView", owner: self, options: nil).first as? UIView {
			addSubview(view)
			view.translatesAutoresizingMaskIntoConstraints = false
			addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view":view]))
			addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view":view]))
		}
		if value > 0
		{
			label.text = String(value)

		}
		else
		{
			label.text = ""
			label.font = UIFont(name: "BrandonGrotesque-Light", size: 40)
		}
		label.adjustsFontSizeToFitWidth = true
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	@IBAction func tapGesture(sender: UITapGestureRecognizer) {
		controller.showControl()
	}
}