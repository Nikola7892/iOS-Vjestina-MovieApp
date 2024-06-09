import Foundation
import UIKit
import PureLayout

class MovieListViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var allMovies: [MovieModel] = []
    private var router: AppRouterProtocol!
    
    private let apiCall = ApiCall()
    
    convenience init(router: AppRouterProtocol) {
        self.init()
        self.router = router
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        setupLayout()
        loadMovies()
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc private func deviceOrientationDidChange() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func buildViews(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.alwaysBounceVertical = true
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MovieListViewCell.self, forCellWithReuseIdentifier: MovieListViewCell.id)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.navigationItem.title = "Movie List"
    }
    
    private func setupLayout() {
        collectionView.autoPinEdge(toSuperviewSafeArea: .top)
        collectionView.autoPinEdge(toSuperviewSafeArea: .leading)
        collectionView.autoPinEdge(toSuperviewSafeArea: .trailing)
        collectionView.autoPinEdge(toSuperviewSafeArea: .bottom)
        view.backgroundColor = .white
        view.addSubview(collectionView)
    }
    
    
    private func loadMovies(){
        Task {
            do {
                self.allMovies = await apiCall.getAllMovies()
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                }
            }
    }
}

extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListViewCell.id, for: indexPath) as? MovieListViewCell else {
            fatalError("Failed to dequeue cell!")
        }
        
        let movie = allMovies[indexPath.item]
        
        if let imageUrl = movie.imageUrl, let name = movie.name, let summary = movie.summary {
            cell.configure(with: imageUrl, title: name, info: summary)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = allMovies[indexPath.item]
        
        if let movieID = movie.id {
            router.navigateToMovieDetails(movieID: movieID)
        }
    }
}

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        let isLandscape = UIDevice.current.orientation.isLandscape
        let width = isLandscape ? max(screenWidth, screenHeight)-120 : screenWidth
        let height: CGFloat = 200
        
        return CGSize(width: width, height: height)
    }
}

