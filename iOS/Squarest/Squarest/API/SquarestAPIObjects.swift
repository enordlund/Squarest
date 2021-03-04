//
//  APIObjects.swift
//
//
//  Created by Erik Nordlund on 7/12/20.
//

import Foundation

struct SquarestRequest: Codable {
	let requestType: RequestType
	let operand1: Double?
	let operand2: Double?
	let startDate: Date?
	let endDate: Date?
	let timeZone: TimeZone?
	let operationCategories: [OperationCategory]?
}

struct SquarestResponse: Codable {
	let id: UUID
	let result: Double?
	let days: [HistoryDay]?
}

enum RequestType: String, Codable {
	case sum
	case square
	case history
}
