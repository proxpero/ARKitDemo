import UIKit
import Firebase
import FirebasePhoneAuthUI

class PhoneSignInViewController: UIViewController, FUIAuthDelegate {

    var handle: AuthStateDidChangeListenerHandle?

    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        pushARVC()
    }



    func login() {
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.isSignInWithEmailHidden = true
        let phoneProvider = FUIPhoneAuth(authUI: authUI!)
        authUI?.delegate = self
        authUI?.providers = [phoneProvider]
        phoneProvider.signIn(withPresenting: self, phoneNumber: nil)
    }

    func pushARVC() {
        guard let arvc = storyboard?.instantiateViewController(withIdentifier: "ARViewControllerId") else { fatalError() }
        present(arvc, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLoggedIn()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        checkLoggedIn()
    }

    func checkLoggedIn() {
        if handle != nil {
            self.login()
        } else {
            handle = Auth.auth().addStateDidChangeListener { auth, user in
                if user != nil {
                    self.pushARVC()
                } else {
                    self.login()
                }
            }
        }
    }

}

