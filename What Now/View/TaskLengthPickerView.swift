//
//  TaskLengthPickerView.swift
//  What Now
//
//  Created by Erik Bye on 6/5/18.
//  Copyright © 2018 Erik Bye. All rights reserved.
//

import UIKit

class TaskLengthPicker: UIView {
    let fiveMinuteButton = TaskLengthButton(taskLength: .fiveMinute)
    let fifteenMinuteButton = TaskLengthButton(taskLength: .fifteenMinute)
    let thirtyMinuteButton = TaskLengthButton(taskLength: .thirtyMinute)
    let oneHourButton = TaskLengthButton(taskLength: .oneHour)
    let threeHourButton = TaskLengthButton(taskLength: .threeHour)
    let fiveHourButton = TaskLengthButton(taskLength: .fiveHour)
    override init(frame: CGRect) {
        super.init(frame: frame)

        let contentView = UIStackView(frame: CGRect.zero)
        contentView.axis = .horizontal
        contentView.spacing = 5
        contentView.distribution = .fillEqually
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let padding = 5

        contentView.addArrangedSubview(fiveMinuteButton)
        fiveMinuteButton.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(contentView.snp.height)
        }
        contentView.addArrangedSubview(fifteenMinuteButton)
        fifteenMinuteButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(fiveMinuteButton.snp.right).offset(padding)
            make.width.equalTo(contentView.snp.height)
        }
        contentView.addArrangedSubview(thirtyMinuteButton)
        thirtyMinuteButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(fifteenMinuteButton.snp.right).offset(padding)
            make.width.equalTo(contentView.snp.height)
        }
        contentView.addArrangedSubview(oneHourButton)
        oneHourButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(thirtyMinuteButton.snp.right).offset(padding)
            make.width.equalTo(contentView.snp.height)
        }
        contentView.addArrangedSubview(threeHourButton)
        threeHourButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(oneHourButton.snp.right).offset(padding)
            make.width.equalTo(contentView.snp.height)
        }
        contentView.addArrangedSubview(fiveHourButton)
        fiveHourButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(threeHourButton.snp.right).offset(padding)
            make.width.equalTo(contentView.snp.height)
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 50 * 6 + 5 * 5, height: 50)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
