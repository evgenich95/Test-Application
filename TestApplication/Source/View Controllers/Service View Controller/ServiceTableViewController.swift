//
//  ServiceTableViewController.swift
//  TestApplication
//
//  Created by developer on 18.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class ServiceTableViewController: UITableViewController {

    var quotes: [Quote]?

    struct KeysForCell {
        static let serviceCell = "ServiceTableViewCell"
    }

    init() {
        super.init(nibName: "ServiceTableViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Service"

        configureTableView()
        getRequest()
    }

    func getRequest() {
        self.startActivityIndicator(withText: "Loading data of chat")
        WebService.getQuotes() { response, error in
            if let error = error {
                self.stopActivityIndicator()
                self.handleError(
                    error,
                    retryAction: self.getRequest,
                    cancelAction: {
                        self.navigationController?.popViewControllerAnimated(true)
                })
                return
            }
            if let response = response {
                self.quotes = response
                self.tableView.reloadData()
                self.stopActivityIndicator(true)
            }
        }
    }

    private func configureTableView() {
        tableView.registerNib(
            UINib(nibName: KeysForCell.serviceCell, bundle: nil),
            forCellReuseIdentifier: KeysForCell.serviceCell
        )
        view.backgroundColor = UIColor.whiteColor()
        edgesForExtendedLayout = UIRectEdge.None
        navigationController?.navigationBar.translucent = false
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 88
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        guard let cell = (tableView.dequeueReusableCellWithIdentifier(KeysForCell.serviceCell,
            forIndexPath: indexPath)) as? ServiceTableViewCell else {
                fatalError("Cell \(KeysForCell.serviceCell).xib is not registered")
        }

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy, hh:mm"

        if let quote = quotes?[indexPath.row] {
            cell.dateLabel.text = dateFormatter.stringFromDate(quote.date)
            cell.textQuoteLabel.text = quote.text
        }

        return cell
    }

    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}
