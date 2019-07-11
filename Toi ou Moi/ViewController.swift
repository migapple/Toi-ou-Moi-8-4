//
//  ViewController.swift
//  Toi ou Moi
//  Utilisé sur l'iphone
//  Created by Michel Garlandat on 18/05/2019.
//  Copyright © 2017 Michel Garlandat. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    var taches : [Tache]?

    var afficherTout = false
    var quoi = "Restau"
    var segment = 0
    
    @IBOutlet weak var titreViewController: UINavigationItem!
    @IBOutlet weak var nbToiLabel: UILabel!
    @IBOutlet weak var totToiLabel: UILabel!
    @IBOutlet weak var nbMoiLabel: UILabel!
    @IBOutlet weak var totMoiLabel: UILabel!
    @IBOutlet weak var quoiSegmentedControl: UISegmentedControl!
    @IBOutlet weak var maTableView: UITableView!
    @IBOutlet weak var TotalStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // initSetup()
        
        maTableView.dataSource = self
        maTableView.delegate = self
        
        let activite = readSetUp()
        
        for index in 0..<activite.activites!.count {
            quoiSegmentedControl.setTitle(activite.activites![index], forSegmentAt: index)
        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.gray
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        // put background view as the most background subviews of stack view
        TotalStackView.insertSubview(backgroundView, at: 0)
        
        // pin the background view edge to the stack view edge
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: TotalStackView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: TotalStackView.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: TotalStackView.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: TotalStackView.bottomAnchor)
            ])
    
        // clearData()
        setupData()

        // On charge le mois en cours avec la première activite
        loadData(moisEncours: 0, choix: activite.activites![0])

        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "fr_FR") as Locale
        dateFormatter.dateFormat = "MM/yyyy"
        
        let calendar = Calendar.current
        let dateDebutDeMois = startOfMonth()
        let dateDebutMoisPrécédent = calendar.date(byAdding: .month, value: 0, to: dateDebutDeMois)!
        
        titreViewController.title = dateFormatter.string(from: dateDebutMoisPrécédent)
        
        miseAjourTotal(taches: taches!)
        maTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let activite = readSetUp()
        
        // setupData()
        loadData(moisEncours: 0, choix: activite.activites![segment])
        miseAjourTotal(taches: taches!)
        maTableView.reloadData()
    }
    
    @IBAction func quoiSegmentedControlAction(_ sender: Any) {
        switch quoiSegmentedControl.selectedSegmentIndex {
        case 0:
            if let choix = quoiSegmentedControl.titleForSegment(at: 0) {
                quoi = choix
                loadData(moisEncours: 0, choix: quoi)
                miseAjourTotal(taches: taches!)
                maTableView.reloadData()
                segment = 0
            }
        case 1:
            if let choix = quoiSegmentedControl.titleForSegment(at: 1) {
                quoi = choix
                loadData(moisEncours: 0, choix: quoi)
                miseAjourTotal(taches: taches!)
                maTableView.reloadData()
                segment = 1
            }
        case 2:
            if let choix = quoiSegmentedControl.titleForSegment(at: 2) {
                quoi = choix
                loadData(moisEncours: 0, choix: quoi)
                miseAjourTotal(taches: taches!)
                maTableView.reloadData()
                segment = 2
            }
        case 3:
            if let choix = quoiSegmentedControl.titleForSegment(at: 3) {
                quoi = choix
                loadData(moisEncours: 0, choix: quoi)
                miseAjourTotal(taches: taches!)
                maTableView.reloadData()
                segment = 3
            }
        case 4:
            if let choix = quoiSegmentedControl.titleForSegment(at: 4) {
                quoi = choix
                 loadData(moisEncours: 0, choix: quoi)
                miseAjourTotal(taches: taches!)
                maTableView.reloadData()
                segment = 4
            }
        case 5:
            if let choix = quoiSegmentedControl.titleForSegment(at: 5) {
                quoi = choix
                 loadData(moisEncours: 0, choix: quoi)
                miseAjourTotal(taches: taches!)
                maTableView.reloadData()
                segment = 5
            }
        default:
            print("Erreur")
        }
    }
    
    @IBAction func Tout(_ sender: Any) {
        // On affiche toutes les données
        if afficherTout {
            loadData(moisEncours: 99, choix: quoi)
            afficherTout = false
            titreViewController.title = "Tout"
        } else {
            loadData(moisEncours: 0, choix: quoi)
            afficherTout = true
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "fr_FR") as Locale
            dateFormatter.dateFormat = "MM/yyyy"
            titreViewController.title = dateFormatter.string(from: startOfMonth())
        }
        
        miseAjourTotal(taches: taches!)
        maTableView.reloadData()
    }
    
    
    @IBAction func PlusMoinsStepper(_ sender: UIStepper) {
        // On se déplace de mois en mois
        let moisEncours = Int(sender.value)
        sender.maximumValue = 12
        sender.minimumValue = -12
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "fr_FR") as Locale
        dateFormatter.dateFormat = "MM/yyyy"
        
        let calendar = Calendar.current
        let dateDebutDeMois = startOfMonth()
        let dateDebutMoisPrécédent = calendar.date(byAdding: .month, value: moisEncours, to: dateDebutDeMois)!
        
        titreViewController.title = dateFormatter.string(from: dateDebutMoisPrécédent)
        loadData(moisEncours: moisEncours, choix: quoi)
        miseAjourTotal(taches: taches!)
        maTableView.reloadData()
    }
    
    @IBAction func poubelle(_ sender: Any) {
                let alertController:UIAlertController = UIAlertController(title: "Supression des données !", message: "Voulez-vous vraiment supprimer toutes les données ?", preferredStyle: .alert)
        
                let cancelAction = UIAlertAction(title: "Non, annuler", style: .cancel) { action -> Void in
                    // don't do anything
                }
        
                let nextAction = UIAlertAction(title: "Oui", style: .destructive) { action -> Void in
                    self.clearData()
                    self.taches = []
                    self.maTableView.reloadData()
                    self.miseAjourTotal(taches: self.taches!)
                }
        
                alertController.addAction(cancelAction)
                alertController.addAction(nextAction)
        
                self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func `import`(_ sender: Any) {
        let alertController:UIAlertController = UIAlertController(title: "Importation des données !", message: "Voulez-vous vraiment importer les données ?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Non, annuler", style: .cancel) { action -> Void in
            // don't do anything
        }
        
        let nextAction = UIAlertAction(title: "Oui", style: .destructive) { action -> Void in
            self.importFile()
            self.loadData(moisEncours: 99, choix: self.quoi)
            self.titreViewController.title = "Tout"
            self.miseAjourTotal(taches: self.taches!)
            self.maTableView.reloadData()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(nextAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func export(_ sender: Any) {
         exportDatabase()
    }
    
    func miseAjourTotal(taches: [Tache]) {
        var nbToi:Int = 0
        var nbMoi:Int = 0
        var totalToi:Double = 0
        var totalMoi:Double = 0
        
        if taches.count > 0 {
            for index in 0 ... taches.count-1 {
                let tache = taches[index]
                if tache.qui == "Toi" {
                    nbToi += 1
                    totalToi += tache.prix
                }
                
                if tache.qui == "Moi" {
                    nbMoi += 1
                    totalMoi += tache.prix
                }
            }
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.locale = Locale(identifier: "fr_FR")

        nbToiLabel.text = "\(nbToi)"
        let totToi1 = NSString(format:"%.2f€", totalToi) as String
        let totToi2 = totToi1.replacingOccurrences(of: ".", with: ",")
        totToiLabel.text = totToi2
        nbMoiLabel.text = "\(nbMoi)"
        let totMoi1 = NSString(format:"%.2f€", totalMoi) as String
        let totMoi2 = totMoi1.replacingOccurrences(of: ".", with: ",")
        totMoiLabel.text = totMoi2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK - Gestion de la TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Calcule le nombre de lignes à afficher
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = taches?.count {
            return count
        } else {
            return 0
        }
    }
    
    // affiche la cellule
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell") as? TableViewCell
        if let tache = taches?[indexPath.row] {
            cell.affiche(tache: tache)
            if tache.qui == "Toi" {
                // UIColor(cgColor: color Litteral
                cell.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1))
            } else {
                cell.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1))
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let tache = taches?[indexPath.row] {
            print(tache)
        }
    }
    
    // Suppression d'une ligne
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if editingStyle == .delete {
            if let tache = taches?[indexPath.row] {
                context.delete(tache)
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                loadData(moisEncours: 0, choix: quoi)
                miseAjourTotal(taches: taches!)
                maTableView.reloadData()
            }
        }
        
        if editingStyle == .insert {
            print("insert")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddEvtSegue" {
            let viewVC = segue.destination as! AjoutViewController
            viewVC.selection = segment
            viewVC.isEditing = false
        }
        
        if segue.identifier == "Modifier" {
            let indexPath = maTableView.indexPathForSelectedRow
            let tache = taches?[indexPath!.row]
            let viewVC = segue.destination as! AjoutViewController
            viewVC.isEditing = true
            viewVC.tache = tache
            viewVC.selection = segment
        }
    }
}
