//
//  SnackbarView.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 16.08.2022.
//

import UIKit

class SnackbarView: UIView {
    //MARK: - Constants
    private let whiteColor = ColorsStorage.white
    
    //MARK: - Private properties
    private let model: SnackbarModel
    private let viewController: UIViewController
    private let viewForSwipeRecognizer = UIView()
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = ColorsStorage.white
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    private var snackbarWasSwiped = false
    
    //MARK: - Calculated properties
    var width: CGFloat { viewController.view.frame.size.width }
    var height: CGFloat { viewController.view.frame.size.width/4 }
    var initialFrame: CGRect { CGRect(x: 0, y: -height, width: width, height: height) }
    var movedFrame: CGRect { CGRect(x: 0, y: -height/2, width: width, height: height) }
    
    //MARK: - Init
    init(model: SnackbarModel, viewController: UIViewController) {
        self.model = model
        self.viewController = viewController
        super.init(frame: .zero)
        
        addSubview(label)
        viewController.view.addSubview(viewForSwipeRecognizer)
        
        backgroundColor = ColorsStorage.red
        clipsToBounds = true
        
        configureTextLabel()
        configureViewForSwipeRecognizer()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 16, y: bounds.height/2, width: bounds.width-32, height: bounds.height/2)
        viewForSwipeRecognizer.frame = CGRect(x: 0, y: -height/2, width: width, height: height+100)
    }
    
    //MARK: - Private methods
    private func configureTextLabel() {
        label.text = model.text
    }
    private func configureViewForSwipeRecognizer() {
        viewForSwipeRecognizer.backgroundColor = ColorsStorage.clear
    }
    
    func showSnackBar() {
        addSwipeGesture()
        snackbarWasSwiped = false
        //стартовая позиция
        self.frame = initialFrame
        viewController.navigationController?.navigationBar.addSubview(self)
        //анимация выезда шторки вниз
        UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction] , animations: {
            self.frame = self.movedFrame
        }, completion: { done in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    if !self.snackbarWasSwiped {
                    UIView.animate(withDuration: 0.3, delay: 0, animations: {
                        self.frame = self.initialFrame
                    }, completion: {done in
                        if done {
                            self.removeFromSuperview()
                        }
                    })
                }
                }
            }
        }
        )
        
    }
    func addSwipeGesture() {
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeUpSnackBar))
        swipeUpGesture.direction = .up
        viewForSwipeRecognizer.addGestureRecognizer(swipeUpGesture)
        viewForSwipeRecognizer.isUserInteractionEnabled = true
    }
    @objc func swipeUpSnackBar() {
        print("swipe")
        snackbarWasSwiped = true
        UIView.animate(withDuration: 0.3, delay: 0, animations: {
            self.frame = self.initialFrame
        }, completion: { done in
            if done {
                self.removeFromSuperview()
                self.viewForSwipeRecognizer.removeFromSuperview()
            }
        })
    }
}
