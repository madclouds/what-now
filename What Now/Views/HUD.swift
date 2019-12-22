import UIKit

class HUD: UIView {
    let image = UIImageView()
    let title = UILabel()
    let message = UILabel()
    let button = UIButton()
    var action: () -> Void = {}
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        title.textAlignment = .center
        message.textAlignment = .center
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.lessThanOrEqualToSuperview().inset(10)
        }

        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(message)
        stackView.addArrangedSubview(button)
        button.setTitleColor(.black, for: .normal)
        button.tap.subscribe(onNext: { [weak self] in
            self?.action()
        })
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width/20
        clipsToBounds = true
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 300, height: 350)
    }
}
