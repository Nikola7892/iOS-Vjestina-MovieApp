import UIKit
import PureLayout

class DifficultyCollectionViewCell: UICollectionViewCell {
    
    private var difficultyLabel: UILabel!
    private var starStackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViews()
        defineLayout()
        styleViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildViews() {
        difficultyLabel = UILabel()
        contentView.addSubview(difficultyLabel)
        
        starStackView = UIStackView()
        contentView.addSubview(starStackView)
    }
    
    private func defineLayout() {
        difficultyLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        difficultyLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 5)
        
        starStackView.autoPinEdge(.top, to: .bottom, of: difficultyLabel, withOffset: 5)
        starStackView.autoAlignAxis(toSuperviewAxis: .vertical)
        starStackView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 5)
    }
    
    private func styleViews() {
        difficultyLabel.font = .boldSystemFont(ofSize: 20)
        difficultyLabel.textColor = .white
        difficultyLabel.textAlignment = .center
        difficultyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        starStackView.axis = .horizontal
        starStackView.alignment = .center
        starStackView.spacing = 2
        starStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.layer.cornerRadius = 5
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.white.cgColor
    }
    
    func configure(with difficulty: String, stars: [UIImage], color: UIColor) {
        difficultyLabel.text = difficulty
        for star in stars {
            let starImageView = UIImageView(image: star)
            starImageView.tintColor = .white
            starStackView.addArrangedSubview(starImageView)
        }
        contentView.backgroundColor = color
    }
}
