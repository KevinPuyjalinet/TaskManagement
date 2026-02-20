//
//  NewTaskView.swift
//  TaskManagement
//
//  Created by Kévin PUYJALINET on 19/02/2026.
//

import SwiftUI
import CoreData

struct NewTaskView: View {
    @Environment(\.dismiss) var dismiss
    
    //MARK: Task Values
    @State var taskTitle: String = ""
    @State var taskDesc: String = ""
    @State var taskDate: Date = Date()
    
    //MARK: Core Data Context
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var taskModel: TaskViewModel
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Go to work", text: $taskTitle)
                } header: {
                    Text("Task Title")
                }
                Section {
                    TextField("Nothing", text: $taskDesc)
                } header: {
                    Text("Task Description")
                }
                // Disabling Date for edit Mode
                if taskModel.editTask == nil {
                    Section {
                        DatePicker("", selection: $taskDate)
                            .datePickerStyle(.graphical)
                            .labelsHidden()
                    } header: {
                        Text("Task Date")
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Add New Task")
            .navigationBarTitleDisplayMode(.inline)
            //MARK: Disabling Dismiss on Swipe
            .interactiveDismissDisabled()
            //MARK: Action Buttons
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        
                        if let task = taskModel.editTask {
                            task.taskTitle = taskTitle
                            task.taskDesc = taskDesc
                        } else {
                            let task = Task(context: context)
                            task.taskTitle = taskTitle
                            task.taskDesc = taskDesc
                            task.taskDate = taskDate
                        }
                        
                        // Saving
                        try? context.save()
                        
                        // Dismissing View
                        dismiss()
                    }
                    .disabled(taskTitle.isEmpty || taskDesc.isEmpty)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            // Loading Task data if from Edit
            .onAppear {
                if let task = taskModel.editTask {
                    taskTitle = task.taskTitle ?? ""
                    taskDesc = task.taskDesc ?? ""
                    
                }
            }
        }
    }
}

#Preview {
    NewTaskView()
        .environmentObject(TaskViewModel())
}
