//
//  File.swift
//  
//
//  Created by Erik Nordlund on 7/9/20.
//

import Foundation
import DynamoDB

class HistoryService {
	let db: DynamoDB
	let tableName: String
	
	init(db: DynamoDB, tableName: String) {
		self.db = db
		self.tableName = tableName
	}
	
	func getItem(withID: String) -> EventLoopFuture<HistoryItem> {
		let input = DynamoDB.GetItemInput(key: [HistoryItem.DynamoDBField.id: DynamoDB.AttributeValue.s(withID)], tableName: tableName)
		
		return db.getItem(input).flatMapThrowing{ (output) -> HistoryItem in
			if output.item == nil {
				throw APIError.itemNotFound
			}
			return try HistoryItem(dictionary: output.item ?? [:])
		}
	}
	
	// Written assuming entries are sorted oldest to newest
	func makeDays(fromChronological: [HistoryItem]) -> [HistoryDay] {
		
		var days = [HistoryDay]()
		
		for item in fromChronological {
			guard let day = days.last?.date, Calendar.current.isDate(day, inSameDayAs: item.date) else {
				// append new day if the current entry's day isn't already in days
				days.append(HistoryDay(date: item.date, items: [item]))
				
				// go to next entry
				continue
			}
			
			// add the entry to the day
			days[days.endIndex - 1].items?.append(item)
		}
		
		return days
	}
	
	func getItems(forRequest: HistoryRequest) -> EventLoopFuture<[HistoryItem]> {
//		#warning("TO DO: make days from items, package in HistoryResponse")
		let input = DynamoDB.ScanInput(tableName: tableName)
		
		// get items
		return db.scan(input).flatMapThrowing({ (output) -> [HistoryItem] in
			try output.items?.compactMap({
				try HistoryItem(dictionary: $0)
			}) ?? []
		})
	}
	
	func create(item: HistoryItem) -> EventLoopFuture<HistoryItem> {
        let input = DynamoDB.PutItemInput(item: item.dynamoDBDictionary, tableName: tableName)
		
		return db.putItem(input).map { (_) -> HistoryItem in
			item
		}
	}
	
	func delete(id: String) -> EventLoopFuture<Void> {
		let input = DynamoDB.DeleteItemInput(key: [HistoryItem.DynamoDBField.id: DynamoDB.AttributeValue.s(id)], tableName: tableName)
		return db.deleteItem(input).map { _ in }
	}
	
	func getEntries(forRequest: HistoryRequest) -> [HistoryEntry] {
		let additionItem = HistoryItem(id: UUID().uuidString, date: Date(), category: .addition, operands: [1, 2], outcome: 2)
		let squareItem = HistoryItem(id: UUID().uuidString, date: Date(timeIntervalSinceNow: TimeInterval(-90000)), category: .square, operands: [3], outcome: 9)
		
		let historyEntries = [HistoryEntry(fromItem: additionItem), HistoryEntry(fromItem: squareItem)]
		
		return historyEntries
	}
}
