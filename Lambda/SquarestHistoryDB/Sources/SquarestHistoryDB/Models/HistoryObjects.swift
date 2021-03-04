//
//  HistoryObjects.swift
//  
//
//  Created by Erik Nordlund on 7/10/20.
//

import Foundation

struct HistoryRequest: Codable {
	let dateRange: DateInterval?
	let operationCategories: [OperationCategory]?
}

struct HistoryResponse: Codable {
	let result: [HistoryDay]?
	let errorMessage: String?
	
}

struct HistoryEntry: Codable {
	var id: UUID
	let date: Date
	let category: OperationCategory
	let summary: String
	
	init(fromItem: HistoryItem) {
		id = UUID(uuidString: fromItem.id) ?? UUID()
		date = fromItem.date
		category = fromItem.category
		
		if category == .addition {
			summary = "\(fromItem.operands[0]) + \(fromItem.operands[1]) = \(fromItem.outcome)"
		} else {
			summary = "\(fromItem.operands[0])\u{00B2} = \(fromItem.outcome)"
		}
	}
}

#warning("TO DO: Change entries to items")
struct HistoryDay: Codable {
	var id = UUID()
	let date: Date
	var items: [HistoryItem]?
}

enum OperationCategory: String, Codable {
	case square
	case addition
}
