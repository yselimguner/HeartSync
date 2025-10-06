//
//  OnboardingViewController.swift
//  HeartSync
//
//  Created by Yavuz Selim Güner on 5.10.2025.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var barProgressView: UIProgressView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var firstImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var firstButtonView: UIView!
    @IBOutlet weak var firstButtonLabel: UILabel!
    
    
    @IBOutlet weak var secondButtonView: UIView!
    @IBOutlet weak var secondButtonLabel: UILabel!
    @IBOutlet weak var whichPageLabel: UILabel!
    
    @IBOutlet weak var selectDateTextField: UITextField!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    private var currentPage = 0
    private let totalPages = 5
    private let datePicker = UIDatePicker()
    private var selectedDate: Date?
    private var inviteCode = ""
    
    
    // Onboarding içeriği
    private let onboardingData: [(image: String, title: String, description: String)] = [
        (
            image: "heart.circle.fill",
            title: "HeartSync'e Hoş Geldin",
            description: "Sevdiğin kişiyle duygusal bağını güçlendir. Her gün birbirinizin kalbini hisset."
        ),
        (
            image: "person.2.fill",
            title: "Bağlantı Kur",
            description: "Partnerinle eşleş ve gerçek zamanlı olarak kalp atışlarınızı paylaş."
        ),
        (
            image: "sparkles",
            title: "Anıları Paylaş",
            description: "Özel anlarınızı kaydet ve birlikte geçirdiğiniz her anı ölümsüzleştir."
        ),
        (
            image: "calendar.badge.clock",
            title: "İlişkiniz Ne Zaman Başladı?",
            description: "O özel günü seç ve her yıl birlikte kutlayalım. ❤️"
        ),
        (
            image: "link.circle.fill",
            title: "Partnerinle Bağlan",
            description: "Davet kodunu paylaş veya partnerinin kodunu gir."
        )
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ONBOARDING EKRANI")
        setupUI()
        updatePageContent()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyGradientBackground()
        applyFirstViewGradient()
    }
    
    
    private func setupUI() {
        // Progress bar ayarları
        barProgressView.progress = 0.33
        barProgressView.progressTintColor = UIColor(red: 255/255, green: 105/255, blue: 180/255, alpha: 1)
        barProgressView.trackTintColor = UIColor.white.withAlphaComponent(0.3)
        barProgressView.layer.cornerRadius = 4
        barProgressView.clipsToBounds = true
        
        // First view ayarları
        firstView.layer.cornerRadius = 24
        firstView.clipsToBounds = true
        
        // İmage view ayarları
        firstImageView.contentMode = .scaleAspectFit
        firstImageView.tintColor = .white
        
        // Button view ayarları
        setupButton(firstButtonView, label: firstButtonLabel)
        setupButton(secondButtonView, label: secondButtonLabel)
        
        // Tap gesture'ları ekle
        let firstButtonTap = UITapGestureRecognizer(target: self, action: #selector(firstButtonTapped))
        firstButtonView.addGestureRecognizer(firstButtonTap)
        
        let secondButtonTap = UITapGestureRecognizer(target: self, action: #selector(secondButtonTapped))
        secondButtonView.addGestureRecognizer(secondButtonTap)
        
        // Label ayarları
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .darkGray
        
        whichPageLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        whichPageLabel.textColor = .gray
        
        // Date picker ayarları
        setupDatePicker()
        selectDateTextField.isHidden = true
        
        // Partner kod bileşenleri gizle
        firstLabel.isHidden = true
        secondLabel.isHidden = true
        firstTextField.isHidden = true
        
        // TextField ayarları
        setupTextFields()
    }
    
    private func setupButton(_ buttonView: UIView, label: UILabel) {
        buttonView.layer.cornerRadius = 12
        buttonView.clipsToBounds = true
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
    }
    
    private func setupDatePicker() {
        // Date picker konfigürasyonu
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date() // Bugünden ileri tarih seçilemesin
        
        // TextField için toolbar oluştur
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Tamam", style: .done, target: self, action: #selector(datePickerDonePressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "İptal", style: .plain, target: self, action: #selector(datePickerCancelPressed))
        
        toolbar.setItems([cancelButton, flexSpace, doneButton], animated: false)
        
        // TextField ayarları
        selectDateTextField.inputView = datePicker
        selectDateTextField.inputAccessoryView = toolbar
        selectDateTextField.textAlignment = .center
        selectDateTextField.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        selectDateTextField.layer.cornerRadius = 12
        selectDateTextField.layer.borderWidth = 1.5
        selectDateTextField.layer.borderColor = UIColor(red: 255/255, green: 105/255, blue: 180/255, alpha: 0.3).cgColor
        selectDateTextField.backgroundColor = .white
        selectDateTextField.placeholder = "Tarih Seç"
        
        // Padding ekle
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: selectDateTextField.frame.height))
        selectDateTextField.leftView = paddingView
        selectDateTextField.leftViewMode = .always
        selectDateTextField.rightView = paddingView
        selectDateTextField.rightViewMode = .always
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    
    @objc private func datePickerValueChanged() {
        selectedDate = datePicker.date
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "tr_TR")
        selectDateTextField.text = formatter.string(from: datePicker.date)
    }
    
    @objc private func datePickerDonePressed() {
        if selectedDate == nil {
            selectedDate = datePicker.date
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.locale = Locale(identifier: "tr_TR")
            selectDateTextField.text = formatter.string(from: datePicker.date)
        }
        selectDateTextField.resignFirstResponder()
    }
    
    @objc private func datePickerCancelPressed() {
        selectDateTextField.resignFirstResponder()
    }
    
    private func setupTextFields() {
        // firstTextField (partner kod girişi)
        firstTextField.textAlignment = .center
        firstTextField.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        firstTextField.layer.cornerRadius = 12
        firstTextField.layer.borderWidth = 1.5
        firstTextField.layer.borderColor = UIColor(red: 255/255, green: 105/255, blue: 180/255, alpha: 0.3).cgColor
        firstTextField.backgroundColor = .white
        firstTextField.placeholder = "Partner Kodunu Gir"
        firstTextField.autocapitalizationType = .allCharacters
        
        // Padding ekle
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: firstTextField.frame.height))
        firstTextField.leftView = paddingView
        firstTextField.leftViewMode = .always
        firstTextField.rightView = paddingView
        firstTextField.rightViewMode = .always
        
        // Label ayarları
        firstLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        firstLabel.textColor = .darkGray
        firstLabel.textAlignment = .left
        
        secondLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        secondLabel.textColor = .darkGray
        secondLabel.textAlignment = .left
    }
    
    private func generateInviteCode() -> String {
        // Benzersiz 6 haneli kod oluştur
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<6).map{ _ in letters.randomElement()! })
    }
    
    @objc private func copyInviteCode() {
        UIPasteboard.general.string = inviteCode
        
        // Kopyalandı bildirimi
        let alert = UIAlertController(title: "✓ Kopyalandı", message: "Davet kodu panoya kopyalandı!", preferredStyle: .alert)
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            alert.dismiss(animated: true)
        }
    }
    
    private func applyGradientBackground() {
        // Mevcut gradient varsa kaldır
        view.layer.sublayers?.first(where: { $0 is CAGradientLayer })?.removeFromSuperlayer()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 255/255, green: 225/255, blue: 245/255, alpha: 1).cgColor,
            UIColor(red: 230/255, green: 230/255, blue: 255/255, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func applyFirstViewGradient() {
        // Mevcut gradient varsa kaldır
        firstView.layer.sublayers?.compactMap { $0 as? CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = firstView.bounds
        gradientLayer.colors = [
            UIColor(red: 255/255, green: 105/255, blue: 180/255, alpha: 1).cgColor,
            UIColor(red: 219/255, green: 39/255, blue: 119/255, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.cornerRadius = 24
        firstView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func updatePageContent() {
        let data = onboardingData[currentPage]
        
        // Animasyonlu içerik güncelleme
        UIView.transition(with: firstImageView, duration: 0.3, options: .transitionCrossDissolve) {
            self.firstImageView.image = UIImage(systemName: data.image)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.titleLabel.alpha = 0
            self.descriptionLabel.alpha = 0
        } completion: { _ in
            self.titleLabel.text = data.title
            self.descriptionLabel.text = data.description
            
            UIView.animate(withDuration: 0.3) {
                self.titleLabel.alpha = 1
                self.descriptionLabel.alpha = 1
            }
        }
        
        // Progress bar güncelle
        let progress = Float(currentPage + 1) / Float(totalPages)
        UIView.animate(withDuration: 0.3) {
            self.barProgressView.setProgress(progress, animated: true)
        }
        
        // Sayfa numarası güncelle - İlk 3 sayfa için göster
        if currentPage < 3 {
            whichPageLabel.text = "\(currentPage + 1)/3"
            whichPageLabel.isHidden = false
            barProgressView.isHidden = false
        } else {
            whichPageLabel.isHidden = true
            barProgressView.isHidden = true
        }
        
        // 4. sayfada (tarih seçimi) özel ayarlar
        if currentPage == 3 {
            selectDateTextField.isHidden = false
            firstLabel.isHidden = true
            secondLabel.isHidden = true
            firstTextField.isHidden = true
            secondButtonView.isHidden = true
            firstButtonLabel.text = "Continue"
            firstButtonView.backgroundColor = UIColor(red: 255/255, green: 105/255, blue: 180/255, alpha: 1)
            firstButtonLabel.textColor = .white
        }
        // 5. sayfada (partner bağlantısı) özel ayarlar
        else if currentPage == 4 {
            selectDateTextField.isHidden = true
            firstLabel.isHidden = false
            secondLabel.isHidden = false
            firstTextField.isHidden = false
            secondButtonView.isHidden = false
            
            // Davet kodu oluştur
            inviteCode = generateInviteCode()
            
            // firstLabel ayarları - Invite Link
            firstLabel.text = "Invite Link"
            
            // selectDateTextField'ı davet kodu için kullan
            selectDateTextField.isHidden = false
            selectDateTextField.text = inviteCode
            selectDateTextField.isUserInteractionEnabled = true
            selectDateTextField.inputView = nil
            selectDateTextField.inputAccessoryView = nil
            selectDateTextField.textColor = UIColor(red: 255/255, green: 105/255, blue: 180/255, alpha: 1)
            selectDateTextField.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            selectDateTextField.layer.borderColor = UIColor(red: 255/255, green: 105/255, blue: 180/255, alpha: 0.5).cgColor
            
            // Kopyalama için tap gesture ekle
            selectDateTextField.isUserInteractionEnabled = false // Düzenlemeyi engelle
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(copyInviteCode))
            selectDateTextField.addGestureRecognizer(tapGesture)
            selectDateTextField.isUserInteractionEnabled = true
            
            // secondLabel ayarları
            secondLabel.text = "Have a code from your partner?"
            
            // Buton ayarları
            firstButtonLabel.text = "Kod ile Katıl"
            firstButtonView.backgroundColor = UIColor(red: 255/255, green: 105/255, blue: 180/255, alpha: 1)
            firstButtonLabel.textColor = .white
            
            secondButtonLabel.text = "Sonra Bağlanacağım"
            secondButtonView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
            secondButtonLabel.textColor = .darkGray
        }
        // Son sayfada buton ayarları
        else if currentPage == totalPages - 1 {
            // Son sayfa
            secondButtonView.isHidden = true
            firstButtonLabel.text = "Get Started"
            firstButtonView.backgroundColor = UIColor(red: 255/255, green: 105/255, blue: 180/255, alpha: 1)
            firstButtonLabel.textColor = .white
        } else {
            // İlk 3 sayfa
            selectDateTextField.isHidden = true
            firstLabel.isHidden = true
            secondLabel.isHidden = true
            firstTextField.isHidden = true
            secondButtonView.isHidden = false
            firstButtonLabel.text = "Continue"
            firstButtonView.backgroundColor = UIColor(red: 255/255, green: 105/255, blue: 180/255, alpha: 1)
            firstButtonLabel.textColor = .white
            
            secondButtonView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
            secondButtonLabel.text = "Skip"
            secondButtonLabel.textColor = .darkGray
        }
    }
    
    @objc private func firstButtonTapped() {
        // Butona basıldığında animasyon
        UIView.animate(withDuration: 0.1, animations: {
            self.firstButtonView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.firstButtonView.transform = .identity
            }
        }
        
        // 4. sayfada tarih seçimi kontrolü
        if currentPage == 3 {
            if selectedDate == nil {
                // Tarih seçilmemişse uyarı göster
                showAlert(title: "Tarih Seç", message: "Lütfen ilişkinizin başlangıç tarihini seçin.")
                return
            }
            // Tarihi kaydet
            UserDefaults.standard.set(selectedDate, forKey: "relationshipStartDate")
            print("İlişki başlangıç tarihi: \(selectedDate!)")
            nextPage()
            return
        }
        
        // 5. sayfada kod ile katıl
        if currentPage == 4 {
            guard let partnerCode = firstTextField.text?.trimmingCharacters(in: .whitespaces),
                  !partnerCode.isEmpty else {
                showAlert(title: "Kod Gerekli", message: "Lütfen partnerinizin kodunu girin.")
                return
            }
            
            // Kod validasyonu (6 karakter)
            if partnerCode.count != 6 {
                showAlert(title: "Geçersiz Kod", message: "Partner kodu 6 karakter olmalıdır.")
                return
            }
            
            // Kodu kaydet ve eşleşme yap
            UserDefaults.standard.set(partnerCode, forKey: "partnerCode")
            print("Partner kodu ile eşleşme: \(partnerCode)")
            
            finishOnboarding()
            return
        }
        
        if currentPage == totalPages - 1 {
            // Get Started - Ana ekrana geç
            finishOnboarding()
        } else {
            // Continue - Sonraki sayfa
            nextPage()
        }
    }
    
    @objc private func secondButtonTapped() {
        // Skip - Direkt ana ekrana geç
        UIView.animate(withDuration: 0.1, animations: {
            self.secondButtonView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.secondButtonView.transform = .identity
            }
        }
        
        // 5. sayfada "Sonra Bağlanacağım" - Ana ekrana geç
        if currentPage == 4 {
            print("Kullanıcı sonra bağlanmayı seçti")
            UserDefaults.standard.set(false, forKey: "isPartnerConnected")
            finishOnboarding()
            return
        }
        
        finishOnboarding()
    }
    
    private func nextPage() {
        if currentPage < totalPages - 1 {
            currentPage += 1
            updatePageContent()
        }
    }
    
    private func finishOnboarding() {
        // Onboarding tamamlandı - Ana ekrana geçiş
        print("Onboarding tamamlandı!")
        
        // UserDefaults'a onboarding tamamlandı işareti koy
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        
        // Ana ekrana geçiş yap (Storyboard segue veya programmatik)
        // performSegue(withIdentifier: "showMainScreen", sender: nil)
        
        // Veya dismiss et
        dismiss(animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}

