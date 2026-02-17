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
    
    //MARK:  Sample Tasks
    var storedTasks: [Task] = [
        Task(taskTitle: "Meeting", taskDescription: "Discuss team task for the day", taskDate: Date(timeIntervalSince1970: 1771341824)),
        Task(taskTitle: "Icon Set", taskDescription: "Edit icons for team task for the next week", taskDate: Date(timeIntervalSince1970: 1771345424)),
        Task(taskTitle: "Prototype", taskDescription: "Make and send prototype", taskDate: Date(timeIntervalSince1970: 1771349024)),
        Task(taskTitle: "Check asset", taskDescription: "Start checking the assets", taskDate: Date(timeIntervalSince1970: 1771352624)),
        Task(taskTitle: "Team party", taskDescription: "Make fun with team mates", taskDate: Date(timeIntervalSince1970: 1771356224)),
        Task(taskTitle: "Client Meeting", taskDescription: "Explain project to client", taskDate: Date(timeIntervalSince1970: 1771359824)),
        Task(taskTitle: "Next Project", taskDescription: "Discuss next project with team", taskDate: Date(timeIntervalSince1970: 1771428224)),
        Task(taskTitle: "App Proposal", taskDescription: "Meet client for the next App Proposal", taskDate: Date(timeIntervalSince1970: 1771431824))
    ]
    
    
    //MARK: Current Week Days
    @Published var currentWeek: [Date] = []
    
    //MARK: Current Day
    @Published var currentDay: Date = Date()
    
    //MARK: Filetring Today Tasks
    @Published var filteredTasks: [Task]?
    
    //MARK: Initializing
    init() {
        fetchCurrentWeek()
        filterTodayTasks()
    }
    
    //MARK: Filter Today Tasks
    func filterTodayTasks() {
        DispatchQueue.global(qos: .userInteractive).async {
            let calendar = Calendar.current
            
            let filtered = self.storedTasks.filter {
                return calendar.isDate($0.taskDate, inSameDayAs: self.currentDay)
            }
                .sorted { task1, task2 in
                    return task2.taskDate > task1.taskDate
                }
            DispatchQueue.main.async {
                withAnimation {
                    self.filteredTasks = filtered
                }
            }
        }
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
        return hour == currentHour
    }
}
