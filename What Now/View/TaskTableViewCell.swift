import UIKit

class TaskTableViewCell: UITableViewCell {
    static let identifier = "TaskTableViewCellIdentifier"
    let title = UILabel()
    private let cardView = UIView()
    //Todo: I want the UI to update when I update this property.  Should I override the setter..?
    let icon = TaskLengthButton(taskLength: .fiveMinute)
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

        cardView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview()
        }
        title.textColor = UIColor(named: "Task Text Color")

        cardView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        cardView.alpha = highlighted ? 0.5 : 1
    }
}
