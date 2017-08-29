
import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var shopLink: UIBarButtonItem!

    
    let pdfStoreInstance = PdfStore.sharedInstance
    
    var filteredPdfs = [PdfObject]()
    var selectedSearchObject: PdfObject?
    var blankSelectedSearchObject: PdfObject?
    
    
    // MARK: - Search
    func filterContentForSearchText(_ searchText: String) {
        // Filter the array using the filter method
        self.filteredPdfs = self.pdfStoreInstance.pdfObjects.filter({( pdfObject: PdfObject) -> Bool in
            let categoryMatch = pdfObject.type == "pdf"
            let stringMatch = pdfObject.name.range(of: searchText, options:NSString.CompareOptions.caseInsensitive)
            return categoryMatch && (stringMatch != nil)
        })
    }
    
    
    func searchDisplayControllerWillEndSearch(_ controller: UISearchDisplayController) {
        // Need to go back to original state
        pdfStoreInstance.pdfsForRoot()
        self.selectedSearchObject = self.blankSelectedSearchObject;
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = UIColor(red: 255.0/255.0, green: 8.0/255.0, blue: 17.0/255.0, alpha: 1.0)
        self.tableView.reloadData()
    }
    
    
    func searchDisplayController(_ controller: UISearchDisplayController, shouldReloadTableForSearch searchString: String?) -> Bool {
        self.filterContentForSearchText(searchString!)
        return true
    }
    
    func searchDisplayController(_ controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text!)
        return true
    }

    
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController?.searchResultsTableView {
            return self.filteredPdfs.count
        } else {
            let tableListLength = pdfStoreInstance.countPdfsForRoot
            return tableListLength + 1
        }

    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        var pdfObject : PdfObject?
        let themeApp = ThemeApp();
        var sectionColor: UIColor;
        
        cell.textLabel?.textColor = UIColor.white

        if tableView == self.searchDisplayController?.searchResultsTableView {

            pdfObject = filteredPdfs[indexPath.row]
            tableView.estimatedRowHeight = 68.0
            tableView.rowHeight = UITableViewAutomaticDimension;

        } else if indexPath.row != pdfStoreInstance.countPdfsForRoot {

            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 
            pdfObject = pdfStoreInstance.getObjectForParentFromRoot(indexPath.row)

        }

        if tableView == self.searchDisplayController?.searchResultsTableView {
            cell.textLabel?.text = pdfObject!.name
        }

        if pdfObject?.type == "dir" {
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }

        if pdfObject?.parent == "/" {

            // cell = tableView.dequeueReusableCellWithIdentifier("imageCell", forIndexPath: indexPath) as! UITableViewCell

            cell.textLabel?.text = pdfObject!.name + " Range"
            
            if(pdfObject != nil){
                let imageName = pdfObject!.section + ".png"
                let image = UIImage(named: imageName)
                let imageView = cell.imageView;
                imageView!.image = image
            }
            
        }

        if(pdfObject != nil){
            sectionColor = themeApp.getColorForSection(pdfObject!.section)
            cell.backgroundColor = sectionColor
        }

        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        var type: String?
        
        if tableView == self.searchDisplayController?.searchResultsTableView {
                type = filteredPdfs[indexPath.row].type
                self.selectedSearchObject = filteredPdfs[indexPath.row]
        }else{
            let indexPath = self.tableView.indexPathForSelectedRow!
            type = pdfStoreInstance.getObjectForParentFromRoot(indexPath.row).type
        }
        
        if type != nil {
            if type == "dir" {
                self.performSegue(withIdentifier: "showTableViewTwo", sender: self)
            }
            if type == "pdf" {
                self.performSegue(withIdentifier: "showDetail", sender: self)
            }
        }

    }

    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if self.selectedSearchObject?.name != nil {
            if segue.identifier == "showDetail" {
                (segue.destination as! DetailViewController).detailItem = self.selectedSearchObject!
            }
        }else{
            if segue.identifier == "showDetail" {
                let indexPath = tableView.indexPathForSelectedRow!
                let pdf = pdfStoreInstance.getObjectForParent(indexPath.row)
                (segue.destination as! DetailViewController).detailItem = pdf
            }
            if segue.identifier == "showTableViewTwo" {
                let indexPath = tableView.indexPathForSelectedRow!
                let pdfObject = pdfStoreInstance.getObjectForParentFromRoot(indexPath.row)
                (segue.destination as! TableViewTwoController).selectedPdfObject = pdfObject
            }
        }
        

    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = UIColor(red: 217.0/255.0, green: 217.0/255.0, blue: 217.0/255.0, alpha: 1.0)
    }
    
    func setNavBarColor(){
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 200.0/255.0, green: 16.0/255.0, blue: 46.0/255.0, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavBarColor()
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
    }
    
    @IBAction func unwindToHomeViewController(_ segue: UIStoryboardSegue) {
        pdfStoreInstance.pdfsForRoot()
    }
    
    @IBAction func shopLinkAction(_ sender: AnyObject) {
        let url = "http://www.grantuk.com/spares/"
        let formattedURL = URL(string: url)
        UIApplication.shared.openURL(formattedURL!);
    }
    
    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavBarColor()
        
        self.navigationItem.title = "Grant TechBox";
        
        shopLink.setFAIcon(icon: FAType.FAShoppingCart, iconSize: 25)
        shopLink.tintColor = UIColor.white
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
        
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = UIColor(red: 255.0/255.0, green: 8.0/255.0, blue: 17.0/255.0, alpha: 1.0)
        
        pdfStoreInstance.pdfsForRoot()
    }

}

