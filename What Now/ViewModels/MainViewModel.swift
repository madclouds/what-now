//
//  MainViewModel.swift
//  What Now
//
//  Created by Erik Bye on 6/5/18.
//  Copyright © 2018 Erik Bye. All rights reserved.
//
import UIKit
import Firebase

class MainViewModel {
    var tasks: [Task] {
        return self.service.getTasks()
    }
    private let service: DatabaseService
    init(databaseService: DatabaseService) {
        self.service = databaseService
    }
    var numberOfTasks: Int {
        return tasks.count
    }
    func task(indexPath: IndexPath) -> Task {
        return tasks[indexPath.row]
    }

    func pickTask(withLength length: TaskLength) -> Task? {
        let filteredTasks = tasks.filter { (task) -> Bool in
            return task.length == length
        }
        guard filteredTasks.count > 0 else {
            return nil
        }
        let randomIndex = Int(arc4random_uniform(UInt32(filteredTasks.count)))
        return filteredTasks[randomIndex]
    }
}
