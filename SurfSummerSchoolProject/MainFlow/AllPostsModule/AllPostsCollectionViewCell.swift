//
//  AllPostsCollectionViewCell.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 05.08.2022.
//

import UIKit

class AllPostsCollectionViewCell: UICollectionViewCell {
//MARK: - Constants
    private enum Constants {
        static let favoriteTapped = UIImage(named: "favoriteTapped")
        static let favoriteUntapped = UIImage(named: "favoriteUntapped")
    }

//MARK: - Views
    @IBOutlet private weak var postImageView: UIImageView!
    @IBOutlet private weak var postTextLabel: UILabel!
    @IBOutlet weak var favoritePostButtonLabel: UIButton!

//MARK: - Properties
    var titleText: String = "" {
        didSet {
            postTextLabel.text = titleText
        }
    }
    var image: UIImage? {
        didSet {
            postImageView.image = image
        }
    }
    var isFavorite = false {
        didSet {
            let image = isFavorite ? Constants.favoriteTapped : Constants.favoriteUntapped
            favoritePostButtonLabel.setImage(image, for: .normal)
        }
    }
    
//MARK: - Action
    @IBAction func favoritePostButtonAction(_ sender: Any) {
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

//MARK: - Private methods
private extension AllPostsCollectionViewCell {
    func configureCell() {
        postTextLabel.textColor = .black
        postTextLabel.font = .systemFont(ofSize: 12)
        
        postImageView.layer.cornerRadius = 12
        
        favoritePostButtonLabel.tintColor = .white
    }
}

