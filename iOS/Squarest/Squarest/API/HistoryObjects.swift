//
//  History.swift
//  Squarest
//
//  Created by Erik Nordlund on 7/9/20.
//

import Foundation
import Combine


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
		id = fromItem.id//UUID(uuidString: fromItem.id) ?? UUID()
		date = fromItem.date
		category = fromItem.category
		
		if category == .sum {
			summary = "\(fromItem.operands[0]) + \(fromItem.operands[1]) = \(fromItem.outcome)"
		} else {
			summary = "\(fromItem.operands[0])\u{00B2} = \(fromItem.outcome)"
		}
	}
}

struct HistoryItem: Codable {
	let id: UUID
	let accountID: String
	let date: Date
	let category: OperationCategory
	let operands: [Double]
	let outcome: Double
	
	struct DynamoDBField {
		static let id = "ID"
		static let accountID = "AccountID"
		static let date = "Date"
		static let category = "Category"
		static let operands = "Operands"
		static let outcome = "Outcome"
	}
}

struct HistoryDay: Codable {
	var id: UUID
	let date: Date
	var items: [HistoryItem]?
}

enum OperationCategory: String, Codable {
	case square
	case sum
}

class History: NetworkManager, ObservableObject {
	@Published var isLoading = false
	@Published var result: [HistoryDay]? = nil
	@Published var errorMessage: String? = nil
	
	@Published var categoryFilter: CategoryFilter = CategoryFilter(operationCategories: nil)
	@Published var dateFilter: DateFilter = DateFilter()
	
	var categoryFilterCancellable: AnyCancellable? = nil
	var dateFilterCancellable: AnyCancellable? = nil
	
	override init() {
		super.init()
		categoryFilterCancellable = categoryFilter.objectWillChange.sink{ (_) in
			self.objectWillChange.send()
		}
		dateFilterCancellable = dateFilter.objectWillChange.sink{ (_) in
			self.objectWillChange.send()
		}
	}
	
	// handle assembling request data, and sending the request.
	func requestHistory() {
		
		isLoading = true
		
		let postData = SquarestRequest(requestType: .history, operand1: nil, operand2: nil, startDate: dateFilter.requestStart, endDate: dateFilter.requestEnd, timeZone: TimeZone.current, operationCategories: categoryFilter.categories)//HistoryRequest(dateRange: on, operationCategories: forCategories)
		
		post(responseType: SquarestResponse.self/*HistoryResponse.self*/, postData: postData, endpoint: nil, completion: ({response, errorMessage in
			self.handle(response: response, postErrorMessage: errorMessage)
			
			self.isLoading = false
		}))
		
	}
	
	func clearFilters() {
		print("clearing filters")
		categoryFilter.clear()
		dateFilter.clear()
	}
	
	
	internal func handle(response: SquarestResponse?, postErrorMessage: String?) {
		if let postError = postErrorMessage {
			// post error happened
			result = nil
			errorMessage = postError
		} else if let historyResponse = response {
			if let responseResult = historyResponse.days {
				// convert to days
				result = responseResult
				errorMessage = nil
			} else {
				result = nil
				errorMessage = "Empty Response"
			}
		} else {
			result = nil
			errorMessage = "Empty Completion"
		}
	}
	
	func makeDays(fromChronological: [HistoryItem]) -> [HistoryDay] {
		
		var days = [HistoryDay]()
		
		for item in fromChronological {
			guard let day = days.last?.date, Calendar.current.isDate(day, inSameDayAs: item.date) else {
				// append new day if the current entry's day isn't already in days
				days.append(HistoryDay(id: UUID(), date: item.date, items: [item]))
				
				// go to next entry
				continue
			}
			
			// add the entry to the day
			days[days.endIndex - 1].items?.append(item)
		}
		
		return days
	}
}
