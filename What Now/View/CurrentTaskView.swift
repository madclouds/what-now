//
//  CurrentTaskView.swift
//  What Now
//
//  Created by Erik Bye on 6/5/18.
//  Copyright © 2018 Erik Bye. All rights reserved.
//

import UIKit
class CurrentTaskView: UIView {
    let cancelButton = UIButton(type: .contactAdd)
    let doneButton = UIButton()
    let label = UILabel()
    var task: Task? {
        didSet {
            label.text = task?.title ?? "Current Task"
            doneButton.isHidden = task == nil
        }
    }
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor(rgb: 0x087EFF)

        label.text = "Current Task"
        label.textColor = .white
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
                make.top.right.equalTo(self).inset(Const.padding)
        }

        addSubview(doneButton)
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.backgroundColor = .green
        doneButton.isHidden = true
        doneButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(Const.padding)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
        doneButton.layer.cornerRadius = 50/2
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
