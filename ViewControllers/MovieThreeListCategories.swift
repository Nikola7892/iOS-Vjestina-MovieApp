import UIKit


class MovieThreeListCategories: UIViewController {
    private var tableView: UITableView!
    private var freeToWatchMovies: [MovieModel] = []
    private var popularMovies: [MovieModel] = []
    private var trendingMovies: [MovieModel] = []
    
    private var apiCall = ApiCall()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        setupLayout()
        loadMovies()
    }
            
    private func buildViews() {
        tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SectionTableViewCell.self, forCellReuseIdentifier: SectionTableViewCell.reuseIdentifier)
        view.addSubview(tableView)
        view.backgroundColor = .white
    }
    
    private func setupLayout() {
        tableView.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
        tableView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 5)
        tableView.autoPinEdge(toSuperviewEdge: .leading, withInset: 5)
        tableView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
    }
    
    private func loadMovies(){
        Task {
            do{
                self.popularMovies = await apiCall.getPopularMovies()
                self.freeToWatchMovies = await apiCall.getFreeToWatchMovies()
                self.trendingMovies = await apiCall.getTrendingMovies()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
  
}

extension MovieThreeListCategories: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SectionTableViewCell.reuseIdentifier, for: indexPath) as! SectionTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "What's Popular"
            cell.collectionView.tag = 1
        case 1:
            cell.titleLabel.text = "Free to Watch"
            cell.collectionView.tag = 2
        case 2:
            cell.titleLabel.text = "Trending"
            cell.collectionView.tag = 3
        default:
            break
        }
        
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        cell.collectionView.reloadData()
        
        return cell
    }
}

extension MovieThreeListCategories: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 1:
            return  popularMovies.count
        case 2:
            return freeToWatchMovies.count
        case 3:
            return trendingMovies.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        let movie: MovieModel
        
        switch collectionView.tag {
        case 1:
            movie = popularMovies[indexPath.item]
        case 2:
            movie = freeToWatchMovies[indexPath.item]
        case 3:
            movie = trendingMovies[indexPath.item]
        default:
            fatalError("Unknown collection view tag")
        }
        
        let imageView = UIImageView(frame: cell.contentView.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let imageUrl = movie.imageUrl, let url = URL(string: imageUrl) {
            imageView.load(url: url)
        }
        cell.contentView.addSubview(imageView)
        
        cell.contentView.layer.cornerRadius = 15
        cell.contentView.layer.masksToBounds = true
        
        let heartBackground = UIView()
        heartBackground.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        heartBackground.layer.cornerRadius = 15
        heartBackground.clipsToBounds = true
        heartBackground.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
        cell.contentView.addSubview(heartBackground)
        
        let heartButton = UIButton()
        heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        heartButton.tintColor = .white
        heartButton.contentMode = .scaleAspectFit
        heartButton.frame = CGRect(x: 15, y: 15, width: 20, height: 20)
        cell.contentView.addSubview(heartButton)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 3
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieID: Int?
        
        switch collectionView.tag {
        case 1:
            movieID = popularMovies[indexPath.item].id
        case 2:
            movieID = freeToWatchMovies[indexPath.item].id
        case 3:
            movieID = trendingMovies[indexPath.item].id
        default:
            movieID = nil
        }
        
        guard let validMovieID = movieID else {
            return
        }
        
        let movieDetailsViewController = MovieDetailsViewController()
        movieDetailsViewController.movieID = validMovieID
        movieDetailsViewController.navigationItem.title = "Movie Details"
        navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }

}

extension UIImageView {
    func load(url: URL?) {
        guard let url = url else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
