//
//  CurrentTimeDatePickerView.swift
//  Squarest
//
//  Created by Erik Nordlund on 7/17/20.
//

import SwiftUI

/// Picker that displays current date and time when inactive
struct CurrentTimeDatePickerView: View {
	@EnvironmentObject var history: History
	
	let title: String
	
	// isActive represents when the user is selecting a manual date with the picker.
	@Binding var isActive: Bool
	
	private var date: Date {
		get {
			if isActive {
				return currentTime.date
			} else {
				return Date()
			}
		}
	}
	
	@StateObject private var currentTime = CurrentTime()
	
    var body: some View {
		DatePicker(selection: $currentTime.date, /*in: firstDate...Date().advanced(by: 3600),*/ label: {
			HStack {
				Text(title)
					.foregroundColor({isActive ? Color(.label) : Color(.placeholderText)}())
				Spacer()
			}
		})
		.disabled(!isActive)
		.onChange(of: isActive) { value in
			if value {
				currentTime.stop()
			} else {
				currentTime.start()
			}
		}
		.onAppear {
			if history.dateFilter.applyEndFilter {
				currentTime.stop()
			} else {
				currentTime.start()
			}
		}
		.onDisappear {
			history.dateFilter.end = date
		}
    }
}

struct CurrentTimeDatePickerView_Previews: PreviewProvider {
	@State static var isActive = false
    static var previews: some View {
		CurrentTimeDatePickerView(title: "End", isActive: $isActive)
    }
}
