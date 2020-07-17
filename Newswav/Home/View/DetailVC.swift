//
//  DetailVC.swift
//  NewsWav Project
//
//  Created by Sudhanshu Sharma (HLB) on 14/07/2020.
//  Copyright © 2020 Sudhanshu Sharma (HLB). All rights reserved.
//

import UIKit
import Cosmos
import Kingfisher
import Reachability

class DetailVC: UIViewController {
    
    var reachability: Reachability!
    @IBOutlet weak var imageView: UIImageView!
    var gist : Gist?
    @IBOutlet weak var gistTitle: UILabel!
    @IBOutlet weak var gistDescription: UILabel!
    @IBOutlet weak var starGist: CosmosView!
    var status : Bool = false
    var checkInternet : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.makeRounded()
        let url = URL(string: self.gist?.owner?.avatar_url ?? "")
        self.imageView.kf.setImage(with: url)
        gistTitle.text = gist?.getFirstFileName()
        gistDescription.text = gist?.description
        starGist.didFinishTouchingCosmos = didFinishTouchingCosmos
        checkGistStar(id: gist!.id)
        //retrieveData()
        
        do {
           try reachability = Reachability()
           NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: Notification.Name.reachabilityChanged, object: reachability)
           try reachability.startNotifier()
       } catch {
            print("This is not working.")
       }
    }
    
    private func didFinishTouchingCosmos(_ rating: Double) {
      if(status){
        if checkInternet{
            unstarGistSelect(id: gist!.id)
        }else{
            deleteData(id: gist!.id)
            createData(id: gist!.id, status: "false")
            self.starGist.rating = 0
            self.status = false
        }
      }else{
        if checkInternet{
            starGistSelect(id: gist!.id)
        }else{
            deleteData(id: gist!.id)
            createData(id: gist!.id, status: "true")
            self.starGist.rating = 1.0
            self.status = true
        }
      }
    }
    
    
    
    @objc func reachabilityChanged(_ note: NSNotification) {
        let reachability = note.object as! Reachability
        if reachability.connection != .unavailable {
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
                checkInternet = true
                retrieveData()
            } else {
                print("Reachable via Cellular")
                checkInternet = true
            }
        } else {
            print("Not reachable")
            checkInternet = false
        }
    }

    

}
