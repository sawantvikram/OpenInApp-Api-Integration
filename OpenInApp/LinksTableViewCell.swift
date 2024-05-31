//
//  LinksTableViewCell.swift
//  OpenInApp
//
//  Created by Touchzing media on 28/03/24.
//

import UIKit

class LinksTableViewCell: UITableViewCell {

    @IBOutlet weak var NameLbl: UILabel!
    
    @IBOutlet weak var DateLbl: UILabel!
    
    @IBOutlet weak var clicks: UILabel!
    
    @IBOutlet weak var linkView: UIView!
    @IBOutlet weak var link: UILabel!
    
    @IBOutlet weak var mainImage: UIImageView!
    
    @IBOutlet weak var mainView: UIView!
    
    weak var delegate: LinkTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        mainView.layer.cornerRadius = 10
        mainView.clipsToBounds = true
        
//        linkView.addDottedBorder(color: .blue, width:  1.0,  bottomLeftRadius: 10   , bottomRightRadius: 10)
        
        linkView.layer.cornerRadius = 10
        linkView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
       
        
        let backgroundImage = UIImage(named: "cornerraduis")
               let backgroundImageView = UIImageView(image: backgroundImage)
               
               // Set the content mode of the image view to scale to fill
               backgroundImageView.contentMode = .scaleToFill
               
               // Add the image view as a subview of yourView and send it to the back
        linkView.addSubview(backgroundImageView)
        linkView.sendSubviewToBack(backgroundImageView)
               
               // Set the constraints to make the image view fill the entire yourView
               backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
               NSLayoutConstraint.activate([
                   backgroundImageView.topAnchor.constraint(equalTo: linkView.topAnchor),
                   backgroundImageView.leadingAnchor.constraint(equalTo: linkView.leadingAnchor),
                   backgroundImageView.trailingAnchor.constraint(equalTo: linkView.trailingAnchor),
                   backgroundImageView.bottomAnchor.constraint(equalTo: linkView.bottomAnchor)
               ])
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    @IBAction func buttontapper(_ sender: Any) {
        
        delegate?.didTapButton(in: self)
    }
    
}

extension UIView {
    func addDottedBorder(color: UIColor, width: CGFloat, bottomLeftRadius: CGFloat, bottomRightRadius: CGFloat) {
           let shapeLayer = CAShapeLayer()
           shapeLayer.strokeColor = color.cgColor
           shapeLayer.lineWidth = width
           shapeLayer.lineDashPattern = [2, 2] // Adjust the pattern as needed
           
           // Create a path for the border
           let path = UIBezierPath()
           let bounds = self.bounds
           let topLeft = bounds.origin
           let topRight = CGPoint(x: bounds.origin.x + bounds.size.width, y: bounds.origin.y)
           let bottomRight = CGPoint(x: bounds.origin.x + bounds.size.width, y: bounds.origin.y + bounds.size.height - bottomRightRadius)
           let bottomLeft = CGPoint(x: bounds.origin.x, y: bounds.origin.y + bounds.size.height - bottomLeftRadius)
           
           path.move(to: CGPoint(x: bounds.origin.x, y: bounds.origin.y + bottomLeftRadius))
           path.addLine(to: topLeft)
           path.addLine(to: topRight)
           path.addLine(to: CGPoint(x: topRight.x, y: topRight.y + bottomRightRadius))
           path.addArc(withCenter: bottomRight, radius: bottomRightRadius, startAngle: CGFloat(0.5 * Double.pi), endAngle: CGFloat(0), clockwise: true)
           path.addLine(to: CGPoint(x: bounds.origin.x + bottomLeftRadius, y: bounds.origin.y + bounds.size.height))
           path.addArc(withCenter: bottomLeft, radius: bottomLeftRadius, startAngle: CGFloat(0), endAngle: CGFloat(0.5 * Double.pi), clockwise: true)
           
           shapeLayer.path = path.cgPath
           layer.addSublayer(shapeLayer)
       }
}




protocol LinkTableViewCellDelegate: AnyObject {
    func didTapButton(in cell: LinksTableViewCell)
}

