//
//  HomeController.swift
//  CreateFirebaseUser
//
//  Created by David Garcia on 7/12/19.
//  Copyright © 2019 David Garcia. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController {
    
    // MARK: - Properties
    
    var welcomeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        return label
    }()
    

    // MARCA: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUserAndConfigureView()
    }
    
   
    // MARCA: - Selectores
    
    @objc func handleSignOut() {
        let alertController = UIAlertController(title: nil, message: "¿Estás seguro de que quieres cerrar sesión??", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "cerrar sesion", style: .destructive, handler: { (_) in
            self.signOut()
        }))
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    

    // MARCA: - API
    
  
    
    func loadUserData() {
          guard let uid = Auth.auth().currentUser?.uid else { return }
          Database.database().reference().child("users").child(uid).child("username").observeSingleEvent(of: .value) { (snapshot) in
              guard let username = snapshot.value as? String else { return }
              self.welcomeLabel.text = "Welcome, \(username)"
              
              UIView.animate(withDuration: 0.5, animations: {
                  self.welcomeLabel.alpha = 1
              })
          }
      }
    
    
    
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            let navController = UINavigationController(rootViewController: LoginController())
            navController.navigationBar.barStyle = .black
            self.present(navController, animated: true, completion: nil)
        } catch let error {
            print("Error al cerrar sesión ..", error)
        }
    }
    
    func authenticateUserAndConfigureView() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let navController = UINavigationController(rootViewController: LoginController())
                navController.navigationBar.barStyle = .black
                self.present(navController, animated: true, completion: nil)
            }
        } else {
            configureViewComponents()
            loadUserData()
        }
    }
    

    // MARCA: - Funciones de ayuda
    
    func configureViewComponents() {
        view.backgroundColor = UIColor.mainBlue()
        
        navigationItem.title = "Social Login David G"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_arrow_back_white_24dp"), style: .plain, target: self, action: #selector(handleSignOut))
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationController?.navigationBar.barTintColor = UIColor.mainBlue()
        
        view.addSubview(welcomeLabel)
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
}
