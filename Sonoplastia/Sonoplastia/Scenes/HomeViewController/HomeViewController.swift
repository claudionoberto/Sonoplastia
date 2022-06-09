//
//  ViewController.swift
//  Sonoplastia
//
//  Created by Claudio Noberto on 07/06/22.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController {
    lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
    lazy var player = AVAudioPlayer()
    var audios = [AudioModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sonoplastia"
        configTableView()
        configData()
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func configData() {
        let audioOne = AudioModel(name: "Ratinho", assetName: "Ratinho_audio")
        let audioTwo = AudioModel(name: "Ai", assetName: "Ai_audio")
        let audioThree = AudioModel(name: "Cavalo", assetName: "Cavalo_audio")
        let audioFour = AudioModel(name: "Dança Gatinho", assetName: "DancaGatinho_audio")
        let audioFive = AudioModel(name: "Demais", assetName: "Demais_audio")
        let audioSix = AudioModel(name: "Ele Gosta", assetName: "EleGosta_audio")
        let audioSeven = AudioModel(name: "Não", assetName: "Nao_audio")
        let audioEight = AudioModel(name: "Pare", assetName: "Pare_audio")
        let audioNine = AudioModel(name: "Rapaz", assetName: "Rapaz_audio")
        let audioTen = AudioModel(name: "Atumalaca", assetName: "Atumalaca_audio")
        let audioEleven = AudioModel(name: "Tome", assetName: "Tome_audio")
        let audioTwelve = AudioModel(name: "Tapa", assetName: "Tapa_audio")
        let audioThirteen = AudioModel(name: "Ui", assetName: "Ui_audio")
        let audioFourteen = AudioModel(name: "Vamo Dança", assetName: "VamoDancar_audio")
        
        [audioOne,
         audioTwo,
         audioThree,
         audioFour,
         audioFive,
         audioSix,
         audioSeven,
         audioEight,
         audioNine,
         audioTen,
         audioEleven,
         audioTwelve,
         audioThirteen,
         audioFourteen].forEach {audios.append($0)}
    }
    
    func configTableView() {
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func playAudio(audioName: String) {
        guard let path = Bundle.main.path(forResource: audioName, ofType: "mp3") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            player.play()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Sons"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let data = audios[indexPath.row]
        cell.textLabel?.text = data.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        playAudio(audioName: audios[indexPath.row].assetName)
    }
    
    func makeContextMenu(Data: AudioModel) -> UIMenu {
        let share = UIAction(title: "Compartilhar", image: UIImage(systemName: "square.and.arrow.up")) { action in
            let activityItem = URL.init(fileURLWithPath: Bundle.main.path(forResource: Data.assetName, ofType: "mp3")!)
            let activityVC = UIActivityViewController(activityItems: [activityItem],applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true)
        }
        return UIMenu(title: "", children: [share])
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let selectedCell = audios[indexPath.row]
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
            return self.makeContextMenu(Data: selectedCell)
        })
    }
}
