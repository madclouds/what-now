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
        let containerView = UIView()
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(22)
        }
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 8
        containerView.backgroundColor = UIColor(named: "Card Background Color")

        label.text = "Current Task"
        label.textColor = .white
        containerView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        containerView.addSubview(cancelButton)
        cancelButton.tintColor = .white
        cancelButton.snp.makeConstraints { make in
                make.top.right.equalToSuperview().inset(Const.padding)
        }

        containerView.addSubview(doneButton)
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(UIColor(named: "Primary Text Color"), for: .normal)
        doneButton.backgroundColor = UIColor(named: "Done Button Background Color")
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
