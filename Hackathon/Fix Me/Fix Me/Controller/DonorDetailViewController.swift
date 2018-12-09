
import UIKit
import GradientProgressBar
import LinearProgressBar

class DonorDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noDataLabel: UILabel!
    var refreshControl = UIRefreshControl()
    var postsData: PostListModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        performDelegates()
        getData()
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
        getData()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        }
    }
    
    func getData() {
        
        if let sp = spinner {
            if !sp.isHidden {
                sp.isHidden = true
            }
        }
        
        if let id = AuthService.instance.userId {
            
            spinner = self.showActivityIndicator(view: self.view)
            
            AuthService.instance.getUserPosts(id: id, dataModel: { (postData) in
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
    }
}

extension DonorDetailViewController {
    
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
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "donorCell1", for: indexPath) as? DonorCell {
            if let data = self.postsData {
                if let payLoad = data.donationsRequired {
                    if let image = payLoad[indexPath.row].image {
                        cell.postImage.loadImage(urlString: image)
                    }
                    if let title = payLoad[indexPath.row].title {
                        cell.postTitle.text = title
                    }
                    if let desc = payLoad[indexPath.row].description {
                        cell.postDescription.text = desc
                    }
                    
                    if let tF = payLoad[indexPath.row].status {
                        cell.timeFrameDays.text = tF
                    }
                    if let prog = payLoad[indexPath.row].amountCompletedPercentage {
                        cell.progress.progressValue = CGFloat(prog)
                    }
                }
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
