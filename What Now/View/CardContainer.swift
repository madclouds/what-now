//
//  CardContainer.swift
//  What Now
//
//  Created by Erik Bye on 6/8/18.
//  Copyright © 2018 Erik Bye. All rights reserved.
//

import UIKit

class CardContainer: UIView {
    var scrollView = UIScrollView()
    let currentTask = CurrentTaskView()
    let pickTaskView = InputView()
    let newTaskView = NewTaskView()
    init() {
        super.init(frame: .zero)

        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(self.snp.width).multipliedBy(3)
        }

        contentView.addSubview(currentTask)
        currentTask.snp.makeConstraints { (make) in
            make.width.equalTo(self.snp.width)
            make.height.equalTo(self.snp.height)
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview()
        }

        contentView.addSubview(pickTaskView)
        pickTaskView.snp.makeConstraints { (make) in
            make.width.equalTo(self.snp.width)
            make.height.equalTo(self.snp.height)
            make.top.bottom.equalToSuperview()
            make.left.equalTo(currentTask.snp.right)
        }

        contentView.addSubview(newTaskView)
        newTaskView.snp.makeConstraints { (make) in
            make.width.equalTo(self.snp.width)
            make.height.equalTo(self.snp.height)
            make.top.bottom.equalToSuperview()
            make.left.equalTo(pickTaskView.snp.right)
        }

        scrollView.needsUpdateConstraints()
        scrollView.layoutIfNeeded()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func goToInput() {
        scrollView.scrollRectToVisible(CGRect(x: self.frame.width, y: 0, width: self.frame.width, height: self.frame.height), animated: true)
    }

    func goToNewTask() {
        scrollView.scrollRectToVisible(CGRect(x: self.frame.width*2, y: 0, width: self.frame.width, height: self.frame.height), animated: true)
    }
    func goToCurrentTask() {
        scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), animated: true)
    }
}
