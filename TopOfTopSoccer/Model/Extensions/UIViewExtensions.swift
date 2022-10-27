//
//  UIViewExtensions.swift

#if os(iOS) || os(tvOS)
import UIKit
import MapKit
import SafariServices

// MARK: - enums
public enum ShakeDirection {
	case horizontal
	case vertical
}

public enum AngleUnit {
	case degrees
	case radians
}

public enum ShakeAnimationType {
	case linear
	case easeIn
	case easeOut
	case easeInOut
}

enum VerticalLocation: String {
    case bottom
    case top
}

let backgroundView = UIView(frame: UIScreen.main.bounds)

// MARK: - Properties
public extension UIView {
	
	@IBInspectable var borderColor: UIColor? {
		get {
			guard let color = layer.borderColor else {
				return nil
			}
			return UIColor(cgColor: color)
		}
		set {
			guard let color = newValue else {
				layer.borderColor = nil
				return
			}
			layer.borderColor = color.cgColor
		}
	}
	
	@IBInspectable var borderWidth: CGFloat {
		get {
			return layer.borderWidth
		}
		set {
			layer.borderWidth = newValue
		}
	}
	@IBInspectable var cornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set {
			//layer.masksToBounds = true
			layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
		}
	}
    var firstResponder: UIView? {
		guard !isFirstResponder else {
			return self
		}
		for subView in subviews where subView.isFirstResponder {
			return subView
		}
		return nil
	}
	
    var height: CGFloat {
		get {
			return frame.size.height
		}
		set {
			frame.size.height = newValue
		}
	}
	
    var isRightToLeft: Bool {
		if #available(iOS 10.0, *, tvOS 10.0, *) {
			return effectiveUserInterfaceLayoutDirection == .rightToLeft
		} else {
			return false
		}
	}
	
    var screenshot: UIImage? {
		UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0)
		defer {
			UIGraphicsEndImageContext()
		}
		guard let context = UIGraphicsGetCurrentContext() else {
			return nil
		}
		layer.render(in: context)
		return UIGraphicsGetImageFromCurrentImageContext()
	}
    
//	@IBInspectable var shadowColor: UIColor? {
    @IBInspectable var shadowColour: UIColor? {
		get {
			guard let color = layer.shadowColor else {
				return nil
			}
			return UIColor(cgColor: color)
		}
		set {
			layer.shadowColor = newValue?.cgColor
		}
	}
	@IBInspectable var shadowOffset: CGSize {
		get {
			return layer.shadowOffset
		}
		set {
			layer.shadowOffset = newValue
		}
	}
	@IBInspectable var shadowOpacity: Float {
		get {
			return layer.shadowOpacity
		}
		set {
			layer.shadowOpacity = newValue
		}
	}
	@IBInspectable var shadowRadius: CGFloat {
		get {
			return layer.shadowRadius
		}
		set {
			layer.shadowRadius = newValue
		}
	}
    var size: CGSize {
		get {
			return frame.size
		}
		set {
			width = newValue.width
			height = newValue.height
		}
	}
    var parentViewController: UIViewController? {
		weak var parentResponder: UIResponder? = self
		while parentResponder != nil {
			parentResponder = parentResponder!.next
			if let viewController = parentResponder as? UIViewController {
				return viewController
			}
		}
		return nil
	}
    var width: CGFloat {
		get {
			return frame.size.width
		}
		set {
			frame.size.width = newValue
		}
	}
    var x: CGFloat {
		get {
			return frame.origin.x
		}
		set {
			frame.origin.x = newValue
		}
	}
	
    var y: CGFloat {
		get {
			return frame.origin.y
		}
		set {
			frame.origin.y = newValue
		}
	}
    
    func dropShadowToView(shadowColor: UIColor) {
        //View Shadow Color
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = 0.2//0.7
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 5 //7
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = true ? UIScreen.main.scale : 1
    }
    
    //MARK:- Set Button Gradient Colors Method
    func applyGradientVertically(colours: [UIColor]) -> Void {
        self.applyGradientV(colours: colours, locations: nil)
    }
    
    func applyGradientV(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        //        gradient.locations = locations
        gradient.startPoint = CGPoint(x: 0.15, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.85, y: 0.5)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyGradientHorizontally(colours: [UIColor], withLocations: [NSNumber]?) -> Void {
        self.applyGradientH(colours: colours, locations: withLocations)
    }
    
    func applyGradientH(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        if locations != nil {
            gradient.locations = locations
        }
        //        gradient.locations = locations
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func removeSublayer(_ view: UIView, layerIndex index: Int) {
        guard let sublayers = view.layer.sublayers else {
            print("The view does not have any sublayers.")
            return
        }
        if sublayers.count > index {
            view.layer.sublayers!.remove(at: index)
        } else {
            print("There are not enough sublayers to remove that index.")
        }
    }
}

extension UIView {
    func dropShadowToTopOrBottom(location: VerticalLocation, color: UIColor, opacity: Float, radius: CGFloat) {
        switch location {
        case .bottom:
            addShadowNew(offset: CGSize(width: 0, height: 5), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadowNew(offset: CGSize(width: 0, height: -5), color: color, opacity: opacity, radius: radius)
        }
    }
    
    func addShadowNew(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        
//        self.layer.masksToBounds = true
//        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: radius, height: radius))
//        let shape = CAShapeLayer()
//        shape.path = maskPath.cgPath
//        self.layer.mask = shape
    }
}


//MARK:- Gradient View
@IBDesignable class GradientButton: UIButton {
    let gradientLayer = CAGradientLayer()
    @IBInspectable var topGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: themeBrownColor, bottomGradientColor: themeBrownColor)
        }
    }

    @IBInspectable var bottomGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: themeBrownColor, bottomGradientColor: themeBrownColor)
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds

    }
    
    private func setGradient(topGradientColor: UIColor?, bottomGradientColor: UIColor?) {
        if let topGradientColor = topGradientColor, let bottomGradientColor = bottomGradientColor {
            gradientLayer.frame = bounds
            gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
            gradientLayer.borderColor = layer.borderColor
            gradientLayer.borderWidth = layer.borderWidth
            gradientLayer.cornerRadius = layer.cornerRadius
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
            layer.insertSublayer(gradientLayer, below: self.imageView?.layer)

        } else {
            gradientLayer.removeFromSuperlayer()
        }
    }
}

@IBDesignable class GradientView: UIView {
    let gradientLayer = CAGradientLayer()
    @IBInspectable var topGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: themeBrownColor, bottomGradientColor: themeBrownColor)
        }
    }

    @IBInspectable var bottomGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: themeBrownColor, bottomGradientColor: themeBrownColor)
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds

    }
    
    private func setGradient(topGradientColor: UIColor?, bottomGradientColor: UIColor?) {
        if let topGradientColor = topGradientColor, let bottomGradientColor = bottomGradientColor {
            gradientLayer.frame = bounds
            gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
            gradientLayer.borderColor = layer.borderColor
            gradientLayer.borderWidth = layer.borderWidth
            gradientLayer.cornerRadius = layer.cornerRadius
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
            layer.insertSublayer(gradientLayer, at: 0)

        } else {
            gradientLayer.removeFromSuperlayer()
        }
    }
}

// MARK: - Methods
public extension UIView {
	
    func shake(count : Float = 4,for duration : TimeInterval = 0.3,withTranslation translation : Float = -5) {
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.byValue = translation
        layer.add(animation, forKey: "shake")
    }
    
    func addTapGestureToView()
    {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }
    @objc func handleTap(sender: UITapGestureRecognizer)
    {
        self.endEditing(true)
    }
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
		let maskPath = UIBezierPath(roundedRect: bounds,
									byRoundingCorners: corners,
									cornerRadii: CGSize(width: radius, height: radius))
		let shape = CAShapeLayer()
		shape.path = maskPath.cgPath
		layer.mask = shape
	}
    func addShadow(ofColor color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0), radius: CGFloat = 3, offset: CGSize = .zero, opacity: Float = 0.5) {
		layer.shadowColor = color.cgColor
		layer.shadowOffset = offset
		layer.shadowRadius = radius
		layer.shadowOpacity = opacity
		layer.masksToBounds = true
	}
    func addSubviews(_ subviews: [UIView]) {
		subviews.forEach({self.addSubview($0)})
	}
	
    func fadeIn(duration: TimeInterval = 0.5, completion: ((Bool) -> Void)? = nil) {
		if isHidden {
			isHidden = false
		}
		UIView.animate(withDuration: duration, animations: {
			self.alpha = 1
		}, completion: completion)
	}
    func fadeOut(duration: TimeInterval = 0.5, completion: ((Bool) -> Void)? = nil) {
		if isHidden {
			isHidden = false
		}
		UIView.animate(withDuration: duration, animations: {
			self.alpha = 0
		}, completion: completion)
	}
	
    class  func loadNibAtIndex(named name: String, bundle: Bundle? = nil,index:Int) -> UIView {
        return (UINib(nibName: name, bundle: bundle).instantiate(withOwner: nil, options: nil)[index] as? UIView)!
    }
    class func loadFromNib(named name: String, bundle: Bundle? = nil) -> UIView? {
		return UINib(nibName: name, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? UIView
	}
	
    func removeSubviews() {
		subviews.forEach({$0.removeFromSuperview()})
	}
	
    func removeGestureRecognizers() {
		gestureRecognizers?.forEach(removeGestureRecognizer)
	}

    func rotate(byAngle angle: CGFloat, ofType type: AngleUnit, animated: Bool = false, duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
		let angleWithType = (type == .degrees) ? CGFloat.pi * angle / 180.0 : angle
		let aDuration = animated ? duration : 0
		UIView.animate(withDuration: aDuration, delay: 0, options: .curveLinear, animations: { () -> Void in
			self.transform = self.transform.rotated(by: angleWithType)
		}, completion: completion)
	}

    func rotate(toAngle angle: CGFloat, ofType type: AngleUnit, animated: Bool = false, duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
		let angleWithType = (type == .degrees) ? CGFloat.pi * angle / 180.0 : angle
		let aDuration = animated ? duration : 0
		UIView.animate(withDuration: aDuration, animations: {
			self.transform = self.transform.concatenating(CGAffineTransform(rotationAngle: angleWithType))
		}, completion: completion)
	}
    func zoomIn()
    {
        if self.isHidden
        {self.isHidden = false}
        self.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.alpha = 1
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: {(_ finished: Bool) -> Void in
        })
    }
    func zoomOut()
    {
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }, completion: {(_ finished: Bool) -> Void in
            self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        })
    }
    func scale(by offset: CGPoint, animated: Bool = false, duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
		if animated {
			UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: { () -> Void in
				self.transform = self.transform.scaledBy(x: offset.x, y: offset.y)
			}, completion: completion)
		} else {
			transform = transform.scaledBy(x: offset.x, y: offset.y)
			completion?(true)
		}
	}
   
    
	
	
	
	/// SwifterSwift: Anchor all sides of the view into it's superview.
	@available(iOS 9, *) func fillToSuperview() {
		// https://videos.letsbuildthatapp.com/
		translatesAutoresizingMaskIntoConstraints = false
		if let superview = superview {
			leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
			rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
			topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
			bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
		}
	}
	
	@available(iOS 9, *) @discardableResult func anchor(
		top: NSLayoutYAxisAnchor? = nil,
		left: NSLayoutXAxisAnchor? = nil,
		bottom: NSLayoutYAxisAnchor? = nil,
		right: NSLayoutXAxisAnchor? = nil,
		topConstant: CGFloat = 0,
		leftConstant: CGFloat = 0,
		bottomConstant: CGFloat = 0,
		rightConstant: CGFloat = 0,
		widthConstant: CGFloat = 0,
		heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
		// https://videos.letsbuildthatapp.com/
		translatesAutoresizingMaskIntoConstraints = false
		
		var anchors = [NSLayoutConstraint]()
		
		if let top = top {
			anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
		}
		
		if let left = left {
			anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
		}
		
		if let bottom = bottom {
			anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
		}
		
		if let right = right {
			anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
		}
		
		if widthConstant > 0 {
			anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
		}
		
		if heightConstant > 0 {
			anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
		}
		
		anchors.forEach({$0.isActive = true})
		
		return anchors
	}

	@available(iOS 9, *)
    func anchorCenterXToSuperview(constant: CGFloat = 0) {
		translatesAutoresizingMaskIntoConstraints = false
		if let anchor = superview?.centerXAnchor {
			centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
		}
	}

	@available(iOS 9, *) func anchorCenterYToSuperview(constant: CGFloat = 0) {
		translatesAutoresizingMaskIntoConstraints = false
		if let anchor = superview?.centerYAnchor {
			centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
		}
	}
	

	@available(iOS 9, *) func anchorCenterSuperview() {
		anchorCenterXToSuperview()
		anchorCenterYToSuperview()
	}
   
    func setViewBottomBorder(borderColor: UIColor)
    {
        self.backgroundColor = UIColor.clear
        let width = 0.5
        
        let borderLine = UIView()
        borderLine.removeFromSuperview()
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - width, width: Double(self.frame.width), height: width)
        borderLine.tag = 99999;
        borderLine.backgroundColor = borderColor
        for v in self.subviews
        {
            if v.tag == 99999
            {
                v.removeFromSuperview()
            }
        }
        self.addSubview(borderLine)
    }
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    func addTapGesture(tapNumber : Int, target: Any , action : Selector) {
        
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    func dropShadow(scale: Bool = true)
    {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 4
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    
    func rotateWithLimit(duration: Double = 1)
    {
        if layer.animation(forKey: "rotationanimationkey") == nil
        {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = 10
            layer.add(rotationAnimation, forKey: "rotationanimationkey")
        }
    }
    
    func shadowAccordingRadius()
    {
        var shadowLayer: CAShapeLayer!
        if shadowLayer == nil
        {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.frame.size.height/2).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.4
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    func keepCenterAndApplyAnchorPoint(_ point: CGPoint) {
        
        guard layer.anchorPoint != point else { return }
        
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
        
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var c = layer.position
        c.x -= oldPoint.x
        c.x += newPoint.x
        
        c.y -= oldPoint.y
        c.y += newPoint.y
        
        layer.position = c
        layer.anchorPoint = point
    }
    
   
    
    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
}
#endif

extension UIScrollView
{
    func setContentViewSize(offset:CGFloat = 0.0) {
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        var maxHeight : CGFloat = 0
        for view in subviews {
            if view.isHidden {
                continue
            }
            let newHeight = view.frame.origin.y + view.frame.height
            if newHeight > maxHeight {
                maxHeight = newHeight
            }
        }
        // set content size
        contentSize = CGSize(width: contentSize.width, height: maxHeight + offset)
        // show scroll indicators
        showsHorizontalScrollIndicator = true
        showsVerticalScrollIndicator = true
    }
}
extension UIView
{
    func copyView<T: UIView>() -> T {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
    }
    func addHeight(_ height: CGFloat) {
        self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: self.frame.width, height: self.frame.height + height))
    }
}

extension UIView {
    
    // Transform a view's shape into circle
    func asCircle() {
        self.layer.cornerRadius = self.frame.width / 2;
        self.layer.masksToBounds = true
    }
    
    func setTintColor(_ color: UIColor, recursive: Bool) {
        tintColor = color
        if recursive {
            subviews.forEach({$0.setTintColor(color, recursive: true)})
        }
    }
}
extension CGRect {
    var center: CGPoint {
        get {
            return CGPoint(x: midX, y: midY)
        }
    }
}

    
public extension UIColor {
    static func fromHex(hexString: String) -> UIColor {
        let hex = hexString.trimmingCharacters(
            in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return UIColor.clear
        }
        
        return UIColor(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255)
    }
}
extension Sequence
{
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        return Dictionary.init(grouping: self, by: key)
    }
}

extension UINavigationController {
    
    func backToViewController(viewController: Swift.AnyClass) {
        
        for element in viewControllers as Array {
            if element.isKind(of: viewController) {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
}

extension UIImagePickerController
{
    func changePickerTopBarColor(_ tintcolorname:UIColor, _ bartintcolorname:UIColor, _ textcolorname:UIColor)
    {
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = bartintcolorname
        self.navigationBar.tintColor = tintcolorname
        self.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : textcolorname
        ]
    }
}

extension UIImageView {
    static func fromGif(frame: CGRect, resourceName: String) -> UIImageView? {
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "gif") else {
            return nil
        }
        let url = URL(fileURLWithPath: path)
        guard let gifData = try? Data(contentsOf: url),
            let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else { return nil }
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        for i in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        let gifImageView = UIImageView(frame: frame)
        gifImageView.animationImages = images
        return gifImageView
    }
}

//MARK:- Social Login Controller present in full screen
extension SFSafariViewController {
    override open var modalPresentationStyle: UIModalPresentationStyle {
        get { return .fullScreen}
        set { super.modalPresentationStyle = newValue }
    }
}

//MARK:- Color Variations
extension UIColor {

    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}

//MARK:- Take Screenshot Of View
extension UIView {
    func takeScreenshot() -> UIImage {
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)

        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)

        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if let myimg = image {
            return myimg
        }
        return UIImage()
    }
}

//MARK:- Drop Shadow to View 
extension UIView {
    func dropShadowToVw(shadowColor: UIColor, offSet: CGSize, opacity: Float, shadowRadius: CGFloat, cornerRadius: CGFloat, corners: UIRectCorner, fillColor: UIColor = .white) {
        
        let shadowLayer = CAShapeLayer()
        let size = CGSize(width: cornerRadius, height: cornerRadius)
        let cgPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size).cgPath //1
        shadowLayer.path = cgPath //2
        shadowLayer.fillColor = fillColor.cgColor //3
        shadowLayer.shadowColor = shadowColor.cgColor //4
        shadowLayer.shadowPath = cgPath
        shadowLayer.shadowOffset = offSet //5
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = shadowRadius
        self.layer.addSublayer(shadowLayer)
    }
}
