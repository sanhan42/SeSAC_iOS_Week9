//
//  ViewController.swift
//  SeSAC_iOS_Week9_Lotto
//
//  Created by 한상민 on 2022/08/30.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var lottoLabel: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
//    var list: Person?
    private var viewModel = PersonViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        LottoAPIManager.requestLotto(drwNo: 1025) { lotto, error in
            guard let lotto = lotto else { return }
            self.lottoLabel.text = lotto.drwNoDate
        }
        
//        PersonAPIManager.requestPerson(query: "kim") { person, error in
//            guard let person = person else { return }
//            dump(person)
//            self.list = person
//            self.tableView.reloadData()
//        }
        viewModel.fetchPerson(query: "Kim")
        viewModel.list.bind { person in
            print("viewController bind")
            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return list?.results.count ?? 0
        return viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let data = viewModel.cellForRowAt(at: indexPath)
//        cell.textLabel?.text = list?.results[indexPath.row].name ?? "무명"
        cell.textLabel?.text = data.name
//        cell.detailTextLabel?.text = list?.results[indexPath.row].knownForDepartment ?? "없음"
        cell.detailTextLabel?.text = data.knownForDepartment
        return cell
    }
}
