//
//  TaskLenghView.swift
//  What Now
//
//  Created by Erik Bye on 6/5/18.
//  Copyright © 2018 Erik Bye. All rights reserved.
//

import UIKit
class TaskLengthButton: UIView {
    var length: TaskLength

    init(taskLength: TaskLength) {
        self.length = taskLength
        super.init(frame: .zero)
        clipsToBounds = true
        backgroundColor = UIColor(named: "Circle Time Button Background Color")

        let titleLabel = UILabel()
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        titleLabel.textColor = UIColor(named: "Circle Time Button Text Color")
        titleLabel.textAlignment = .center
        titleLabel.text = taskLength.title

        let subTitleLabel = UILabel()
        addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(15)
        }
        subTitleLabel.textColor = .white
        subTitleLabel.textAlignment = .center
        subTitleLabel.font = UIFont(descriptor: subTitleLabel.font.fontDescriptor, size: 8)
        subTitleLabel.alpha = 0.8
        subTitleLabel.text = taskLength.subTitle
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 50, height: 50)
    }
    override func layoutSubviews() {
        layer.cornerRadius = frame.height/2.0
    }
}
