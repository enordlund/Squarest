//
//  File.swift
//  
//
//  Created by Erik Nordlund on 7/9/20.
//

import Foundation
import DynamoDB

struct HistoryItem: Codable {
	let id: String
	let date: Date
	let category: OperationCategory
	let operands: [Double]
	let outcome: Double
	
	struct DynamoDBField {
		static let id = "id"
		static let date = "OperationDate"
		static let category = "OperationCategory"
		static let operands = "operands"
		static let outcome = "OperationOutcome"
	}
}

extension HistoryItem {
	
	func operandsStrings() -> [String] {
		var strings = [String]()
		
		for operand in operands {
			strings.append(String(operand))
		}
		
		return strings
	}
	
	var dynamoDBDictionary: [String: DynamoDB.AttributeValue] {
		
		let dictionary = [
			DynamoDBField.id: DynamoDB.AttributeValue.s(id),
			DynamoDBField.date: DynamoDB.AttributeValue.n(String(date.timeIntervalSinceReferenceDate)),
			DynamoDBField.category: DynamoDB.AttributeValue.s(category.rawValue),
			DynamoDBField.operands: DynamoDB.AttributeValue.ns(operandsStrings()),
			DynamoDBField.outcome: DynamoDB.AttributeValue.n(String(outcome))
		]
		
		return dictionary
	}
	
	init(dictionary: [String: DynamoDB.AttributeValue]) throws {
		guard let id = dictionary[DynamoDBField.id]?.asString,
			  let date = dictionary[DynamoDBField.date]?.asNumber,
			  let category = dictionary[DynamoDBField.category]?.asString,
			  let operands = dictionary[DynamoDBField.operands]?.asNumberSet,
			  let outcome = dictionary[DynamoDBField.outcome]?.asNumber
		else {
			throw APIError.decodingError
		}
		
		
		self.id = id
		self.date = Date(timeIntervalSinceReferenceDate: date)
		self.category = OperationCategory(rawValue: category) ?? .addition
		
		self.operands = operands
		self.outcome = outcome
	}
}
