//
//  Date+InterfaceFormat.swift
//  Squarest
//
//  Created by Erik Nordlund on 7/13/20.
//

import Foundation

extension Date {
	func historyHeaderFormat() -> String {
		let formatter = DateFormatter()
		formatter.dateStyle = .long
		formatter.timeStyle = .none
		formatter.doesRelativeDateFormatting = true
		
		return formatter.string(from: self)
	}
}
