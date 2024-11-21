//
//  MediaHeaderUIView.swift
//  DesafioGloboPlay
//
//  Created by Juliana Marchl on 16/11/24.
//

import UIKit
import SDWebImage

class MediaHeaderUIView: UIView {
    
    var navigationTitle: String?
    
    private let viewModel = MediaViewModel()
    
    let headerImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let labelContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let playButtonContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let favoritesButtonContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.customGray,
            .font: UIFont.boldSystemFont(ofSize: 16)
        ]
        let attributedTitle = NSAttributedString(string: Constants.watch, attributes: attributes)
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.layer.backgroundColor = UIColor.white.cgColor
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
    
    let favoritesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.backgroundColor = UIColor.clear.cgColor
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        setupButtons()
        setupNotificationCenter()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(headerImageView)
        addSubview(labelContainerView)
        addSubview(playButtonContainerView)
        addSubview(favoritesButtonContainerView)
        labelContainerView.addSubview(titleLabel)
        labelContainerView.addSubview(subtitleLabel)
        labelContainerView.addSubview(descriptionLabel)
        playButtonContainerView.addSubview(playButton)
        favoritesButtonContainerView.addSubview(favoritesButton)
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI(_:)), name: .didUpdateModel, object: nil)
    }
    
    private func setupButtons() {
        playButton.addTarget(self, action: #selector(handlePlayButtonTap), for: .touchUpInside)
        favoritesButton.addTarget(self, action: #selector(handleFavoritesButtonTap), for: .touchUpInside)
    }
    
    @objc private func handlePlayButtonTap() {
        print("Play!")
    }

    @objc private func handleFavoritesButtonTap() {
        let isAdding = (favoritesButton.currentAttributedTitle?.string == Constants.addToList)
        
        viewModel.toggleFavoritesState(isAdding: isAdding)

        updateFavoritesButtonTitle(viewModel.favoritesButtonTitle ?? Constants.addToList)
    }
    
    func updateFavoritesButtonTitle(_ title: String) {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 16)
        ]
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        favoritesButton.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    @objc private func updateUI(_ notification: Notification) {
        guard let model = notification.object as? Media, let posterPath = model.poster_path, let mediaType = model.media_type else { return }
        headerImageView.sd_setImage(with: URL(string: Constants.imgUrl + posterPath))
        titleLabel.text = model.name
        subtitleLabel.text = mediaType.capitalizeFirstLetter()
        descriptionLabel.text = model.overview
        updateFavoritesButtonTitle(UserDefaultsManager.shared.getFavoritesButtonStateForTitle(forID: model.id))
        navigationTitle = model.name
    }
    
    private func setupConstraints() {
        let headerViewImageConstraints = [
            headerImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            headerImageView.heightAnchor.constraint(equalToConstant: 220),
            headerImageView.topAnchor.constraint(equalTo: topAnchor),
            headerImageView.bottomAnchor.constraint(equalTo: labelContainerView.topAnchor, constant: -20),
        ]
        
        let labelsContainerConstraints = [
            labelContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            labelContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            labelContainerView.bottomAnchor.constraint(equalTo: playButtonContainerView.topAnchor, constant: -15),
        ]

        let buttonsContainerViewConstraints = [
            playButtonContainerView.widthAnchor.constraint(equalTo: favoritesButtonContainerView.widthAnchor),
            playButtonContainerView.heightAnchor.constraint(equalTo: favoritesButtonContainerView.heightAnchor),
            playButtonContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            playButtonContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            favoritesButtonContainerView.heightAnchor.constraint(equalToConstant: 70),
            favoritesButtonContainerView.leadingAnchor.constraint(equalTo: playButtonContainerView.trailingAnchor, constant: 10),
            favoritesButtonContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            favoritesButtonContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
        ]
        
        let playButtonConstraints = [
            playButton.widthAnchor.constraint(equalTo: playButtonContainerView.widthAnchor),
            playButton.heightAnchor.constraint(equalTo: playButtonContainerView.heightAnchor),
            ]
        
        let favoritesButtonConstraints = [
            favoritesButton.widthAnchor.constraint(equalTo: favoritesButtonContainerView.widthAnchor),
            favoritesButton.heightAnchor.constraint(equalTo: favoritesButtonContainerView.heightAnchor),
            ]
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: labelContainerView.topAnchor, constant: 10),
             titleLabel.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor, constant: 10),
             titleLabel.trailingAnchor.constraint(equalTo: labelContainerView.trailingAnchor, constant: -10),
        ]
        
        let subtitleLabelConstraints = [
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor, constant: 10),
            subtitleLabel.trailingAnchor.constraint(equalTo: labelContainerView.trailingAnchor, constant: -10),
        ]
        
        let descriptionLabelConstraints = [
            descriptionLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: labelContainerView.trailingAnchor, constant: -10),
            descriptionLabel.bottomAnchor.constraint(equalTo: labelContainerView.bottomAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(headerViewImageConstraints)
        NSLayoutConstraint.activate(labelsContainerConstraints)
        NSLayoutConstraint.activate(buttonsContainerViewConstraints)
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(favoritesButtonConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(subtitleLabelConstraints)
        NSLayoutConstraint.activate(descriptionLabelConstraints)
    }
}

