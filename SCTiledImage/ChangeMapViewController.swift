//
//  ChangeMapViewController.swift
//  SCTiledImage
//
//  Created by urt-macmini-2019 on 04/10/2022.
//  Copyright © 2022 siclo. All rights reserved.
//

import UIKit

class ChangeMapViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView = UITableView()
    var items = [URL]()
    var selectedIndex = IndexPath(row: -1, section: 0)
    
    var callback : ((String)->())?
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        if selectedIndex.row >= 0 {
            callback?(items[selectedIndex.row].lastPathComponent)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        let manager = FileManager.default
        guard let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        print(url)
        
        do {
            items = try manager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options:[])
            var dir:String = ""
            for item in items {
                print("found \(item)")
                dir = item.lastPathComponent
                print(dir)
            }
        } catch {
            print(error)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].lastPathComponent
        if selectedIndex == indexPath {
            cell.backgroundColor = UIColor.gray
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexesToRedraw = [indexPath]
        selectedIndex = indexPath
        
        tableView.deselectRow(at: indexPath, animated: true)
        print("cell")
        tableView.reloadRows(at: indexesToRedraw, with: .fade)
    }
}
