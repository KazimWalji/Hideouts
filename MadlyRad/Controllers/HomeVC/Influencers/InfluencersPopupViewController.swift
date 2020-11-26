
import UIKit

enum NetworkServiceError: Error {
    case noData
}

struct InfluencerData: Decodable {
    let name: String
    let image: String
    let shortInfo: String
    let info: String
    let tiktokLink: String
    let instaLink: String
    let imageLink: String
}

class InfluencersPopupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var tableView: UITableView!
    private var data = [InfluencerData]()
    
    var onShowDetail: ((InfluencerData?) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "InfluencerCell", bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: "InfluencerCell")

        tableView.delegate = self
        tableView.dataSource = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        backgroundView.addGestureRecognizer(gesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        let colors = [UIColor(with: "#C5C6E7").cgColor, UIColor(with: "#EFD3E7").cgColor]
        let points = [CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0)]
        gradientView.setupBackgroundGradient(colors: colors, points: points)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchInfluencersData { [weak self] (result) in
            switch result {
            case .success(let influencers):
                self?.data = influencers.shuffled()
                self?.tableView.reloadData()
            case .failure(let error):
                break
            }
        }
    }

    func fetchInfluencersData(completion: @escaping(Result<[InfluencerData], NetworkServiceError>) -> Void) {
        guard let url = Bundle.main.url(forResource: "InfluencersData", withExtension: "json") else {
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let data = try Data(contentsOf: url)
                let influencers = try JSONDecoder().decode([InfluencerData].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(influencers))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
            }
        }
    }
    
    private func showDetails(data: InfluencerData?) {
        let vc = InfluencerDetailViewController()
        vc.data = data
        self.present(vc, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dataItem = data[indexPath.row] as? InfluencerData, let cell = tableView.dequeueReusableCell(withIdentifier: "InfluencerCell") as? InfluencerCell else {
            return UITableViewCell()
        }
        cell.data = dataItem
        cell.onButtonClicked = { [weak self] data in
            self?.showDetails(data: data)
//            self?.onShowDetail?(data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 3.33
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.backgroundColor = UIColor.clear.cgColor
    }
    
    @objc
    func onTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}



extension UIView {
    func setupBackgroundGradient(colors: [CGColor], points: [CGPoint]) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = points.first ?? CGPoint.zero
        gradient.endPoint = points.last ?? CGPoint.zero
        if let localsublayers = self.layer.sublayers {
            for sub in localsublayers {
                if sub is CAGradientLayer {
                    sub.removeFromSuperlayer()
                }
            }
        }
        self.layer.insertSublayer(gradient, at: 0)
    }
}

extension UIColor {
    convenience init(with hex:String) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            self.init()
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
