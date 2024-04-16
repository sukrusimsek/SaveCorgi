//
//  ViewController.swift
//  Save Corgi
//
//  Created by Şükrü Şimşek on 14.04.2024.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, GADFullScreenContentDelegate {
    // MARK: - Enum
    fileprivate enum ScreenEdge: Int {
        case top = 0
        case right = 1
        case bottom = 2
        case left = 3
    }
    
    fileprivate enum GameState {
        case ready
        case playing
        case gameOver
    }
    
    // MARK: - Constants
    fileprivate let playerAnimationDuration = 5.0
    fileprivate let enemySpeed: CGFloat = 40 // points per second
    fileprivate let colors = [#colorLiteral(red: 0.08235294118, green: 0.6980392157, blue: 0.5411764706, alpha: 1), #colorLiteral(red: 0.07058823529, green: 0.5725490196, blue: 0.4470588235, alpha: 1), #colorLiteral(red: 0.9333333333, green: 0.7333333333, blue: 0, alpha: 1), #colorLiteral(red: 0.9411764706, green: 0.5450980392, blue: 0, alpha: 1), #colorLiteral(red: 0.1411764706, green: 0.7803921569, blue: 0.3529411765, alpha: 1), #colorLiteral(red: 0.1176470588, green: 0.6431372549, blue: 0.2941176471, alpha: 1), #colorLiteral(red: 0.8784313725, green: 0.4156862745, blue: 0.03921568627, alpha: 1), #colorLiteral(red: 0.7882352941, green: 0.2470588235, blue: 0, alpha: 1), #colorLiteral(red: 0.1490196078, green: 0.5098039216, blue: 0.8352941176, alpha: 1), #colorLiteral(red: 0.1137254902, green: 0.4156862745, blue: 0.6784313725, alpha: 1), #colorLiteral(red: 0.8823529412, green: 0.2, blue: 0.1607843137, alpha: 1), #colorLiteral(red: 0.7019607843, green: 0.1411764706, blue: 0.1098039216, alpha: 1), #colorLiteral(red: 0.537254902, green: 0.2352941176, blue: 0.662745098, alpha: 1), #colorLiteral(red: 0.4823529412, green: 0.1490196078, blue: 0.6235294118, alpha: 1), #colorLiteral(red: 0.6862745098, green: 0.7137254902, blue: 0.7333333333, alpha: 1), #colorLiteral(red: 0.1529411765, green: 0.2196078431, blue: 0.2980392157, alpha: 1), #colorLiteral(red: 0.1294117647, green: 0.1843137255, blue: 0.2470588235, alpha: 1), #colorLiteral(red: 0.5137254902, green: 0.5843137255, blue: 0.5843137255, alpha: 1), #colorLiteral(red: 0.4235294118, green: 0.4745098039, blue: 0.4784313725, alpha: 1)]
    
    fileprivate var playerView = UIImageView(frame: .zero)
    fileprivate var playerAnimator: UIViewPropertyAnimator?
    
    fileprivate var enemyViews = [UIView]()
    fileprivate var enemyAnimators = [UIViewPropertyAnimator]()
    fileprivate var enemyTimer: Timer?
    
    fileprivate var displayLink: CADisplayLink?
    fileprivate var beginTimestamp: TimeInterval = 0
    fileprivate var elapsedTime: TimeInterval = 0
    
    fileprivate var gameState = GameState.ready
    private var interstitial: GADInterstitialAd?
    
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var bestTimeLabel: UILabel!
    
    @IBOutlet weak var lightDarkButton: UIButton!
    @IBAction func toggleDarkLight(_ sender: Any) {
        if let title = lightDarkButton.titleLabel?.text {
            if title == "Dark" {
                view.backgroundColor = .lightGray
                lightDarkButton.setTitle("Light", for: .normal)
                lightDarkButton.setImage(UIImage(systemName: "sun.max.fill"), for: .normal)
                lightDarkButton.setTitleColor(.white, for: .normal)
                if let title = lightDarkButton.titleLabel?.text {
                    let startBackgroundColor: UIColor
                    let startClockLabelColor: UIColor
                    let startStartLabelColor: UIColor
                    let startBestTimeLabelColor: UIColor
                    
                    let endBackgroundColor: UIColor
                    let endClockLabelColor: UIColor
                    let endStartLabelColor: UIColor
                    let endBestTimeLabelColor: UIColor
                    
                    if title == "Dark" {
                        startBackgroundColor = view.backgroundColor ?? .white
                        startClockLabelColor = clockLabel.textColor ?? .black
                        startStartLabelColor = startLabel.textColor ?? .black
                        startBestTimeLabelColor = bestTimeLabel.textColor ?? .black
                        
                        endBackgroundColor = .white
                        endClockLabelColor = .black
                        endStartLabelColor = .black
                        endBestTimeLabelColor = .black
                    } else {
                        startBackgroundColor = view.backgroundColor ?? .lightGray
                        startClockLabelColor = clockLabel.textColor ?? .white
                        startStartLabelColor = startLabel.textColor ?? .white
                        startBestTimeLabelColor = bestTimeLabel.textColor ?? .white
                        
                        endBackgroundColor = .black
                        endClockLabelColor = .white
                        endStartLabelColor = .white
                        endBestTimeLabelColor = .white
                    }
                    
                    UIView.animate(withDuration: 0.2) {
                        self.view.backgroundColor = endBackgroundColor
                        self.clockLabel.textColor = endClockLabelColor
                        self.startLabel.textColor = endStartLabelColor
                        self.bestTimeLabel.textColor = endBestTimeLabelColor
                        
                        self.clockLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                        self.startLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                        self.bestTimeLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    } completion: { _ in
                        UIView.animate(withDuration: 0.2) {
                            self.clockLabel.transform = .identity
                            self.startLabel.transform = .identity
                            self.bestTimeLabel.transform = .identity
                        }
                    }
                }

                
            } else {
                lightDarkButton.setTitle("Dark", for: .normal)
                view.backgroundColor = .white
                lightDarkButton.setImage(UIImage(systemName: "moon.fill"), for: .normal)
                startLabel.textColor = .black
                clockLabel.textColor = .black
                bestTimeLabel.textColor = .black
                lightDarkButton.setTitleColor(.black, for: .normal)
                if let title = lightDarkButton.titleLabel?.text {
                    // Başlangıç ve hedef renkler
                    let startBackgroundColor: UIColor
                    let startClockLabelColor: UIColor
                    let startStartLabelColor: UIColor
                    let startBestTimeLabelColor: UIColor
                    
                    let endBackgroundColor: UIColor
                    let endClockLabelColor: UIColor
                    let endStartLabelColor: UIColor
                    let endBestTimeLabelColor: UIColor
                    
                    if title == "Dark" {
                        startBackgroundColor = view.backgroundColor ?? .black
                        startClockLabelColor = clockLabel.textColor ?? .white
                        startStartLabelColor = startLabel.textColor ?? .white
                        startBestTimeLabelColor = bestTimeLabel.textColor ?? .white
                        
                        endBackgroundColor = .white
                        endClockLabelColor = .black
                        endStartLabelColor = .black
                        endBestTimeLabelColor = .black
                    } else {
                        startBackgroundColor = view.backgroundColor ?? .lightGray
                        startClockLabelColor = clockLabel.textColor ?? .white
                        startStartLabelColor = startLabel.textColor ?? .white
                        startBestTimeLabelColor = bestTimeLabel.textColor ?? .white
                        
                        endBackgroundColor = .white
                        endClockLabelColor = .white
                        endStartLabelColor = .white
                        endBestTimeLabelColor = .white
                    }
                    
                    UIView.animate(withDuration: 0.2) {
                        self.view.backgroundColor = endBackgroundColor
                        self.clockLabel.textColor = endClockLabelColor
                        self.startLabel.textColor = endStartLabelColor
                        self.bestTimeLabel.textColor = endBestTimeLabelColor
                        
                        self.clockLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                        self.startLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                        self.bestTimeLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    } completion: { _ in
                        UIView.animate(withDuration: 0.2) {
                            self.clockLabel.transform = .identity
                            self.startLabel.transform = .identity
                            self.bestTimeLabel.transform = .identity
                        }
                    }
                }

            }
        }
    }
    
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayerView()
        prepareGame()
        configureModeButton()

        Task {
            await loadInterstitialAd()
        }
        
    }

    func configureModeButton() {
        lightDarkButton.setImage(UIImage(systemName: "moon.fill"), for: .normal)
        lightDarkButton.layer.cornerRadius = 12
        lightDarkButton.layer.masksToBounds = true
        lightDarkButton.layer.shadowColor = UIColor.black.cgColor
        lightDarkButton.layer.shadowOpacity = 0.5
        lightDarkButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        lightDarkButton.layer.shadowRadius = 4
        lightDarkButton.layer.borderColor = UIColor.black.cgColor
        lightDarkButton.layer.borderWidth = 2
        lightDarkButton.backgroundColor = .quaternarySystemFill
        lightDarkButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    
    
    func loadInterstitialAd() async {
        do {
            interstitial = try await GADInterstitialAd.load(
                withAdUnitID: "ca-app-pub-3940256099942544/4411468910", request: GADRequest())
            interstitial?.fullScreenContentDelegate = self
        } catch {
            print("Failed to load interstitial ad with error: \(error.localizedDescription)")
        }
    }
    
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        prepareGame()
    }
    func interstitialDidReceiveAd(_ ad: GADInterstitialAd) {
        print("Interstitial ad has been loaded successfully.")
    }
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameState == .ready {
            startGame()
        }
        
        if let touchLocation = event?.allTouches?.first?.location(in: view) {
            movePlayer(to: touchLocation)
            moveEnemies(to: touchLocation)
        }
//        guard let touch = touches.first else { return }
//        let touchLocation = touch.location(in: self.view)
        
        
    }
    
    
    
    // MARK: - Selectors
    @objc func generateEnemy(timer: Timer) {
        let screenEdge = ScreenEdge.init(rawValue: Int(arc4random_uniform(4)))
        let screenBounds = UIScreen.main.bounds
        var position: CGFloat = 0
        
        switch screenEdge! {
        case .left, .right:
            position = CGFloat(arc4random_uniform(UInt32(screenBounds.height)))
        case .top, .bottom:
            position = CGFloat(arc4random_uniform(UInt32(screenBounds.width)))
        }
        
        let enemyView = UIImageView(frame: .zero)
        enemyView.bounds.size = CGSize(width: 16, height: 16)
        enemyView.backgroundColor = getRandomColor()
        let imageNames = ["cat","cat2","cat3","cat4","cat5","cat6","cat7"]
        let randomCatIndex = Int(arc4random_uniform(UInt32(imageNames.count)))
        let randomImageCat = imageNames[randomCatIndex]
        let randomCat = UIImage(named: randomImageCat)
        enemyView.image = randomCat
        enemyView.layer.cornerRadius = 8
        enemyView.layer.masksToBounds = true
        
        switch screenEdge! {
        case .left:
            enemyView.center = CGPoint(x: 0, y: position)
        case .right:
            enemyView.center = CGPoint(x: screenBounds.width, y: position)
        case .top:
            enemyView.center = CGPoint(x: position, y: screenBounds.height)
        case .bottom:
            enemyView.center = CGPoint(x: position, y: 0)
        }
        
        view.addSubview(enemyView)
        
        // Start animation
        let duration = getEnemyDuration(enemyView: enemyView)
        let enemyAnimator = UIViewPropertyAnimator(duration: duration,
                                                   curve: .linear,
                                                   animations: { [weak self] in
            if let strongSelf = self {
                enemyView.center = strongSelf.playerView.center
            }
        }
        )
        enemyAnimator.startAnimation()
        enemyAnimators.append(enemyAnimator)
        enemyViews.append(enemyView)
    }
    
    @objc func tick(sender: CADisplayLink) {
        updateCountUpTimer(timestamp: sender.timestamp)
        checkCollision()
    }
}

fileprivate extension ViewController {
    
    func setupPlayerView() {
        playerView.backgroundColor = .systemBlue
        let imageNamesDog = ["1","2","3"]
        let randomDogIndex = Int(arc4random_uniform(UInt32(imageNamesDog.count)))
        let randomImageDog = imageNamesDog[randomDogIndex]
        let randomDog = UIImage(named: randomImageDog)
        playerView.image = randomDog
        playerView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        playerView.layer.cornerRadius = 17
        playerView.layer.masksToBounds = true
        view.addSubview(playerView)
    }
    
    func startEnemyTimer() {
        enemyTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(generateEnemy(timer:)), userInfo: nil, repeats: true)
    }
    
    func stopEnemyTimer() {
        guard let enemyTimer = enemyTimer,
              enemyTimer.isValid else {
            return
        }
        enemyTimer.invalidate()
    }
    
    func startDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(tick(sender:)))
        displayLink?.add(to: RunLoop.main, forMode: RunLoop.Mode.default)
    }
    
    func stopDisplayLink() {
        displayLink?.isPaused = true
        displayLink?.remove(from: RunLoop.main, forMode: RunLoop.Mode.default)
        displayLink = nil
    }
    
    func getRandomColor() -> UIColor {
        let index = arc4random_uniform(UInt32(colors.count))
        return colors[Int(index)]
    }
    
    func getEnemyDuration(enemyView: UIView) -> TimeInterval {
        let dx = playerView.center.x - enemyView.center.x
        let dy = playerView.center.y - enemyView.center.y
        return TimeInterval(sqrt(dx * dx + dy * dy) / enemySpeed)
    }
    
    func gameOver() {
        stopGame()
        displayGameOverAlert()
        print("Finish The Game")
        
    }
    
    func stopGame() {
        stopEnemyTimer()
        stopDisplayLink()
        stopAnimators()
        gameState = .gameOver
        view.isUserInteractionEnabled = false

    }
    
    func prepareGame() {
        getBestTime()
        removeEnemies()
        centerPlayerView()
        popPlayerView()
        startLabel.isHidden = false
        lightDarkButton.isHidden = false
        clockLabel.text = "00:00.000"
        gameState = .ready
        view.isUserInteractionEnabled = true

    }
    
    func startGame() {
        startEnemyTimer()
        startDisplayLink()
        startLabel.isHidden = true
        lightDarkButton.isHidden = true
        beginTimestamp = 0
        gameState = .playing
        
    }
    
    func removeEnemies() {
        enemyViews.forEach {
            $0.removeFromSuperview()
        }
        enemyViews = []
    }
    
    func stopAnimators() {
        playerAnimator?.stopAnimation(true)
        playerAnimator = nil
        enemyAnimators.forEach {
            $0.stopAnimation(true)
        }
        enemyAnimators = []
    }
    
    func updateCountUpTimer(timestamp: TimeInterval) {
        if beginTimestamp == 0 {
            beginTimestamp = timestamp
        }
        elapsedTime = timestamp - beginTimestamp
        clockLabel.text = format(timeInterval: elapsedTime)
    }
    
    func format(timeInterval: TimeInterval) -> String {
        let interval = Int(timeInterval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let milliseconds = Int(timeInterval * 1000) % 1000
        return String(format: "%02d:%02d.%03d", minutes, seconds, milliseconds)
    }
    
    func checkCollision() {
        enemyViews.forEach {
            guard let playerFrame = playerView.layer.presentation()?.frame,
                  let enemyFrame = $0.layer.presentation()?.frame,
                  playerFrame.intersects(enemyFrame) else {
                return
            }
            gameOver()
        }
    }
    
    func movePlayer(to touchLocation: CGPoint) {
        playerAnimator = UIViewPropertyAnimator(duration: playerAnimationDuration,
                                                dampingRatio: 0.5,
                                                animations: { [weak self] in
            self?.playerView.center = touchLocation
        })
        playerAnimator?.startAnimation()
    }
    
    func moveEnemies(to touchLocation: CGPoint) {
        for (index, enemyView) in enemyViews.enumerated() {
            let duration = getEnemyDuration(enemyView: enemyView)
            enemyAnimators[index] = UIViewPropertyAnimator(duration: duration,
                                                           curve: .linear,
                                                           animations: {
                enemyView.center = touchLocation
            })
            enemyAnimators[index].startAnimation()
        }
    }
    
    func displayGameOverAlert() {
        let (title, message) = getGameOverTitleAndMessage()
        let alert = UIAlertController(title: "Game Over", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: title, style: .default,
                                   handler: { _ in
            self.prepareGame()
            
            Task {
                await self.loadInterstitialAd()
                if let interstitial = self.interstitial {
                    interstitial.present(fromRootViewController: self)
                } else {
                    print("Interstitial ad wasn't ready.")
                }
            }
        }
        )
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func getGameOverTitleAndMessage() -> (String, String) {
        let elapsedSeconds = Int(elapsedTime) % 60
        setBestTime(with: format(timeInterval: elapsedTime))
        
        switch elapsedSeconds {
        case 0..<10: return ("Don't give up! 😅", "You'll get there! 💪")
        case 10..<30: return ("Try again! 😉", "Improving! Keep it up! 😄")
        case 30..<60: return ("One more round! 😉", "Fantastic! 👏")
        default:
            return ("Absolutely! 😚", "You're amazing! Keep playing! 🌟")
        }
        
    }
    
    func centerPlayerView() {
        playerView.center = view.center
    }
    
    func popPlayerView() {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [0, 0.2, -0.2, 0.2, 0]
        animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.duration = CFTimeInterval(0.7)
        animation.isAdditive = true
        animation.repeatCount = 1
        animation.beginTime = CACurrentMediaTime()
        playerView.layer.add(animation, forKey: "pop")
    }
    
    func setBestTime(with time:String){
        let defaults = UserDefaults.standard
        defaults.set(time, forKey: "lastTime")
        
    }
    
    func getBestTime(){
        let defaults = UserDefaults.standard
        
        if let time = defaults.value(forKey: "lastTime") as? String {
            self.bestTimeLabel.text = "Last Game: \(time)"
        }
    }
    
}
