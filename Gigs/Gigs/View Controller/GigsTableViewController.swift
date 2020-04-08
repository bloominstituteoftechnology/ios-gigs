//
//  GigsTableViewController.swift
//  Gigs
//
//  Created by Nichole Davidson on 4/7/20.
//  Copyright © 2020 Nichole Davidson. All rights reserved.
//

import UIKit

final class GigsTableViewController: UITableViewController {
    
    enum CellIdentifier: String {
        case gigCell = "GigCell"
    }
    
       // MARK: - Properties
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var gigController = GigController()
    private lazy var viewModel = GigsViewModel()
    private lazy var dataSource = makeDataSource()
    
     // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewModel.shouldPresentLoginViewController {
            performSegue(withIdentifier: LoginViewController.identifier, sender: self)
        }
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: animated)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = segue.destination as? GigDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow
            else { return }
        
        let gigName = viewModel.gigNames[indexPath.row]
        controller.gigName = gigName
    }
}

// MARK: - UITableViewDiffableDataSource

extension GigsTableViewController {
    enum Section {
        case main
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Section, String> {
        UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, name in
            let cell = tableView
                .dequeueReusableCell(withIdentifier: CellIdentifier.gigCell.rawValue,
                                     for: indexPath)
            
            cell.textLabel?.text = name
            return cell
        }
    }
    
    private func update() {
        activityIndicator.stopAnimating()
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        dataSource.apply(snapshot, animatingDifferences: false)
        snapshot.appendItems(viewModel.gigNames)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

