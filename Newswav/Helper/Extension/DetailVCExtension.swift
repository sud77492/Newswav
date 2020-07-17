//
//  DetailVCExtension.swift
//  Newswav
//
//  Created by Sudhanshu Sharma (HLB) on 17/07/2020.
//  Copyright © 2020 Sudhanshu Sharma (HLB). All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CoreData

extension DetailVC {
    
    func createData(id : String, status: String){
            
            //As we know that container is set up in the AppDelegates so we need to refer that container.
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            //We need to create a context from this container
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Now let’s create an entity and new user records.
            let userEntity = NSEntityDescription.entity(forEntityName: "Gist", in: managedContext)!
            
            //final, we need to add some data to our newly created record for each keys using
            //here adding 5 data with loop
            
            let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
            user.setValue(id, forKeyPath: "id")
            user.setValue(status, forKey: "status")

            //Now we have set all the values. The next step is to save them inside the Core Data
            
            do {
                try managedContext.save()
                retrieveData()
               
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
        
        
        
        
        func retrieveData() {
            
            //As we know that container is set up in the AppDelegates so we need to refer that container.
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            //We need to create a context from this container
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Prepare the request of type NSFetchRequest  for the entity
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Gist")
     
    //
            do {
                let result = try managedContext.fetch(fetchRequest)
                for data in result as! [NSManagedObject] {
                    let id = data.value(forKey: "id") as! String
                    let status = data.value(forKey: "status") as! String
                    print(id)
                    print(status)
                    if status == "true"{
                        starGistSelect(id: id)
                    }else{
                        unstarGistSelect(id: id)
                    }
                    
                }
                deleteAll()
            } catch {
                
                print("Failed")
            }
        }
        
        func updateData(){
        
            //As we know that container is set up in the AppDelegates so we need to refer that container.
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            //We need to create a context from this container
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "User")
            fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur1")
            do
            {
                let test = try managedContext.fetch(fetchRequest)
       
                    let objectUpdate = test[0] as! NSManagedObject
                    objectUpdate.setValue("newName", forKey: "username")
                    objectUpdate.setValue("newmail", forKey: "email")
                    objectUpdate.setValue("newpassword", forKey: "password")
                    do{
                        try managedContext.save()
                    }
                    catch
                    {
                        print(error)
                    }
                }
            catch
            {
                print(error)
            }
       
        }
        
    func deleteData(id:String){
            
            //As we know that container is set up in the AppDelegates so we need to refer that container.
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            //We need to create a context from this container
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Gist")
            fetchRequest.predicate = NSPredicate(format: "id = %@", id)
           
            do
            {
                let test = try managedContext.fetch(fetchRequest)
                if test.count > 0 {
                    let objectToDelete = test[0] as! NSManagedObject
                    managedContext.delete(objectToDelete)
                    
                    do{
                        try managedContext.save()
                    }
                    catch
                    {
                        print(error)
                    }
                }
                
            }
            catch
            {
                print(error)
            }
          
        }
    
    
    func deleteAll(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Gist")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        } catch {
            print ("There was an error")
        }
    }
    
    public func starGistSelect(id: String){
        AF.request("https://api.github.com/gists/\(String(describing: id))/star?access_token=\(Constants.APIKey)", method: .put, parameters: nil, headers: nil).responseJSON { response in
            if let statusCode = response.response?.statusCode {
                if statusCode == 204 {
                    self.starGist.rating = 1.0
                    self.starGist.text = "star"
                    self.status = true
                }else{
                    self.starGist.rating = 0.0
                    self.starGist.text = "unstar"
                    self.status = false
                }
            }
        }
    
    }
    
    
    
    public func unstarGistSelect(id: String){
        AF.request("https://api.github.com/gists/\(String(describing: id))/star?access_token=\(Constants.APIKey)", method: .delete, parameters: nil, headers: nil).responseJSON { response in
            if let statusCode = response.response?.statusCode {
                if statusCode == 204 {
                    self.starGist.rating = 0.0
                    self.starGist.text = "unstar"
                    self.status = false
                    
                }else{
                    self.starGist.rating = 1.0
                    self.starGist.text = "star"
                    self.status = true
                }
            }
        }
    }
    
    public func checkGistStar(id: String){
    AF.request("https://api.github.com/gists/\(String(describing: id))/star?access_token=\(Constants.APIKey)", method: .get, parameters: nil, headers: nil).responseJSON { response in
            if let statusCode = response.response?.statusCode {
                if statusCode == 204 {
                    self.starGist.rating = 1.0
                    self.starGist.text = "star"
                    self.status = true
                }else{
                    self.starGist.rating = 0.0
                    self.starGist.text = "unstar"
                    self.status = false
                }
            }
        }
    }

}
