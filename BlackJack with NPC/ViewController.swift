//
//  ViewController.swift
//  BlackJack with NPC
//
//  Created by Ryan Lin on 2022/10/9.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var ppImageViews: [UIImageView]!
    @IBOutlet var npcImageViews: [UIImageView]!
    @IBOutlet weak var npcPointLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var betLabel: UILabel!
    @IBOutlet weak var showSegmentedControl: UISegmentedControl!
    @IBOutlet weak var showReduceBetButton: UIButton!
    @IBOutlet weak var showIncreaceBetButton: UIButton!
    @IBOutlet weak var showRefillMoneyButton: UIButton!
    @IBOutlet weak var chipsLabel: UILabel!
    @IBOutlet weak var playerPointLabel: UILabel!
    
    @IBOutlet var playerImageViews: [UIImageView]!
    
    @IBOutlet weak var showDealButton: UIButton!
    @IBOutlet weak var showHitButton: UIButton!
    @IBOutlet weak var showStandButton: UIButton!
    
    //發明兩個array去存所有的花色和數字，在使用迴圈產生牌組
    var suits = ["♠️","♥️","♦️","♣️"]
    var ranks = ["A","2","3","4","5","6","7","8","9","10","J","Q","K"]
    //發明兩個空的撲克牌的array 玩家和npc，裏面裝著Card的型別
    var playerCards = [Card]()
    var npcCards = [Card]()
    
    //給HIT加牌按鈕使用的index
    var index = 1
    
    //npc前兩張牌單一點數
    var npcPoint1 = 0
    //npc兩張卡點數總和
    var npc2CardPoint = 0
    //npc後三張牌單一點數
    var npcPoint2 = 0
    //npc卡牌3~5的點數總和
    var npc3to5CardPoint = 0
    //npc總點數
    var npcSumPoint = 0
    
    var point = 0
    //player前兩張牌單一點數
    var playerPoint1 = 0
    //player卡牌1~2的點數總和
    var player2CardPoint = 0
    //player後三張牌單一點數
    var playerPoint2 = 0
    //player卡牌3~5的點數總和
    var player3to5CardPoint = 0
    //player總點數
    var playerSumPoint = 0
    
    //賭注金額
    var bet = 500
    //減去賭金後剩餘的籌碼
    var chips = 2000
    
    override func viewDidLoad() {
        super.viewDidLoad()

        betLabel.text = String("💸 \(bet)")
        chipsLabel.text = String("💸 \(chips)")
        //全部label變圓角
        npcPointLabel.layer.cornerRadius = 15
        infoLabel.layer.cornerRadius = 15
        playerPointLabel.layer.cornerRadius = 15
        betLabel.layer.cornerRadius = 15
        chipsLabel.layer.cornerRadius = 15
        //bet跟chips label加入邊框跟顏色
        betLabel.layer.borderWidth = 2
        betLabel.layer.borderColor = UIColor.blue.cgColor
        chipsLabel.layer.borderWidth = 2
        chipsLabel.layer.borderColor = UIColor.blue.cgColor
        //npc跟player point label加入邊框跟顏色
        npcPointLabel.layer.borderWidth = 2
        npcPointLabel.layer.borderColor = UIColor.systemGray6.cgColor
        playerPointLabel.layer.borderWidth = 2
        playerPointLabel.layer.borderColor = UIColor.systemGray6.cgColor
        //給ppImageView加上邊框顏色
        for i in 0...2 {
            ppImageViews[i].layer.borderWidth = CGFloat(2)
            ppImageViews[i].layer.borderColor = UIColor.systemOrange.cgColor
        }
        for suit in suits {
            for rank in ranks {
                //把迴圈產生的52張牌存入card
                let card = Card(suit: suit, rank: rank)
                ////把card加進array playerCards和npcCards裏面
                playerCards.append(card)
                npcCards.append(card)
            }
        }
    }
    
    fileprivate func initialization() {
        
        showDealButton.isEnabled = false
        
        //隱藏npc跟player後面3張牌
        for i in 2...4 {
            npcImageViews[i].isHidden = true
            playerImageViews[i].isHidden = true
        }
        //顯示三隻pp
        for i in 0...2 {
            ppImageViews[i].isHidden = false
        }
        //覆蓋npc第五張牌，讓牌看起來像背景
        ppImageViews[3].layer.isHidden = false
        ppImageViews[3].layer.borderWidth = CGFloat(2)
        ppImageViews[3].layer.borderColor = UIColor(red: 58/255, green: 153/255, blue: 168/255, alpha: 1).cgColor
        
        showStandButton.isEnabled = true
        
        npcPointLabel.text = ""
        infoLabel.text = String("🦄 BLACK JACK 🐽")
        //洗牌
        playerCards.shuffle()
        npcCards.shuffle()
        
        index = 1
        
        point = 0
        playerPoint1 = 0
        player2CardPoint = 0
        playerPoint2 = 0
        player3to5CardPoint = 0
        playerSumPoint = 0
        
        npcPoint1 = 0
        npcPoint2 = 0
        npc2CardPoint = 0
        npc3to5CardPoint = 0
        npcSumPoint = 0
        
        //給npc跟player影像加上邊框
        for i in 0...4 {
            npcImageViews[i].layer.borderWidth = CGFloat(2)
            npcImageViews[i].layer.borderColor = UIColor.systemOrange.cgColor
            playerImageViews[i].layer.borderWidth = CGFloat(2)
            playerImageViews[i].layer.borderColor = UIColor.systemOrange.cgColor
        }
    }
    
    @IBAction func dealButton(_ sender: UIButton) {
        initialization()
        showReduceBetButton.isEnabled = false
        showIncreaceBetButton.isEnabled = false

        if bet > 0 {
            //發給玩家兩張牌，用迴圈設定牌組的圖片顯示
            for player in 0...1 {
                playerImageViews[player].image = UIImage(named: "\(playerCards[player].suit)\(playerCards[player].rank)")
                //設定每張牌可得的點數
                //兩張A等於12
                if playerCards[0].rank == "A" && playerCards[1].rank == "A" {
                    
                    player2CardPoint = 12
                    playerPointLabel.text = "\(player2CardPoint)"
                    print("player got AA okay")
                    
                } else {
                    if playerCards[player].rank == "A" {
                        playerPoint1 = 11
                    } else if playerCards[player].rank == "J" || playerCards[player].rank == "Q" || playerCards[player].rank == "K" {
                        playerPoint1 = 10
                    } else {
                        playerPoint1 = Int(playerCards[player].rank)!
                    }
                    //player前兩張牌的點數
                    player2CardPoint += playerPoint1
                    playerPointLabel.text = "\(player2CardPoint)"
                }
            }
            
            //發給npc兩張牌
            for npcCard in 0...1 {
                npcImageViews[npcCard].image = UIImage(named: "\(npcCards[npcCard].suit)\(npcCards[npcCard].rank)")
                //設定點數
                //兩張A等於12
                if npcCards[0].rank == "A" && npcCards[1].rank == "A" {
                    npc2CardPoint = 12
                } else {
                    if npcCards[npcCard].rank == "A" {
                        npcPoint1 = 11
                    } else if npcCards[npcCard].rank == "J" || npcCards[npcCard].rank == "Q" || npcCards[npcCard].rank == "K" {
                        npcPoint1 = 10
                    } else {
                        npcPoint1 = Int(npcCards[npcCard].rank)!
                    }
                    //npc前兩張牌點數
                    npc2CardPoint += npcPoint1
                }
            }
            //npc前兩張牌大於等於17，則顯示點數
            if npc2CardPoint >= 17 {
                npcSumPoint = npc2CardPoint
                print("npc兩張卡 大於17")
                //npc前兩張牌不足17，則需加牌
            } else if npc2CardPoint < 17 {
                //npc加牌迴圈
                for i in 2...4 {
                    //npc總點數不足17，則需加牌
                    if npcSumPoint < 17 {
                        //顯示run到的牌
                        npcImageViews[i].isHidden = false
                        npcImageViews[i].image = UIImage(named: "\(npcCards[i].suit)\(npcCards[i].rank)")
                        
                        //設定點數
                        if npcCards[i].rank == "A" {
                            npcPoint2 = 1
                        } else if npcCards[i].rank == "J" || npcCards[i].rank == "Q" || npcCards[i].rank == "K" {
                            npcPoint2 = 10
                        } else {
                            npcPoint2 = Int(npcCards[i].rank)!
                        }
                        //npc後三張牌的點數相加
                        npc3to5CardPoint += npcPoint2
                        //npc前兩張加後三張的點數
                        npcSumPoint = npc2CardPoint + npc3to5CardPoint
                        if npcSumPoint > 21 {
                            print("deal npc > 21")
                        } else if npcSumPoint <= 21 {
                            print("deal npc <= 21")
                        }
                    }
                }
            }
            if player2CardPoint == 21 {
                sender.isEnabled = true
                showHitButton.isEnabled = false
                showStandButton.isEnabled = false
                infoLabel.text = "YOU WIN ! BLACK JACK !"
                chips += (bet*2)
                betLabel.text = "💸 \(bet)"
                chipsLabel.text = "💸 \(chips)"
                showIncreaceBetButton.isEnabled = true
                showReduceBetButton.isEnabled = true
                print("player 兩張卡 21點 okay")
            } else{
                showHitButton.isEnabled = true
            }
        //未下賭金時
        } else if bet == 0 {
            sender.isEnabled = true
            infoLabel.text = "Please Place Your Bet !"
            showStandButton.isEnabled = false
            showReduceBetButton.isEnabled = false
            showIncreaceBetButton.isEnabled = true
            npcPointLabel.text = ""
            playerPointLabel.text = ""
            print("deal no bet")
        }
    }
    fileprivate func hitResultSeting() {
        showDealButton.isEnabled = true
        showStandButton.isEnabled = false
        showReduceBetButton.isEnabled = true
        showIncreaceBetButton.isEnabled = true
    }
    func lose() {
        bet -= bet
        betLabel.text = "💸 \(bet)"
        showReduceBetButton.isEnabled = true
        showIncreaceBetButton.isEnabled = true
        
        if chips == 0 {
            showReduceBetButton.isEnabled = false
            showIncreaceBetButton.isEnabled = false
            showDealButton.isEnabled = false
            showHitButton.isEnabled = false
            showStandButton.isEnabled = false
            showRefillMoneyButton.isEnabled = true
            infoLabel.text = "NPC WIN ! Press 💰 to get 💸💸"
        }
    }
    fileprivate func showBetChipsLabel() {
        betLabel.text = "💸 \(bet)"
        chipsLabel.text = "💸 \(chips)"
    }
    func showNpcPoint() {
        switch npcSumPoint {
        case 2...21 :
            npcPointLabel.text = "\(npcSumPoint)"
        default:
            npcPointLabel.text = "\(npcSumPoint) BUST🐽"
        }
    }
    @IBAction func hitButton(_ sender: UIButton) {
        showDealButton.isEnabled = false
        index += 1
        playerImageViews[index].isHidden = false
        playerImageViews[index].image = UIImage(named: "\(playerCards[index].suit)\(playerCards[index].rank)")
        //設定每張牌可得的點數
        if playerCards[index].rank == "A" {
            playerPoint2 = 1
        }else if playerCards[index].rank == "J" || playerCards[index].rank == "Q" || playerCards[index].rank == "K" {
            playerPoint2 = 10
        } else {
            playerPoint2 = Int(playerCards[index].rank)!
        }
        //player後三張牌的點數相加
        player3to5CardPoint += playerPoint2
        //player前兩張加後三張的點數
        playerSumPoint = player2CardPoint + player3to5CardPoint
        playerPointLabel.text = "\(playerSumPoint)"
        //player21點或是超過21點結果，ＨIT BUTTON即失效
        if playerSumPoint == 21, npcSumPoint == 21 {
            //隱藏三隻pp跟第四張coverImageView
            for i in 0...3 {
                ppImageViews[i].isHidden = true
            }
            infoLabel.text = "TIE !"
            sender.isEnabled = false
            hitResultSeting()
            showNpcPoint()
            print("HIT result 1")
        } else if playerSumPoint == 21, npcSumPoint > playerSumPoint {
            //隱藏三隻pp跟第四張coverImageView
            for i in 0...3 {
                ppImageViews[i].isHidden = true
            }
            infoLabel.text = "YOU WIN !"
            chips += bet
            showBetChipsLabel()
            sender.isEnabled = false
            hitResultSeting()
            showNpcPoint()
            print("HIT result 2 okay $")
        } else if playerSumPoint == 21, npcSumPoint < playerSumPoint {
            //隱藏三隻pp跟第四張coverImageView
            for i in 0...3 {
                ppImageViews[i].isHidden = true
            }
            infoLabel.text = "YOU WIN !"
            chips += bet
            showBetChipsLabel()
            sender.isEnabled = false
            hitResultSeting()
            showNpcPoint()
            print("HIT result 3 okay $ okay")
        } else if playerSumPoint < 22, index == 4 {
            //隱藏三隻pp跟第四張coverImageView
            for i in 0...3 {
                ppImageViews[i].isHidden = true
            }
            infoLabel.text = "YOU WIN ! FIVE CARDS"
            chips += (bet*2)
            showBetChipsLabel()
            sender.isEnabled = false
            hitResultSeting()
            showNpcPoint()
            print("HIT result 4 okay $")
        } else if playerSumPoint > 21, npcSumPoint > 21 {
            //隱藏三隻pp跟第四張coverImageView
            for i in 0...3 {
                ppImageViews[i].isHidden = true
            }
            sender.isEnabled = false
            infoLabel.text = "TIE !"
            playerPointLabel.text = "\(playerSumPoint) BUST !"
            hitResultSeting()
            showNpcPoint()
            print("HIT result 5 okay")
        } else if playerSumPoint > 21, npcSumPoint <= 21 {
            //隱藏三隻pp跟第四張coverImageView
            for i in 0...3 {
                ppImageViews[i].isHidden = true
            }
            hitResultSeting()
            infoLabel.text = "NPC WIN !"
            playerPointLabel.text = "\(playerSumPoint) BUST !"
            lose()
            sender.isEnabled = false
            showNpcPoint()
            print("HIT result 6 okay $ okay")
        }
    }
    fileprivate func standResultSeting() {
        chips += bet
        betLabel.text = "💸 \(bet)"
        chipsLabel.text = "💸 \(chips)"
        showReduceBetButton.isEnabled = true
        showIncreaceBetButton.isEnabled = true
    }
    fileprivate func showReInButton() {
        showReduceBetButton.isEnabled = true
        showIncreaceBetButton.isEnabled = true
    }
    @IBAction func standButton(_ sender: UIButton) {
        showDealButton.isEnabled = true
        showHitButton.isEnabled = false
        //隱藏三隻pp跟第四張coverImageView
        for i in 0...3 {
            ppImageViews[i].isHidden = true
        }
        
        if player2CardPoint > playerSumPoint {
            
            if player2CardPoint > npcSumPoint {
                infoLabel.text = "YOU WIN !"
                standResultSeting()
                showNpcPoint()
                print("result 1 okay $ okay")
            } else if player2CardPoint < npcSumPoint, npcSumPoint > 21 {
                infoLabel.text = "YOU WIN !"
                standResultSeting()
                showNpcPoint()
                print("result 2 okay $ okay")
            } else if player2CardPoint < npcSumPoint {
                infoLabel.text = "NPC WIN !"
                showNpcPoint()
                lose()
                print("result 3 okay $ okay")
            } else if player2CardPoint == npcSumPoint {
                infoLabel.text = "TIE !"
                showReInButton()
                showNpcPoint()
                print("result 4 okay")
            }
        } else {
            //npc player都沒爆，同分
            if playerSumPoint == npcSumPoint {
                infoLabel.text = "TIE !"
                showReInButton()
                showNpcPoint()
                print("result 5 okay ")
                //npc player都沒爆，player大
            } else if playerSumPoint > npcSumPoint, playerSumPoint < 22{
                infoLabel.text = "YOU WIN !"
                standResultSeting()
                showNpcPoint()
                print("result 6 okay $ okay")
                //npc爆，player沒爆
            } else if playerSumPoint <= 21, npcSumPoint > 21 {
                infoLabel.text = "YOU WIN !"
                npcPointLabel.text = "\(npcSumPoint) BUST !"
                standResultSeting()
                showNpcPoint()
                print("result 7 okay $ okay")
                //npc player都沒爆，player小
            } else if playerSumPoint < npcSumPoint, npcSumPoint < 22{
                infoLabel.text = "NPC WIN !"
                showNpcPoint()
                lose()
                print("result 8 okay $ okay")
            }
        }
        sender.isEnabled = false
    }
    @IBAction func refillMoneyButton(_ sender: UIButton) {
        bet = 500
        chips = 2000
        infoLabel.text = "🦄 BLACK JACK 🐽"
        showDealButton.isEnabled = true
        showBetChipsLabel()
        showReInButton()
        sender.isEnabled = false
    }
    @IBAction func reduceBetButton(_ sender: UIButton) {
        showIncreaceBetButton.isEnabled = true
        switch  showSegmentedControl.selectedSegmentIndex  {
        case 0:
            switch bet  {
            case  0 :
                sender.isEnabled = false
                infoLabel.text = "Press + to Place Your Bet"
            case 100 :
                sender.isEnabled = false
                infoLabel.text = "Mininal Bet: 💸 $100"
            default:
                bet -= 100
                chips += 100
            }
        default :
            switch bet {
            case 300 :
                bet = 100
                chips += 200
                sender.isEnabled = false
                infoLabel.text = "Mininal Bet: 💸 $100"
            case 200 :
                bet = 100
                chips += 100
                sender.isEnabled = false
                infoLabel.text = "Mininal Bet: 💸 $100"
            case 100 :
                sender.isEnabled = false
                infoLabel.text = "Mininal Bet: 💸 $100"
            case 0 :
                sender.isEnabled = false
                infoLabel.text = "Press + to Place Your Bet"
            default :
                bet -= 300
                chips += 300
            }
        }
        showBetChipsLabel()
    }
    @IBAction func increaseBetButton(_ sender: UIButton) {
        showReduceBetButton.isEnabled = true
        switch showSegmentedControl.selectedSegmentIndex  {
        case 0 :
            switch chips  {
            case 0:
                sender.isEnabled = false
                infoLabel.text = "Maximal Bet: 💸 $\(bet+chips)"
            default :
                bet += 100
                chips -= 100
            }
        default :
            switch chips  {
            case 200:
                bet += 200
                chips -= 200
                sender.isEnabled = false
                infoLabel.text = "Maximal Bet: 💸 $\(bet+chips)"
            case 100:
                bet += 100
                chips -= 100
                sender.isEnabled = false
                infoLabel.text = "Maximal Bet: 💸 $\(bet+chips)"
            case  0:
                sender.isEnabled = false
                infoLabel.text = "Maximal Bet: 💸 $\(bet+chips)"
            default:
                bet += 300
                chips -= 300
            }
        }
        showBetChipsLabel()
    }
}
