//
//  Styles.swift
//  APPsistencia
//
//  Created by Francis on 25/10/2018.
//  Copyright © 2018 Francis. All rights reserved.
//

import Foundation
import UIKit

// Opacidad del color
private let opacity: CGFloat = 1.0

// Enumerado para los colores
// Aquí se tienen que definir los nombres de los colores de la app
enum Color
{
    case colorPrimary
    case colorPrimaryDark
    case colorAccent
    case black
    case red
    case ok
    case fail
    case naranja
    case blanco
}

// Obtiene un color combinado con la opcidad
// Aquí se tienen que definir los valores de los colores en RGB de la app
func getColor(color: Color, opacidad: CGFloat = opacity) -> UIColor
{
    let baseColor: UIColor
    
    switch color
    {
    case .colorPrimary:
        baseColor = UIColor(red: 0/255, green: 150/255, blue: 136/255, alpha: 100/100)
    case .colorPrimaryDark:
        baseColor = UIColor(red: 0/255, green: 121/255, blue: 107/255, alpha: 100/100)
    case .colorAccent:
        baseColor = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 100/100)
    case .black:
        baseColor = UIColor(red: 12/255, green: 0/255, blue: 51/255, alpha: 100/100)
    case .red:
        baseColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 100/100)
    case .ok:
        baseColor = UIColor(red: 0/255, green: 0/255, blue: 153/255, alpha: 100/100)
    case .fail:
        baseColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 100/100)
    case .naranja:
        baseColor = UIColor(red: 214/255, green: 181/255, blue: 1/255, alpha: 100/100)
    case .blanco:
        baseColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 100/100)
    }
    
    // Combine with the opacity
    return baseColor.withAlphaComponent(opacidad)
}

// Enumerado para el estilo de la letra
enum TextType
{
    case normal
    case bold
    case italic
    case italicbold
}

// Enumerado para
enum Emphasis
{
    case style1
    case style2
}

// Enumerado para la alineación del texto
enum Alignment
{
    case left
    case center
    case right
}

class TextStyle
{
    // variables
    private let tamanio: CGFloat
    private let emphasis: Emphasis
    private let color: Color
    let alignment: Alignment
    private let texttype: TextType
    
    // Constructor
    init(tamanio: CGFloat, color: Color, texttype: TextType, emphasis: Emphasis, alignment: Alignment)
    {
        self.tamanio = tamanio
        self.color = color
        self.emphasis = emphasis
        self.alignment = alignment
        self.texttype = texttype
    }
}

// MARK: - text style accessors
extension TextStyle
{
    /// Get the colour that should be used, taking into account both the colour and the opacity
    ///
    /// - Returns: the colour of the font
    var colorWithAlpha: UIColor
    {
        return getColor(color: color)
    }
    
    /// Get the font object that should be used for this text style
    ///
    /// - Returns: a UIFont, based on the style and the emphasis
    var font: UIFont
    {
        let weight: UIFont.Weight
        switch emphasis
        {
        case .style1:
            weight = UIFont.Weight.regular
        case .style2:
            weight = UIFont.Weight.semibold
        }
        
        var font = UIFont.systemFont(ofSize: tamanio, weight: weight)
        
        switch texttype
        {
        case .normal:
            font = font.desetBold().desetItalic()
        case .bold:
            font = font.setBold()
        case .italic:
            font = font.setItalic()
        case .italicbold:
            font = font.setItalic().setBold()
        }
        
        return font
    }
    
    /// Gets attributes for the styled font
    ///
    /// - Returns: the font and colour attributes
    var attributes: [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: colorWithAlpha]
    }
    
    /// Get an attributed string based on the styled font
    ///
    /// - Parameter string: the string
    /// - Returns: an attributed string
    func getAttributedString(string: String) -> NSAttributedString
    {
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    // Formatea el texto para un botón, dejando un espacio en blanco al principio y al final
    func getAttributedStringButton(string: String, backgroundcolor: Color) -> NSAttributedString
    {
        let atributosocultartexto = [NSAttributedString.Key.foregroundColor: getColor(color: backgroundcolor, opacidad: 0.0)]
        
        let textoformateado = NSMutableAttributedString(string: string, attributes: attributes)
        let espacio1 = NSMutableAttributedString(string: "_", attributes: atributosocultartexto)
        let espacio2 = NSMutableAttributedString(string: "_", attributes: atributosocultartexto)
        
        espacio1.append(textoformateado)
        espacio1.append(espacio2)
        
        return espacio1
    }
}

// Extensión para añadir estilos al UIButton
extension UIButton
{
    func setStyle(title: String, style textStyle: TextStyle, backgroundcolor: Color)
    {
        titleLabel?.font = textStyle.font
        tintColor = textStyle.colorWithAlpha
        setAttributedTitle(textStyle.getAttributedStringButton(string: title, backgroundcolor: backgroundcolor), for: .normal)
        
        let textAlignment: NSTextAlignment
        switch textStyle.alignment
        {
        case .center:
            textAlignment = .center
        case .left:
            textAlignment = .left
        case.right:
            textAlignment = .right
        }
        
        titleLabel?.textAlignment = textAlignment
        
        self.backgroundColor = getColor(color: backgroundcolor)
        
        layer.cornerRadius = 5
        clipsToBounds = true
    }
}

// // Extensión para añadir estilos al UILabel
extension UILabel
{
    func setStyle2(with textStyle: TextStyle)
    {
        font = textStyle.font
        textColor = textStyle.colorWithAlpha
        
        let textAlignment: NSTextAlignment
        switch textStyle.alignment
        {
        case .center:
            textAlignment = .center
        case .left:
            textAlignment = .left
        case.right:
            textAlignment = .right
        }
        self.textAlignment = textAlignment
    }
}

// Extensión para añadir estilos al UIView y a todo lo que herede de él, como por ejemplo el UIStackView
extension UIView
{
    func setStyle(with textStyle: TextStyle)
    {
        let subview = UIView(frame: bounds)
        subview.backgroundColor = textStyle.colorWithAlpha
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subview, at: 0)
    }
}

// Extensión para apadir padding al UIStackView
extension UIStackView
{
    func setPadding(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat)
    {
        layoutMargins = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        isLayoutMarginsRelativeArrangement = true
    }
}

// Extensión para añadir estilos al UIBarButtonItem
extension UIBarButtonItem
{
    func setStyle(with textStyle: TextStyle, for controlState: UIControl.State)
    {
        self.setTitleTextAttributes(textStyle.attributes, for: controlState)
    }
}

// Extensión de la clase UIFont para poner las letras en negrita y/o en cursiva
extension UIFont
{
    var isBold: Bool
    {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    
    var isItalic: Bool
    {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
    
    func setBold() -> UIFont
    {
        if(isBold)
        {
            return self
        }
        else
        {
            var fontAtrAry = fontDescriptor.symbolicTraits
            fontAtrAry.insert([.traitBold])
            let fontAtrDetails = fontDescriptor.withSymbolicTraits(fontAtrAry)
            return UIFont(descriptor: fontAtrDetails!, size: pointSize)
        }
    }
    
    func setItalic()-> UIFont
    {
        if(isItalic)
        {
            return self
        }
        else
        {
            var fontAtrAry = fontDescriptor.symbolicTraits
            fontAtrAry.insert([.traitItalic])
            let fontAtrDetails = fontDescriptor.withSymbolicTraits(fontAtrAry)
            return UIFont(descriptor: fontAtrDetails!, size: pointSize)
        }
    }
    func desetBold() -> UIFont
    {
        if(!isBold)
        {
            return self
        }
        else
        {
            var fontAtrAry = fontDescriptor.symbolicTraits
            fontAtrAry.remove([.traitBold])
            let fontAtrDetails = fontDescriptor.withSymbolicTraits(fontAtrAry)
            return UIFont(descriptor: fontAtrDetails!, size: pointSize)
        }
    }
    
    func desetItalic()-> UIFont
    {
        if(!isItalic)
        {
            return self
        }
        else
        {
            var fontAtrAry = fontDescriptor.symbolicTraits
            fontAtrAry.remove([.traitItalic])
            let fontAtrDetails = fontDescriptor.withSymbolicTraits(fontAtrAry)
            return UIFont(descriptor: fontAtrDetails!, size: pointSize)
        }
    }
}
