//
//  ViewController.swift
//  TbvAddRemove
//
//  Created by CallmeOni on 26/8/2566 BE.
//

import UIKit

struct itemNo{
    var id:String
    var name:String
    var timeAdd:String?
    var timeRemove:String?
}

class ViewController: UIViewController {

    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var tbvShow: UITableView!
    
    let randomName = ["AAA", "BBB", "CCC", "DDD", "EEE"]
    private var arrCheck:[itemNo] = []
    private var timmerCheck: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tbvShow.delegate = self
        tbvShow.dataSource = self
        tbvShow.register(UINib(nibName: "TestViewCell", bundle: nil), forCellReuseIdentifier: "TestCell")
        
        self.addBtn.setTitle("Add Data", for: .normal)
        self.addBtn.addTarget(self, action: #selector(addData), for: .touchUpInside)
    }
    
    //MARK: Action Button
    @objc func addData(){
        var newItem = itemNo(id: String(Int.random(in: 0...3)), name: randomName[Int.random(in: 0..<randomName.count)], timeAdd:self.getTimeReceive(isNew: true), timeRemove: nil)
        
        if let index = arrCheck.firstIndex(where: { $0.id == newItem.id }){
            self.arrCheck[index].name = newItem.name
            self.arrCheck[index].timeRemove = self.getTimeReceive(isNew:false)
            self.tbvShow.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        }else{
            newItem.timeAdd = self.getTimeReceive(isNew: true)
            newItem.timeRemove = self.getTimeReceive(isNew: false)
            self.arrCheck.append(newItem)
            if self.arrCheck.count > 0{
                DispatchQueue.main.async {
                    self.tbvShow.reloadData()
                }
                if let timmer = timmerCheck{ }else{
                    self.startTimmer()
                }
            }
        }
    }

    func startTimmer(){
        self.timmerCheck = Timer()
        self.timmerCheck?.invalidate()
        self.timmerCheck = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.checkRemove), userInfo: nil, repeats: true)
    }

    @objc func checkRemove(){
        print("Start checkRemove")
        if self.arrCheck.count > 0{
            for idx in 0...self.arrCheck.count - 1{
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm:ss"
                guard let timeAdd = self.arrCheck[idx].timeAdd, let timeRemove = self.arrCheck[idx].timeRemove else{
                    print("Guard No Olddate or No NewDate")
                    return
                }
                
                if let timeAdd = formatter.date(from: timeAdd), let timeRemove = formatter.date(from: timeRemove){
                    if timeRemove >= timeAdd {
                        self.arrCheck[idx].timeAdd = self.getTimeReceive(isNew: true)
                    }else{
                        self.arrCheck.remove(at: idx)
                        self.tbvShow.beginUpdates()
                        self.tbvShow.deleteRows(at: [IndexPath(item: idx, section: 0)], with: .fade)
                        self.tbvShow.endUpdates()
                        return
                    }
                }else{
                    print("No Olddate or No NewDate")
                }
            }
        }else{
            self.arrCheck = []
            self.timmerCheck?.invalidate()
            self.timmerCheck = nil
        }
    }
    
    private func getTimeReceive(isNew:Bool) -> String{
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "HH:mm:ss"
        if isNew{
            return formatter.string(from: now)
        }else{
            return formatter.string(from: now.addingTimeInterval(3))
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCheck.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath) as! TestViewCell
        let item = arrCheck[indexPath.row]
        cell.lbCellTest.text = "Item \(item.id), name \(item.name)"
        return cell
    }
}

