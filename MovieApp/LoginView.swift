import UIKit
import PureLayout

class LoginView: UIViewController {
    
    private var titleLabel: UILabel!
    private var username: UITextField!
    private var password: UITextField!
    private var loginButton: UIButton!
    private var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
    }
    
    private func buildViews() {
        createViews()
        styleViews()
        layoutViews()
    }
    
    func createViews() {
        titleLabel = UILabel()
        titleLabel.text = "MovieApp"
        view.addSubview(titleLabel)
        
        username = UITextField()
        username.placeholder = "Username"
        view.addSubview(username)
        
        password = UITextField()
        password.placeholder = "Password"
        view.addSubview(password)
        
        loginButton = UIButton()
        loginButton.setTitle("Login", for: .normal)
        view.addSubview(loginButton)
        
        signupButton = UIButton()
        signupButton.setTitle("Sign up", for: .normal)
        view.addSubview(signupButton)
    }
    
    func styleViews() {
        view.backgroundColor = .white
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 36)
        
        username.borderStyle = .roundedRect
        
        password.borderStyle = .roundedRect
        
        loginButton.backgroundColor = .black
        signupButton.backgroundColor = .black
        
    }
    
    func layoutViews() {
        titleLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 100)
        
        username.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 20)
        username.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 50)
        username.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 50)
        
        password.autoPinEdge(.top, to: .bottom, of: username, withOffset: 20)
        password.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 50)
        password.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 50)
        
        loginButton.autoPinEdge(.top, to: .bottom, of: password, withOffset: 20)
        loginButton.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 100)
        loginButton.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 100)
        
        signupButton.autoPinEdge(.top, to: .bottom, of: loginButton, withOffset: 20)
        signupButton.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 100)
        signupButton.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 100)
    }
    

}

