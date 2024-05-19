
import Foundation
import UIKit
import MovieAppData
import PureLayout

class MovieListViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private let movieUseCase = MovieUseCase()
    
    
    private var router: AppRouterProtocol!
    
    convenience init(router: AppRouterProtocol) {
        self.init()
        self.router = router
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        setupLayout()
        
        self.navigationItem.title = "Movie List"
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
        collectionView.register(MovieListViewCell.self, forCellWithReuseIdentifier: MovieListViewCell.id)
        collectionView.alwaysBounceVertical = true
                view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    private func setupLayout() {
        collectionView.autoPinEdge(toSuperviewSafeArea: .top)
        collectionView.autoPinEdge(toSuperviewSafeArea: .leading)
        collectionView.autoPinEdge(toSuperviewSafeArea: .trailing)
        collectionView.autoPinEdge(toSuperviewSafeArea: .bottom)
        view.backgroundColor = .white
        view.addSubview(collectionView)
    }
}

extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieUseCase.allMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListViewCell.id, for: indexPath) as? MovieListViewCell else {
            fatalError("Failed to dequeue cell!")
        }
        //nedostaje mi godina, nije mi htjelo dohvatiti godinu
        let movie = movieUseCase.allMovies[indexPath.item]
        cell.configure(with: movie.imageUrl, title: movie.name,info: movie.summary)
            return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let movie = movieUseCase.allMovies[indexPath.item]
            let movieDetailsViewController = MovieDetailsViewController()
            movieDetailsViewController.movieID = movie.id
            movieDetailsViewController.navigationItem.title = "Movie Details"
            navigationController?.pushViewController(movieDetailsViewController, animated: true)
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

