//
//  DetailedPostImageTableViewCell.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 06.08.2022.
//

import UIKit

class DetailedPostImageTableViewCell: UITableViewCell {
    //MARK: - Views
    @IBOutlet private weak var detailedPostImageView: UIImageView!
    
    //MARK: - Properties
    var image: UIImage? {
        didSet {
            detailedPostImageView.image = image
        }
    }
    
    //MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        detailedPostImageView.layer.cornerRadius = 12
        detailedPostImageView.contentMode = .scaleAspectFill
    }
}
