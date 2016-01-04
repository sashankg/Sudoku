//
//  GameViewModel.swift
//  Sudoku
//
//  Created by Sashank Gogula on 12/7/15.
//  Copyright © 2015 sashankg. All rights reserved.
//

import Foundation
import Interstellar

class GameViewModel: NSObject {
	var gameSignal: Signal<Game>
	var puzzle: [Square] {
		if let game = gameSignal.peek()
		{
			return game.puzzle
		}
		return []
	}
	var solution: [Square] {
		if let game = gameSignal.peek()
		{
			return game.solution
		}
		return []
	}
	
	var playerSquares: [Square]
	var solver: Solver
	override init()
	{
		solver = Solver()
		gameSignal = Signal()
		playerSquares = []
		super.init()
		gameSignal.next { game in
			self.playerSquares = game.playerSquares
		}
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "saveGame", name: UIApplicationWillResignActiveNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "saveGame", name: UIApplicationWillTerminateNotification, object: nil)
	}
	
	func loadGame()
	{
		if puzzle.isEmpty
		{
			if let url = NSUserDefaults.standardUserDefaults().URLForKey("puzzle")
			{
				let game = NSKeyedUnarchiver.unarchiveObjectWithData(NSData(contentsOfFile: url.path!)!) as! Game
				self.gameSignal.update(game)
			}
			else
			{
				generateNewGame()
			}
		}
		else
		{
			generateNewGame()
		}

	}
	
	private func generateNewGame()
	{
		let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
		dispatch_async(dispatch_get_global_queue(priority, 0)) {
			let game = self.solver.createNewGame()
			self.gameSignal.update(game)
			game.save()
		}
	}
	
	func updateSquare(square: Square)
	{
		if !playerSquares.isEmpty
		{
			let index = (0..<playerSquares.count).reduce(nil as Int?) { selectedIndex, index in
				if selectedIndex == nil
				{
					if playerSquares[index].x == square.x && playerSquares[index].y == square.y
					{
						return index
					}
				}
				return selectedIndex
			}
			
			if let index = index
			{
				playerSquares.removeAtIndex(index)
			}
		}
		if square.value > 0
		{
			playerSquares.append(square)
		}
	}
	
	func saveGame()
	{
		print("Game Saved")
		let game = Game(puzzle: puzzle, solution: solution, playerSquares: playerSquares)
		game.save()
	}
	
	func removeMistakes()
	{
		playerSquares = playerSquares.filter { square in solution.contains(square) }
	}
	
	func checkProgress() -> Progress
	{
		let playerSquares = self.playerSquares.sort({ $0.hashValue < $1.hashValue})
		let solution = self.solution.sort({ $0.hashValue < $1.hashValue})
		if playerSquares == solution
		{
			return .Finished
		}
		let goodSoFar = playerSquares.reduce(true) { passed, square in
			if passed
			{
				return solution.contains(square)
			}
			return false
		}
		if goodSoFar
		{
			return .GoodSoFar
		}
		return .Mistake
	}
	
	func giveHint()
	{
		for square in solution
		{
			if !playerSquares.contains(square)
			{
				playerSquares.append(square)
				break
			}
		}
	}
}

enum Progress
{
	case Finished
	case Mistake
	case GoodSoFar
}



