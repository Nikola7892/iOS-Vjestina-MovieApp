import UIKit
import MovieAppData

class MovieThreeListCategories: UIViewController {
    private var tableView: UITableView!
    private var movieUseCase: MovieUseCaseProtocol!
    private var popularMovies: [MovieModel] = []
    private var freeToWatchMovies: [MovieModel] = []
    private var trendingMovies: [MovieModel] = []
    
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
        tableView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 10)
        tableView.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
        tableView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
    }
    
    private func loadMovies() {
        movieUseCase = MovieUseCase()
        popularMovies = movieUseCase.popularMovies
        freeToWatchMovies = movieUseCase.freeToWatchMovies
        trendingMovies = movieUseCase.trendingMovies
        tableView.reloadData()
    }
}

extension MovieThreeListCategories: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SectionTableViewCell.reuseIdentifier, for: indexPath) as! SectionTableViewCell
        
        if(indexPath.section==0){
            cell.titleLabel.text = "What's Popular"
            cell.collectionView.tag = 0
        }
        else if(indexPath.section==1){
            cell.titleLabel.text = "Free to Watch"
            cell.collectionView.tag = 1
        }
        else {
            cell.titleLabel.text = "Trending"
            cell.collectionView.tag = 2
        }
        
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
    
        return cell
    }
}

extension MovieThreeListCategories: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView.tag == 0){
            return popularMovies.count
        }
        else if(collectionView.tag == 1){
            return freeToWatchMovies.count
        } else {
            return trendingMovies.count
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        
        var movies: [MovieModel] = []
        
        if(collectionView.tag == 0){
            movies = popularMovies
        }
        else if(collectionView.tag == 1){
            movies = freeToWatchMovies
        } else {
            movies = trendingMovies
        }
        
        let movie = movies[indexPath.item]
        
        let imageView = UIImageView(frame: cell.contentView.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.load(url: URL(string: movie.imageUrl)!)
      
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
        
        let width = collectionView.bounds.width/3
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
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

