//
//  TaskLengthPickerView.swift
//  What Now
//
//  Created by Erik Bye on 6/5/18.
//  Copyright © 2018 Erik Bye. All rights reserved.
//

import UIKit

class TaskLengthPicker: UIView {
    let oneMinuteButton = TaskLengthButton()
    let fiveMinuteButton = TaskLengthButton()
    let fifteenMinuteButton = TaskLengthButton()
    let thirtyMinuteButton = TaskLengthButton()
    let oneHourButton = TaskLengthButton()
    let fiveHourButton = TaskLengthButton()
    override init(frame: CGRect) {
        super.init(frame: frame)

        oneMinuteButton.length = .oneMinute
        fiveMinuteButton.length = .fiveMinute
        fifteenMinuteButton.length = .fifteenMinute
        thirtyMinuteButton.length = .thirtyMinute
        oneHourButton.length = .oneHour
        fiveHourButton.length = .fiveHour

        let contentView = UIStackView(frame: CGRect.zero)
        contentView.axis = .horizontal
        contentView.spacing = 5
        contentView.distribution = .fillEqually
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let padding = 5
        contentView.addArrangedSubview(oneMinuteButton)
        oneMinuteButton.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(contentView.snp.height)
        }
        contentView.addArrangedSubview(fiveMinuteButton)
        fiveMinuteButton.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.left.equalTo(oneMinuteButton.snp.right).offset(padding)
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
        contentView.addArrangedSubview(fiveHourButton)
        fiveHourButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(oneHourButton.snp.right).offset(padding)
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
