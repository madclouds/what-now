//
//  NewTaskView.swift
//  What Now
//
//  Created by Erik Bye on 6/5/18.
//  Copyright © 2018 Erik Bye. All rights reserved.
//

import UIKit

class NewTaskView: UIView {
    let input = UITextField(frame: CGRect.zero)
    let cancelButton = UIButton(type: .contactAdd)
    let taskLengthPicker = TaskLengthPicker()
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
        taskLengthPicker.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(Const.padding)
            make.bottom.equalToSuperview().inset(Const.padding)
            make.height.equalTo(50)
        }
        input.backgroundColor = .white
        containerView.addSubview(input)
        input.textAlignment = .center
        input.snp.makeConstraints { (make) in
            make.right.left.equalTo(taskLengthPicker)
            make.height.equalTo(50)
            make.bottom.equalTo(taskLengthPicker.snp.top).offset(-Const.padding)
        }
        input.layer.cornerRadius = 50/2
        input.clipsToBounds = true

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "New task name:"
        label.textColor = .white
        containerView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(input.snp.top).offset(-10)
        }

        containerView.addSubview(cancelButton)
        cancelButton.tintColor = .white
        cancelButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        cancelButton.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(Const.padding)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
