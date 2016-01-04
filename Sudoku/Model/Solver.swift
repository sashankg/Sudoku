//
//  Solver
//  Sudoku
//
//  Created by Sashank Gogula on 12/13/15.
//  Copyright © 2015 sashankg. All rights reserved.
//

import Foundation
class Solver {
	private var x: [Constraint: [Square]]!
	private var y: [Square: [Constraint]]!
	
	init()
	{
		
	}
	
	private func createConstraints() -> [Constraint]
	{
		var constraints = [Constraint]()
		var key = 0
		for x in 0..<9
		{
			for y in 0..<9
			{
				constraints.append(Constraint(hashValue: key, satisfies: { square in square.x == x && square.y == y}))
				key += 1
			}
		}
		for x in 0..<9
		{
			for v in 1...9
			{
				constraints.append(Constraint(hashValue: key, satisfies: { square in square.x == x && square.value == v}))
				key += 1
			}
		}
		for y in 0..<9
		{
			for v in 1...9
			{
				constraints.append(Constraint(hashValue: key, satisfies: { square in square.y == y && square.value == v}))
				key += 1
			}
		}
		for n in 0..<9
		{
			for v in 1...9
			{
				constraints.append(Constraint(hashValue: key, satisfies: { square in
					let a = 3 * (square.y / 3)
					let b = square.x / 3
					return a + b == n && square.value == v})
				)
				key += 1
			}
		}
		return constraints
	}
	
	private func createSquares() -> [Square]
	{
		var squares = [Square]()
		for x in 0..<9
		{
			for y in 0..<9
			{
				for n in 1...9
				{
					squares.append(Square(value: n, x: x, y: y))
				}
			}
		}
		return squares
	}
	
	private func createRows(constraints: [Constraint], fromColumns y: [Square: [Constraint]]) -> [Constraint: [Square]]
	{
		var x = [Constraint: [Square]]()
		for n in constraints
		{
			for choice in y
			{
				if choice.1.contains(n)
				{
					if let _ = x[n]
					{
						x[n]!.append(choice.0)
					}
					else
					{
						x[n] = [choice.0]
					}
				}
			}
		}
		return x
	}
	
	
	func sampleBoard() -> [Square]
	{
		let _ = [
			[0, 8, 0,/**/ 4, 0, 9,/**/ 6, 5, 3],
			[6, 4, 2,/**/ 8, 0, 0,/**/ 0, 7, 0],
			[0, 0, 0,/**/ 0, 0, 0,/**/ 8, 0, 0],
			/*--------------------------------*/
			[0, 0, 7,/**/ 0, 0, 5,/**/ 0, 4, 2],
			[0, 0, 0,/**/ 7, 0, 1,/**/ 0, 0, 0],
			[8, 5, 0,/**/ 6, 0, 0,/**/ 1, 0, 0],
			/*--------------------------------*/
			[0, 0, 6,/**/ 0, 0, 0,/**/ 0, 0, 0],
			[0, 1, 0,/**/ 0, 0, 4,/**/ 7, 3, 6],
			[2, 7, 3,/**/ 5, 0, 8,/**/ 0, 1, 0]
		]
		
		let b = [
			[0, 0, 0,/**/ 0, 0, 0,/**/ 0, 0, 0],
			[0, 0, 0,/**/ 0, 0, 0,/**/ 0, 0, 0],
			[0, 0, 0,/**/ 0, 0, 0,/**/ 8, 0, 0],
			/*--------------------------------*/
			[0, 0, 7,/**/ 0, 0, 5,/**/ 0, 4, 2],
			[0, 0, 0,/**/ 7, 0, 1,/**/ 0, 0, 0],
			[8, 5, 0,/**/ 6, 0, 0,/**/ 1, 0, 0],
			/*--------------------------------*/
			[0, 0, 6,/**/ 0, 0, 0,/**/ 0, 0, 0],
			[0, 1, 0,/**/ 0, 0, 4,/**/ 7, 3, 6],
			[2, 7, 3,/**/ 5, 0, 8,/**/ 0, 1, 0]
		]
		
		
		
		
		var board = [Square]()
		for r in 0..<9
		{
			for c in 0..<9
			{
				if b[c][r] != 0
				{
					board.append(Square(value: b[c][r], x: r, y: c))
				}
			}
		}
		return board
	}
	
	func createNewGame() -> Game
	{
		let constraints = createConstraints()
		let squares = createSquares()
		y = [Square: [Constraint]]()
		for square in squares
		{
			y[square] = []
			for constraint in constraints
			{
				if constraint.satisfies(square)
				{
					y[square]?.append(constraint)
				}
			}
		}
		x = createRows(constraints, fromColumns: y)
		
		var values = [1, 2, 3, 4, 5, 6, 7, 8, 9].shuffle()
		var topRow = [Square]()
		for x in 0..<9
		{
			topRow.append(Square(value: values.removeLast(), x: x, y: 0))
		}
		var removedColsArray = [[[Square]]]()
		for square in topRow
		{
			removedColsArray.append(select(square))
		}
		
		let solution = solve()! + topRow
		var board = solution.map { square in Square(value: square.value, x: square.x, y: square.y) }
		
		for square in topRow.reverse()
		{
			deselect(square, cols: removedColsArray.removeLast())
		}
		
		var removedSquares = [Square]()
		while boardHasUniqueSolution(board)
		{
			removedSquares.append(board.removeAtIndex(Int(arc4random_uniform(UInt32(board.count)))))
		}
		board.append(removedSquares.removeLast())
		return Game(puzzle: board, solution: removedSquares, playerSquares: [])
	}

	func solve() -> [Square]?
	{
		if x.isEmpty
		{
			return []
		}
		if x.first!.1.isEmpty
		{
			return nil
		}
		
		let c = x.sort { $0.1.count < $1.1.count }.first!.0
		for r in x[c]!.shuffle()
		{
			let cols = select(r)
			if let solved = solve()
			{
				deselect(r, cols: cols)
				return [r] + solved
			}
			else
			{
				deselect(r, cols: cols)
			}
		}
		return nil
	}
	
	func boardHasUniqueSolution(board: [Square]) -> Bool
	{
		var solutionCount = 0
		func countSolutions()
		{
			if x.isEmpty
			{
				solutionCount += 1
				return
			}
			if x.first!.1.isEmpty
			{
				return
			}
			
			let c = x.sort { $0.1.count < $1.1.count }.first!.0
			for r in x[c]!.shuffle()
			{
				let cols = select(r)
				countSolutions()
				deselect(r, cols: cols)
				if solutionCount > 1
				{
					return
				}
			}
			return
		}
		
		var removedColsArray = [[[Square]]]()
		for square in board
		{
			removedColsArray.append(select(square))
		}
		
		countSolutions()
		
		for square in board.reverse()
		{
			deselect(square, cols: removedColsArray.removeLast())
		}
		
		return solutionCount == 1
	}
	
	private func select(r: Square) -> [[Square]]
	{
		var cols = [[Square]]()
		for j in y[r]!
		{
			//if x[j] != nil
			//{
				for i in x[j]!
				{
					for k in y[i]!
					{
						if k != j
						{
							x[k]!.removeAtIndex((x[k]!.indexOf(i))!)
						}
					}
				}
				cols.append(x.removeValueForKey(j)!)
			//}
		}
		return cols
	}
	
	private func deselect(r: Square, cols: [[Square]]) -> [[Square]]
	{
		var cols = cols
		for j in y[r]!.reverse()
		{
			x[j] = cols.removeLast()
			for i in x[j]!
			{
				for k in y[i]!
				{
					if k != j
					{
						if let _ = x[k]
						{
							x[k]!.append(i)
						}
						else
						{
							x[k] = [i]
						}
					}
				}
			}
		}
		return cols
	}
}