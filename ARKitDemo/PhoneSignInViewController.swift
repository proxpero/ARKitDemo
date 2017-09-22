import UIKit
import Firebase
import FirebasePhoneAuthUI

class PhoneSignInViewController: UIViewController, FUIAuthDelegate {

    /// MARK: UI Outlets and Actions

    @IBOutlet var treeButton: UIButton!
    @IBOutlet var logInOutButton: UIBarButtonItem!

    @IBAction func didTapTreeButton(_ sender: UIButton) {
        pushARVC()
    }

    @IBAction func didTapLogInOut(_ sender: UIBarButtonItem) {
        if userIsLoggedIn {
            // TODO: Fix optional try.
            try? FUIAuth.defaultAuthUI()?.signOut()
        } else {
            login()
        }
    }

    /// Private State

    private var handle: AuthStateDidChangeListenerHandle?

    private var userIsLoggedIn: Bool = false {
        didSet {
            switch userIsLoggedIn {
            case true:
                treeButton.isEnabled = true
                logInOutButton.title = "Log Out"
            case false:
                treeButton.isEnabled = false
                logInOutButton.title = "Log In"
            }
        }
    }

    /// Methods

    // FUIAuthDelegate delegate method.
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let error = error {
            // TODO: Show error to the user.
            print(error.localizedDescription)
            return
        }
        pushARVC()
    }

    /// TODO: Inject AuthUI singleton into vc instead of referencing directly.
    private func login() {
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.isSignInWithEmailHidden = true
        let phoneProvider = FUIPhoneAuth(authUI: authUI!)
        authUI?.delegate = self
        authUI?.providers = [phoneProvider]
        phoneProvider.signIn(withPresenting: self, phoneNumber: nil)
    }

    // TODO: Use coordinator handle this action (and login).
    private func pushARVC() {
        guard let arvc = storyboard?.instantiateViewController(withIdentifier: "ARViewControllerId") else { fatalError() }
        navigationController?.pushViewController(arvc, animated: true)
    }

    /// Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            self.userIsLoggedIn = user != nil
        }
    }

    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}

