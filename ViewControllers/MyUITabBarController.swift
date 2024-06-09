import UIKit

class MyUITabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private var router: AppRouterProtocol!
    
    convenience init(router: AppRouterProtocol) {
        self.init()
        self.router = router
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupTabs()
        styleBarItems()
    }
    
    private func setupTabs() {
        let movieList = createNavigation(title: "Movie List", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"), vc: MovieThreeListCategories())
        let favourites = createNavigation(title: "Favourites", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"), vc: FavouritesViewController())
        
        self.setViewControllers([movieList, favourites], animated: true)
    }
    
    private func styleBarItems() {
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .gray
    }
       
    private func createNavigation(title: String, image: UIImage?, selectedImage: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        
        if title == "Movie List" {
            nav.viewControllers.first?.navigationItem.title = "Movie List"
        } else {
            nav.viewControllers.first?.navigationItem.title = "Favourites"
        }
        
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        nav.tabBarItem.selectedImage = selectedImage
        
        return nav
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let viewControllers = tabBarController.viewControllers {
            if viewController == viewControllers[1] {
                viewControllers[0].tabBarItem.title = "Home"
            } else {
                viewControllers[0].tabBarItem.title = "Movie List"
            }
        }
    }
}

