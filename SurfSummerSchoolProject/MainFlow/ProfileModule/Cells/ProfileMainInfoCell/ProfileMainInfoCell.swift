//
//  ProfileMainInfoCell.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 17.08.2022.
//

import UIKit

class ProfileMainInfoCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileFirstNameLabel: UILabel!
    @IBOutlet weak var profileLastNameLabel: UILabel!
    @IBOutlet weak var profileQuoteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        profileImageView.layer.cornerRadius = 12
    }
}
