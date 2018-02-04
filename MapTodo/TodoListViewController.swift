//
//  ViewController.swift
//  MapTodo
//
//  Created by Hitomi Fukushima on 2016/10/08.
//  Copyright © 2016年 fukushima. All rights reserved.
//

import CoreData
import CoreLocation
import RealmSwift
import UIKit

class TodoListViewController: AppViewController {

    @IBOutlet weak var todoListTableView: UITableView!
    @IBOutlet weak var todoListItemCell: UITableViewCell!
    var todoEntries: Results<Todo>!
    var placeEntries: Results<Place>!
    // swiftlint:disable force_try
    let realm: Realm = try! Realm()
    // swiftlint:enable force_try

    override func viewDidLoad() {
        super.viewDidLoad()
        todoEntries = Todo.getAll(realm: realm)
        placeEntries = Place.getAll(realm: realm)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        todoEntries = Todo.getAll(realm: realm)
        todoListTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func place(section: Int) -> Place? {
        return placeEntries.count > section ? placeEntries[section] : nil
    }

    func todoEntries(section: Int) -> Results<Todo>? {
        return place(section: section).map { todoEntries.filter("place = %@", $0) }
    }

    func todo(indexPath: IndexPath) -> Todo? {
        if let todoList = todoEntries(section: indexPath.section), todoList.count > indexPath.row {
                return todoList[indexPath.row]
        }
        return nil
    }

    @objc func placeButtonTapped(sender: UIButton) {
        let controller = R.storyboard.main.placeView()!
        controller.place = place(section: sender.tag)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: AppTableViewHeaderView = AppTableViewHeaderView()
        headerView.setLabelText(text: place(section: section)!.name)
        let placeButton = headerView.showDetailButton!
        placeButton.tag = section
        placeButton.addTarget(self, action: #selector(TodoListViewController.placeButtonTapped), for: .touchUpInside)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }

}

extension TodoListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return placeEntries.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoEntries(section: section)!.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TextFieldTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "TodoListItem") as? TextFieldTableViewCell
        cell.delegate = self
        cell.indexPath = indexPath
        if let todo = todo(indexPath: indexPath) {
            cell.textField.text = todo.item
            cell.isBottom = false
        } else {
            cell.textField.text = ""
            cell.isBottom = true
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // swiftlint:disable force_try
            try! realm.write {
                todo(indexPath: indexPath)?.delete(realm: realm)
            }
            // swiftlint:enable force_try
            todoListTableView.reloadData()
        }
    }
}

extension TodoListViewController: TextFieldTableViewCellDelegate {
    func textFieldDidEndEditing(cell: TextFieldTableViewCell, value: String, indexPath: IndexPath) {
        let todo: Todo
        let isNew: Bool
        if self.todo(indexPath: indexPath) != nil {
            todo = self.todo(indexPath: indexPath)!
            isNew = false
        } else if !value.isEmpty {
            todo = Todo()
            isNew = true
        } else {
            return
        }
        if value != todo.item {
            // swiftlint:disable force_try
            try! realm.write {
                todo.replace(realm: realm, item: value, place: place(section: indexPath.section)!)
            }
            // swiftlint:enable force_try
            todoListTableView.reloadData()
            if isNew {
                if let cell = todoListTableView.cellForRow(at: IndexPath.init(row: indexPath.row + 1, section: indexPath.section)) as? TextFieldTableViewCell {
                    cell.textField.becomeFirstResponder()
                }
            }
        }
    }
}
