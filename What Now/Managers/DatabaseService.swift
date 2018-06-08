//
//  DatabaseService.swift
//  What Now
//
//  Created by Erik Bye on 6/7/18.
//  Copyright © 2018 Erik Bye. All rights reserved.
//

protocol DatabaseService {
    func save(title: String, length: TaskLength)

    func update(task: Task)

    func delete(task: Task)

    func getTasks() -> [Task]
}
