//
//  Constraint.swift
//  Sudoku
//
//  Created by Sashank Gogula on 12/12/15.
//  Copyright © 2015 sashankg. All rights reserved.
//

import Foundation

struct Constraint: Hashable {
	var hashValue: Int
	let satisfies: (Square) -> Bool
}

func == (lhs: Constraint, rhs: Constraint) -> Bool
{
	return lhs.hashValue == rhs.hashValue
}