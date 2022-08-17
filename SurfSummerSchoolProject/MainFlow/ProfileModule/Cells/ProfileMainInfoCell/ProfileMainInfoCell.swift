//
//  ProfileMainInfoCell.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 17.08.2022.
//

import UIKit

class ProfileMainInfoCell: UITableViewCell {
    //MARK: - Views
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileFirstNameLabel: UILabel!
    @IBOutlet weak var profileLastNameLabel: UILabel!
    @IBOutlet weak var profileQuoteLabel: UILabel!
    
    //MARK: - Properties
    var imageUrlInString: String = "" {
        didSet {
            guard let url = URL(string: imageUrlInString) else {
                 return
             }
            profileImageView.loadImage(from: url)
        }
    }
    //MARK: - Cell's lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        profileImageView.layer.cornerRadius = 12
    }
}
