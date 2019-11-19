//
//  NotesTableViewController.swift
//  MyNotes
//
//  Created by Hewlett, Brianna Anne on 11/19/19.
//  Copyright © 2019 Hewlett, Brianna Anne. All rights reserved.
//

import UIKit
import CoreData

class NotesTableViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var notes = [Note]()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadNotes()
        
        self.tableView.rowHeight = 84.0
    }
    
    func loadNotes(){
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        
        do{
            notes = try context.fetch(request)
        }catch{
            print("Error fetching Notes from Core Data!")
        }
        
        tableView.reloadData()
    }
    
    func saveNotes(){
        do{
            try context.save()
        }catch{
            print("Error saving Notes to Core Data")
        }
        
        tableView.reloadData()
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var titleTextField = UITextField()
        var typeTextField = UITextField()

        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: date)
        
        let alert = UIAlertController(title: "Add Note", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default, handler: { (action) in
            let newNote = Note(context: self.context)
            
            newNote.title = titleTextField.text!
            newNote.type = typeTextField.text!
            newNote.dateCreated = formattedDate
            
            self.notes.append(newNote)
            
            self.saveNotes()
        })
        
        action.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (cancelAction) in
            
        })
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        alert.addTextField(configurationHandler: { (field) in
            titleTextField = field
            titleTextField.placeholder = "Enter Title"
            titleTextField.addTarget(self, action: #selector((self.alertTextFieldDidChange)), for: .editingChanged)
        })
        alert.addTextField(configurationHandler: { (field) in
            typeTextField = field
            typeTextField.placeholder = "Enter Type"
            typeTextField.addTarget(self, action: #selector((self.alertTextFieldDidChange)), for: .editingChanged)
        })

        present(alert, animated: true, completion: nil)
    }
    
    @objc func alertTextFieldDidChange(){
        let alertController = self.presentedViewController as! UIAlertController
        
        let action = alertController.actions[0]
        
        if let title = alertController.textFields![0].text, let type = alertController.textFields![1].text {
            
            let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
            let trimmedType = type.trimmingCharacters(in: .whitespaces)

            if(!trimmedTitle.isEmpty && !trimmedType.isEmpty){
                action.isEnabled = true
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyNoteCell", for: indexPath)

        // Configure the cell...

        let note = notes[indexPath.row]
        cell.textLabel?.text = note.title!
        cell.detailTextLabel!.numberOfLines = 0
        cell.detailTextLabel?.text = note.type! + "\n" + note.dateCreated!
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
