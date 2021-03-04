//
//  HistoryRow.swift
//  Squarest
//
//  Created by Erik Nordlund on 7/10/20.
//

import SwiftUI

struct HistoryRow: View {
	let item: HistoryItem
	
    var body: some View {
		if item.category == .sum {
			Text("\(item.operands[0].interfaceFormat()) + \(item.operands[1].interfaceFormat()) = \(item.outcome.interfaceFormat())")
		} else {
			// square
			Text("\(item.operands[0].interfaceFormat())\u{00B2} = \(item.outcome.interfaceFormat())")
		}
    }
}

struct HistoryRow_Previews: PreviewProvider {
	static let previewItem = HistoryItem(id: UUID(), accountID: "1", date: Date(), category: .sum, operands: [1, 2], outcome: 3)
    static var previews: some View {
		HistoryRow(item: previewItem)
    }
}
