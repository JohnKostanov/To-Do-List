//
//  ToDoItemTableViewController.swift
//  To Do List
//
//  Created by  Джон Костанов on 10/08/2019.
//  Copyright © 2019 John Kostanov. All rights reserved.
//

import UIKit

class ToDoItemTableViewController: UITableViewController {
    // MARK: - Properties
    var todo = ToDo()
    var datePicker = DatePickerCell()
    let datePickerIndexPath = IndexPath(row: 1, section: 2)
    var isDatePickerShown: Bool = false {
        didSet {
            datePicker.isHidden = !isDatePickerShown
        }
    }
}

//MARK: - UITableViewDataSource
extension ToDoItemTableViewController/*: UITableViewDataSource*/ {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndexPath:
            return isDatePickerShown ? UITableView.automaticDimension : 0
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return todo.keys.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let value = todo.values[section]
        return value is Date ? 2 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let value = todo.values[section]
        let cell = getCellFor(indexPath: indexPath, with: value)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let key = todo.capitilizedKeys[section]
        return key
    }
}

// MARK: - UITableViewDelegate
extension ToDoItemTableViewController/*: UITableViewDelegate*/ {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = todo.values[indexPath.section]
        
        if value is Date {
            isDatePickerShown.toggle()
            
        } else if value is UIImage {
            isDatePickerShown = false
            
            let alert = UIAlertController(title: "Chose Source", message: nil, preferredStyle: .actionSheet)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancel)
            
            let imagePicker = SectionImagePickerController()
            imagePicker.delegate = self
            imagePicker.section = indexPath.section
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
                    imagePicker.sourceType = .camera
                    self.present(imagePicker, animated: true)
                }
                alert.addAction(cameraAction)
            }
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { action in
                    imagePicker.sourceType = .photoLibrary
                    self.present(imagePicker, animated: true)
                }
                alert.addAction(photoLibraryAction)
            }
            
            present(alert, animated: true)
        } else {
            isDatePickerShown = false
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

// MARK: - Cell Configurator
extension ToDoItemTableViewController {
    func getCellFor(indexPath: IndexPath, with value: Any?) -> UITableViewCell {
        
        if let stringValue = value as? String {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
            cell.textField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
            cell.textField.section = indexPath.section
            cell.textField.text = stringValue
            return cell
            
        } else if let dateValue = value as? Date {
            
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell") as! DateCell
                cell.setDate(dateValue)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "DatePickerCell") as! DatePickerCell
                cell.datePicker.addTarget(self, action: #selector(dateValueChanged(_:)), for: .valueChanged)
                cell.datePicker.date = dateValue
                cell.datePicker.section = indexPath.section
                cell.datePicker.minimumDate = Date()
                return cell
            default:
                fatalError("Please are more prototype cells for Date section")
            }
            
        } else if let imageValue = value as? UIImage {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell") as! ImageCell
            cell.largeImageView.image = imageValue
            return cell
            
        } else if let boolValue = value as? Bool {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
            cell.switchButton.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
            cell.switchButton.isOn = boolValue
            cell.switchButton.section = indexPath.section
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
            cell.textField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
            cell.textField.text = ""
            cell.textField.section = indexPath.section
            return cell
        }
    }
}
// MARK: - Actions
extension ToDoItemTableViewController {
    @objc func dateValueChanged(_ sender: SectionDatePicker) {
        let section = sender.section!
        let key = todo.keys[section]
        let date = sender.date
        todo.setValue(date, forKey: key)
        let labelIndexPath = IndexPath(row: 0, section: section)
        tableView.reloadRows(at: [labelIndexPath], with: .automatic)
    }
    
    @objc func switchValueChanged(_ sender: SectionSwitch) {
        isDatePickerShown = false
        let key = todo.keys[sender.section!]
        let value = sender.isOn
        todo.setValue(value, forKey: key)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @objc func textFieldValueChanged(_ sender: SectionTextField) {
        isDatePickerShown = false
        let key = todo.keys[sender.section!]
        let text = sender.text ?? ""
        todo.setValue(text, forKey: key)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}

extension ToDoItemTableViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        guard let sectionPicker = picker as? SectionImagePickerController else { return }
        guard let section = sectionPicker.section else { return }
        let key = todo.keys[section]
        todo.setValue(image, forKey: key)
        let indexPath = IndexPath(row: 0, section: section)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
extension ToDoItemTableViewController: UINavigationControllerDelegate {}
