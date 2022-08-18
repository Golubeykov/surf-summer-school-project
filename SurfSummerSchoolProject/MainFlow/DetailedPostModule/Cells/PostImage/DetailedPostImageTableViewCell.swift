//
//  DetailedPostImageTableViewCell.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 06.08.2022.
//

import UIKit

class DetailedPostImageTableViewCell: UITableViewCell {
    //MARK: - Constants
    private enum Constants {
        static let favoriteTapped = UIImage(named: "favoriteTapped")
        static let favoriteUntapped = UIImage(named: "favoriteUntapped")
    }
    let favoritesStorage = FavoritesStorage.shared
    var postTextLabel: String = ""
    
    //MARK: - Views
    @IBOutlet private weak var detailedPostImageView: UIImageView!
    @IBOutlet private weak var favoriteButtonLabel: UIButton!
    
    
    //MARK: - Events // Реализуется позже
    var didFavoriteTap: (() -> Void)?
    @IBAction func favoriteButtonAction(_ sender: Any) {        
        didFavoriteTap?()
    }
    
    //MARK: - Calculated
    var buttonImage: UIImage? {
        return isFavorite ? Constants.favoriteTapped : Constants.favoriteUntapped
    }
    
    //MARK: - Properties
    var imageUrlInString: String = "" {
        didSet {
            guard let url = URL(string: imageUrlInString) else {
                 return
             }
             detailedPostImageView?.loadImage(from: url)
        }
    }
    var isFavorite = false {
        didSet {
            favoriteButtonLabel.setImage(buttonImage, for: .normal)
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
