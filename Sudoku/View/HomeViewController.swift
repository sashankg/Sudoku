//
//  HomeViewController.swift
//  Sudoku
//
//  Created by Sashank Gogula on 12/21/15.
//  Copyright © 2015 sashankg. All rights reserved.
//

import Foundation
import UIKit
class HomeViewController: UIViewController  {
	var gameViewModel: GameViewModel!
	@IBAction func returnFromSegueActions(sender: UIStoryboardSegue){
	}
	
	override func viewDidLoad() {
		gameViewModel = GameViewModel()
		gameViewModel.loadGame()
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let destination = segue.destinationViewController as? GameViewController
		{
			destination.viewModel = gameViewModel
		}
	}
	@IBAction func linkToWebsite(sender: UIButton) {
		UIApplication.sharedApplication().openURL(NSURL(string: "http://sashank.ga")!)
	}
}
