//
//  UniversityListViewController.swift
//  UniversityFinder
//
//  Created by bilal awan on 21/09/2024.
//

import UIKit

import UIKit

class UniversityListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultsLabel: UILabel!
    var countryName: String = ""
    private var universityListViewModel = UniversityListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Universities in \(countryName)"
        self.navigationController?.navigationBar.tintColor = Constants.APP_COLOR
        setupTableView()
        fetchUniversities()
    }

    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 345
    }
    
    private func reloadTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    private func fetchUniversities() {
        LoadingIndicator.shared.showLoading(on: self.view)
        universityListViewModel.fetchUniversities(for: countryName) { [weak self] error in
            DispatchQueue.main.async {
                LoadingIndicator.shared.hideLoading()
                if let error = error {
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                } else {
                    self?.reloadTableView()
                }
            }
        }
    }

    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

extension UniversityListViewController: UITableViewDelegate, UITableViewDataSource, UniversityCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if universityListViewModel.universities.count == 0 {
            noResultsLabel.isHidden = false
        }
        return universityListViewModel.universities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UniversityCell", for: indexPath) as? UniversityCell else {
            return UITableViewCell()
        }

        let universityVM = universityListViewModel.universities[indexPath.row]
        cell.delegate = self
        cell.configure(with: universityVM)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func didTapWebsite(url: URL) {
        UIApplication.shared.open(url)
    }
}

