//
//  DiffableTableview.swift
//  HabitsHero
//
//  Created by Marcos Contente on 11/06/25.
//

import SwiftUI
import UIKit

struct DiffableTableView: UIViewRepresentable {
    @StateObject var viewModel = HabitsViewModel()

    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        context.coordinator.dataSource = makeDataSource(for: tableView)
        tableView.delegate = context.coordinator

        return tableView
    }

    func updateUIView(_ uiView: UITableView, context: Context) {
        let categories = Array(Set(viewModel.habits.map { $0.category })).sorted()

        var snapshot = NSDiffableDataSourceSnapshot<String, UUID>()
        snapshot.appendSections(categories)

        categories.forEach { category in
            let ids = viewModel.habits.filter { $0.category == category }.map { $0.id }
            snapshot.appendItems(ids, toSection: category)
        }

        context.coordinator.dataSource?.apply(snapshot, animatingDifferences: true)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    private func makeDataSource(for tableView: UITableView) -> UITableViewDiffableDataSource<String, UUID> {
        UITableViewDiffableDataSource<String, UUID>(tableView: tableView) { tableView, indexPath, habitID in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            if let habit = viewModel.habits.first(where: { $0.id == habitID }) {
                var config = UIListContentConfiguration.subtitleCell()
                config.text = habit.title
                config.secondaryText = habit.category
                cell.contentConfiguration = config
                cell.accessoryType = habit.isCompleted ? .checkmark : .none
            }
            return cell
        }
    }

    class Coordinator: NSObject, UITableViewDelegate {
        var parent: DiffableTableView
        var dataSource: UITableViewDiffableDataSource<String, UUID>?

        init(_ parent: DiffableTableView) {
            self.parent = parent
        }

        private func tableView(_ tableView: UITableView, titleForHeaderInSection sectionIndex: Int) -> String? {
            dataSource?.snapshot().sectionIdentifiers[sectionIndex]
        }

        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            guard editingStyle == .delete,
                  let id = dataSource?.itemIdentifier(for: indexPath),
                  let idx = parent.viewModel.habits.firstIndex(where: { $0.id == id })
            else { return }
            parent.viewModel.habits.remove(at: idx)
            tableView.performBatchUpdates(nil)
        }
    }
}
