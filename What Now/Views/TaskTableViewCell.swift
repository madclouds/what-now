import UIKit

class TaskTableViewCell: UITableViewCell {
    static let identifier = "TaskTableViewCellIdentifier"
    let title = UILabel()
    var task: Task? {
        didSet {
            if let newTask = task {
                self.title.text = newTask.title
                self.length = newTask.length
            }
        }
    }
    private let cardView = UIView()
    var length: TaskLength? {
        didSet {
            if let newLength = length {
                icon.length = newLength
            }
        }
    }
    let icon = TaskLengthButton()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        addSubview(cardView)
        cardView.backgroundColor = UIColor(named: "Task Background Color")
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        let insetAmount = 10
        cardView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(insetAmount)
            make.top.equalToSuperview()
        }
        sendSubview(toBack: cardView)
        cardView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
        }
        cardView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(10)
            make.right.lessThanOrEqualTo(icon.snp.left)
            make.top.bottom.equalToSuperview()
        }
        title.textColor = UIColor(named: "Task Text Color")
        title.lineBreakMode = .byTruncatingMiddle
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        cardView.alpha = highlighted ? 0.5 : 1
    }
}
