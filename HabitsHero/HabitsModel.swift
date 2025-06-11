//
//  HabitsModel.swift
//  HabitsHero
//
//  Created by Marcos Contente on 11/06/25.
//

import Foundation

struct Habit: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var category: String
    var isCompleted: Bool = false
}
