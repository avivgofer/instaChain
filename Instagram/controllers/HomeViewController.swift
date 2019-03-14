//
//  HomeViewController.swift
//  Instagram
//
//  Created by admin on 19/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SDWebImage
import ProgressHUD

class HomeViewController: UIViewController, UITableViewDelegate{
    
    @IBOutlet weak var tableview: UITableView!
    var posts = [Post]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
        tableview.delegate = self
        tableview.rowHeight = UITableView.automaticDimension
        loadPosts()
        // Do any additional setup after loading the view.
    }
    
    func loadPosts(){
        ProgressHUD.show("Download Image", interaction: false)
        Model.instance.loadPosts(){(DataSnapshot) in
            if let dict = DataSnapshot.value as? [String: Any]{
                let post = Post(json: dict)
                self.posts.append(post)
                print(self.posts)
                self.tableview.reloadData()
            }
            
        }
    }

}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 460;//Choose your custom row height
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! HomeTableViewCell
        
        let post = posts[indexPath.row]
       
        if let uid = post.uid {
            Model.instance.loadUser(uid: uid){(snapshot) in
                if let dict = snapshot.value as? [String: Any]{
                    let user = User(json:dict)
                    cell.nameLabel.text = user.username
                    if let photoUrlString = user.profileImageUrl{
                        let photoUrl = URL(string: photoUrlString)
                        cell.profileImageView.sd_setImage(with: photoUrl) { (image, error, chace, url) in
                            cell.profileImageView.layer.cornerRadius = 10
                            cell.profileImageView.clipsToBounds = true
                        }
                    }
                }
            }
        }
        cell.captionLabel.text = post.caption
        if let photoUrlString = post.photoUrl{
            let photoUrl = URL(string: photoUrlString)
            cell.postImageView.sd_setImage(with: photoUrl) { (image, error, chace, url) in
                
            }
        }
        
        cell.postImageView.layer.cornerRadius = 4
        cell.postImageView.clipsToBounds = true
        return cell
    }
}
