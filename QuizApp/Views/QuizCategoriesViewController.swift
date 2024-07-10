import UIKit
import PureLayout

class QuizCategoriesViewController: UIViewController {
    
    private var router: AppRouterProtocol!
    
    convenience init(router: AppRouterProtocol) {
        self.init()
        self.router = router
    }
    
    private var titleLabel: UILabel!
    private var homeButton: UIButton!
    private var tableView: UITableView!
    private var gradientLayer: CAGradientLayer!
    
    private let categories = ["Films", "Music", "Video Games", "Computers", "Mathematics", "Sports", "Geography", "History"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        defineLayout()
        styleViews()
    }
    
    private func buildViews() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        titleLabel = UILabel()
        titleLabel.text = "Choose a Quiz!"
        view.addSubview(titleLabel)
        
        homeButton = UIButton(type: .system)
        view.addSubview(homeButton)
        
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        view.addSubview(tableView)
    }
    
    private func defineLayout() {
        titleLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 5)
        titleLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        
        tableView.autoPinEdgesToSuperviewSafeArea(with: .zero, excludingEdge: .top)
        tableView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 25)
        
        homeButton.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 16)
        homeButton.autoPinEdge(toSuperviewSafeArea: .top, withInset: 16)
    }
    
    private func styleViews() {
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemMint.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 35)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        homeButton.setImage(UIImage(systemName: "house.fill"), for: .normal)
        homeButton.tintColor = .white
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
}

extension QuizCategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: categories[indexPath.row])
        return cell
    }
    
}

