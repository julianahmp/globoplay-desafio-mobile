//
//  MediaDetailsUIView.swift
//  DesafioGloboPlay
//
//  Created by Juliana Marchl on 16/11/24.
//

import UIKit

class MediaDetailsUIView: UIView {

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.technicalSheet
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        setupNotificationCenter()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI(_:)), name: .didUpdateModel, object: nil)
    }
    
    @objc private func updateUI(_ notification: Notification) {
        guard let model = notification.object as? Media else { return }

        let attributedText = NSMutableAttributedString()
        let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 10

        /// Título Original
        let originalTitle = NSAttributedString(
            string: Constants.originalTitle,
            attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.lightGray]
        )
        let originalTitleValue = NSAttributedString(
            string: "\(model.original_name ?? Constants.emptyString)\n",
            attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.lightGray]
        )
        attributedText.append(originalTitle)
        attributedText.append(originalTitleValue)

        /// Tipo de Mídia
        let mediaTypeTitle = NSAttributedString(
            string: Constants.mediaType,
            attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.lightGray]
        )
        let mediaTypeValue = NSAttributedString(
            string: "\(model.media_type ?? Constants.emptyString)\n".capitalizeFirstLetter(),
            attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.lightGray]
        )
        attributedText.append(mediaTypeTitle)
        attributedText.append(mediaTypeValue)

        /// Idioma Original
        let originalLanguageTitle = NSAttributedString(
            string: Constants.originalLanguage,
            attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.lightGray]
        )
        let originalLanguageValue = NSAttributedString(
            string: "\(model.original_language ?? Constants.emptyString)\n".uppercased(),
            attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.lightGray]
        )
        attributedText.append(originalLanguageTitle)
        attributedText.append(originalLanguageValue)
        
        /// Sinopse
        let overviewTitle = NSAttributedString(
            string: Constants.overview,
            attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.lightGray]
        )
        let overviewValue = NSAttributedString(
            string: "\(model.overview ?? Constants.emptyString)\n",
            attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.lightGray]
        )
        attributedText.append(overviewTitle)
        attributedText.append(overviewValue)

        descriptionLabel.attributedText = attributedText
    }

    private func setupConstraints() {
        let containerViewConstraints = [
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor)
        ]
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ]
        
        let descriptionLabelConstraints = [
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(containerViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(descriptionLabelConstraints)
    }
}
