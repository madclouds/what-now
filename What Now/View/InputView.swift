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
        backgroundColor = UIColor(rgb: 0xFF1B1B)

        addSubview(taskLengthPicker)
        taskLengthPicker.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(Const.padding)
            make.height.equalTo(50)
        }

        let label = UILabel()
        label.text = "Pick Task"
        label.textColor = .white
        addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(taskLengthPicker.snp.top)
        }

        addSubview(newTaskButton)
        newTaskButton.snp.makeConstraints { make in
            make.top.right.equalTo(self).inset(Const.padding)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
