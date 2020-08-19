//
//  ViewController.swift
//  MrIdli
//
//  Created by govind on 05/08/20.
//  Copyright © 2020 govind. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var orderButton :UIButton!
    @IBOutlet weak var callUsButton : UIButton!
    @IBOutlet weak var findourStoreButton : UIButton!
    @IBOutlet weak var menuButton : UIButton!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    @IBOutlet weak var pageController : UIPageControl!
    
    
    let cellScale:CGFloat = 0.6
    var imageArray : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.startAnimating()
//        let screenSize = collectionView.frame.size
//        let cellWidth = (screenSize.width - 25)
//        let cellHeight = (screenSize.height - 10)
//        let insetX = (view.frame.width - cellWidth) / 2.0
//        let insetY = (view.frame.height - cellHeight) / 2.0
//
//       // let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
//       // layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
//        collectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //button radius
        orderButton.layer.cornerRadius = 10
        callUsButton.layer.cornerRadius = 5
        findourStoreButton.layer.cornerRadius = 5
        menuButton.layer.cornerRadius = 10
        
        //background image
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "Background")?.draw(in: self.view.bounds)

        if let image = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        }else{
            UIGraphicsEndImageContext()
            debugPrint("Image not available")
         }
        
        //Firebase
        
        let db = Firestore.firestore()
        db.collection("Banner").order(by: "name").getDocuments{(snapshots,error) in
            if error == nil && snapshots != nil {
                for document in snapshots!.documents{
                    let documenturl = document.get("url") as! String
                    self.imageArray.append(documenturl)
                    self.collectionView.reloadData()
                }
                self.pageController.numberOfPages = self.imageArray.count
                self.progressView.stopAnimating()
                self.progressView.isHidden = true
                self.startTimer()
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageController.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    @IBAction func callUsButtonEvent(_ sender: UIButton) {
        if let phoneCallURL = URL(string: "telprompt://+971507175406") {

            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                     application.openURL(phoneCallURL as URL)

                }
            }
        }
    }
    
    @IBAction func findStoreButtonEvent(_ sender: UIButton) {
      //  self.openTrackerInBrowser()
        let lat = (25.4017058)
        let longi = (55.4417783)
        if let UrlNavigation = URL.init(string: "comgooglemaps://?saddr=&daddr=\(lat),\(longi)") {
            if UIApplication.shared.canOpenURL(UrlNavigation){
                    if let urlDestination = URL.init(string: "comgooglemaps://?saddr=&daddr=\(lat),\(longi)") {
                        UIApplication.shared.open(urlDestination)
                    }
            }
            else {
                NSLog("Can't use comgooglemaps://");
                self.openTrackerInBrowser()

            }
        }
        else
        {
            NSLog("Can't use comgooglemaps://");
           self.openTrackerInBrowser()
        }
    }
    
    func openTrackerInBrowser(){

            let lat = 25.4017058
            let longi = 55.4417783

            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(longi)") {
                UIApplication.shared.open(urlDestination)
            }
        
    }
    //25.4017058,55.4417783
    
    /**
     Scroll to Next Cell
     */
    var current: Int = 0
    @objc func scrollToNextCell(_ timer1: Timer){

        if let coll  = collectionView {
            
                      if ((current)  < imageArray.count - 1){
                          let indexPath1: IndexPath?
                          indexPath1 = IndexPath.init(row: current + 1, section: 0)
                          coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                        current = current+1
                      }
                      else{
                          let indexPath1: IndexPath?
                          indexPath1 = IndexPath.init(row: 0, section: 0)
                          coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                        current = 0
                      }
            pageController.currentPage = current
                      
                  
              }
    }

    /**
     Invokes Timer to start Automatic Animation with repeat enabled
     */
    func startTimer() {
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.scrollToNextCell(_:)), userInfo: nil, repeats: true)



    }
    
    
}

extension ViewController : UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! collectionViewCell
        let image = imageArray[indexPath.item]
        cell.image.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "loading"), options: [.continueInBackground, .progressiveLoad])
        cell.image.layer.cornerRadius = 10
        cell.image.layer.masksToBounds = true
        return cell
    }
}

extension ViewController : UIScrollViewDelegate, UICollectionViewDelegate{
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left)/cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex*cellWidthIncludingSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        
        targetContentOffset.pointee = offset
    }
}

extension ViewController : UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
}

