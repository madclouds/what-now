import UIKit
import SnapKit

class ProgressView: UIView {
    var progress: Float = 0 {
        didSet {
            progressView.snp.makeConstraints { (make) in
                make.height.equalToSuperview().multipliedBy(progress)
            }
            self.setNeedsUpdateConstraints()

            UIView.animate(withDuration: 1) {
                self.layoutIfNeeded()
            }
        }
    }
    let progressView = UIView()

    init() {
        super.init(frame: .zero)
        progressView.backgroundColor = .white
        progressView.alpha = 0.3
        self.addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
