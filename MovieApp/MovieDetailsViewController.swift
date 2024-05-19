import UIKit
import PureLayout
import MovieAppData

class MovieDetailsViewController: UIViewController {
    
    private var scrollView: UIScrollView!
    private var headerView: HeaderView!
    private var movieDetails: MovieDetailsModel?
    var movieID: Int?
    
    private var overview: UILabel!
    private var movieInfo: UILabel!
    
    private var actorLabels: [UILabel] = []
    private var roleLabels: [UILabel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        if let movieID = movieID {
            movieDetails = MovieUseCase().getDetails(id: movieID)
            if let details = movieDetails {
                headerView.configure(with: details)
                configureDetails(details)
            }
        }
        layoutViews()
        styleViews()
        animateTextElements()
    }
    
    private func buildViews() {
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        
        headerView = HeaderView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(headerView)
        
        overview = UILabel()
        overview.text = "Overview"
        scrollView.addSubview(overview)
        
        movieInfo = UILabel()
        scrollView.addSubview(movieInfo)
    }
    
    private func layoutViews() {
        scrollView.autoPinEdgesToSuperviewEdges()
        
        headerView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
        headerView.autoPinEdge(toSuperviewEdge: .leading, withInset: 0)
        headerView.autoMatch(.width, to: .width, of: scrollView, withOffset: 0)
        headerView.autoSetDimension(.height, toSize: 300)
        
        overview.autoPinEdge(.top, to: .bottom, of: headerView, withOffset: 12)
        overview.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        
        movieInfo.autoPinEdge(.top, to: .bottom, of: overview, withOffset: 12)
        movieInfo.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        movieInfo.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
        
        var previousActorLabel: UILabel?
        var previousRoleLabel: UILabel?
        let actorLabelWidth: CGFloat = 120
        
        for i in 0..<actorLabels.count {
            let actorLabel = actorLabels[i]
            let roleLabel = roleLabels[i]
            actorLabel.autoSetDimension(.width, toSize: actorLabelWidth)
            
            if(i==0){
                actorLabel.autoPinEdge(.top, to: .bottom, of: movieInfo, withOffset: 25)
                actorLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
            } else if (i % 3 == 0){
                actorLabel.autoPinEdge(.top, to: .bottom, of: previousRoleLabel!, withOffset: 40)
                actorLabel.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
            } else {
                actorLabel.autoPinEdge(.top, to: .top, of: previousActorLabel!)
                actorLabel.autoPinEdge(.leading, to: .trailing, of: previousActorLabel!, withOffset: 15)
            }
            
            roleLabel.autoPinEdge(.top, to: .bottom, of: actorLabel, withOffset: 5)
            roleLabel.autoPinEdge(.leading, to: .leading, of: actorLabel)
            
            if(i % 3 == 2){
                actorLabel.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
            }
            if(i == actorLabels.count - 1){
                roleLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 20)
            }
            previousActorLabel = actorLabel
            previousRoleLabel = roleLabel
        }
    }
    
    private func styleViews() {
        scrollView.backgroundColor = .white
        
        overview.font = .boldSystemFont(ofSize: 22)
        overview.transform = CGAffineTransform(translationX: -view.bounds.width, y: 0)
        overview.alpha = 0
        
        movieInfo.numberOfLines = 0
        movieInfo.lineBreakMode = .byWordWrapping
        movieInfo.textColor = .black
        movieInfo.font = .systemFont(ofSize: 18)
        movieInfo.transform = CGAffineTransform(translationX: -view.bounds.width, y: 0)
        movieInfo.alpha = 0
        
        for label in actorLabels {
            label.textColor = .black
            label.font = UIFont.boldSystemFont(ofSize: 16)
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.alpha = 0
        }
        
        for label in roleLabels {
            label.textColor = .gray
            label.font = UIFont.systemFont(ofSize: 14)
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.alpha = 0
        }
    }
    
    private func configureDetails(_ details: MovieDetailsModel) {
        movieInfo.text = details.summary
        
        for (index, crewMember) in details.crewMembers.enumerated() {
            let actorLabel = UILabel()
            let roleLabel = UILabel()
            
            actorLabel.text = crewMember.name
            roleLabel.text = crewMember.role
            
            if (index < actorLabels.count) {
                actorLabels[index].text = actorLabel.text
                roleLabels[index].text = roleLabel.text
            } else {
                actorLabels.append(actorLabel)
                roleLabels.append(roleLabel)
                scrollView.addSubview(actorLabel)
                scrollView.addSubview(roleLabel)
            }
        }
    }
    

    private func animateTextElements() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.overview.transform = .identity
            self.overview.alpha = 1
            self.movieInfo.transform = .identity
            self.movieInfo.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                for label in self.actorLabels {
                           label.alpha = 1
                }
                for label in self.roleLabels {
                            label.alpha = 1
                        }
            }, completion: nil)
        })
    }


}


class HeaderView: UIView {
    private var containerView: UIView!
    private var movieTitle: UILabel!
    private var movieImage: UIImageView!
    private var userScore: UILabel!
    private var releaseDate: UILabel!
    private var genre: UILabel!
    private var duration: UILabel!

    private var buttonBackground: UIView!
    private var starButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutViews()
        configureLayout()
        styleViews()
        animateTextElements()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutViews() {
        containerView = UIView()
        addSubview(containerView)

        movieImage = UIImageView()
        containerView.addSubview(movieImage)

        userScore = UILabel()
        containerView.addSubview(userScore)
        
        
        releaseDate = UILabel()
        containerView.addSubview(releaseDate)
        
        movieTitle = UILabel()
        containerView.addSubview(movieTitle)
        
        
        genre = UILabel()
        containerView.addSubview(genre)
       
        
        duration = UILabel()
        containerView.addSubview(duration)
        
        buttonBackground = UIView()
        containerView.addSubview(buttonBackground)
        

        starButton = UIButton()
        containerView.addSubview(starButton)
    }

    private func styleViews() {
        movieImage.contentMode = .scaleAspectFill
        movieImage.clipsToBounds = true

        movieTitle.textColor = .white
        movieTitle.font = .boldSystemFont(ofSize: 22)
        movieTitle.numberOfLines = 0
        movieTitle.lineBreakMode = .byWordWrapping
        
        userScore.textColor = .white
        releaseDate.textColor = .white
        genre.textColor = .white
        duration.textColor = .white
        userScore.textColor = .white

        buttonBackground.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        buttonBackground.layer.cornerRadius = 15
        buttonBackground.clipsToBounds = true

        starButton.setImage(UIImage(systemName: "star"), for: .normal)
        starButton.tintColor = .white
        starButton.contentMode = .scaleAspectFit
    }

    private func configureLayout() {
        containerView.autoPinEdgesToSuperviewEdges()

        movieImage.autoPinEdgesToSuperviewEdges()
        
        buttonBackground.autoSetDimensions(to: CGSize(width: 30, height: 30))
        buttonBackground.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 10)
        buttonBackground.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 10)

        starButton.autoSetDimensions(to: CGSize(width: 20, height: 20))
        starButton.autoAlignAxis(.horizontal, toSameAxisOf: buttonBackground)
        starButton.autoAlignAxis(.vertical, toSameAxisOf: buttonBackground)
        
        genre.autoPinEdge(.bottom, to: .top, of: buttonBackground, withOffset: -10)
        genre.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 16)

        duration.autoPinEdge(.leading, to: .trailing, of: genre, withOffset: 16)
        duration.autoAlignAxis(.horizontal, toSameAxisOf: genre)

        releaseDate.autoPinEdge(.bottom, to: .top, of: genre, withOffset: -10)
        releaseDate.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 16)
        
        movieTitle.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 16)
        movieTitle.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 16)
        movieTitle.autoPinEdge(.bottom, to: .top, of: releaseDate, withOffset: -15)

        userScore.autoPinEdge(.bottom, to: .top, of: movieTitle, withOffset: -10)
        userScore.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 16)
    }

    
    private func animateTextElements() {
        let translation = CGAffineTransform(translationX: -containerView.bounds.width, y: 0)
        
        movieTitle.transform = translation
        releaseDate.transform = translation
        genre.transform = translation
        duration.transform = translation
        userScore.transform = translation
        
        movieTitle.alpha = 0
        releaseDate.alpha = 0
        genre.alpha = 0
        duration.alpha = 0
        userScore.alpha = 0
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            self.movieTitle.transform = .identity
            self.movieTitle.alpha = 1
            
            self.releaseDate.transform = .identity
            self.releaseDate.alpha = 1
            
            self.genre.transform = .identity
            self.genre.alpha = 1
            
            self.duration.transform = .identity
            self.duration.alpha = 1
            
            self.userScore.transform = .identity
            self.userScore.alpha = 1
        }, completion: nil)
    }
    
    
    func configure(with details: MovieDetailsModel) {
        movieTitle.text = "\(details.name) (\(details.year))"
        releaseDate.text = "\(formattedDate(from: details.releaseDate)) (US)"
        genre.text = genreString(from: details.categories)
        duration.text = durationString(from: details.duration)
        userScore.text = "\(details.rating) User Score"

        DispatchQueue.global().async { [weak self] in
            if let url = URL(string: details.imageUrl),
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.movieImage.image = image
                    self?.animateTextElements()
                }
            }
        }
    }

    private func genreString(from categories: [MovieCategoryModel]) -> String {
        var genreString = ""
        for category in categories {
            switch category {
            case .action:
                genreString += "Action, "
            case .adventure:
                genreString += "Adventure, "
            case .comedy:
                genreString += "Comedy, "
            case .crime:
                genreString += "Crime, "
            case .drama:
                genreString += "Drama, "
            case .fantasy:
                genreString += "Fantasy, "
            case .romance:
                genreString += "Romance, "
            case .scienceFiction:
                genreString += "Science Fiction, "
            case .thriller:
                genreString += "Thriller, "
            case .western:
                genreString += "Western, "
            }
        }
        genreString = String(genreString.dropLast(2))
        return genreString
    }

    private func durationString(from minutes: Int) -> String {
        let hours = minutes / 60
        let minutes = minutes % 60
        if(hours > 0){
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    private func formattedDate(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "mm/dd/yyyy"
            return dateFormatter.string(from: date)
        }
        return dateString
    }
}
