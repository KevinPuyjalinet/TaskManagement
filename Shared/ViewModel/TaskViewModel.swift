//
//  TaskViewModel.swift
//  TaskManagement
//
//  Created by Kévin PUYJALINET on 16/02/2026.
//

import Foundation
import SwiftUI
import Combine

class TaskViewModel: ObservableObject {
    
    //MARK: Current Week Days
    @Published var currentWeek: [Date] = []
    
    //MARK: Current Day
    @Published var currentDay: Date = Date()
    
    //MARK: Filetring Today Tasks
    @Published var filteredTasks: [Task]?
    
    //MARK: New Task View
    @Published var addNewTask: Bool = false
    
    //MARK: Edit Data
    @Published var editTask: Task?
    
    //MARK: Initializing
    init() {
        fetchCurrentWeek()
    }
    
    func fetchCurrentWeek() {
        let today = Date()
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        guard let firstWeekDay = week?.start else { return }
        (1...7).forEach { day in
            let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay)
            currentWeek.append(weekday!)
        }
    }
    
    //MARK: Extracting Date
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.string(from: date)
    }
    
    //MARK: Checking if current Date is Today
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
    
    //MARK: Checking if the currentHour is task Hour
    func isCurrentHour(date: Date) -> Bool {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date())
        let isToday = calendar.isDateInToday(date)
        return (hour == currentHour && isToday)
    }
}
