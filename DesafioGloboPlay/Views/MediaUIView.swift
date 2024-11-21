//
//  MediaUIView.swift
//  DesafioGloboPlay
//
//  Created by Juliana Marchl on 20/11/24.
//

import UIKit

class MediaUIView: UIView {
    
    let backgroundBlurredImageView: UIImageView = {
        let imageView = UIImageView(frame: UIScreen.main.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = imageView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.addSubview(blurEffectView)
        
        return imageView
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let headerContainerView: MediaHeaderUIView = {
        let headerContainerView = MediaHeaderUIView()
        headerContainerView.translatesAutoresizingMaskIntoConstraints = false
        return headerContainerView
    }()
    
    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [Constants.watchToo.uppercased(), Constants.details.uppercased()])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    let detailsContainerView: MediaDetailsUIView = {
        let detailsContainerView = MediaDetailsUIView()
        detailsContainerView.translatesAutoresizingMaskIntoConstraints = false
        return detailsContainerView
    }()
    
    let alsoWatchCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 160)
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: Constants.mediaCollectionViewCellIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollView.contentSize = CGSize(width: alsoWatchCollectionView.frame.width, height: alsoWatchCollectionView.frame.height)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(backgroundBlurredImageView)
        addSubview(scrollView)

        scrollView.addSubview(contentView)
        contentView.addSubview(headerContainerView)
        contentView.addSubview(segmentedControl)
        contentView.addSubview(detailsContainerView)
        contentView.addSubview(alsoWatchCollectionView)
        
        detailsContainerView.isHidden = true
        alsoWatchCollectionView.isHidden = false
    }
    
    private func setupConstraints() {
        let scrollViewConstraints = [
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        let contentViewConstraints = [
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ]
        
        let headerContainerViewConstraints = [
            headerContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ]
        
        let segmentedControlConstraints = [
            segmentedControl.topAnchor.constraint(equalTo: headerContainerView.bottomAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        let alsoWatchCollectionViewConstraints = [
            alsoWatchCollectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            alsoWatchCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            alsoWatchCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            alsoWatchCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            alsoWatchCollectionView.heightAnchor.constraint(equalToConstant: 380),
        ]
        
        let detailsContainerViewConstraints = [
            detailsContainerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            detailsContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            detailsContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            detailsContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(scrollViewConstraints)
        NSLayoutConstraint.activate(contentViewConstraints)
        NSLayoutConstraint.activate(headerContainerViewConstraints)
        NSLayoutConstraint.activate(segmentedControlConstraints)
        NSLayoutConstraint.activate(alsoWatchCollectionViewConstraints)
        NSLayoutConstraint.activate(detailsContainerViewConstraints)
    }
}

