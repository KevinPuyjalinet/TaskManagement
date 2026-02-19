//
//  Home.swift
//  TaskManagement
//
//  Created by Kévin PUYJALINET on 16/02/2026.
//

import SwiftUI
import CoreData

struct Home: View {
    @StateObject var taskModel: TaskViewModel = TaskViewModel()
    @Namespace var animation
    @Environment(\.managedObjectContext) var context
    var body: some View {
        //MARK: - Body
        ScrollView(.vertical, showsIndicators: false) {
            
            //MARK: Lazy Stack With Pinned Header
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                Section {
                    
                    //MARK: Current Week View
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            
                            ForEach(taskModel.currentWeek, id: \.self) { day in
                                // EEE will return day as MON, TUE...etc
                                VStack(spacing: 10) {
                                    Text(taskModel.extractDate(date: day, format: "dd"))
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                    Text(taskModel.extractDate(date: day, format: "EEE"))
                                        .font(.system(size: 14))
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 8, height: 8)
                                        .opacity(taskModel.isToday(date: day) ? 1 : 0)
                                }
                                
                                //MARK: Forground Style
                                .foregroundStyle(taskModel.isToday(date: day) ? .primary : .tertiary)
                                .foregroundStyle(taskModel.isToday(date: day) ? .white : .black)
                                //MARK: Capsule Shape
                                .frame(width: 45, height: 90)
                                .background(
                                    ZStack {
                                        //MARK: Matched Geometry Effect
                                        if taskModel.isToday(date: day) {
                                            Capsule()
                                                .foregroundStyle(.black)
                                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                        }
                                    }
                                )
                                .contentShape(Capsule())
                                .onTapGesture {
                                    // Updating Current Day
                                    withAnimation {
                                        taskModel.currentDay = day
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    taskView()
                    
                } header: {
                    HeaderView()
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        //MARK: Add Button
        .overlay (
            Button {
                taskModel.addNewTask.toggle()
            } label: {
                Image(systemName: "plus")
                    .foregroundStyle(Color.white)
                    .padding()
                    .background(Color.black, in: Circle())
            }
            .padding()
            ,alignment: .bottomTrailing
        )
        .sheet(isPresented: $taskModel.addNewTask) {
            NewTaskView()
        }
    }
    
    //MARK: - Tasks View
    @ViewBuilder
    func taskView() -> some View {
        LazyVStack(spacing: 20) {
            // Converting object as Our Task Model
            DynamicFilteredView(dateToFilter: taskModel.currentDay) { (object: Task) in
                TaskCardView(task: object)
            }
        }
        .padding()
        .padding(.top)
    }
    
    //MARK: - Task Card View
    @ViewBuilder
    func TaskCardView(task: Task) -> some View {
        HStack(alignment: .top, spacing: 30) {
            
            //MARK: Since CoreData Values will Give Optional data
            VStack(spacing: 10) {
                Circle()
                    .fill(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? (task.isCompleted ? .green : .black) : .clear)
                    .frame(width: 15, height: 15)
                    .background(
                        Circle()
                            .stroke(.black, lineWidth: 1)
                            .padding(-3)
                    )
                    .scaleEffect(!taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 0.8 : 1)
                Rectangle()
                    .fill(.black)
                    .frame(width: 3)
            }
            
            VStack {
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(task.taskTitle ?? "")
                            .font(.title2.bold())
                        Text(task.taskDesc ?? "")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .hLeading()
                    Text(task.taskDate?.formatted(date: .omitted, time: .shortened) ?? "")
                }
                
                if taskModel.isCurrentHour(date: task.taskDate ?? Date()) {
                    HStack(spacing: 5) {
                        
                            if !task.isCompleted {
                                withAnimation(.easeInOut) {
                                //MARK: Check Button
                                Button {
                                    //Updating Status
                                    task.isCompleted = true
                                    //Saving
                                    try? context.save()
                                } label: {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.black)
                                        .padding(10)
                                        .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                                }
                            }
                        }
                        
                        Text(task.isCompleted ? "Marked as Completed" : "Mark Task as Completed")
                            .font(.system(size: task.isCompleted ? 14 : 16, weight: .light))
                            .foregroundStyle(task.isCompleted ? .gray : .white)
                            .hLeading()
                    }
                    .padding(.top)
                }
            }
            .foregroundStyle(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? .white : .black)
            .padding(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 15: 0)
            .padding(.bottom, taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 1 : 0)
            .hLeading()
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.black.opacity(0.9))
                    .opacity(taskModel.isCurrentHour(date: task.taskDate ?? Date()) ? 1 : 0)
            )
        }
        .hLeading()
    }
    
    //MARK: - Header
    @ViewBuilder
    func HeaderView() -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 10) {
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundStyle(.gray)
                Text("Today")
                    .font(.largeTitle.bold())
            }
            .hLeading()
            
            Button {
                
            } label: {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .foregroundStyle(.black)
            }
        }
        .padding()
        .safeAreaPadding(.top, 50)
        .background(Color(.white))
    }
}

#Preview {
    Home()
        .environmentObject(TaskViewModel())
}

//MARK: - UI Design Helper functions
extension View {
    func hLeading() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    func hTrailing() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    func hCenter() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .center)
    }
}
