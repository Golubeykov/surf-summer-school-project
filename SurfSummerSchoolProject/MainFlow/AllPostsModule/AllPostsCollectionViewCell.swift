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
    @IBOutlet private weak var favoritePostButtonLabel: UIButton!
    
    
    //MARK: - Events
    var didFavoriteTap: (() -> Void)?
    
    //MARK: - Calculated
    var buttonImage: UIImage? {
        return isFavorite ? Constants.favoriteTapped : Constants.favoriteUntapped
    }
    
    //MARK: - Properties
    var titleText: String = "Test" {
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
            favoritePostButtonLabel.setImage(buttonImage, for: .normal)
        }
    }
    
    //MARK: - Action
    @IBAction func favoritePostButtonAction(_ sender: UIButton) {
        didFavoriteTap?()
        isFavorite.toggle()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
    }
}

//MARK: - Private methods
private extension AllPostsCollectionViewCell {
    func configureCell() {
        postTextLabel.textColor = .black
        postTextLabel.font = .systemFont(ofSize: 12)
        
        postImageView.layer.cornerRadius = 12
        
        favoritePostButtonLabel.tintColor = .white
        isFavorite = false
    }
}

