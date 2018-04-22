//
//  ViewController.swift
//  GithubInstantSearch
//
//  Created by Shashank Shandilya on 4/22/18.
//  Copyright © 2018 org. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var timer: Timer?
    var currentAPITask: URLSessionDataTask?
    var results: [Items] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func textfieldValueChange(_ sender: Any) {
        self.timer?.invalidate()
        //0.3 secs timer to skip searches when there is a fast typing by the user.
        self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(timerFired(timer:)), userInfo: self.textField.text, repeats: false)
    }
    
    @objc func timerFired(timer: Timer) {
        guard let searchString = timer.userInfo as? String else {
            return
        }
        
        if searchString.count == 0 {
            //
            self.currentAPITask?.cancel()//cancels api call that is in progress.
            //delete search results.
            self.results.removeAll()
            self.tableView.reloadData()
            return
        }
        
        self.currentAPITask?.cancel()
        //make api call.
//        https://api.github.com/search/users?q=Tom&sort=followers
        guard let url = URL(string: "https://api.github.com/search/users") else {
            return
        }

        self.currentAPITask = APIConnection.shared.makeRequest(toURL: url, params: ["q": searchString, "sort": "followers"], method: .Get) { [weak self] (error, data) in
            guard let strongSelf = self else {
                return
            }
        
            if let err = error {
                //Show error
                print("got error \(err)")
                return
            }
            
            guard let responseData = data else {
                return
            }
            
            print("response \(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)")
            let jsonDecoder = JSONDecoder()
            let responseModel = try? jsonDecoder.decode(Response.self, from: responseData)
            
            if let resp = responseModel {
                if let items = resp.items {
                    strongSelf.results = items
                    strongSelf.tableView.reloadData()
                }
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! ImageLabelTableViewCell
        let item = self.results[indexPath.row]
        cell.label.text = item.login
        return cell
    }
}
