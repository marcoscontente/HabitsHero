//
//  HabitsViewModel.swift
//  HabitsHero
//
//  Created by Marcos Contente on 11/06/25.
//

import Combine

class HabitsViewModel: ObservableObject {
    @Published var habits: [Habit] = []

    func addHabit(title: String, category: String) {
        let new = Habit(title: title, category: category)
        habits.append(new)
    }

    func toggleCompletion(of habit: Habit) {
        guard let idx = habits.firstIndex(of: habit) else { return }
        habits[idx].isCompleted.toggle()
    }
}
