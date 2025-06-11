//
//  ContentView.swift
//  HabitsHero
//
//  Created by Marcos Contente on 11/06/25.
//

import SwiftUI

enum ViewType: String, CaseIterable {
    case list = "List"
    case grid = "Grid"
}

struct ContentView: View {
    @StateObject private var viewModel = HabitsViewModel()
    @State private var selectedView: ViewType = .list
    @State private var showingAdd = false

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationView {
            VStack {
                Picker("", selection: $selectedView) {
                    ForEach(ViewType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                Group {
                    if selectedView == .list {
                        listView
                    } else {
                        gridView
                    }
                }
                .animation(.default, value: selectedView)
                .padding(.horizontal)

                Spacer()
            }
            .navigationTitle("Habits Hero")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAdd = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAdd) { }
        }
    }

    // MARK: – List
    private var listView: some View {
        List {
            ForEach(viewModel.habits) { habit in
                HStack {
                    VStack(alignment: .leading) {
                        Text(habit.title).font(.headline)
                        Text(habit.category).font(.subheadline).foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                        .onTapGesture {
                            viewModel.toggleCompletion(of: habit)
                        }
                }
            }
        }
    }

    // MARK: – Grid
    private var gridView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.habits) { habit in
                    VStack {
                        HStack {
                            Text(habit.title)
                                .font(.headline)
                            Spacer()
                        }
                        HStack {
                            Text(habit.category)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                                .onTapGesture {
                                    viewModel.toggleCompletion(of: habit)
                                }
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).strokeBorder())
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
