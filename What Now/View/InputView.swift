//
//  InputView.swift
//  What Now
//
//  Created by Erik Bye on 6/5/18.
//  Copyright © 2018 Erik Bye. All rights reserved.
//

import UIKit

class InputView: UIView {

    let newTaskButton = UIButton(type: .contactAdd)
    let taskLengthPicker = TaskLengthPicker(frame: CGRect.zero)
    init() {
        super.init(frame: .zero)

        let containerView = UIView()
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(22)
        }
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 8
        containerView.backgroundColor = UIColor(named: "Card Background Color")

        containerView.addSubview(taskLengthPicker)
        taskLengthPicker.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(Const.padding)
            make.height.equalTo(50)
        }

        let label = UILabel()
        label.text = "Pick Task"
        label.textColor = .white
        containerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(taskLengthPicker.snp.top)
        }

        containerView.addSubview(newTaskButton)
        newTaskButton.tintColor = .white
        newTaskButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(Const.padding)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
