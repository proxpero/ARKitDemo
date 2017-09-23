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

    private var phoneProvider: FUIPhoneAuth?
    private var handle: AuthStateDidChangeListenerHandle?

    private var userIsLoggedIn: Bool = false {
        didSet {
            treeButton.isEnabled = userIsLoggedIn
            logInOutButton.title = userIsLoggedIn ? "Log Out" : "Log In"
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

    private func login() {
        guard let phoneProvider = phoneProvider else {
            return
        }
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
        guard let authUI = FUIAuth.defaultAuthUI() else {
            return
        }
        authUI.isSignInWithEmailHidden = true
        authUI.delegate = self
        let phoneProvider = FUIPhoneAuth(authUI: authUI)
        authUI.providers = [phoneProvider]
        self.phoneProvider = phoneProvider
    }

    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}

