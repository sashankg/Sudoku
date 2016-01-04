//
//  MessageViewController.swift
//  Sudoku
//
//  Created by Sashank Gogula on 1/3/16.
//  Copyright © 2016 sashankg. All rights reserved.
//

import Foundation
import UIKit
class MessageViewController: UIViewController {
	var controller: GameViewController!
	
	@IBAction func backButtonPressed(sender: UIButton)
	{
		dismissViewControllerAnimated(true) { () -> Void in
			self.controller.performSegueWithIdentifier("unwindHome", sender: self)
		}
	}
	
	@IBAction func settingsButtonPressed(sender: UIButton)
	{
		dismissViewControllerAnimated(true) { () -> Void in
			self.controller.performSegueWithIdentifier("toSettings", sender: self)
		}
	}
	
}