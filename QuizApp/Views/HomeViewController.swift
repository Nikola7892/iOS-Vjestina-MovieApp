import UIKit
import PureLayout

class HomeViewController: UIViewController {
    
    private var router: AppRouterProtocol!
    
    convenience init(router: AppRouterProtocol) {
        self.init()
        self.router = router
    }
    
    private var scrollView: UIScrollView!
    private var contentView: UIView!

    private var gradientView: UIView!
    private var gradientLayer: CAGradientLayer!
    
    private var titleLabel: UILabel!
    private var profileButton: UIButton!
    private var startQuizButton: UIButton!
    private var settingsButton: UIButton!
    private var leaderboardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        defineLayout()
        styleViews()
    }
    
    private func buildViews() {
        gradientView = UIView()
        view.addSubview(gradientView)
        
        gradientLayer = CAGradientLayer()
        
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        
        contentView = UIView()
        scrollView.addSubview(contentView)
        
        titleLabel = UILabel()
        titleLabel.text = "QuizApp"
        contentView.addSubview(titleLabel)
        
        
        profileButton = UIButton()
        profileButton.setTitle("My Profile", for: .normal)
        contentView.addSubview(profileButton)
        
        startQuizButton = UIButton()
        startQuizButton.setTitle("Start Quiz", for: .normal)
        contentView.addSubview(startQuizButton)
        
        settingsButton = UIButton()
        settingsButton.setTitle("Settings", for: .normal)
        contentView.addSubview(settingsButton)
        
        leaderboardButton = UIButton()
        leaderboardButton.setTitle("Leaderboard", for: .normal)
        contentView.addSubview(leaderboardButton)
    }
    
    private func defineLayout() {
        gradientView.autoPinEdgesToSuperviewEdges()
        
        scrollView.autoPinEdgesToSuperviewEdges()
        contentView.autoPinEdgesToSuperviewEdges()
        contentView.autoMatch(.width, to: .width, of: view)

        let buttonWidth = 250
        let buttonHeight = 50
        titleLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 10)
        titleLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        
        profileButton.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 40)
        profileButton.autoAlignAxis(toSuperviewAxis: .vertical)
        profileButton.autoSetDimensions(to: CGSize(width: buttonWidth, height: buttonHeight))
        
        
        startQuizButton.autoPinEdge(.top, to: .bottom, of: profileButton, withOffset: 40)
        startQuizButton.autoAlignAxis(toSuperviewAxis: .vertical)
        startQuizButton.autoSetDimensions(to: CGSize(width: buttonWidth, height: buttonHeight))
        
        leaderboardButton.autoPinEdge(.top, to: .bottom, of: startQuizButton, withOffset: 40)
        leaderboardButton.autoAlignAxis(toSuperviewAxis: .vertical)
        leaderboardButton.autoSetDimensions(to: CGSize(width: buttonWidth, height: buttonHeight))
        
        settingsButton.autoPinEdge(.top, to: .bottom, of: leaderboardButton, withOffset: 40)
        settingsButton.autoAlignAxis(toSuperviewAxis: .vertical)
        settingsButton.autoSetDimensions(to: CGSize(width: buttonWidth, height: buttonHeight))
        
        contentView.autoPinEdge(.bottom, to: .bottom, of: settingsButton, withOffset: 40)
    }
    
    private func styleViews() {
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemMint.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)

        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 50)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        
        profileButton.backgroundColor = .systemBlue
        profileButton.setTitleColor(.white, for: .normal)
        profileButton.layer.cornerRadius = 10
        profileButton.layer.borderWidth = 2
        profileButton.layer.borderColor = UIColor.white.cgColor
        profileButton.layer.shadowColor = UIColor.black.cgColor
        profileButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        profileButton.layer.shadowOpacity = 0.3
        profileButton.layer.shadowRadius = 5
        profileButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        startQuizButton.backgroundColor = .systemGreen
        startQuizButton.setTitleColor(.white, for: .normal)
        startQuizButton.layer.cornerRadius = 10
        startQuizButton.layer.borderWidth = 2
        startQuizButton.layer.borderColor = UIColor.white.cgColor
        startQuizButton.layer.shadowColor = UIColor.black.cgColor
        startQuizButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        startQuizButton.layer.shadowOpacity = 0.3
        startQuizButton.layer.shadowRadius = 5
        startQuizButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        settingsButton.backgroundColor = .systemTeal
        settingsButton.setTitleColor(.white, for: .normal)
        settingsButton.layer.cornerRadius = 10
        settingsButton.layer.borderWidth = 2
        settingsButton.layer.borderColor = UIColor.white.cgColor
        settingsButton.layer.shadowColor = UIColor.black.cgColor
        settingsButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        settingsButton.layer.shadowOpacity = 0.3
        settingsButton.layer.shadowRadius = 5
        settingsButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        leaderboardButton.backgroundColor = .systemPurple
        leaderboardButton.setTitleColor(.white, for: .normal)
        leaderboardButton.layer.cornerRadius = 10
        leaderboardButton.layer.borderWidth = 2
        leaderboardButton.layer.borderColor = UIColor.white.cgColor
        leaderboardButton.layer.shadowColor = UIColor.black.cgColor
        leaderboardButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        leaderboardButton.layer.shadowOpacity = 0.3
        leaderboardButton.layer.shadowRadius = 5
        leaderboardButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = gradientView.bounds
    }
}
