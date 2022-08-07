//
//  DetailedPostBodyShortedTableViewCell.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 07.08.2022.
//

import UIKit

class DetailedPostBodyShortedTableViewCell: UITableViewCell {
//MARK: - Views
    @IBOutlet weak var bodyTextShorted: UILabel!
    //MARK: - Properties
    var bodyText: String = "" {
        didSet {
            bodyTextShorted.text = bodyText
        }
    }
    //MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        configureApperance()
    }
    private func configureApperance() {
        selectionStyle = .none
        bodyTextShorted.font = .systemFont(ofSize: 12, weight: .light)
        bodyTextShorted.textColor = .black
    }
    
}
