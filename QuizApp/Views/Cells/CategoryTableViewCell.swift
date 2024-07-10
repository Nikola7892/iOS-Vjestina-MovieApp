import UIKit
import PureLayout

class CategoryTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var categoryLabel: UILabel!
    private var collectionView: UICollectionView!
    
    private let difficultyLevels = ["Easy", "Medium", "Hard"]
    private let difficultyStars: [[UIImage]] = [
        [UIImage(systemName: "star.fill")!, UIImage(systemName: "star")!, UIImage(systemName: "star")!],
        [UIImage(systemName: "star.fill")!, UIImage(systemName: "star.fill")!, UIImage(systemName: "star")!],
        [UIImage(systemName: "star.fill")!, UIImage(systemName: "star.fill")!, UIImage(systemName: "star.fill")!]
    ]
    private let difficultyColors: [UIColor] = [.systemGreen, .systemTeal, .systemPurple]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildViews()
        defineLayout()
        styleViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildViews() {
        categoryLabel = UILabel()
        contentView.addSubview(categoryLabel)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DifficultyCollectionViewCell.self, forCellWithReuseIdentifier: "DifficultyCell")
        contentView.addSubview(collectionView)
    }
    
    private func defineLayout() {
        categoryLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        categoryLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
        
        collectionView.autoPinEdge(.top, to: .bottom, of: categoryLabel, withOffset: 10)
        collectionView.autoAlignAxis(toSuperviewAxis: .vertical)
        collectionView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
        collectionView.autoSetDimension(.height, toSize: 80)
        collectionView.autoSetDimension(.width, toSize: contentView.frame.width)
    }
    
    private func styleViews() {
        categoryLabel.font = .boldSystemFont(ofSize: 30)
        categoryLabel.textColor = .white
        categoryLabel.textAlignment = .center
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = .clear
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 5)
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowRadius = 5
        
        selectionStyle = .none
    }
    
    func configure(with category: String) {
        categoryLabel.text = category
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return difficultyLevels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DifficultyCell", for: indexPath) as? DifficultyCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: difficultyLevels[indexPath.item], stars: difficultyStars[indexPath.item], color: difficultyColors[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 80)
    }
}
