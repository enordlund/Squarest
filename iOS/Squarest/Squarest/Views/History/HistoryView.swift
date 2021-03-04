//
//  HistoryView.swift
//  Squarest
//
//  Created by Erik Nordlund on 7/9/20.
//

import SwiftUI

struct HistoryView: View {
	@EnvironmentObject var history: History
	
	@State private var filterViewIsPresented: Bool = false
	
	#warning("TO DO: Create function to convert HistoryItems to summaries for UI")
    var body: some View {
		NavigationView {
			Group {
				if history.isLoading {
					ProgressView()
				} else if history.errorMessage != nil {
					// error loading results
					Text(history.errorMessage!)
						.multilineTextAlignment(.center)
						.padding()
				} else if history.result != nil {
					// results loaded
					#warning("TO DO: Implement pull to refresh")
					List {
						ForEach(history.result!, id: \.id, content: { day in
							if day.items != nil {
								Section(header: Text("\(day.date.historyHeaderFormat())"), content: {
									ForEach(day.items!, id: \.id, content: { item in
										HistoryRow(item: item)
									}).onDelete { indexSet in
										#warning("TO DO: Send delete request for the id of the item, and soft-refresh...")
										#warning("Build delete handling into History instead of doing it here")
 //										refreshHistory()
//										history.delete(id: UUID)
									 if let dayIndex = history.result?.firstIndex(where: { $0.id == day.id }) {
										 indexSet.forEach { itemIndex in
											 history.result?[dayIndex].items?.remove(at: itemIndex)
										 }
										 
									 }
								 }
								})
							}
						})
					}
				} else {
					// empty response
					VStack {
						Text("Empty Response")
						
						Button(action: {
							refreshHistory()
						}, label: {
							Text("Refresh")
						})
					}
				}
			}
			.navigationBarTitle(Text("History"), displayMode: .large)
			.navigationBarItems(leading: Button(action: {
				refreshHistory()
			}, label: {
				Image(systemName: "arrow.clockwise")
					.font(.title2)
			}), trailing: Button(action: {
				showFilterView()
			}, label: {
				if applyFilter() {
					Image(systemName: "line.horizontal.3.decrease.circle.fill")
						.font(.title2)
				} else {
					Image(systemName: "line.horizontal.3.decrease.circle")
						.font(.title2)
				}
			}))
			.sheet(isPresented: $filterViewIsPresented, onDismiss: {
				refreshHistory()
			}) {
				NavigationView {
					HistoryFilterView(isPresented: $filterViewIsPresented, firstDate: history.result?.last?.date ?? Date())
						.environmentObject(history)
				}
				
			}
		}
    }
	
	func refreshHistory() {
		history.requestHistory()
	}
	
	func showFilterView() {
		filterViewIsPresented = true
	}
	
	func applyFilter() -> Bool {
		return history.dateFilter.applyStartFilter || history.dateFilter.applyEndFilter || history.categoryFilter.categories != nil
	}
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
		HistoryView()
    }
}
