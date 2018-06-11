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

class MainViewController: UIViewController {

    private let viewModel: MainViewModel
    private let databaseService: DatabaseService

    var task: Task?
    let tableView = UITableView()
    internal let cardContainer = CardContainer()
    init(databaseService: DatabaseService, viewModel: MainViewModel) {
        self.viewModel = viewModel
        self.databaseService = databaseService
        super.init(nibName: nil, bundle: nil)
        databaseService.observable.subscribe(onNext: { [weak self] in self?.tableView.reloadData() })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        view.addSubview(cardContainer)
        cardContainer.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(headerHeight)
        }

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(cardContainer.snp.bottom)
        }
        view.backgroundColor = .lightGray
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        setupInput()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        goTo()
    }

    let headerHeight: CGFloat = 200

    var tableViewWidth: CGFloat {
        return tableView.bounds.width
    }
    func goTo() {
        if viewModel.tasks.count > 0 {
            cardContainer.goToInput()
        } else {
            cardContainer.goToNewTask()
        }
    }
}

extension MainViewController {
    func setupInput() {
        cardContainer.newTaskView.cancelButton.tap.subscribe(onNext: { [weak self] in
            self?.cardContainer.goToInput()
        })
        //Todo: this doesn't feel right.  I would think there's a better way to subscribe here
        cardContainer.newTaskView.taskLengthPicker.fiveMinuteButton.tap.subscribe(onNext: { [weak self] in
            guard let length = self?.cardContainer.newTaskView.taskLengthPicker.fiveMinuteButton.length else {
                return
            }
            self?.newTask(title: self?.cardContainer.newTaskView.input.text ?? "", length: length)
            self?.cardContainer.newTaskView.input.text = ""
        })
        cardContainer.newTaskView.taskLengthPicker.fifteenMinuteButton.tap.subscribe(onNext: { [weak self] in
            guard let length = self?.cardContainer.newTaskView.taskLengthPicker.fifteenMinuteButton.length else {
                return
            }
            self?.newTask(title: self?.cardContainer.newTaskView.input.text ?? "", length: length)
            self?.cardContainer.newTaskView.input.text = ""
        })
        cardContainer.newTaskView.taskLengthPicker.thirtyMinuteButton.tap.subscribe(onNext: { [weak self] in
            guard let length = self?.cardContainer.newTaskView.taskLengthPicker.thirtyMinuteButton.length else {
                return
            }
            self?.newTask(title: self?.cardContainer.newTaskView.input.text ?? "", length: length)
            self?.cardContainer.newTaskView.input.text = ""
        })
        cardContainer.newTaskView.taskLengthPicker.oneHourButton.tap.subscribe(onNext: { [weak self] in
            guard let length = self?.cardContainer.newTaskView.taskLengthPicker.oneHourButton.length else {
                return
            }
            self?.newTask(title: self?.cardContainer.newTaskView.input.text ?? "", length: length)
            self?.cardContainer.newTaskView.input.text = ""
        })
        cardContainer.newTaskView.taskLengthPicker.threeHourButton.tap.subscribe(onNext: { [weak self] in
            guard let length = self?.cardContainer.newTaskView.taskLengthPicker.threeHourButton.length else {
                return
            }
            self?.newTask(title: self?.cardContainer.newTaskView.input.text ?? "", length: length)
            self?.cardContainer.newTaskView.input.text = ""
        })
        cardContainer.newTaskView.taskLengthPicker.fiveHourButton.tap.subscribe(onNext: { [weak self] in
            guard let length = self?.cardContainer.newTaskView.taskLengthPicker.fiveHourButton.length else {
                return
            }
            self?.newTask(title: self?.cardContainer.newTaskView.input.text ?? "", length: length)
            self?.cardContainer.newTaskView.input.text = ""
        })

        cardContainer.currentTask.cancelButton.tap.subscribe(onNext: { [weak self] in
            self?.cardContainer.goToInput()
        })
        cardContainer.currentTask.doneButton.tap.subscribe(onNext: { [weak self] in
            self?.doneCurrentTask()
        })
        cardContainer.pickTaskView.newTaskButton.tap.subscribe(onNext: { [weak self] in
            self?.cardContainer.goToNewTask()
            self?.tableView.reloadData()
        })
        cardContainer.pickTaskView.taskLengthPicker.fiveMinuteButton.tap.subscribe(onNext: { [weak self] in
            guard let length = self?.cardContainer.pickTaskView.taskLengthPicker.fiveMinuteButton.length else {
                return
            }
            self?.pickTask(length: length)
        })
        cardContainer.pickTaskView.taskLengthPicker.fifteenMinuteButton.tap.subscribe(onNext: { [weak self] in
            guard let length = self?.cardContainer.pickTaskView.taskLengthPicker.fifteenMinuteButton.length else {
                return
            }
            self?.pickTask(length: length)
        })
        cardContainer.pickTaskView.taskLengthPicker.thirtyMinuteButton.tap.subscribe(onNext: { [weak self] in
            guard let length = self?.cardContainer.pickTaskView.taskLengthPicker.thirtyMinuteButton.length else {
                return
            }
            self?.pickTask(length: length)
        })
        cardContainer.pickTaskView.taskLengthPicker.oneHourButton.tap.subscribe(onNext: { [weak self] in
            guard let length = self?.cardContainer.pickTaskView.taskLengthPicker.oneHourButton.length else {
                return
            }
            self?.pickTask(length: length)
        })
        cardContainer.pickTaskView.taskLengthPicker.threeHourButton.tap.subscribe(onNext: { [weak self] in
            guard let length = self?.cardContainer.pickTaskView.taskLengthPicker.threeHourButton.length else {
                return
            }
            self?.pickTask(length: length)
        })
        cardContainer.pickTaskView.taskLengthPicker.fiveHourButton.tap.subscribe(onNext: { [weak self] in
            guard let length = self?.cardContainer.pickTaskView.taskLengthPicker.fiveHourButton.length else {
                return
            }
            self?.pickTask(length: length)
        })
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfTasks
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 + 10 + 10
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = viewModel.task(indexPath: indexPath)
        pick(task: task)
    }
}

extension MainViewController {
    func pick(task: Task) {
        self.task = task
        cardContainer.currentTask.task = task
        cardContainer.goToCurrentTask()
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
        cardContainer.currentTask.task = nil
        cardContainer.goToInput()
    }

    func doneCurrentTask() {
        guard let task = task else {
            return
        }
        databaseService.delete(task: task)
        self.task = nil
        goTo()
    }
}

struct Task: Codable {

    var title: String
    var id: String
    var length: TaskLength

}

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
