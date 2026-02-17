//
//  Task.swift
//  TaskManagement
//
//  Created by Kévin PUYJALINET on 16/02/2026.
//

import Foundation

// Task Model
struct Task: Identifiable {
    var id = UUID().uuidString
    var taskTitle: String
    var taskDescription: String
    var taskDate: Date
}
