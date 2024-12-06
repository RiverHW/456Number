import UIKit

class CountdownProgressView: UIView {

    // 总倒计时时长（单位：秒）
    var totalTime: Float = 60.0
    // 当前剩余时间
    private var remainingTime: Float = 60.0
    // 定时器
     var timer: Timer?
    // 进度条
    private let progressView = UIProgressView(progressViewStyle:.default)
    // 显示剩余时间的标签
//    private let timeLabel = UILabel()

    // 定义闭包类型，用于在倒计时结束时回调
    typealias CountdownCompletionBlock = () -> Void
    // 存储倒计时结束的闭包回调
    var completionBlock: CountdownCompletionBlock?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        // 设置进度条的框架和默认属性
        progressView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 20)
        progressView.progress = 1.0
        addSubview(progressView)
        progressView.progressTintColor = .black
        // 设置时间标签的框架和默认属性
//        timeLabel.frame = CGRect(x: 0, y: 25, width: bounds.width, height: 30)
//        timeLabel.textAlignment = .center
//        addSubview(timeLabel)
    }

    func startCountdown() {
        remainingTime = totalTime
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }

    @objc func updateCountdown() {
        if remainingTime > 0 {
            remainingTime -= 0.01
//            timeLabel.text = "\(remainingTime)"
            let progress = Float(remainingTime) / Float(totalTime)
            progressView.progress = progress
        } else {
            timer?.invalidate()
            // 调用闭包，通知外部倒计时结束
            completionBlock?()
        }
    }
}
