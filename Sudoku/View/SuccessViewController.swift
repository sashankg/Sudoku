//
//  SuccessViewController.swift
//  Sudoku
//
//  Created by Sashank Gogula on 1/3/16.
//  Copyright © 2016 sashankg. All rights reserved.
//

import Foundation
import UIKit
class SuccessViewController: MessageViewController {
	@IBAction func againButtonPressed(sender: UIButton) {
		dismissViewControllerAnimated(true) { () -> Void in
			self.controller.newGame()
		}
	}
	
}