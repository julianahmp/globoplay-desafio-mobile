//
//  HomeUIView.swift
//  DesafioGloboPlay
//
//  Created by Juliana Marchl on 21/11/24.
//

import UIKit

class HomeUIView: UIView {

    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(HomeMediaTableViewCell.self, forCellReuseIdentifier: Constants.homeMediaTableViewCellIdentifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor.customGray
            } else {
                return UIColor.white
            }
        }
        table.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        return table
    }()
    
    let searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        return search
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
