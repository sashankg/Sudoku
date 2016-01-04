//
//  SettingsViewController.swift
//  Sudoku
//
//  Created by Sashank Gogula on 1/3/16.
//  Copyright © 2016 sashankg. All rights reserved.
//

import Foundation
import UIKit
class SettingsViewController: UIViewController {
	var controller: GameViewController!
	
	@IBAction func newGameButtonPressed(sender: UIButton) {
		controller.newGame()
		performSegueWithIdentifier("unwindSettings", sender: self)
	}
}
