
import UIKit

class TableViewTwoController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    var selectedPdfObject: PdfObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    
    @IBOutlet var tableView: UITableView!
    @IBAction func goHome(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "unwindToHome", sender: self)
    }

    let pdfStoreInstance = PdfStore.sharedInstance
    
    func configureView() {
        if self.selectedPdfObject != nil {
            self.navigationItem.title = selectedPdfObject?.name;
            pdfStoreInstance.pdfsForParent(selectedPdfObject!.name, selectedRouteObject: selectedPdfObject!)
        }
    }
    
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableListLength = pdfStoreInstance.countPdfsForParent
        return tableListLength
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
       
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension;

        let pdfObject = pdfStoreInstance.getObjectForParent(indexPath.row)
        var cell = UITableViewCell()
        
        cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 
    
        if pdfObject.type == "dir" {
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator

        }
        
        cell.textLabel?.text = pdfObject.name
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 0

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    
        let indexPath = self.tableView.indexPathForSelectedRow
        let type = pdfStoreInstance.getObjectForParent(indexPath!.row).type
        if type == "dir" {
            self.performSegue(withIdentifier: "showTableViewTwo", sender: self)
        }
        if type == "pdf" {
            self.performSegue(withIdentifier: "showDetail", sender: self)
        }
        
    }
    
    // Stop the automatic segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any!) -> Bool {
        return false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "showDetail" {
            let indexPath = self.tableView.indexPathForSelectedRow
            let pdf = pdfStoreInstance.getObjectForParent(indexPath!.row)
            (segue.destination as! DetailViewController).detailItem = pdf
        }
        if segue.identifier == "showTableViewTwo" {
            let indexPath = self.tableView.indexPathForSelectedRow
            let pdfObject = pdfStoreInstance.getObjectForParent(indexPath!.row)
            (segue.destination as! TableViewTwoController).selectedPdfObject = pdfObject
        }
    }
    

    func setNavBarColor(){
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.isTranslucent = false
        
        let themeApp = ThemeApp();
        var sectionColor: UIColor;
        
        if((self.selectedPdfObject) != nil){
            sectionColor = themeApp.getColorForSection(self.selectedPdfObject!.section)
            self.navigationController?.navigationBar.barTintColor = sectionColor
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.setNavBarColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavBarColor()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        if (!(parent?.isEqual(self.parent) ?? false)) {
            pdfStoreInstance.pdfsForParent(selectedPdfObject!.parent, selectedRouteObject: selectedPdfObject!)
        }
    }

}

