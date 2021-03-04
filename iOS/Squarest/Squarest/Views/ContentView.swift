//
//  ContentView.swift
//  Squarest
//
//  Created by Erik Nordlund on 7/8/20.
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject var history: History
	
    var body: some View {
		TabView {
			SquareView()
				.tabItem() {
					VStack {
						Image(systemName: "square")
						Text("Square")
					}
				}
			
			SumView()
				.tabItem() {
					VStack {
						Image(systemName: "plus")
						Text("Sum")
					}
				}
			
			HistoryView()
				.tabItem() {
					VStack {
						Image(systemName: "clock")
						Text("History")
					}
				}
		}
		.onAppear {
			history.requestHistory()
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
