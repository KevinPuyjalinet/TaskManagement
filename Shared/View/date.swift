//
//  date.swift
//  TaskManagement
//
//  Created by Kévin PUYJALINET on 17/02/2026.
//

import Foundation
import SwiftUI

struct dateInterval: View {
    let startOfDay = Calendar.current.startOfDay(for: Date())
    
    var body: some View {
        Button {
            print(Date().timeIntervalSince1970)
        } label: {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundStyle(.black)
        }
    }
}

#Preview {
    dateInterval()
}
