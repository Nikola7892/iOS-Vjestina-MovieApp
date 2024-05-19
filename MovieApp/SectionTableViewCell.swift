import UIKit

class SectionTableViewCell: UITableViewCell {
    static let reuseIdentifier = "SectionTableViewCell"
    
    var titleLabel: UILabel!
    var collectionView: UICollectionView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        buildViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildViews() {
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(collectionView)
        
    
    }
    
    private func setupLayout(){
        titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 15)
        titleLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 15)
        titleLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 15)
        
        collectionView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 15)
        collectionView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        collectionView.autoSetDimension(.height, toSize: 200)
                            
    }
}

