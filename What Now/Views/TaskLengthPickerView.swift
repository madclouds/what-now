//
//  TaskLengthPickerView.swift
//  What Now
//
//  Created by Erik Bye on 6/5/18.
//  Copyright © 2018 Erik Bye. All rights reserved.
//

import UIKit
import Snail

class TaskLengthPicker: UIView {
    let lengthTapped: Observable<TaskLength>
    var buttons: [TaskLengthButton] = []
    init() {
        lengthTapped = Observable()
        super.init(frame: .zero)
//        let taskPicked = observable <TaskLength>

        //Subscribe to the buttons, and call the observable with the length enum

        //loop over

        let contentView = UIStackView()
        contentView.spacing = 5

        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        TaskLength.all.forEach { taskLength in
            let taskButton = TaskLengthButton()
            taskButton.length = taskLength
            buttons.append(taskButton)
            contentView.addArrangedSubview(taskButton)
            taskButton.tap.subscribe(onNext: { [weak self] in
                self?.lengthTapped.on(.next(taskLength))
            })
        }

    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 50)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
