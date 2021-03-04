//
//  HistoryFilterView.swift
//  Squarest
//
//  Created by Erik Nordlund on 7/13/20.
//

import SwiftUI

struct HistoryFilterView: View {
	@EnvironmentObject var history: History
	
	@Binding var isPresented: Bool
	
	var firstDate: Date
	
	
    var body: some View {
		List {
			Section(header: Text("Categories"), content: {
				HStack {
					Text("Sum")
						.foregroundColor({history.categoryFilter.categories != nil ? Color(.label) : Color(.placeholderText)}())
					Spacer()
					CheckButtonBoolean(isSelected: $history.categoryFilter.includeSum, action: {
                        
					})
				}
				
				HStack {
					Text("Square")
						.foregroundColor({history.categoryFilter.categories != nil ? Color(.label) : Color(.placeholderText)}())
					Spacer()
					CheckButtonBoolean(isSelected: $history.categoryFilter.includeSquare, action: {
                        
					})
				}
			})
			
			Section(header: Text("Date"), content: {
				HStack {
					DatePicker(selection: $history.dateFilter.start, label: {
						HStack {
							Text("Start")
								.foregroundColor({history.dateFilter.applyStartFilter ? Color(.label) : Color(.placeholderText)}())
							Spacer()
						}
					})
					.disabled(!history.dateFilter.applyStartFilter)
					
					CheckButtonBoolean(isSelected: $history.dateFilter.applyStartFilter, action: {
						if history.dateFilter.applyStartFilter == false {
							history.dateFilter.start = firstDate
						}
					})
				}
				
				HStack {
					CurrentTimeDatePickerView(title: "End", isActive: $history.dateFilter.applyEndFilter)
					
					
					CheckButtonBoolean(isSelected: $history.dateFilter.applyEndFilter, action: {
                        
					})
				}
			})
		}
		.listStyle(InsetGroupedListStyle())
		.navigationBarItems(leading:
								Button(action: {
									withAnimation {
										history.clearFilters()
									}
								}, label: {
									Label("Clear", systemImage: "")
										.font(.body)
								}).disabled(!applyFilter()),
							trailing:
								Button(action: {
									isPresented = false
								}, label: {
									Label("Done", systemImage: "")
								})
							)
		.navigationTitle(Text("Filter"))
		.onReceive(history.$categoryFilter) { publisherThing in
			print("received from category filter")
			print(publisherThing)
		}
    }
	
	func applyFilter() -> Bool {
		return history.dateFilter.applyStartFilter || history.dateFilter.applyEndFilter || history.categoryFilter.categories != nil
	}
}

struct HistoryFilterView_Previews: PreviewProvider {
	@State static var interval: DateInterval? = nil
	@State static var start: Date = Date()
	@State static var end: Date = Date()
	@State static var categories: [OperationCategory]? = nil
	@State static var applyFilter = false
	
	@State static var presented = true
	
    static var previews: some View {
		HistoryFilterView(isPresented: $presented, firstDate: Date())
    }
}
