//
//  ViewController.swift
//  caoqinyu_8
//
//  Created by student on 2018/11/24.
//  Copyright © 2018年 2016110302. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var students = [Student]()
    var teachers = [Teacher]()
    var tableTitle = ["Teacher", "Student"]
    //定义一个表视图
    var table: UITableView!
    var rightItem: UIBarButtonItem!
    var alert: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "table"
        self.view.backgroundColor = UIColor.white
        //创建表视图，并设置代理和数据源
        table = UITableView(frame: self.view.bounds)
        table.delegate = self
        table.dataSource = self
        self.view.addSubview(table)
        
        rightItem = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: #selector(edit))
        self.navigationItem.rightBarButtonItem = rightItem
        
        let leftItem = UIBarButtonItem(title: "添加", style: .plain, target: self, action: #selector(addStudent))
        self.navigationItem.leftBarButtonItem = leftItem
        
        //生成3个Teacher对象
        for i in 1...3 {
            let j = Teacher(title: "主任", firstName: "曹", lastName: "\(i)", age: 18, gender: .female, department: .one)
            teachers.append(j)
        }
        //生成3个Student对象
        for i in 1..<4{
            let j = Student(stuNo:i, firstName: "包", lastName: "\(i)", age: 19, gender: .male, department: .two)
            students.append(j)
        }
        
        //按全名排序
        teachers.sort { return $0.fullName < $1.fullName }
        students.sort { return $0.fullName < $1.fullName }
        
    }
    
    /// 添加学生提示框
    @objc func addStudent() {
        
        alert = UIAlertController(title: "学生信息", message: "学生信息", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "sno"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "first name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "last name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "sex"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "age"
        }
        
        let OKBtn = UIAlertAction(title: "ok", style: .default) { (alert) in
            self.add()
        }
        let cancelBtn = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alert.addAction(OKBtn)
        alert.addAction(cancelBtn)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    /// 添加学生
    func add() {
        let no = Int(alert.textFields![0].text!)
        let firstName = alert.textFields![1].text!
        let lastName = alert.textFields![2].text!
        let gender: Gender
        switch alert.textFields![3].text! {
        case "男":
            gender = .male
        case "女":
            gender = .female
        default:
            gender = .unknow
        }
        let age = Int(alert.textFields![4].text!)
        let student = Student(stuNo: no!, firstName: firstName, lastName: lastName, age: age!, gender: gender)
        students.append(student)
        
        table.reloadData()
    }
    
    /// 编辑表视图
    @objc func edit() {
        if table.isEditing {
            rightItem.title = "edit"
            table.isEditing = false
        } else {
            rightItem.title = "ok"
            table.isEditing = true
        }
    }
    
    // MARK: delegate
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = tableTitle[indexPath.section]
        
        let name: String
        if indexPath.section == 0 {
            name = teachers[indexPath.row].fullName
        } else {
            name = students[indexPath.row].fullName
        }
        
        let message = "你选择的名字为: \(name)"
        
        let alert = UIAlertController(title: "message", message: message, preferredStyle: .alert)
        let OKBtn = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(OKBtn)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: data source
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            if indexPath.section == 0 {
                teachers.remove(at: indexPath.row)
            } else {
                students.remove(at: indexPath.row)
            }
            
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.section != destinationIndexPath.section {
            tableView.reloadData()
        } else {
            if sourceIndexPath.section == 0 {
                teachers.insert(teachers.remove(at: sourceIndexPath.row), at: destinationIndexPath.row)
            } else {
                students.insert(students.remove(at: sourceIndexPath.row), at: destinationIndexPath.row)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableTitle.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableTitle[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return teachers.count
        } else {
            return students.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = tableTitle[indexPath.section]
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if cell == nil {
            let style: UITableViewCell.CellStyle = (identifier == "Teacher") ? .subtitle : .default
            cell = UITableViewCell(style: style, reuseIdentifier: identifier)
            cell?.accessoryType = .disclosureIndicator
        }
        
        switch identifier {
        case "Teacher":
            cell?.textLabel?.text = teachers[indexPath.row].fullName
            cell?.detailTextLabel?.text = teachers[indexPath.row].title
        case "Student":
            cell?.textLabel?.text = students[indexPath.row].fullName
        default:
            break
        }
        
        return cell!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

