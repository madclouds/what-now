//
//  ViewController.swift
//  What Now
//
//  Created by Erik Bye on 6/3/18.
//  Copyright © 2018 Erik Bye. All rights reserved.
//

import UIKit
import SnapKit

struct Const {
    static let padding: CGFloat = 10
}

class MainViewController: UITableViewController {

    var task: Task?
    var tasks: [Task]?
    var scrollView: UIScrollView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tasks = [Task(name: "First Task", length: 5),
                        Task(name: "Second Task", length: 5),
                        Task(name: "Third Task", length: 5)]
        self.tableView.tableFooterView = UIView()
    }

    let headerHeight: CGFloat = 200

    var tableViewWidth: CGFloat {
        return self.tableView.bounds.width
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks?.count ?? 0;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let task = self.tasks?[indexPath.row] else {
            return cell
        }

        cell.textLabel?.text = task.name
        let padding: CGFloat = 10
        let icon = LengthIcon(color: .red, length: 5)
        icon.frame = CGRect(x: tableView.frame.width - icon.frame.width - padding, y: padding, width: icon.frame.width, height: icon.frame.height)
        cell.contentView.addSubview(icon)
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let tableViewWidth = tableView.bounds.width
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: tableViewWidth, height: self.headerHeight))
        guard let scrollView = self.scrollView else {
            return nil
        }
        scrollView.contentSize = CGSize(width: tableViewWidth * 3, height: self.headerHeight)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false

        let currentTask = CurrentTaskView()
        currentTask.delegate = self
        scrollView.addSubview(currentTask)

        let inputView = InputView(frame: CGRect(x: tableViewWidth, y: 0, width: tableViewWidth, height: self.headerHeight))
        inputView.delegate = self
        scrollView.addSubview(inputView)

        let newTaskView = NewTaskView(frame: CGRect(x: tableViewWidth*2, y: 0, width: tableViewWidth, height: self.headerHeight))
        newTaskView.delegate = self
        scrollView.addSubview(newTaskView)

        scrollView.contentOffset = CGPoint(x: tableViewWidth, y: 0)


        return scrollView
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.headerHeight
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 + 10 + 10
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let task = self.tasks?[indexPath.row] {
            self.didSelect(task: task)
        }
    }

    func didSelect(task: Task) {
        self.task = task
        self.goToCurrentTask()
    }

    func goToInput() {
        self.scrollView?.scrollRectToVisible(CGRect(x: self.tableViewWidth, y: 0, width: self.tableViewWidth, height: self.headerHeight), animated: true)
    }

    func goToNewTask() {
        self.scrollView?.scrollRectToVisible(CGRect(x: self.tableViewWidth*2, y: 0, width: self.tableViewWidth, height: self.headerHeight), animated: true)
    }

    func goToCurrentTask() {
        self.scrollView?.scrollRectToVisible(CGRect(x: 0, y: 0, width: self.tableViewWidth, height: self.headerHeight), animated: true)
    }
}

extension MainViewController: InputViewDelegate, NewTaskViewDelegate, CurrentTaskViewDelegate {
    func newTaskAction() {
        self.goToNewTask()
    }
    func cancelNewTaskAction() {
        self.goToInput()
    }
    func cancelCurrentTaskAction() {
        self.goToInput()
    }
}

class LengthIcon : UIView {
    var color: UIColor
    var length: NSNumber
    let buttonSize: CGFloat = 50;
    init(color: UIColor, length: NSNumber) {

        self.color = color;
        self.length = length;
        super.init(frame: CGRect(x: 0, y: 0, width: self.buttonSize, height: self.buttonSize))
        self.backgroundColor = self.color
        self.layer.cornerRadius = self.buttonSize/2.0
        self.clipsToBounds = true

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

protocol InputViewDelegate {
    func newTaskAction()
}

class InputView : UIView {

    var delegate: InputViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Pick Task"
        label.textColor = .white
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-60)
        }

        let taskLengthPicker = TaskLengthPicker(frame: CGRect.zero)
        self.addSubview(taskLengthPicker)
        taskLengthPicker.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Const.padding)
            make.height.equalTo(50)
        }

        let newTaskButton = UIButton(type: .contactAdd)
        newTaskButton.addTarget(self, action:#selector(newTaskButtonAction) , for: .touchUpInside)
        self.addSubview(newTaskButton)

        newTaskButton.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(Const.padding)
            make.right.equalTo(self).offset(-Const.padding)
        }
    }

    @objc func newTaskButtonAction() {
        self.delegate?.newTaskAction()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol NewTaskViewDelegate {
    func cancelNewTaskAction()
}

class NewTaskView : UIView {
    var delegate: NewTaskViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .orange;

        let padding: CGFloat = 10
        let buttonSize: CGFloat = 50

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Create Task"
        label.textColor = .white
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-60)
        }




        let taskLengthPicker = TaskLengthPicker(frame: CGRect.zero)
        self.addSubview(taskLengthPicker)
        taskLengthPicker.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(Const.padding)
            make.height.equalTo(50)
        }
        let input = UITextField(frame: CGRect.zero)
        input.backgroundColor = .white
        self.addSubview(input)
        input.snp.makeConstraints { (make) in
            make.right.left.equalTo(taskLengthPicker)
            make.height.equalTo(50)
            make.bottom.equalTo(taskLengthPicker.snp.top).inset(Const.padding)
        }

        let cancelButton = UIButton(type: .contactAdd)
        cancelButton.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        cancelButton.addTarget(self, action:#selector(cancelButtonAction) , for: .touchUpInside)
        self.addSubview(cancelButton)

        cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(padding)
            make.left.equalTo(self).offset(padding)
        }
    }

    @objc func cancelButtonAction() {
        self.delegate?.cancelNewTaskAction()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol CurrentTaskViewDelegate {
    func cancelCurrentTaskAction()
}

class CurrentTaskView : UIView {
    var delegate: CurrentTaskViewDelegate?
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .black;
        let padding: CGFloat = 10
        let buttonSize: CGFloat = 50

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Current Task"
        label.textColor = .white
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }

        let cancelButton = UIButton(type: .contactAdd)
        cancelButton.frame = CGRect(x: frame.width - padding - buttonSize, y: padding, width: buttonSize, height: buttonSize)
        cancelButton.addTarget(self, action:#selector(cancelButtonAction) , for: .touchUpInside)
        self.addSubview(cancelButton)
    }

    @objc func cancelButtonAction() {
        self.delegate?.cancelCurrentTaskAction()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol TaskLengthPickerDelegate {
    func didPick(length:CGFloat)
}

class TaskLengthPicker: UIView {
    var delegate: TaskLengthPickerDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)

        let contentView = UIStackView(frame: CGRect.zero)
        contentView.axis = .horizontal
        contentView.spacing = 5
        contentView.distribution = .fillEqually
        self.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let width = 50

        let b1 = TaskLengthButton(frame: CGRect(x: 0, y: 0, width: width, height: width))
        contentView.addArrangedSubview(b1)

        let b2 = TaskLengthButton(frame: CGRect(x: 0, y: 0, width: width, height: width))
        contentView.addArrangedSubview(b2)

        let b3 = TaskLengthButton(frame: CGRect(x: 0, y: 0, width: width, height: width))
        contentView.addArrangedSubview(b3)

        let b4 = TaskLengthButton(frame: CGRect(x: 0, y: 0, width: width, height: width))
        contentView.addArrangedSubview(b4)

        let b5 = TaskLengthButton(frame: CGRect(x: 0, y: 0, width: width, height: width))
        contentView.addArrangedSubview(b5)

        let b6 = TaskLengthButton(frame: CGRect(x: 0, y: 0, width: width, height: width))
        contentView.addArrangedSubview(b6)
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 50 * 6 + 5 * 5, height: 50)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TaskLengthButton: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.layer.cornerRadius = frame.height/2.0
        self.backgroundColor = .blue
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct Task {
    var name: String
    var length: NSNumber
}

