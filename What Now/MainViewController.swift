//
//  ViewController.swift
//  What Now
//
//  Created by Erik Bye on 6/3/18.
//  Copyright © 2018 Erik Bye. All rights reserved.
//

import UIKit
import SnapKit
import Snail
import Firebase

struct Const {
    static let padding: CGFloat = 10
}

enum TaskLength: Codable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let title = try values.decode(Float.self, forKey: .length)
        switch title {
        case 5: self = .fiveMinute
        case 15: self = .fifteenMinute
        case 30: self = .thirtyMinute
        case 60: self = .oneHour
        case 180: self = .threeHour
        case 300: self = .fiveHour
        default: self = .fiveHour
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(length, forKey: .length)
        try container.encode(subTitle, forKey: .subTitle)
    }

    case fiveMinute
    case fifteenMinute
    case thirtyMinute
    case oneHour
    case threeHour
    case fiveHour

    static let all: [TaskLength] = [.fiveMinute, .fifteenMinute, .thirtyMinute, .oneHour, .threeHour, .fiveHour]

    var title: String {
        switch self {
        case .fiveMinute: return "5"
        case .fifteenMinute: return "15"
        case .thirtyMinute: return "30"
        case .oneHour: return "1"
        case .threeHour: return "3"
        case .fiveHour: return "5"
        }
    }

    var subTitle: String {
        switch self {
        case .fiveMinute: return "min"
        case .fifteenMinute: return "min"
        case .thirtyMinute: return "min"
        case .oneHour: return "hr"
        case .threeHour: return "hr"
        case .fiveHour: return "hr"
        }
    }

    var length: Float {
        switch self {
        case .fiveMinute: return 5
        case .fifteenMinute: return 15
        case .thirtyMinute: return 30
        case .oneHour: return 60
        case .threeHour: return 60*3
        case .fiveHour: return 60*5
        }
    }

    enum CodingKeys: String, CodingKey {
        case title
        case subTitle
        case length
    }
}

class MainViewController: UITableViewController {

    private let viewModel: MainViewModel
    private let databaseService: DatabaseService

    var task: Task?
    var scrollView: UIScrollView?
    let currentTask = CurrentTaskView()
    let pickTaskView = InputView()
    let newTaskView = NewTaskView()
    init(databaseService: DatabaseService, viewModel: MainViewModel) {
        self.viewModel = viewModel
        self.databaseService = databaseService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        let db = Firestore.firestore()
        db.collection("tasks").addSnapshotListener { (_, error) in
            guard error == nil else {
                return
            }
            self.tableView.reloadData()
        }
//        let db = Firestore.firestore()

//        var ref: DocumentReference? = nil
//        ref = db.collection("users").addDocument(data: [
//            "first": "Ada",
//            "last": "Lovelace",
//            "born": 1815
//        ]) { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(ref!.documentID)")
//            }
//        }
//
//        ref = db.collection("users").addDocument(data: [
//            "first": "Alan",
//            "middle": "Mathison",
//            "last": "Turing",
//            "born": 1912
//        ]) { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(ref!.documentID)")
//            }
//        }
    }

    let headerHeight: CGFloat = 200

    var tableViewWidth: CGFloat {
        return tableView.bounds.width
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfTasks
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
         let task = viewModel.task(indexPath: indexPath)
        cell.textLabel?.text = task.title
        let icon = TaskLengthButton(taskLength: task.length)
        cell.contentView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(10)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableViewWidth = tableView.bounds.width
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: tableViewWidth, height: headerHeight))
        guard let scrollView = scrollView else {
            return nil
        }

        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(tableViewWidth*3)
        }
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false

        contentView.addSubview(currentTask)
        currentTask.snp.makeConstraints { (make) in
            make.width.equalTo(tableViewWidth)
            make.height.equalTo(headerHeight)
            make.top.bottom.left.equalToSuperview()
        }
        currentTask.cancelButton.tap.subscribe(onNext: { [weak self] in
            self?.goToInput()
        })
        currentTask.doneButton.tap.subscribe(onNext: { [weak self] in
            self?.doneCurrentTask()
        })

        contentView.addSubview(pickTaskView)
        pickTaskView.newTaskButton.tap.subscribe(onNext: { [weak self] in
            self?.goToNewTask()
            self?.tableView.reloadData()
        })

        pickTaskView.snp.makeConstraints { (make) in
            make.width.equalTo(tableViewWidth)
            make.top.bottom.equalToSuperview()
            make.left.equalTo(currentTask.snp.right)
        }

        pickTaskView.taskLengthPicker.fiveMinuteButton.tap.subscribe(onNext: { [weak self] in
            guard let length = self?.pickTaskView.taskLengthPicker.fiveMinuteButton.length else {
                return
            }
            self?.pickTask(length: length)
        })
        pickTaskView.taskLengthPicker.fifteenMinuteButton.tap.subscribe(onNext: { [weak self] in
            guard let length = self?.pickTaskView.taskLengthPicker.fifteenMinuteButton.length else {
                return
            }
            self?.pickTask(length: length)
        })
        pickTaskView.taskLengthPicker.thirtyMinuteButton.tap.subscribe(onNext: { [weak self] in
            guard let length = self?.pickTaskView.taskLengthPicker.thirtyMinuteButton.length else {
                return
            }
            self?.pickTask(length: length)
        })
        pickTaskView.taskLengthPicker.oneHourButton.tap.subscribe(onNext: { [weak self] in
            guard let length = self?.pickTaskView.taskLengthPicker.oneHourButton.length else {
                return
            }
            self?.pickTask(length: length)
        })
        pickTaskView.taskLengthPicker.threeHourButton.tap.subscribe(onNext: { [weak self] in
            guard let length = self?.pickTaskView.taskLengthPicker.threeHourButton.length else {
                return
            }
            self?.pickTask(length: length)
        })
        pickTaskView.taskLengthPicker.fiveHourButton.tap.subscribe(onNext: { [weak self] in
            guard let length = self?.pickTaskView.taskLengthPicker.fiveHourButton.length else {
                return
            }
            self?.pickTask(length: length)
        })

        contentView.addSubview(newTaskView)
        newTaskView.snp.makeConstraints { (make) in
            make.width.equalTo(tableViewWidth)
            make.top.bottom.equalToSuperview()
            make.left.equalTo(pickTaskView.snp.right)
        }
        newTaskView.cancelButton.tap.subscribe(onNext: { [weak self] in
            self?.goToInput()
        })

        newTaskView.taskLengthPicker.fiveMinuteButton.tap.subscribe(onNext: { [weak self] in
            guard let length = self?.newTaskView.taskLengthPicker.fiveMinuteButton.length else {
                return
            }
            self?.newTask(title: self?.newTaskView.input.text ?? "", length: length)
            self?.newTaskView.input.text = ""
        })
        newTaskView.taskLengthPicker.fifteenMinuteButton.tap.subscribe(onNext: { [weak self] in
            guard let length = self?.newTaskView.taskLengthPicker.fifteenMinuteButton.length else {
                return
            }
            self?.newTask(title: self?.newTaskView.input.text ?? "", length: length)
            self?.newTaskView.input.text = ""
        })
        newTaskView.taskLengthPicker.thirtyMinuteButton.tap.subscribe(onNext: { [weak self] in
            guard let length = self?.newTaskView.taskLengthPicker.thirtyMinuteButton.length else {
                return
            }
            self?.newTask(title: self?.newTaskView.input.text ?? "", length: length)
            self?.newTaskView.input.text = ""
        })
        newTaskView.taskLengthPicker.oneHourButton.tap.subscribe(onNext: { [weak self] in
            guard let length = self?.newTaskView.taskLengthPicker.oneHourButton.length else {
                return
            }
            self?.newTask(title: self?.newTaskView.input.text ?? "", length: length)
            self?.newTaskView.input.text = ""
        })
        newTaskView.taskLengthPicker.threeHourButton.tap.subscribe(onNext: { [weak self] in
            guard let length = self?.newTaskView.taskLengthPicker.threeHourButton.length else {
                return
            }
            self?.newTask(title: self?.newTaskView.input.text ?? "", length: length)
            self?.newTaskView.input.text = ""
        })
        newTaskView.taskLengthPicker.fiveHourButton.tap.subscribe(onNext: { [weak self] in
            guard let length = self?.newTaskView.taskLengthPicker.fiveHourButton.length else {
                return
            }
            self?.newTask(title: self?.newTaskView.input.text ?? "", length: length)
            self?.newTaskView.input.text = ""
        })

        scrollView.needsUpdateConstraints()
        scrollView.layoutIfNeeded()
        scrollView.contentOffset = CGPoint(x: tableViewWidth, y: 0)
        return scrollView
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 + 10 + 10
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = viewModel.task(indexPath: indexPath)
        pick(task: task)
    }

    func goToInput() {
        scrollView?.scrollRectToVisible(CGRect(x: tableViewWidth, y: 0, width: tableViewWidth, height: headerHeight), animated: true)
    }

    func goToNewTask() {
        scrollView?.scrollRectToVisible(CGRect(x: tableViewWidth*2, y: 0, width: tableViewWidth, height: headerHeight), animated: true)
    }

    func goToCurrentTask() {
        scrollView?.scrollRectToVisible(CGRect(x: 0, y: 0, width: tableViewWidth, height: headerHeight), animated: true)
    }
}

extension MainViewController {
    func pick(task: Task) {
        self.task = task
        currentTask.task = task
        goToCurrentTask()
    }
    func pickTask(length: TaskLength) {
        guard let task = viewModel.pickTask(withLength: length) else {
            //no task at that length
            return
        }
        pick(task: task)
    }

    func newTask(title: String, length: TaskLength) {
        guard title.count > 0 else {
            return
        }
        databaseService.save(title: title, length: length)
    }

    func cancelCurrentTask() {
        task = nil
        currentTask.task = nil
        goToInput()
    }

    func doneCurrentTask() {
        guard let task = task else {
            return
        }
        databaseService.delete(task: task)
        self.task = nil
        goToInput()
    }
}

struct Task: Codable {

    var title: String
    var id: String
    var length: TaskLength

}
