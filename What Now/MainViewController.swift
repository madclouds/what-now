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

    var task: Task?  //Move this to ViewModel named currentTask

    let tableView = UITableView()
    let progressView = ProgressView()
    internal let cardContainer = CardContainer()
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.reloadData.subscribe(onNext: { [weak self] _ in
            self?.tableView.reloadData()
            self?.filterTaskButtons()
        })
        self.viewModel.onTaskCompleted.subscribe(onNext: { [weak self] _ in
            self?.cardContainer.currentTaskView.updateScoreLabel()
        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Main Background Color")

        view.addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(named: "Table Background Color")
        tableView.separatorColor = .clear
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        view.addSubview(cardContainer)
        cardContainer.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.left.right.equalToSuperview()
            make.height.equalTo(headerHeight)
        }

        setupInput()

        let hud = HUD()
        hud.title.text = "Title!"
        hud.message.text = "Message!"
        hud.image.image = UIImage(named: "iTunesArtwork")
        hud.button.setTitle("Close", for: .normal)
        hud.action = {
            hud.removeFromSuperview()
        }
        view.addSubview(hud)
        hud.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
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

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        cardContainer.newTaskView.cancelButton.tap.subscribe(onNext: { [weak self] in
            self?.cardContainer.goToInput()
        })
        cardContainer.currentTaskView.cancelButton.tap.subscribe(onNext: { [weak self] in
            self?.cardContainer.goToInput()
        })
        cardContainer.currentTaskView.doneButton.tap.subscribe(onNext: { [weak self] in
            self?.doneCurrentTask()
        })
        cardContainer.pickTaskView.newTaskButton.tap.subscribe(onNext: { [weak self] in
            self?.cardContainer.goToNewTask()
        })

        //Todo: This doesn't feel right.  I would think there's a better way to subscribe here
        cardContainer.pickTaskView.taskLengthPicker.lengthTapped.subscribe(onNext: { [weak self] length in
            self?.pickTask(length: length)
        })

        cardContainer.newTaskView.taskLengthPicker.lengthTapped.subscribe(onNext: { [weak self] length in
            self?.newTask(title: self?.cardContainer.newTaskView.input.text ?? "", length: length)
        })

        filterTaskButtons()
    }

    func filterTaskButtons() {
        var activeTasks: Set<TaskLength> = []
        for task in viewModel.tasks {
            activeTasks.insert(task.length)
        }

        for button in cardContainer.pickTaskView.taskLengthPicker.buttons {
            if let length = button.length, !activeTasks.contains(length) {
                button.alpha = 0.4
            } else {
                button.alpha = 1
            }
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfTasks
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       return viewModel.cell(forTableView: tableView, atIndexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 + 10 + 10
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = viewModel.task(indexPath: indexPath)
        pick(task: task)
    }
}

//Todo: Should these methods be in the controller?

//Move all thse to the ViewModel
// All logic should be in view model, controllers only bind things together.
// Database services should be injected to ViewModel! then can have 100% code coverage
extension MainViewController {
    func pick(task: Task) {
        self.task = task
        cardContainer.currentTaskView.task = task
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
        cardContainer.newTaskView.input.text = ""
        viewModel.save(title: title, length: length)
    }

    func cancelCurrentTask() {
        task = nil
        cardContainer.currentTaskView.task = nil
        cardContainer.goToInput()
    }

    func doneCurrentTask() {
        guard let task = task else {
            return
        }

        viewModel.done(task)
        progressView.progress = viewModel.meaningfulMinutes/1000.0
        cardContainer.currentTaskView.task = nil
        self.task = nil
        goTo()
    }
}

struct Const {
    static let padding: CGFloat = 10
}
