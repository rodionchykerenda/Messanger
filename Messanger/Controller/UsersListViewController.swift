//
//  UsersListViewController.swift
//  Messanger
//
//  Created by Rodion on 3/21/19.
//  Copyright © 2019 Rodion. All rights reserved.
//

import UIKit
import MessageKit

class UsersListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var chatService: ChatService?
    var isDarkModeOn: Bool = false
    
    private var dataSource: [User] = []{
        didSet{
            tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupObservers()
        setupDataSource()
        setupViewMode()
    }
    
    //MARK: - Setup methods
    func setupDelegates(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(updateUsersList), name: .NewUserJoinedChat, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateUsersList), name: .UserLeftChat, object: nil)
    }
    
    func setupDataSource(){
        dataSource = chatService?.getCurrentUsers() ?? []
    }
    
    func setupViewMode(){
        if isDarkModeOn{
            darkModeUI()
        } else {
            lightModeUI()
        }
    }
    
    //Interface view methods
    private func darkModeUI(){
        tableView.backgroundColor = #colorLiteral(red: 0.1067128852, green: 0.1615819931, blue: 0.265824914, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1316523552, green: 0.2483583391, blue: 0.4827849269, alpha: 1)
        self.navigationController?.navigationBar.barStyle = .black
    }
    
    private func lightModeUI(){
        tableView.backgroundColor = nil
        self.navigationController?.navigationBar.barTintColor = nil
        self.navigationController?.navigationBar.barStyle = .default
    }

}

//MARK: - Table view configuration
extension UsersListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserTableViewCell else {
            fatalError("Error: Cell doesn`t exist")
        }
        if isDarkModeOn {
            cell.textLabelColor = UIColor.white
        } else {
            cell.textLabelColor = UIColor.black
        }
        cell.updateCell(user: dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = tableView.backgroundColor
    }
    
}

//MARK: - Notifications
extension UsersListViewController{
    
    @objc private func updateUsersList(){
        setupDataSource()
    }
    
}
