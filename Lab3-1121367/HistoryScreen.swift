//
//  HistoryScreen.swift
//  Lab3-1121367
//
//  Created by Sameer Shaligram on 2023-04-21.
//

import UIKit

class HistoryScreen: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var path: Int = 0
    
    private var items: [error] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        loadDefaultItems()
    }
    
    private func loadDefaultItems(){
        items.append(error(title: 2008, subtitle: "API key has been disabled.", icon: UIImage(systemName: "key")!))
                     items.append(error(title: 1006, subtitle: "No matching location found.", icon: UIImage(systemName: "magnifyingglass")!))

    }
    
    
    @IBAction func deleteButton(_ sender: UIBarButtonItem) {
        
    }
    
}

extension HistoryScreen: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "errorCell", for: indexPath)
        
        let item = items[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        
        content.text = "\(item.title)"
        content.secondaryText = item.subtitle
        content.image = item.icon
        
        cell.contentConfiguration = content

        
        return cell
    }
}

extension HistoryScreen: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        path = indexPath.row
    }
    
    private func removeItem(at indexPath: IndexPath){
        items.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    
}

struct error{
    let title: Int
    let subtitle: String
    let icon: UIImage
}
