//
//  UniversityCell.swift
//  UniversityFinder
//
//  Created by bilal awan on 21/09/2024.
//

import UIKit
import MapKit

protocol UniversityCellDelegate: AnyObject {
    func didTapWebsite(url: URL)
}

class UniversityCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var domainsLabel: UILabel!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var webPagesTextView: UITextView!
    @IBOutlet weak var stateProvinceLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detailViewHeight: NSLayoutConstraint!
    
    weak var delegate: UniversityCellDelegate?
    private var universityViewModel: UniversityViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        detailsView.isHidden = true
        webPagesTextView.isEditable = false
        webPagesTextView.delegate = self
        webPagesTextView.textContainerInset = UIEdgeInsets.zero
        webPagesTextView.textContainer.lineFragmentPadding = 0
    }

    func configure(with viewModel: UniversityViewModel) {
        self.universityViewModel = viewModel
        nameLabel.text = viewModel.name
        detailsView.isHidden = !viewModel.isExpanded
        let buttonTitle = viewModel.isExpanded ? "-" : "+"
        expandButton.setTitle(buttonTitle, for: .normal)

        if viewModel.isExpanded {
            detailViewHeight.constant = 293
            domainsLabel.text = viewModel.domains
            countryCodeLabel.text = viewModel.countryCode
            setWebPagesTextView(with: viewModel.webPages) // Update the method to handle attributed text
            stateProvinceLabel.text = viewModel.stateProvince
            countryLabel.text = viewModel.country

            if let coordinate = viewModel.coordinate {
                updateMap(with: coordinate)
            } else {
                viewModel.fetchCoordinates { [weak self] error in
                    if let coordinate = viewModel.coordinate {
                        DispatchQueue.main.async {
                            self?.updateMap(with: coordinate)
                        }
                    }
                }
            }
        } else {
            detailViewHeight.constant = 0
        }
    }

    private func setWebPagesTextView(with webPages: [String]) {
        let attributedString = NSMutableAttributedString()
        let linkAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.red,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        for webPage in webPages {
            if let url = URL(string: webPage) {
                let attributedLink = NSMutableAttributedString(string: webPage, attributes: linkAttributes)
                attributedLink.addAttribute(.link, value: url, range: NSRange(location: 0, length: webPage.count))
                attributedString.append(attributedLink)
                attributedString.append(NSAttributedString(string: "\n")) // Add a line break
            }
        }
        
        webPagesTextView.attributedText = attributedString
    }

    private func updateMap(with coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 50000, longitudinalMeters: 50000)
        mapView.setRegion(region, animated: false)
    }

    @IBAction func expandButtonTapped(_ sender: UIButton) {
        universityViewModel?.isExpanded.toggle()
        if let viewModel = universityViewModel {
            configure(with: viewModel)
            
            if let tableView = self.parentTableView() {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }
    }
}

extension UniversityCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        delegate?.didTapWebsite(url: URL)
        return false
    }
}

extension UIView {
    func parentTableView() -> UITableView? {
        var view = self.superview
        while let v = view {
            if let tableView = v as? UITableView {
                return tableView
            }
            view = v.superview
        }
        return nil
    }
}
