//
//  SettingsSegue.swift
//  Sudoku
//
//  Created by Sashank Gogula on 1/3/16.
//  Copyright © 2016 sashankg. All rights reserved.
//

import Foundation
import UIKit
class SettingsSegue: UIStoryboardSegue {
	override func perform() {
		let source = self.sourceViewController.view
		let destination = self.destinationViewController.view
		let screenWidth = source.bounds.size.width
		let screenHeight = source.bounds.size.height
		destination.frame = CGRectMake(0, -screenHeight, screenWidth, screenHeight)
		
		let window = UIApplication.sharedApplication().keyWindow
		window?.insertSubview(destination, aboveSubview: source)
		
		UIView.animateWithDuration(0.5, animations: {
			source.frame.origin.y = screenHeight
			destination.frame.origin.y = 0
			}, completion: { _ in
				self.sourceViewController.presentViewController(self.destinationViewController as UIViewController, animated: false, completion: nil)
		})
	}
}

class SettingsUnwindSegue: UIStoryboardSegue {
	override func perform() {
		let source = self.sourceViewController.view
		let destination = self.destinationViewController.view
		let screenWidth = source.bounds.size.width
		let screenHeight = source.bounds.size.height
		destination.frame = CGRectMake(0, screenHeight, screenWidth, screenHeight)
		
		let window = UIApplication.sharedApplication().keyWindow
		window?.insertSubview(destination, aboveSubview: source)
		
		UIView.animateWithDuration(0.5, animations: {
			source.frame.origin.y = -screenHeight
			destination.frame.origin.y = 0
			}, completion: { _ in
				self.sourceViewController.dismissViewControllerAnimated(false, completion: nil)
		})
	}
}