//
//  HomeViewController.swift
//  DesafioGloboPlay
//
//  Created by Juliana Marchl on 14/11/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewModel()
    
    private let homeUIView = HomeUIView()
    
    override func loadView() {
        view = homeUIView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        homeUIView.tableView.delegate = self
        homeUIView.tableView.dataSource = self
        
        setupHomeNavigationBar()
    }
    
    func setupHomeNavigationBar() {
        let appearance = UINavigationBarAppearance()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor { traitCollection in
                if traitCollection.userInterfaceStyle == .dark {
                    return UIColor.white
                } else {
                    return UIColor.black
                }
            },
            .font: UIFont.systemFont(ofSize: 28, weight: .bold)
        ]
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = attributes
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.title = Constants.globoplay
        navigationItem.backButtonTitle = Constants.emptyString
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeUIView.tableView.frame = view.bounds
    }
    
    private func fetchData(for cell: HomeMediaTableViewCell, at indexPath: IndexPath) -> UITableViewCell {
        guard let section = Sections(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        viewModel.fetchData(for: section) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let mediaItems):
                    cell.configure(with: mediaItems)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        return cell
    }
    
    @objc private func handleBackButton() {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - UITableView

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.sectionTitles.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.homeMediaTableViewCellIdentifier, for: indexPath) as? HomeMediaTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        
        return fetchData(for: cell, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Constants.sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        header.textLabel?.textColor = UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor.white
            } else {
                return UIColor.black
            }
        }
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
}

// MARK: - CollectionViewTableViewCellDelegate

extension HomeViewController: HomeMediaTableViewCellDelegate {
    func didTapCell(_ cell: HomeMediaTableViewCell, model: Media) {
        DispatchQueue.main.async { [weak self] in
            let vc = MediaViewController()
            vc.configure(with: model)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
