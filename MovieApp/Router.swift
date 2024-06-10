import UIKit
import Foundation

protocol AppRouterProtocol {
    func navigateToMovieDetails(movieID: Int)
    func setStartScreen(in window: UIWindow?)
}


class AppRouter: AppRouterProtocol {
    
    private let navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func setStartScreen(in window: UIWindow?) {
        let vc = MovieListViewController(router:self)
        
        navigationController.pushViewController(vc, animated: false)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func navigateToMovieDetails(movieID: Int) {
            let movieDetailsViewController = MovieDetailsViewController()
            movieDetailsViewController.movieID = movieID
            movieDetailsViewController.navigationItem.title = "Movie Details"
            navigationController?.pushViewController(movieDetailsViewController, animated: true)
        }
}
