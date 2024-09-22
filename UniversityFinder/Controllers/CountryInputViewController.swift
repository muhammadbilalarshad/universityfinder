//
//  CountryInputViewController.swift
//  UniversityFinder
//
//  Created by bilal awan on 21/09/2024.
//

import UIKit

class CountryInputViewController: UIViewController {
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "University Finder"
        setupUI()
    }

    private func setupUI() {
        searchButton.layer.cornerRadius = 8
    }

    @IBAction func searchButtonTapped(_ sender: UIButton) {
        guard let countryName = countryTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !countryName.isEmpty else {
            showAlert(title: "Error", message: "Please enter a country name.")
            return
        }
        performSegue(withIdentifier: "showUniversityList", sender: countryName)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUniversityList",
           let destinationVC = segue.destination as? UniversityListViewController,
           let countryName = sender as? String {
            destinationVC.countryName = countryName
        }
    }

    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
