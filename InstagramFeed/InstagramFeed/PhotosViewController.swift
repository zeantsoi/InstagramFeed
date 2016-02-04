//
//  ViewController.swift
//  InstagramFeed
//
//  Created by Marc Anderson on 2/3/16.
//  Copyright © 2016 Marc Adam. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController {

    var photos: [NSDictionary]?

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 320

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshPhotos:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        refreshPhotos(refreshControl)
    }

    func refreshPhotos(refreshControl: UIRefreshControl) {
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )

        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options:[]) as? NSDictionary {
                        self.photos = responseDictionary["data"] as? [NSDictionary]
                        self.tableView.reloadData()
                        refreshControl.endRefreshing()
                    }
                }
        });
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! PhotoTableViewCell
        let pdvc = segue.destinationViewController as! PhotoDetailsViewController
        pdvc.photoURL = cell.photoURL
    }

}

extension PhotosViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let photos = photos {
            return photos.count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)

        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profileView.layer.borderWidth = 1;

        let photo = photos![section]
        let user = photo["user"] as! NSDictionary
        let username = user["username"] as! String
        let profilePicture = user["profile_picture"] as! String
        let imageURL = NSURL(string: profilePicture)!
         profileView.setImageWithURL(imageURL)
        headerView.addSubview(profileView)
        
        // Add a UILabel for the username her
        let usernameLabel = UILabel(frame: CGRect(x: 50, y: 10, width: headerView.frame.width - 60, height: 22.0))
        usernameLabel.text = username
        headerView.addSubview(usernameLabel)

        return headerView
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell") as! PhotoTableViewCell

        let photo = photos![indexPath.section]
        let images = photo["images"] as! NSDictionary
        let resolution = images["low_resolution"] as! NSDictionary
        let url = resolution["url"] as! String
        let imageURL = NSURL(string: url)!
        cell.photoURL = imageURL
        cell.photoImageView!.setImageWithURL(imageURL)

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}