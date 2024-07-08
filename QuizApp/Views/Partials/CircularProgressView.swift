import UIKit
import PureLayout

class CircularProgressView: UIView {
    var progressLayer = CAShapeLayer()
    var trackLayer = CAShapeLayer()
    
    var progress: CGFloat = 0 {
        didSet {
            progressLayer.strokeEnd = progress
        }
    }
    
    var progressColor: UIColor = .red {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    var trackColor: UIColor = .gray {
        didSet {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        defineLayout()
        styleViews()
    }
    
    required init?(coder:NSCoder){
        super.init(coder: coder)
        defineLayout()
        styleViews()
    }
    
    private func defineLayout() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: 75, startAngle: -CGFloat.pi / 2, endAngle: 1.5 * CGFloat.pi, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        layer.addSublayer(trackLayer)
        
        progressLayer.path = circularPath.cgPath
        layer.addSublayer(progressLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        defineLayout()
        styleViews()
    }
    
    func updateProgressColor(to color: UIColor) {
        progressColor = color
    }
    
    func styleViews() {
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 15
        trackLayer.strokeEnd = 1
        
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 20
        progressLayer.strokeEnd = 0
    }
}
