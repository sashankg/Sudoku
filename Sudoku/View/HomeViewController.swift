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
		gameViewModel.generateNewGame()
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let destination = segue.destinationViewController as? GameViewController
		{
			print(gameViewModel)
			destination.viewModel = gameViewModel
		}
	}
}