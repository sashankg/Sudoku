//
//  GameSegue.swift
//  Sudoku
//
//  Created by Sashank Gogula on 12/21/15.
//  Copyright © 2015 sashankg. All rights reserved.
//

import Foundation
import UIKit
class GameSegue: UIStoryboardSegue {
	override func perform() {
		let source = self.sourceViewController.view
		let destination = self.destinationViewController.view
		let screenWidth = source.bounds.size.width
		let screenHeight = source.bounds.size.height
		destination.frame = CGRectMake(screenWidth, 0, screenWidth, screenHeight)

		let window = UIApplication.sharedApplication().keyWindow
		window?.insertSubview(destination, aboveSubview: source)

		UIView.animateWithDuration(0.5, animations: {
			source.frame.origin.x = -screenWidth
			destination.frame.origin.x = 0
			}, completion: { _ in
				self.sourceViewController.presentViewController(self.destinationViewController as UIViewController, animated: false, completion: nil)
		})
	}
}

class GameUnwindSegue: UIStoryboardSegue {
	override func perform() {
		let source = self.sourceViewController.view
		let destination = self.destinationViewController.view
		let screenWidth = source.bounds.size.width
		let screenHeight = source.bounds.size.height
		destination.frame = CGRectMake(-screenWidth, 0, screenWidth, screenHeight)
		let window = UIApplication.sharedApplication().keyWindow
		window?.insertSubview(destination, aboveSubview: source)
		UIView.animateWithDuration(0.5, animations: {
			source.frame.origin.x = screenWidth
			destination.frame.origin.x = 0
			}, completion: { _ in
				self.sourceViewController.dismissViewControllerAnimated(false, completion: nil)
		})
	}
}