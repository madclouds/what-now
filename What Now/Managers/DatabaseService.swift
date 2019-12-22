//
//  DatabaseService.swift
//  What Now
//
//  Created by Erik Bye on 6/7/18.
//  Copyright © 2018 Erik Bye. All rights reserved.
//

import Snail

protocol DatabaseService {
    //rename to tasksChanged
    var onTasksChanged: Observable<[Task]> { get set }

    var saveTask: Observable<Task> {get set}

    //save return an observerable (a new task).  Call save from a viewmodel you can display the error.
    //while save happens, with using an observer, you can start/show a spinner and end it on error or on next
    func save(title: String, length: TaskLength)

    func delete(task: Task)

    func getTasks() -> [Task]
}
