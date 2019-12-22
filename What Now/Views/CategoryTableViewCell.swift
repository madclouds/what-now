import UIKit

class CategoryTableViewCell: UITableViewCell {
    static let identifier = "CategoryTableViewCellIdentifier"
    let title = UILabel()
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
