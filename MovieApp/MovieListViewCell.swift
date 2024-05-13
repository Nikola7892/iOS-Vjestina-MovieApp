import UIKit
import PureLayout

class MovieListViewCell: UICollectionViewCell {
    
    static let id = "MovieListViewCell"
    private var containerView: UIView!
    private var movieImageView: UIImageView!
    private var titleLabel: UILabel!
    private var infoLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildViews(){
        containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 6
        
        contentView.addSubview(containerView)
                
        movieImageView = UIImageView()
        movieImageView.contentMode = .scaleAspectFill
        movieImageView.clipsToBounds = true
        
        containerView.addSubview(movieImageView)
                
        titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.numberOfLines = 2
        containerView.addSubview(titleLabel)
                
        infoLabel = UILabel()
        infoLabel.font = UIFont.systemFont(ofSize: 13)
        infoLabel.numberOfLines = 0
        infoLabel.lineBreakMode = .byWordWrapping
        containerView.addSubview(infoLabel)
    }
    
    private func setupLayout() {
        containerView.autoPinEdge(toSuperviewEdge: .top, withInset: 5)
        containerView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 10)
        containerView.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
        containerView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 5)
        
        movieImageView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
        movieImageView.autoPinEdge(toSuperviewEdge: .leading, withInset: 0)
        movieImageView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
        movieImageView.autoMatch(.width, to: .width, of: containerView, withMultiplier: 0.35)
        
        titleLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 10)
        titleLabel.autoPinEdge(.leading, to: .trailing, of: movieImageView, withOffset: 8)
        titleLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 10)
        
        infoLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 5)
        infoLabel.autoPinEdge(.leading, to: .trailing, of: movieImageView, withOffset: 8)
        infoLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 10)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        movieImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        movieImageView.layer.cornerRadius = containerView.layer.cornerRadius
    }
    
    func configure(with imageUrl: String?, title: String, info: String) {
        titleLabel.text = title
        infoLabel.text = info
        
        guard let imageUrlString = imageUrl, let imageUrl = URL(string: imageUrlString) else {
            movieImageView.image = nil
            return
        }
        let task = URLSession.shared.dataTask(with: imageUrl) { [weak self] (data, response, error) in
            guard let data = data, let image = UIImage(data: data) else {return}
            DispatchQueue.main.async {
                self?.movieImageView.image = image
            }
        }
        task.resume()
    }
}

