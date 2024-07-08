import UIKit
import PureLayout

class QuizQuestionViewController: UIViewController {

    private var router: AppRouterProtocol!
    
    convenience init(router: AppRouterProtocol) {
        self.init()
        self.router = router
    }
    
    
    private var gradientView: UIView!
    private var gradientLayer: CAGradientLayer!
    
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    
    private var progressView: CircularProgressView!
    private var timer: DispatchSourceTimer?
    private var totalTime: TimeInterval = 10.0
    private var elapsedTime: TimeInterval = 0.0
    
    private var quizTitle: UILabel!
    private var question: UILabel!
    private var answerButtons: [UIButton] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        defineLayout()
        styleViews()
        startTimer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateGradientFrame()
    }
    
    private func buildViews() {
        gradientView = UIView()
        gradientLayer = CAGradientLayer()
        view.addSubview(gradientView)
        
        scrollView = UIScrollView()
        contentView = UIView()
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)

        quizTitle = UILabel()
        quizTitle.text = "Quiz in: CATEGORY NAME"
        contentView.addSubview(quizTitle)
        
        question = UILabel()
        question.text = "Question uhfiwhf iuwfhierhf oehfeorhf ohe?"
        contentView.addSubview(question)
        
        progressView = CircularProgressView()
        contentView.addSubview(progressView)
        
        for i in 0..<4 {
            let button = UIButton()
            button.setTitle("Answer \(i + 1)", for: .normal)
            answerButtons.append(button)
            contentView.addSubview(button)
        }
    }
    
    private func defineLayout() {
        
        gradientView.autoPinEdgesToSuperviewEdges()
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
       
        scrollView.autoPinEdgesToSuperviewEdges()
        
        contentView.autoPinEdgesToSuperviewEdges()
        contentView.autoMatch(.width, to: .width, of: view)
        
        quizTitle.autoPinEdge(toSuperviewSafeArea: .top, withInset: 10)
        quizTitle.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        quizTitle.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
        
        question.autoPinEdge(.top, to: .bottom, of: quizTitle, withOffset: 20)
        question.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        question.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
        
        progressView.autoPinEdge(.top, to: .bottom, of: question, withOffset: 40)
        progressView.autoAlignAxis(toSuperviewAxis: .vertical)
        progressView.autoSetDimensions(to: CGSize(width: 150, height: 150))
        
        let buttonGridSpacing: CGFloat = 30
        let buttonWidth: CGFloat = 160
        let buttonHeight: CGFloat = 70
        
        answerButtons[0].autoPinEdge(.top, to: .bottom, of: progressView, withOffset: 40)
        answerButtons[0].autoAlignAxis(.vertical, toSameAxisOf: progressView, withOffset: -(buttonWidth + buttonGridSpacing) / 2)
        answerButtons[0].autoSetDimensions(to: CGSize(width: buttonWidth, height: buttonHeight))
        
        answerButtons[1].autoPinEdge(.top, to: .bottom, of: progressView, withOffset: 40)
        answerButtons[1].autoAlignAxis(.vertical, toSameAxisOf: progressView, withOffset: (buttonWidth + buttonGridSpacing) / 2)
        answerButtons[1].autoSetDimensions(to: CGSize(width: buttonWidth, height: buttonHeight))
        
        answerButtons[2].autoPinEdge(.top, to: .bottom, of: answerButtons[0], withOffset: buttonGridSpacing)
        answerButtons[2].autoAlignAxis(.vertical, toSameAxisOf: answerButtons[0])
        answerButtons[2].autoSetDimensions(to: CGSize(width: buttonWidth, height: buttonHeight))
        
        answerButtons[3].autoPinEdge(.top, to: .bottom, of: answerButtons[1], withOffset: buttonGridSpacing)
        answerButtons[3].autoAlignAxis(.vertical, toSameAxisOf: answerButtons[1])
        answerButtons[3].autoSetDimensions(to: CGSize(width: buttonWidth, height: buttonHeight))
        
        contentView.autoPinEdge(.bottom, to: .bottom, of: answerButtons[3], withOffset: 40)
    }
    
    private func styleViews() {
        
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemMint.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        quizTitle.textAlignment = .center
        quizTitle.textColor = .white
        quizTitle.font = .boldSystemFont(ofSize: 50)
        quizTitle.numberOfLines = 0
        quizTitle.lineBreakMode = .byWordWrapping
        
        question.textAlignment = .center
        question.textColor = .white
        question.numberOfLines = 0
        question.font = .boldSystemFont(ofSize: 28)
        question.lineBreakMode = .byWordWrapping
        
        progressView.progressColor = UIColor.systemGreen
        progressView.trackColor = UIColor.lightGray

        for button in answerButtons {
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 5)
            button.layer.shadowOpacity = 0.3
            button.layer.shadowRadius = 5
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        }
        answerButtons[0].backgroundColor = .systemBlue
        answerButtons[1].backgroundColor = .systemGreen
        answerButtons[2].backgroundColor = .systemTeal
        answerButtons[3].backgroundColor = .systemPurple
    }
    
    private func updateGradientFrame() {
        gradientLayer.frame = gradientView.bounds
    }
    
    private func startTimer() {
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .background))
        timer?.schedule(deadline: .now(), repeating: 0.1)
        timer?.setEventHandler { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.elapsedTime += 0.1
                let progress = CGFloat(self.elapsedTime / self.totalTime)
                self.progressView.progress = progress
                
                let greenToRedTransition = self.elapsedTime / self.totalTime
                let color = UIColor(
                    red: CGFloat(1.0 * greenToRedTransition),
                    green: CGFloat(1.0 * (1 - greenToRedTransition)),
                    blue: 0.0,
                    alpha: 1.0
                )
                self.progressView.updateProgressColor(to: color)
                
                if self.elapsedTime >= self.totalTime {
                    self.timer?.cancel()
                }
            }
        }
        timer?.resume()
    }
}
