//
//  LoginViewController.swift
//  DailyStock
//
//  Created by 김정민 on 2021/12/18.
//
//
import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {


    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    @IBOutlet var appleLoginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        [googleLoginButton,appleLoginButton].forEach{
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.white.cgColor
            $0?.layer.cornerRadius = 30
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //Google Sign In
        GIDSignIn.sharedInstance().presentingViewController = self

    }


    @IBAction func googleLoginButtonTapped(_ sender: UIButton) {
        // TODO: Firebase 인증
        GIDSignIn.sharedInstance().signIn()

    }



    @IBAction func appleLoginButtonTapped(_ sender: UIButton) {
        // TODO: Firebase 인증
    }



}
