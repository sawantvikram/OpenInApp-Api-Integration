import UIKit
import Charts


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LinkTableViewCellDelegate, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    

    @IBOutlet weak var scrollViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var greetingMessageLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var LineChart: LineChartView!
    
    @IBOutlet weak var linkTableView: UITableView!
    @IBOutlet weak var viewBelowDashboard: UIView!
    
    @IBOutlet weak var tableViewLoadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var loadingSpinerGrapg: UIActivityIndicatorView!
//    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var segment: SSSegmentedControl!
    
    @IBOutlet weak var searchBar: UISearchBar!
    var dashboardData: DashboardData?
  
    var filterData : DashboardData?
    
    var dataPointsTopLinks = [String]()
    var valuesTopLinks =  [Int]()
    
    var clickdata : [String]?
    
    @IBOutlet weak var infoCollectionView: UICollectionView!

    
    @IBOutlet weak var infoDataActivityIndicitor: UIActivityIndicatorView!
  
    var dataPointsRecentLinks = [String]()
    var valuesRecentLinks = [Int]()
    @IBOutlet weak var WhatsAppContact: UIView!
    
    @IBOutlet weak var searchButton: UIButton!
    
    let images = ["Toadayclick", "location", "global"]
    let infolabels = ["Today's Click", "Top Location", "Top Source"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set greeting message
        greetingMessageLbl.text = getGreetingMessage()
        
        // Sample data for the line chart
        let players = ["Ozil", "Ramsey", "Laca", "Auba", "Xhaka", "Torreira"]
        let goals = [6, 8, 26, 30, 8, 10]
      
      
        
        searchBar.delegate = self

        searchBar.isHidden = true
       
        WhatsAppContact.layer.cornerRadius  = 8
        WhatsAppContact.layer.borderWidth = 1
        WhatsAppContact.layer.borderColor = #colorLiteral(red: 0.3358187377, green: 0.8380175233, blue: 0.4472739697, alpha: 0.3181023849)
        WhatsAppContact.clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(whatsAppTapped))
        WhatsAppContact.addGestureRecognizer(tapGesture)
        WhatsAppContact.isUserInteractionEnabled = true
        
       
        loadingSpinerGrapg.startAnimating()
        tableViewLoadingSpinner.startAnimating()
        infoDataActivityIndicitor.startAnimating()
        
//        let normalTextAttributes: [NSAttributedString.Key: Any] = [
//                   .foregroundColor: UIColor.black // Set your desired unselected color
//               ]
//               segment.setTitleTextAttributes(normalTextAttributes, for: .normal)
//
//               // Set the text color for the selected state
//               let selectedTextAttributes: [NSAttributedString.Key: Any] = [
//                   .foregroundColor: UIColor.white // Set your desired selected color
//               ]
//        segment.setTitleTextAttributes(selectedTextAttributes, for: .selected)
//        
        
        
        segment.numberOfSegments = 2
        segment.segmentsTitle = "Top Link,Recent Link"
        
        segment.currentIndexBackgroundColor = #colorLiteral(red: 0.01143774949, green: 0.5319700241, blue: 1, alpha: 1)
//        segment.cornerRadius  = segment.frame.size.height/2
        segment.clipsToBounds = true
        
        segment.currentIndexTitleColor = .white
        segment.otherIndexTitleColor = #colorLiteral(red: 0.6, green: 0.6117647059, blue: 0.6274509804, alpha: 1)
        segment.borderColor = .clear
        
        viewBelowDashboard.clipsToBounds = true
        viewBelowDashboard.layer.cornerRadius = 20
        viewBelowDashboard.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
      
        
        
        
        fetchDashboardData { result in
            switch result {
            case .success(let data):
                            // Assign the fetched data to the property
                self.dashboardData = data
                
                self.filterData = data
                
                // Use dashboardData to populate your table view
                print( "Dashboard Data : \(self.dashboardData!.data.recentLinks[2].originalImage)" )
                
              
                
                if(self.dashboardData?.data.recentLinks.count ?? 0 > 1){
                    
                    for link in self.dashboardData!.data.topLinks {
                        // Process each element of recentLinks
                        
                        self.dataPointsTopLinks.append(self.formatMonth(link.createdAt) ?? "Jan")
                        self.valuesTopLinks.append(link.totalClicks)
                    }
                    
                    for link in self.dashboardData!.data.recentLinks {
                        // Process each element of recentLinks
                        
                    
                       
                        
                        self.dataPointsRecentLinks.append(self.formatMonth(link.createdAt)!)
                        self.valuesRecentLinks.append(link.totalClicks)
                    }
                    
                }
                
                let overallUrlChart = self.dashboardData?.data.overallUrlChart
                
                let dataPoints = Array(overallUrlChart!.keys)
                let values = Array(overallUrlChart!.values)

                // Call the function with extracted data
              
                
                
                DispatchQueue.main.async {
                    
                    // Customize and display line chart
//                    self.customizeLineChart(dataPoints: self.dataPointsTopLinks, values: self.valuesTopLinks)
                    
                    self.customizeLineChart(dataPoints: dataPoints, values: values)
                    
                    self.loadingSpinerGrapg.stopAnimating()
                    self.loadingSpinerGrapg.isHidden = true
                    self.tableViewLoadingSpinner.stopAnimating()
                    self.tableViewLoadingSpinner.isHidden = true
                    self.infoDataActivityIndicitor.stopAnimating()
                    self.infoDataActivityIndicitor.isHidden = true
                    self.linkTableView.reloadData()
                    
//                    self.todaysClickLbl.text = String(self.dashboardData?.todayClicks ?? 0)
                    
                    self.scrollViewHeightConstant.constant = CGFloat(670 + (150 * (self.dashboardData?.data.recentLinks.count ?? 0)))
                
                    self.clickdata = [String(self.dashboardData?.todayClicks ?? 0), String(self.dashboardData?.topLocation ?? "Mumbai"), String(self.dashboardData?.topSource ?? "Direct")]
                    self.infoCollectionView.reloadData()
                }
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
        
        
        
       
        segment.didTapSegment = { index in
                   print(index)
               
            
            self.linkTableView.reloadData()
            
//            if self.segment.currentIndex == 0{
//                
//          
//                self.customizeLineChart(dataPoints: self.dataPointsTopLinks, values: self.valuesTopLinks)
//                
//            }else{
//                
//                self.customizeLineChart(dataPoints: self.dataPointsRecentLinks, values: self.valuesRecentLinks)
//                
//            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("Dashboad Data count : ", dashboardData?.data.recentLinks.count)
        
        
        if segment.currentIndex == 0 {
            
            return filterData?.data.topLinks.count ?? 0
        }else{
            
            return filterData?.data.recentLinks.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = linkTableView.dequeueReusableCell(withIdentifier: "LinkCellIdentfier", for: indexPath) as! LinksTableViewCell
        
        // Reset cell content
          cell.NameLbl.text = ""
          cell.clicks.text = ""
          cell.DateLbl.text = ""
          cell.link.text = ""
          cell.mainImage.image = nil
          
          var link: Link? = nil
          if segment.currentIndex == 0 {
              link = filterData?.data.topLinks[indexPath.row]
          } else {
              link = filterData?.data.recentLinks[indexPath.row]
          }
          
          if let link = link {
              
              cell.NameLbl.text = link.title
              
              print("All Clicks : ", link.totalClicks)
              
              var clicks = link.totalClicks
              
              cell.clicks.text = String(clicks)
              if String(link.totalClicks).count < 1{
                  cell.clicks.text = String(123)
                  
              }
              
             
              cell.DateLbl.text = self.formatDateString(link.createdAt)
              cell.link.text = link.webLink
              
              // Load and set the image asynchronously
              if let imageUrl = URL(string: link.originalImage) {
                  DispatchQueue.global().async {
                      if let imageData = try? Data(contentsOf: imageUrl),
                         let image = UIImage(data: imageData) {
                          DispatchQueue.main.async {
                              // Check if cell is still displaying the same link
                              if let currentIndexPath = tableView.indexPath(for: cell),
                                 currentIndexPath == indexPath {
                                  cell.mainImage.image = image
                              }
                          }
                      }
                  }
              }
          }
        
        cell.selectionStyle = .none
        cell.delegate = self
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return clickdata?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = infoCollectionView.dequeueReusableCell(withReuseIdentifier: "infocell", for: indexPath) as! InfoCollectionViewCell
        
        
        cell.defLabel.text = infolabels[indexPath.row]
        cell.srcimage.image = UIImage(named: images[indexPath.row])
        cell.numberOfTimes.text =  clickdata![indexPath.row]
        cell.layer.cornerRadius = 8
        
        
        return cell
    }
    
 

    
    
    func getGreetingMessage() -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())

        switch hour {
        case 0..<12:
            return "Good Morning"
        case 12:
            return "Good Noon"
        case 13..<17:
            return "Good Afternoon"
        case 17..<21:
            return "Good Evening"
        default:
            return "Hello"
        }
    }
 
    func customizeLineChart(dataPoints: [String], values: [Int]) {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "Sample Data")
        lineChartDataSet.colors = [#colorLiteral(red: 0.05490196078, green: 0.4352941176, blue: 1, alpha: 1)] // Set line color
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.circleHoleColor = UIColor.blue // Set circle hole color
        lineChartDataSet.lineWidth = 3
        
        let gradientColors = [#colorLiteral(red: 0.05490196078, green: 0.4352941176, blue: 1, alpha: 1), UIColor.clear.cgColor] // Start with blue color and fade to transparent
           let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
           let gradientFill = LinearGradientFill(gradient: gradient, angle: 270)
          
          // Assign the gradient fill to the dataSet's fill property
          lineChartDataSet.fill = gradientFill
        lineChartDataSet.drawFilledEnabled = true
        
        
        // Set fill color for area under curve
//        lineChartDataSet.fillColor = #colorLiteral(red: 0.3476826251, green: 0.9705113367, blue: 0.2593537415, alpha: 0.3149058361)
//        lineChartDataSet.drawFilledEnabled = true // Enable drawing filled area under curve
        
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        LineChart.data = lineChartData
        
        // Customize x-axis
        let xAxis = LineChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        
        // Customize y-axis
        let yAxis = LineChart.leftAxis
        yAxis.axisMinimum = 0.0
        
        // Enable pinch zoom and double tap to zoom
        LineChart.pinchZoomEnabled = true
        LineChart.doubleTapToZoomEnabled = true
        
        // Disable legend
        LineChart.legend.enabled = false
        LineChart.drawGridBackgroundEnabled = false
        
        // Set chart description
//        LineChart.chartDescription.text = "Cliks Per Month"
    }

    // Function to fetch data from the API
    func fetchDashboardData(completion: @escaping (Result<DashboardData, Error>) -> Void) {
        let urlString = "https://api.inopenapp.com/api/v1/dashboardNew"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjU5MjcsImlhdCI6MTY3NDU1MDQ1MH0.dCkW0ox8tbjJA2GgUx2UEwNlbTZ7Rr38PVFJevYcXFI", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let dashboardData = try decoder.decode(DashboardData.self, from: data)
                
                print(dashboardData)
                
                completion(.success(dashboardData))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    
    func formatDateString(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = dateFormatter.date(from: dateString) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "dd MMMM yyyy"
            return outputDateFormatter.string(from: date)
        } else {
            return nil
        }
    }
    
    func formatMonth(_ dateString: String) -> String? {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = dateFormatter.date(from: dateString) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "MMM"
            return outputDateFormatter.string(from: date)
        } else {
            return nil
        }
    }
    
    
    func didTapButton(in cell: LinksTableViewCell) {
           if let indexPath = linkTableView.indexPath(for: cell) {
               // Handle button tap for the cell at indexPath
               
               copyStringToClipboard(dashboardData!.data.recentLinks[indexPath.row].webLink)
               
               
               
           }
       }
    
    func copyStringToClipboard(_ text: String) {
        
        showToast(message: "Text Copied To ClipBoard")
        
        let pasteboard = UIPasteboard.general
        pasteboard.string = text
    }
    
    
    @IBAction func segmentView(_ sender: UISegmentedControl) {
        
        linkTableView.reloadData()
        
//        if segment.currentIndex == 0{
//            
//      
//            self.customizeLineChart(dataPoints: self.dataPointsTopLinks, values: self.valuesTopLinks)
//            
//        }else{
//            
//            self.customizeLineChart(dataPoints: self.dataPointsRecentLinks, values: self.valuesRecentLinks)
//            
//        }
        
        
    }
    
    
    
    
    func showToast(message: String) {
        let toastView = CustomToastView(frame: CGRect(x: 20, y: view.frame.height - 170, width: view.frame.width - 40, height: 50))
        toastView.messageLabel.text = message
        
        view.addSubview(toastView)
        
        UIView.animate(withDuration: 0.3, animations: {
            toastView.alpha = 1.0
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                UIView.animate(withDuration: 0.3) {
                    toastView.alpha = 0.0
                } completion: { _ in
                    toastView.removeFromSuperview()
                }
            }
        }
    }
    
    
    @objc func whatsAppTapped(){
        
        
        
        if let url = URL(string: "https://api.whatsapp.com/send/?phone=%2B91" + (dashboardData?.supportWhatsappNumber.trimmingCharacters(in: .whitespaces) ?? "9901908504") + "&text&type=phone_number&app_absent=0"),
                 UIApplication.shared.canOpenURL(url) {
                  UIApplication.shared.open(url, options: [:], completionHandler: nil)
              }
        
        
    }
    
    @IBAction func searchButtonClicked(_ sender: Any) {
        
        segment.isHidden = true
        searchBar.isHidden = false
        searchButton.isHidden = true
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        segment.isHidden = false
        self.searchBar.isHidden = true
        searchButton.isHidden = false
        
        searchBar.text = ""

                filterData = dashboardData

               searchBar.endEditing(true)

        linkTableView.reloadData()
        
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        

        if segment.currentIndex == 0{
            
            if let dashboardData = dashboardData {
                filterData?.data.topLinks = searchText.isEmpty ? dashboardData.data.topLinks : dashboardData.data.topLinks.filter { link in
                    return link.title.range(of: searchText, options: .caseInsensitive) != nil
                }
            }
        }else{
            
            if let dashboardData = dashboardData {
                filterData?.data.recentLinks = searchText.isEmpty ? dashboardData.data.recentLinks : dashboardData.data.recentLinks.filter { link in
                    return link.title.range(of: searchText, options: .caseInsensitive) != nil
                }
                
            }
        }

        linkTableView.reloadData()
        
        
    }

    
    

}



struct DashboardData: Codable {
    let status: Bool
    let statusCode: Int
    let message: String
    let supportWhatsappNumber: String
    let extraIncome: Double
    let totalLinks: Int
    let totalClicks: Int
    let todayClicks: Int
    let topSource: String
    let topLocation: String
    let startTime: String
    let linksCreatedToday: Int
    let appliedCampaign: Int
    
    var data: DashboardDetails // Change 'let' to 'var'
  

}

struct DashboardDetails: Codable {
    var recentLinks: [Link]
    var topLinks: [Link]
    var overallUrlChart: [String: Int]
}

struct Link: Codable {
    let urlId: Int
    let webLink: String
    let smartLink: String
    let title: String
    let totalClicks: Int
    let originalImage: String
    let thumbnail: String?
    let timesAgo: String
    let createdAt: String
    let domainId: String
    let urlPrefix: String?
    let urlSuffix: String
    let app: String
    let isFavourite: Bool
}
