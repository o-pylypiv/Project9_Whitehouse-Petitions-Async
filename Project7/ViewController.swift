//
//  ViewController.swift
//  Project7
//
//  Created by Olha Pylypiv on 23.01.2024.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        downloadData(from: urlString)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showCredits))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterPetitions))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        // petitions[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
            //print(filteredPetitions)
        }
    }
    
    func showError() {
        DispatchQueue.main.async {
            [weak self] in
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(ac, animated: true)
        }
    }

    func downloadData(from url: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            guard let url = URL(string: url) else { return }

            Task {
                let dataLoader = DataLoader()
                let receviedData = await dataLoader.downloadData(url: url)
                if let data = receviedData {
                    self?.parse(json: data)
                } else {
                    self?.showError()
                }
            }
        }
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits here", message: "The data comes from the We The People API of the Whitehouse.", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func filterPetitions() {
        
        let ac = UIAlertController(title: "Search petition", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let searchAction = UIAlertAction(title: "Search", style: .default) {
            [weak self, weak ac] action in
            guard let searchPrompt = ac?.textFields?[0].text else {return}
            self?.searchPetition(searchPrompt)
        }
        ac.addAction(searchAction)
        present(ac, animated: true)
    }
   
    func searchPetition(_ searchPrompt: String) {
        filteredPetitions.removeAll()
        for petition in petitions {
            if petition.title.lowercased().contains(searchPrompt.lowercased()) || petition.body.lowercased().contains(searchPrompt.lowercased()) {
                filteredPetitions.append(petition)
            }
        }
        //print(filteredPetitions)
        //petitions = filteredPetitions
        tableView.reloadData()
    }

}
