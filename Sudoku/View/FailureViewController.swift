//
//  FailureViewController.swift
//  Sudoku
//
//  Created by Sashank Gogula on 1/3/16.
//  Copyright © 2016 sashankg. All rights reserved.
//

import Foundation
import UIKit
class FailureViewController: MessageViewController {
	@IBAction func removeMistakesButtonPressed(sender: UIButton) {
		dismissViewControllerAnimated(true) {
			self.controller.removeMistakes()
			self.controller.zoomIn()
		}
	}
	@IBAction func continueButtonPressed(sender: UIButton) {
		dismissViewControllerAnimated(true) {
			self.controller.zoomIn()
		}
	}
	
}