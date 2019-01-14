//
//  BBCView.swift
//  bigboychoi
//
//  Created by Matt Wormley on 1/12/19.
//  Copyright © 2019 Matt Wormley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    weak var tableView: UITableView!
    
    var halfInningLabels:[UILabel] = []
    var game:Game = Game()
    var currentHalfInning = 0
    var players:[Player] = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName:nibNameOrNil, bundle:nibBundleOrNil)
        loadGame()
    }

    // note slightly new syntax for 2017
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        loadGame()
    }

    private func loadGame() {
        game.halfInnings[0].runsScored = 0

        players += [Player(name:"Matt", avatarURL:"https://en.wikipedia.org/wiki/Matt_Damon#/media/File:Matt_Damon_TIFF_2015.jpg")]
        players += [Player(name:"Bill", avatarURL:"https://en.wikipedia.org/wiki/Matt_Damon#/media/File:Matt_Damon_TIFF_2015.jpg")]
        players += [Player(name:"Dave", avatarURL:"https://en.wikipedia.org/wiki/Matt_Damon#/media/File:Matt_Damon_TIFF_2015.jpg")]
        players += [Player(name:"Dan", avatarURL:"https://en.wikipedia.org/wiki/Matt_Damon#/media/File:Matt_Damon_TIFF_2015.jpg")]

        var orderedPlayers = [0,1,2,3]
        for i in 0...17 {
            game.halfInnings[i].orderedPlayers = orderedPlayers
            orderedPlayers.append(orderedPlayers.removeFirst())
        }
    }
    override func loadView() {
        super.loadView()
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            self.view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: tableView.topAnchor),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            self.view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            ])
        self.tableView = tableView
    }

    override func viewDidLoad() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        self.tableView.dataSource = self

        for i in 0...8 {
            let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            headerLabel.center = CGPoint(x: 80 + i * 26, y: 574)
            headerLabel.textAlignment = .center
            headerLabel.text = String(i + 1)
            self.view.addSubview(headerLabel)
        }

        for i in 0...17 {
            let halfInningLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            let inning = i / 2
            let isTopInning = i % 2 == 0
            halfInningLabel.center = CGPoint(x: 80 + inning * 26, y: (isTopInning ? 600 : 626))
            halfInningLabel.textAlignment = .center
            self.view.addSubview(halfInningLabel)
            
            halfInningLabels += [halfInningLabel]
        }
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        changeHalfInning(newHalfInning:0)
        drawScoreboard()
    }

    private func changeHalfInning(newHalfInning:Int) {
        halfInningLabels[currentHalfInning].textColor = UIColor.black
        halfInningLabels[currentHalfInning].backgroundColor = UIColor.white
        currentHalfInning = newHalfInning
        halfInningLabels[currentHalfInning].textColor = UIColor.white
        halfInningLabels[currentHalfInning].backgroundColor = UIColor.black
        game.halfInnings[currentHalfInning].runsScored = 0
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            if (currentHalfInning < 17) {
                changeHalfInning(newHalfInning:currentHalfInning + 1)
            }
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.left {
            if (currentHalfInning > 0) {
                changeHalfInning(newHalfInning:currentHalfInning - 1)
            }
        }
        
        var scoreBump = 0
        if gesture.direction == UISwipeGestureRecognizerDirection.up {
            scoreBump = +1
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.down {
            scoreBump = -1
        }
        if scoreBump != 0 {
            if let oldRunsScored = game.halfInnings[currentHalfInning].runsScored {
                game.halfInnings[currentHalfInning].runsScored = oldRunsScored + scoreBump
                if game.halfInnings[currentHalfInning].runsScored! < 0 {
                    game.halfInnings[currentHalfInning].runsScored = 0
                }
            } else {
                game.halfInnings[currentHalfInning].runsScored = 0
            }
        }
        drawScoreboard()
    }
    
    private func drawScoreboard() {
        let currentHalfInningLabel = halfInningLabels[currentHalfInning]
        let currentHalfInningData = game.halfInnings[currentHalfInning]
        
        currentHalfInningLabel.text = String(currentHalfInningData.runsScored!)
        currentHalfInningLabel.textColor = UIColor.white
        currentHalfInningLabel.backgroundColor = UIColor.green
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let halfInningData = self.game.halfInnings[self.currentHalfInning]
        let player = self.players[halfInningData.orderedPlayers[indexPath.item]]
        cell.textLabel?.text = player.name
        return cell
    }
}
