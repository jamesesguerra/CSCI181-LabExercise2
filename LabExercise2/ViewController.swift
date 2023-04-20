//
//  ViewController.swift
//  LabExercise2
//
//  Created by James Esguerra on 3/19/23.
//

import UIKit

class ViewController: UIViewController {
    
    var data = [Spell]()
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchApiData(URL: "https://wizard-world-api.herokuapp.com/Spells?Type=Conjuration") { result in
            self.data = result
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func fetchApiData(URL url:String, completion: @escaping ([Spell]) -> Void) {
        
        let url = URL(string: url)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { data, response, error in
            if data != nil && error == nil {
                do {
                    let parsingData = try JSONDecoder().decode([Spell].self, from: data!)
                    completion(parsingData)
                } catch {
                    print("There was an error: ")
                    print(error)
                }
            }
        }

        dataTask.resume()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = data[indexPath.row].name
        return cell!
    }
}

struct Spell:Codable {
    let id: String
    let name: String
    let incantation: String?
    let effect: String
    let canBeVerbal: Bool?
    let type: String
    let light: String
    let creator: String?
}

