//
//  ContentView.swift
//  TaskManagement
//
//  Created by Kévin PUYJALINET on 16/02/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
            .preferredColorScheme(.light)
            .environmentObject(TaskViewModel())
    }
}

#Preview {
    ContentView()
}
