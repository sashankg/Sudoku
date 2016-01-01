//
//  Square.swift
//  Sudoku
//
//  Created by Sashank Gogula on 12/13/15.
//  Copyright © 2015 sashankg. All rights reserved.
//

import Foundation


struct Square: Hashable {
	let value: Int
	let x, y: Int
	var hashValue: Int { return (value*100) + x * 10 + y }
}

func == (lhs: Square, rhs: Square) -> Bool
{
	return lhs.value == rhs.value && lhs.x == rhs.x && lhs.y == rhs.y
}