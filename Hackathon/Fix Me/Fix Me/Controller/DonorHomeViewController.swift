//
//  DonorHomeViewController.swift
//  Fix Me
//
//  Created by Asad 'Bunny' on 08/12/2018.
//  Copyright © 2018 Asad 'Bunny'. All rights reserved.
//

//
//  DonorViewController.swift
//  Fix Me
//
//  Created by Asad 'Bunny' on 09/12/2018.
//  Copyright © 2018 Asad 'Bunny'. All rights reserved.
//

import UIKit
import GradientProgressBar
import LinearProgressBar

class DonorHomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //IBOutlets
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noDataLabel: UILabel!
    var refreshControl = UIRefreshControl()
    var id = 1
    var postsData: PostListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        performDelegates()
        getData(id: self.id)
    }
    
    //SegmentedController action listener
    @IBAction func indexDidChanged(_ sender: UISegmentedControl) {
        switch segmentedController.selectedSegmentIndex {
        case 0:
            self.id = 1
            getData(id: 1)
        case 1:
            self.id = 2
            getData(id: 2)
        case 2:
            self.id = 3
            getData(id: 3)
        case 3:
            self.id = 4
            getData(id: 4)
        default:
            return
        }
    }
    
    //Delegates
    func performDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    //Refresh Controller method
    @objc func refresh(sender:AnyObject) {
        getData(id: self.id)
    }
    
    func getData(id: Int) {
        
        if let sp = spinner {
            if !sp.isHidden {
                sp.isHidden = true
            }
        }
        
        spinner = self.showActivityIndicator(view: self.view)

        AuthService.instance.getPosts(id: id, dataModel: { (postData) in
            self.postsData = postData
            self.collectionView.reloadData()
        }, errorMessage: { (message) in
            if let msg = message {
                self.refreshControl.endRefreshing()
                spinner?.dismissLoader()
                self.displayAlert(title: BUSINESS_NAME, message: msg)
            }
        }) { (success) in
            if success {
                self.refreshControl.endRefreshing()
                spinner?.dismissLoader()
            } else {
                self.refreshControl.endRefreshing()
                spinner?.dismissLoader()
                self.displayAlert(title: BUSINESS_NAME, message: ERROR_MESSAGE)
            }
        }
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        }
    }
    
}

extension DonorHomeViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let data = self.postsData {
            if let payLoad = data.donationsRequired {
                self.noDataLabel.isHidden = true
                return payLoad.count
            } else {
                self.noDataLabel.isHidden = false
                return 0
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "donorCell", for: indexPath) as? DonorCell {
            if let data = self.postsData {
                if let payLoad = data.donationsRequired {
                    cell.donationButton.tag = indexPath.row
                    cell.donationButton.addTarget(self, action: #selector(donationPressed(_:)), for: .touchUpInside)
                    if let image = payLoad[indexPath.row].image {
                        cell.postImage.loadImage(urlString: image)
                    }
                    if let title = payLoad[indexPath.row].title {
                        cell.postTitle.text = title
                    }
                    if let desc = payLoad[indexPath.row].description {
                        cell.postDescription.text = desc
                    }
                    if let tAmount = payLoad[indexPath.row].amount {
                        cell.totalAmount.text = "\(tAmount)"
                    }
                    if let rAmount = payLoad[indexPath.row].amountRecieved {
                        cell.receivedAmount.text = "\(rAmount)"
                    }
                    if let tF = payLoad[indexPath.row].timeFrame {
                        cell.timeFrameDays.text = "\(tF) Days"
                    }
                    if let prog = payLoad[indexPath.row].amountCompletedPercentage {
                        print(prog)
//                        let progress = CGFloat(prog) / 100
//                        cell.progress.
                        cell.progress.progressValue = CGFloat(prog)
                    }
                }
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    @objc func donationPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: BUSINESS_NAME, message: "Are you sure you want to donate?", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Rs. 200"
            textField.keyboardType = .numberPad
        }
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (success) in
            if let tf =  alertController.textFields?.first {
                if tf.text != "" {
                    print("Amount: \(tf.text!)")
                } else {
                    self.displayAlert(title: BUSINESS_NAME, message: "Please provide some money!")
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: { (success) in
            
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 340)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}


class DonorCell: UICollectionViewCell {
    
    @IBOutlet weak var postImage: CachedImageView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postDescription: UITextView!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var receivedAmount: UILabel!
    @IBOutlet weak var timeFrameDays: UILabel!
    @IBOutlet weak var progress: LinearProgressBar!
    @IBOutlet weak var donationButton: UIButton!
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.white
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 5
        self.layer.shadowRadius = 4.0
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.2
    }
}

