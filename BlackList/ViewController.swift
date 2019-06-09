//
//  ViewController.swift
//  BlackList
//
//  Created by Denny Caruso on 21/12/2018.
//  Copyright © 2018 Denny Caruso. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var imagePicker: UIImagePickerController!

    //var people: [NSManagedObject] = []
    var peopleArray = [Person]()
    var orientation: Bool!
    var edit: Bool! = false
    
    override func viewDidLoad() {
        print("Start")
        if UIDevice.current.orientation == UIDeviceOrientation.portrait {
            orientation = true
        } else {
            orientation = false
        }
        tableView.dataSource = self
        tableView.delegate = self
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self

        super.viewDidLoad()
        //title  = "The Black List"
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BlackCell")
        loadData()
        //tableView.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func loadData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        
        do {
            //sleep(2)
            peopleArray = try managedContext.fetch(fetchRequest)
            
//            print("Rimozione: \(peopleArray.removeDuplicates())")
//            peopleArray.removeDuplicates()
            tableView.reloadData()
            edit = false
            checkDuplicate()
        } catch let error as NSError {
                print("Error. Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func checkDuplicate() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        do {
            if let result = try? managedContext.fetch(fetchRequest) {
                for object in result {
                    print(object)
                }}} catch let error as NSError {
                    print("pepe")
        }
    }
    
    
     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
        //2
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        //3
        do {
            peopleArray = try managedContext.fetch(fetchRequest) as! [Person]
        } catch let error as NSError {
            print("Error. Could not fetch. \(error), \(error.userInfo)")
        }
    }
    /*
   // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //meals.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
*/
    
   /*  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }*/
    
 
    
    @IBAction func addName(_ sender: UIBarButtonItem) {
       
        
        let alert = UIAlertController(title: "Select Your Image", message: "Pick from album or take photo", preferredStyle: .actionSheet)
        
        let album = UIAlertAction(title: "Pick from Album", style: .default, handler: {
            (action) -> Void in
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let camera = UIAlertAction(title: "Take a Picture", style: .default, handler: {
            (action) -> Void in
            self.useCamera()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (action) -> Void in
        })
        
        alert.addAction(album)
        alert.addAction(camera)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
//        let imagePicker = UIImagePickerController()
//        imagePicker.sourceType = .photoLibrary
//        imagePicker.delegate = self
//        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            picker.dismiss(animated: true, completion: {
                self.createBlackListName(with: image)
            })
        }
    }
    
    func useCamera() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerController.SourceType.camera
        imagePicker.cameraCaptureMode = .photo
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true, completion: nil)
    }

    func createBlackListName (with image: UIImage) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let nameItem = Person(context: managedContext)
        nameItem.image = NSData(data: image.jpegData(compressionQuality: 0.3)!) as Data
        
        
        let alert = UIAlertController(title: "New Name", message: "Insert new name and surname about the person who you hate", preferredStyle: .alert)
        alert.addTextField {(textfield: UITextField) in textfield.placeholder = "Name and Surname"
            
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {(action: UIAlertAction) in
                let personTextField = alert.textFields?.first
                
                if personTextField?.text != "" {
                    nameItem.name = personTextField?.text
                    do {
                        try managedContext.save()
                        self.save(nameItem: nameItem)
                        
                    } catch let error as NSError {
                        print("Error. Could not save. \(error), \(error.userInfo)")
                    }
                }
                } as! (UIAlertAction) -> Void))

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            }
         present(alert, animated: true)
    }
    
    
    //***NON CANCELLARE***
    
//        let inputAlert = UIAlertController(title: "New Name", message: "Insert new name and surname about the person who you hate", preferredStyle: .alert)
//
//        inputAlert.addTextField {(textfield: UITextField) in textfield.placeholder = "Name and Surname"
//        }
//        
//        inputAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action: UIAlertAction) in
//
//            let personTextField = inputAlert.textFields?.first
//            if personTextField?.text != "" {
//                nameItem.name = personTextField?.text
//                do {
//                    try managedContext.save()
//                } catch let error as NSError {
//                    print("Error. Could not save. \(error), \(error.userInfo)")
//                }
//            }} as! (UIAlertAction) -> Void))
//        
//        inputAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        /*
        let saveAction = UIAlertAction(title: "Save", style: .default){
            [unowned self] action in
            let personTextField = alert
            if personTextField?.text != "" {
                print("Entro in IF 218")
                nameItem.name = personTextField?.text
            }
            nameItem.name = textField.text
            self.save(nameItem: nameItem)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)*/
    
    
    
    func save(nameItem: Person){
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        //1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        
        //3
        person.setValue(nameItem.image, forKey: "image")
        person.setValue(nameItem.name, forKey: "name")
        
        //4
        do {
            let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
            peopleArray = try (managedContext.fetch(fetchRequest) as! [Person])
            try managedContext.save()
            peopleArray.append(nameItem)
            loadData()
            
        } catch let error as NSError {
            print("Error. Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    func update(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        //1
        let managedContext = appDelegate.persistentContainer.viewContext
        //2
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!

        do {
            let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
            peopleArray = try managedContext.fetch(fetchRequest)
        
            try managedContext.save()
            self.tableView.reloadData()
            
        } catch let error as NSError {
            print("Error. Could not save. \(error), \(error.userInfo)")
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            orientation = false
            //self.tableView.layout
        } else {
            print("Portrait")
            orientation = true

        }
    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var dim: CGFloat
        dim = 75
        return dim
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = peopleArray[indexPath.row]
        let cellBlack = tableView.dequeueReusableCell(withIdentifier: "BlackCell", for: indexPath)
    
        if let personImage = UIImage(data: person.image as! Data) {
            
            
            var cellImg: UIImageView = UIImageView(frame: CGRect(x: 10, y: 1, width: 70, height: 70))
            
            if orientation == false {
                self.tabBarController?.tabBar.isHidden = true
                tabBarController?.tabBar.isHidden = true
            }
            cellImg.image = personImage
            cellBlack.addSubview(cellImg)
//            cellImg.contentMode = .scaleAspectFit
            cellImg.contentMode = .scaleAspectFill
            cellImg.layer.cornerRadius = 10
            cellImg.layer.masksToBounds = true
            
            cellBlack.imageView?.image = UIImage(named: "t")
            print("Dimensioni: \(personImage.size.width)")
        }
        
        cellBlack.textLabel?.text = person.name
        return cellBlack
    }
    
    
    //crea immagine a tutto schermo in una subview
    func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath){
        let person = peopleArray[didSelectRowAt.row]
        let imageView = UIImageView(image: UIImage(data: person.image as! Data))
//        super.view.autoresizesSubviews = true
//        imageView.autoresizesSubviews = true
        
//        imageView.autoresizingMask
        if orientation == false {
            self.tabBarController?.tabBar.isHidden = true
            self.tabBarController?.tabBar.layer.zPosition = -1
        }
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.frame = super.view.frame
        imageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        imageView.addGestureRecognizer(tap)

        self.view.addSubview(imageView)
    }
    
    // dismissa la subview create con image a tutto schermo
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.layer.zPosition = -0
    }
    
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            //array
//            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//                return
//            }
//
//            let managedContext = appDelegate.persistentContainer.viewContext
//
//            do {
//                managedContext.delete(self.peopleArray[indexPath.row])
//
//                self.peopleArray.remove(at: indexPath.row)
//                print("indice \(indexPath.row)")
//                self.tableView.deleteRows(at: [indexPath], with: .fade)
//                self.update()
//                self.tableView.reloadData()
//
//                try managedContext.save()
//
//            } catch let error as NSError {
//                print("Error. Could not save. \(error), \(error.userInfo)")
//            }
//        }
//    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            print("update")
        }
        let delete = UITableViewRowAction(style: .default, title: "Delete") { action, index in
            do {
                managedContext.delete(self.peopleArray[indexPath.row])
                
                self.peopleArray.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                
                try managedContext.save()
                
            } catch let error as NSError {
                print("Error. Could not save. \(error), \(error.userInfo)")
            }
        }
        return [delete, edit]
    }
}
