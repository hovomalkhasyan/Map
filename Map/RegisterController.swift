//
//  RegisterController.swift
//  Map
//
//  Created by Hovo on 8/4/20.
//  Copyright © 2020 Hovo. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {
    var signUp:Bool = true {
        willSet {
            if newValue{
                tintlabel.text = "Регистрация"
                nameField.isHidden = false
                enterButton.setTitle("Вход", for: .normal)
            }else{
                tintlabel.text = "Вход"
                nameField.isHidden = true
                 enterButton.setTitle("Регистрация", for: .normal)
            }
        }
    }
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var tintlabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func enterButton(_ sender: UIButton) {
        signUp = !signUp
    }
}
