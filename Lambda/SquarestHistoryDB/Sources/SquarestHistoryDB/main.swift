import Foundation
import AWSLambdaRuntime


func getEntries(forRequest: HistoryRequest) -> [HistoryEntry] {
	let additionItem = HistoryItem(id: UUID().uuidString, date: Date(), category: .addition, operands: [1, 2], outcome: 2)
	let squareItem = HistoryItem(id: UUID().uuidString, date: Date(timeIntervalSinceNow: TimeInterval(-90000)), category: .square, operands: [3], outcome: 9)
	
	let historyEntries = [HistoryEntry(fromItem: additionItem), HistoryEntry(fromItem: squareItem)]
	
	return historyEntries
}

Lambda.run(HistoryLambdaHandler.init)
