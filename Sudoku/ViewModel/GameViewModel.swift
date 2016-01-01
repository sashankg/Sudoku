//
//  GameViewModel.swift
//  Sudoku
//
//  Created by Sashank Gogula on 12/7/15.
//  Copyright © 2015 sashankg. All rights reserved.
//

import Foundation
import Interstellar

class GameViewModel {
	var puzzleSignal: Signal<[Square]?>
	var solutionSignal: Signal<[Square]>
	var solver: Solver
	init()
	{
		solver = Solver()
		self.puzzleSignal = Signal()
		self.solutionSignal = Signal()
	}
	
	func generateNewGame()
	{
		let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
		dispatch_async(dispatch_get_global_queue(priority, 0)) {
			let game = self.solver.createNewGame()
			//game.save()
			//let game = NSKeyedUnarchiver.unarchiveObjectWithData(NSData(contentsOfFile: NSUserDefaults.standardUserDefaults().URLForKey("puzzle")!.path!)!) as! Puzzle
			let puzzle = game.puzzle
			self.puzzleSignal.update(puzzle)
			self.solutionSignal.update(game.solution)
		}
	}
}