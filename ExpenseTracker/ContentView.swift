//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Ismam Ferdous on 6/2/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Home()
                .navigationBarHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
