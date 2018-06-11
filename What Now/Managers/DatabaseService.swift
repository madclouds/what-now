//
//  DatabaseService.swift
//  What Now
//
//  Created by Erik Bye on 6/7/18.
//  Copyright © 2018 Erik Bye. All rights reserved.
//

import Snail

protocol DatabaseService {

    var observable: Observable<Void> { get set }  //Todo: I want an observerable to update the table view when new data is loaded

    func save(title: String, length: TaskLength)

    func update(task: Task)

    func delete(task: Task)

    func getTasks() -> [Task]
}
