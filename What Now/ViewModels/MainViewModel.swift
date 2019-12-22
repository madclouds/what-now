//
//  MainViewModel.swift
//  What Now
//
//  Created by Erik Bye on 6/5/18.
//  Copyright © 2018 Erik Bye. All rights reserved.
//
import UIKit
import Firebase
import Snail

class MainViewModel {
    var tasks: [Task] {
        return self.databaseService.getTasks()
    }
    var meaningfulMinutes: Float {
        set {
            UserDefaults.standard.set(newValue, forKey: "MeaningfulMinutes")
        }
        get {
            return UserDefaults.standard.value(forKey: "MeaningfulMinutes") as? Float ?? 0
        }
    }
    var reloadData: Observable<[Task]>
    var onTaskCompleted: Observable<Task>
    private let databaseService: DatabaseService
    init(databaseService: DatabaseService) {
        self.reloadData = Observable()
        self.databaseService = databaseService
        self.onTaskCompleted = Observable()
        self.databaseService.onTasksChanged.subscribe(onNext: { [weak self] tasks in
            self?.reloadData.on(.next(tasks))
        })
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

    func delete(task: Task) {
        databaseService.delete(task: task)
    }

    //call save
    func save(title: String, length: TaskLength) {
        databaseService.save(title: title, length: length)
//        databaseService.saveTask.subscribe(onNext: { [weak self] in
//        })

    }

    func done(_ task: Task) {
        var savedMinutes: Float = 0
        meaningfulMinutes += task.length.length
        onTaskCompleted.on(.next(task))
        delete(task: task)
    }

    func cell(forTableView tableView: UITableView, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
        cell.task = self.task(indexPath: indexPath)
        return cell
    }
}
