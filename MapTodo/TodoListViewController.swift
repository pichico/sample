//
//  ViewController.swift
//  MapTodo
//
//  Created by Hitomi Fukushima on 2016/10/08.
//  Copyright © 2016年 fukushima. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var todoEntities: [Todo]!
    override func viewDidLoad() {
        super.viewDidLoad()
        todoEntities = Todo.mr_findAll() as! [Todo]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        todoEntities = Todo.mr_findAll() as! [Todo]
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoEntities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "TodoListItem")
        cell.textLabel?.text = todoEntities[indexPath.row].item
        return cell
    }
}

