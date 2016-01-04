//
//  NoMistakesViewController.swift
//  Sudoku
//
//  Created by Sashank Gogula on 1/3/16.
//  Copyright © 2016 sashankg. All rights reserved.
//

import Foundation
import UIKit
class NoMistakesViewController: MessageViewController {
	@IBAction func continueButtonPressed(sender: UIButton) {
		dismissViewControllerAnimated(true) {
			self.controller.zoomIn()
		}
	}
}