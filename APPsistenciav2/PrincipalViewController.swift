//
//  PrincipalViewController.swift
//  APPsistenciav2
//
//  Created by Francis on 25/01/2019.
//  Copyright © 2019 Francis. All rights reserved.
//

import UIKit
import EventKit
//import MMDrawerController
import NavigationDrawer

class PrincipalViewController: UIViewController, CalendarViewDataSource, CalendarViewDelegate
{
    @IBOutlet weak var lUsuarioLlega: UILabel!
    @IBOutlet weak var bBotonCerrar: UIButton!
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var lavisopulsadoprolongado: UILabel!
    
    var usuario = "";
    //1.
    let interactor = Interactor()
    
    // Hago que se muestre la barra de status
    /*override var prefersStatusBarHidden: Bool {
     return false
     }*/
    
    @IBAction func funcionalidadBotonMesAnterior(_ sender: UIButton)
    {
        self.calendarView.goToPreviousMonth()
    }
    
    @IBAction func funcionalidadBotonMesSiguiente(_ sender: UIButton)
    {
        self.calendarView.goToNextMonth()
    }
    
    //2.
    @objc func abrirCerrarDrawer()
    {
        performSegue(withIdentifier: "showSlidingMenu", sender: nil)
        /*let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)*/
    }
    
    //3. Add a Pan Gesture to slide the menu from Certain Direction
    @IBAction func edgePanGesture(sender: UIScreenEdgePanGestureRecognizer)
    {
        let translation = sender.translation(in: view)
        
        let progress = MenuHelper.calculateProgress(translationInView: translation, viewBounds: view.bounds, direction: .Right)
        
        MenuHelper.mapGestureStateToInteractor(
            gestureState: sender.state,
            progress: progress,
            interactor: interactor)
            {
                self.performSegue(withIdentifier: "showSlidingMenu", sender: nil)
            }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //self.navigationItem.setHidesBackButton(true, animated:true)
        //self.navigationItem.title = "APPsistencia"
        
        // Cambio el icono de la barra de navegación por el típico de la hamburguesa para el menú
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage(named: "icons8-menu.pdf"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(abrirCerrarDrawer), for: UIControl.Event.touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
        //self.navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(abrirCerrarDrawer)), animated: true)
        
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "test", style: .done, target: self, action: #selector(abrirCerrarDrawer))
        
        // Pillo el usuario guardado
        let preferencias = UserDefaults.standard
        usuario = preferencias.object(forKey: "usuario") as! String
        lUsuarioLlega.text = usuario + CORREO
        
        lavisopulsadoprolongado.text = "Pulse prolongadamente sobre un día para anotar asistencias."
        
        aplicarEstilos()
    }
    
    //4. Prepare for segue
    // Este método se ejecuta cuando hay un cambio de pantalla
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let destinationViewController = segue.destination as? SlidingViewController
        {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = self.interactor
        }
        // Pongo el texto del navigation view a nulo
        //navigationItem.title = nil
        // Si se ejecuta el segue pizza se ejecuta esto
        if segue.identifier == "seguecerrarsesion"
        {
            // Elimino las preferencias
            let defaults = UserDefaults.standard
            defaults.set(usuario, forKey: "")
            defaults.set(false, forKey: "recordarme")
            // Cambio el texto del botón atrás
            //navigationItem.title = ""
            // Creo un navigation view y le pongo texto en el centro
            let vc = segue.destination as UIViewController
            vc.navigationItem.title = "APPsistencia"
            // Deshabilito el botón de atrás
            vc.navigationItem.hidesBackButton = true
        }
    }
    
    func aplicarEstilos() -> Void
    {
        bBotonCerrar.imageView?.contentMode = .scaleAspectFit
        
        lUsuarioLlega.setStyle2(with: estilotextousuarioconectado)
        lavisopulsadoprolongado.setStyle2(with: estilotextousuarioconectadocentrado)
        
        // Estilos del calendario
        CalendarView.Style.cellShape                = .bevel(8.0)
        CalendarView.Style.cellColorDefault         = UIColor.clear
        CalendarView.Style.cellColorToday           = UIColor(red:1.00, green:0.84, blue:0.64, alpha:1.00)
        CalendarView.Style.cellSelectedBorderColor  = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        CalendarView.Style.cellEventColor           = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        CalendarView.Style.headerTextColor          = UIColor.white
        CalendarView.Style.cellTextColorDefault     = UIColor.white
        CalendarView.Style.cellTextColorToday       = UIColor(red:0.31, green:0.44, blue:0.47, alpha:1.00)
        
        CalendarView.Style.firstWeekday             = .monday
        
        calendarView.dataSource = self
        calendarView.delegate = self
        
        calendarView.direction = .horizontal
        calendarView.multipleSelectionEnable = false
        calendarView.marksWeekends = true
        
        calendarView.backgroundColor = UIColor(red:0.31, green:0.44, blue:0.47, alpha:1.00)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        let today = Date()
        
        /*var tomorrowComponents = DateComponents()
         tomorrowComponents.day = 1*/
        
        //let tomorrow = self.calendarView.calendar.date(byAdding: tomorrowComponents, to: today)!
        // Hago que la fecha actual esté seleccionada
        self.calendarView.selectDate(today)
        
        // Carga los eventos
        /*self.calendarView.loadEvents() { error in
         if error != nil {
         let message = "The karmadust calender could not load system events. It is possibly a problem with permissions"
         let alert = UIAlertController(title: "Events Loading Error", message: message, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
         self.present(alert, animated: true, completion: nil)
         }
         }*/
        // Muestro el calendario en la fecha actual
        self.calendarView.setDisplayDate(today)
    }
    
    // ***** Funciones del protocolo KDCalendarDataSource *****
    
    // Fecha de inicio del calendario
    func startDate() -> Date
    {
        // La fecha de inicio del calendario va a ser dos años antes de la fecha actual
        var dateComponents = DateComponents()
        dateComponents.year = -2
        let today = Date()
        let threeMonthsAgo = self.calendarView.calendar.date(byAdding: dateComponents, to: today)!
        return threeMonthsAgo
    }
    
    // Fecha de fin del calendario
    func endDate() -> Date
    {
        // La fecha fin del calendario va a ser 2 años después de la fecha actual
        var dateComponents = DateComponents()
        dateComponents.year = 2;
        let today = Date()
        let twoYearsFromNow = self.calendarView.calendar.date(byAdding: dateComponents, to: today)!
        return twoYearsFromNow
    }
    
    // ********************************************************
    
    // ***** Funciones del protocolo KDCalendarDelegate *****
    
    // Funcionalidad para cuando se hace doble click sobre un día
    func calendar(_ calendar: CalendarView, didSelectDate date : Date, withEvents events: [CalendarEvent])
    {
        /*print("Did Select: \(date) with \(events.count) events")
         for event in events {
         print("\t\"\(event.title)\" - Starting at:\(event.startDate)")
         }*/
        //print("Doble click sobre el día \(date)")
    }
    
    // Funcionalidad para cuando cambias el mes del calendario haciendo scroll para un lado
    func calendar(_ calendar: CalendarView, didScrollToMonth date : Date)
    {
        //self.datePicker.setDate(date, animated: true)
    }
    
    // Funcionalidad para cuando pulsas prolongadamente un día
    func calendar(_ calendar: CalendarView, didLongPressDate date : Date)
    {
        //print("Click prolongado sobre el día \(date)")
        /*let alert = UIAlertController(title: "Create New Event", message: "Message", preferredStyle: .alert)
         
         alert.addTextField { (textField: UITextField) in
         textField.placeholder = "Event Title"
         }
         
         let addEventAction = UIAlertAction(title: "Create", style: .default, handler: { (action) -> Void in
         let title = alert.textFields?.first?.text
         self.calendarView.addEvent(title!, date: date)
         })
         
         let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
         
         alert.addAction(addEventAction)
         alert.addAction(cancelAction)
         
         self.present(alert, animated: true, completion: nil)*/
        
    }
    
    // ******************************************************

}

extension PrincipalViewController: UIViewControllerTransitioningDelegate
{    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentMenuAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
