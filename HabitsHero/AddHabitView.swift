//
//  AddHabitView.swift
//  HabitsHero
//
//  Created by Marcos Contente on 11/06/25.
//

import SwiftUI

struct AddHabitView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String = ""
    @State private var category: String = ""

    var onSave: (String, String) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("New Hábito")) {
                    TextField("Title", text: $title)
                    TextField("Category", text: $category)
                }
            }
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    guard !title.isEmpty, !category.isEmpty else { return }
                    onSave(title, category)
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}
