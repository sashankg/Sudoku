//
//  Puzzle.swift
//  Sudoku
//
//  Created by Sashank Gogula on 12/24/15.
//  Copyright © 2015 sashankg. All rights reserved.
//

import Foundation
import EDStorage

class Puzzle: NSObject, NSCoding {
	
	var puzzle: [Square]
	var solution: [Square]
	var playerSquares: [Square]
	
	func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(NSArray(array: puzzle.map{ $0.hashValue }), forKey: PuzzlePropertyKeys.puzzleKey)
		aCoder.encodeObject(NSArray(array: solution.map{ $0.hashValue }), forKey: PuzzlePropertyKeys.solutionKey)
		aCoder.encodeObject(NSArray(array: playerSquares.map{ $0.hashValue }), forKey: PuzzlePropertyKeys.playerSquaresKey)
	}
	
	required init?(coder aDecoder: NSCoder) {
		print((aDecoder.decodeObjectForKey(PuzzlePropertyKeys.puzzleKey) as! NSArray))
		puzzle = ((aDecoder.decodeObjectForKey(PuzzlePropertyKeys.puzzleKey) as! NSArray) as! [Int]).map { hash in Square(value: hash/100, x: hash%100, y: hash%10) }
		solution = [] //(aDecoder.decodeObjectForKey(PuzzlePropertyKeys.solutionKey) as! NSArray) as! [Int]).map { hash in Square(value: hash/100, x: hash%100, y: hash%10) }
		playerSquares = [] //(aDecoder.decodeObjectForKey(PuzzlePropertyKeys.playerSquaresKey) as! NSArray) as! [Int]).map { hash in Square(value: hash/100, x: hash%100, y: hash%10) }

	}
	
	func save()
	{
		let data = NSKeyedArchiver.archivedDataWithRootObject(self)
		data.persistToCacheWithExtension("puzzle", success: { url, size in NSUserDefaults.standardUserDefaults().setURL(url, forKey: "puzzle")}, failure: {error in print(error)})
	}

	init(puzzle: [Square], solution: [Square])
	{
		self.puzzle = puzzle
		self.solution = solution
		self.playerSquares = []
	}
	
	struct PuzzlePropertyKeys {
		static let puzzleKey = "puzzle"
		static let solutionKey = "solution"
		static let playerSquaresKey = "player"
	}
}