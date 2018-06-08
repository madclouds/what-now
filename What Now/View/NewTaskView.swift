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
    let taskLengthPicker = TaskLengthPicker(frame: CGRect.zero)
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor(rgb: 0x34F355)

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "New Task View"
        label.textColor = .white
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-60)
        }

        addSubview(taskLengthPicker)
        taskLengthPicker.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(Const.padding)
            make.height.equalTo(50)
        }
        input.backgroundColor = .white
        addSubview(input)
        input.textAlignment = .center
        input.snp.makeConstraints { (make) in
            make.right.left.equalTo(taskLengthPicker)
            make.height.equalTo(50)
            make.bottom.equalTo(taskLengthPicker.snp.top).offset(-Const.padding)
        }
        input.layer.cornerRadius = 50/2
        input.clipsToBounds = true

        addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.top.left.equalTo(self).offset(Const.padding)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
