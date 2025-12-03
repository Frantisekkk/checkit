import UIKit
import Social
import MobileCoreServices
import UniformTypeIdentifiers

class ShareViewController: UIViewController {
    
    // MARK: - Properties
    private var sharedURL: String?
    private let backendURL = "https://n8n.nightsun.sk/webhook-test/6129cb38-d880-4def-8b67-40755e8a3f5a" // n8n webhook endpoint
    private let appGroupName = "group.com.videoanalyzer.shared"
    
    // UI Elements
    private var containerView: UIView!
    private var titleLabel: UILabel!
    private var optionsStackView: UIStackView!
    private var closeButton: UIButton!
    private var responseContainerView: UIView!
    private var responseTextView: UITextView!
    private var loadingLabel: UILabel!
    
    // Animation
    private var typewriterTimer: Timer?
    private var currentTypewriterIndex = 0
    private var fullResponseText = ""
    private var fullAttributedText: NSAttributedString?
    private var dotAnimationTimer: Timer?
    private var dotCount = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        extractSharedContent()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // Background - semi-transparent black
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // Container (bottom sheet style) - pure black
        containerView = UIView()
        containerView.backgroundColor = .black
        containerView.layer.cornerRadius = 14
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        // Title
        titleLabel = UILabel()
        titleLabel.text = "Analyze Video"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        // Options Stack
        optionsStackView = UIStackView()
        optionsStackView.axis = .vertical
        optionsStackView.spacing = 12
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(optionsStackView)
        
        // Create option buttons - iOS minimalistic style
        createOptionButton(title: "Hoax Check", subtitle: "Verify authenticity", action: #selector(hoaxCheckTapped))
        createOptionButton(title: "Explain This", subtitle: "Get detailed explanation", action: #selector(explainThisTapped))
        createOptionButton(title: "Expand This Idea", subtitle: "Explore related concepts", action: #selector(expandIdeaTapped))
        
        // Response Container (hidden initially)
        responseContainerView = UIView()
        responseContainerView.backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0)
        responseContainerView.layer.cornerRadius = 10
        responseContainerView.translatesAutoresizingMaskIntoConstraints = false
        responseContainerView.isHidden = true
        containerView.addSubview(responseContainerView)
        
        // Loading Label (animated dots)
        loadingLabel = UILabel()
        loadingLabel.text = "•••"
        loadingLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        loadingLabel.textColor = UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1.0)
        loadingLabel.textAlignment = .center
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        responseContainerView.addSubview(loadingLabel)
        
        // Response Text View
        responseTextView = UITextView()
        responseTextView.backgroundColor = .clear
        responseTextView.textColor = .white
        responseTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        responseTextView.isEditable = false
        responseTextView.isScrollEnabled = true
        responseTextView.isSelectable = true
        responseTextView.dataDetectorTypes = .link
        responseTextView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        responseTextView.translatesAutoresizingMaskIntoConstraints = false
        responseTextView.isHidden = true
        responseContainerView.addSubview(responseTextView)
        
        // Close Button - white text on dark gray
        closeButton = UIButton(type: .system)
        closeButton.setTitle("Done", for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0) // #1C1C1E
        closeButton.layer.cornerRadius = 10
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(closeButton)
        
        // Constraints
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 480),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            optionsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            optionsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            optionsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            responseContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            responseContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            responseContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            responseContainerView.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -16),
            
            loadingLabel.centerXAnchor.constraint(equalTo: responseContainerView.centerXAnchor),
            loadingLabel.centerYAnchor.constraint(equalTo: responseContainerView.centerYAnchor),
            
            responseTextView.topAnchor.constraint(equalTo: responseContainerView.topAnchor),
            responseTextView.leadingAnchor.constraint(equalTo: responseContainerView.leadingAnchor),
            responseTextView.trailingAnchor.constraint(equalTo: responseContainerView.trailingAnchor),
            responseTextView.bottomAnchor.constraint(equalTo: responseContainerView.bottomAnchor),
            
            closeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            closeButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -34),
            closeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func createOptionButton(title: String, subtitle: String, action: Selector) {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0) // #1C1C1E
        button.layer.cornerRadius = 10
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: action, for: .touchUpInside)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        subtitleLabel.textColor = UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1.0) // #8E8E93
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevronImageView.tintColor = UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1.0) // #8E8E93
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        button.addSubview(titleLabel)
        button.addSubview(subtitleLabel)
        button.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 70),
            titleLabel.topAnchor.constraint(equalTo: button.topAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            chevronImageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -16),
            chevronImageView.widthAnchor.constraint(equalToConstant: 13),
            chevronImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        optionsStackView.addArrangedSubview(button)
    }
    
    // MARK: - Extract Shared Content
    private func extractSharedContent() {
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
              let attachments = extensionItem.attachments else {
            showError("No content shared")
            return
        }
        
        print("[SHARE EXTENSION] Processing \(attachments.count) attachments")
        
        for attachment in attachments {
            // Check for URL
            if attachment.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                attachment.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { [weak self] (item, error) in
                    if let url = item as? URL {
                        print("[SHARE EXTENSION] ✓ Received URL: \(url.absoluteString)")
                        DispatchQueue.main.async {
                            self?.sharedURL = url.absoluteString
                        }
                    }
                }
                return
            }
            
            // Check for text/URL as string
            if attachment.hasItemConformingToTypeIdentifier(UTType.plainText.identifier) {
                attachment.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { [weak self] (item, error) in
                    if let text = item as? String {
                        print("[SHARE EXTENSION] ✓ Received text: \(text)")
                        DispatchQueue.main.async {
                            self?.sharedURL = text
                        }
                    }
                }
                return
            }
        }
        
        showError("Couldn't extract URL from shared content")
    }
    
    // MARK: - Backend Communication
    private func analyzeVideo(action: String) {
        guard let urlString = sharedURL else { return }
        
        print("[SHARE EXTENSION] Analyzing with action: \(action)")
        print("[SHARE EXTENSION] Video URL: \(urlString)")
        
        // Show loading UI
        showLoadingState()
        
        // Map action to type format (matching Flutter app)
        let typeMap: [String: String] = [
            "hoax_check": "hoax",
            "explain_this": "info",
            "expand_idea": "clarification"
        ]
        let analysisType = typeMap[action] ?? "info"
        
        guard let url = URL(string: backendURL) else {
            showError("Invalid backend URL")
            return
        }
        
        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 120.0  // Extended timeout for AI processing
        
        let body: [String: Any] = [
            "type": analysisType,
            "url": urlString
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        print("[SHARE EXTENSION] Sending request to backend...")
        print("[SHARE EXTENSION] Backend URL: \(backendURL)")
        print("[SHARE EXTENSION] Request body: \(body)")
        
        // Create URLSession with extended timeout
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 120.0
        config.timeoutIntervalForResource = 240.0
        let session = URLSession(configuration: config)
        
        // Send request and wait for response
        session.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("[SHARE EXTENSION] ✗ Error: \(error.localizedDescription)")
                    self?.showError("Failed to analyze: \(error.localizedDescription)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("[SHARE EXTENSION] Response status: \(httpResponse.statusCode)")
                    
                    if httpResponse.statusCode != 200 {
                        self?.showError("Server error: \(httpResponse.statusCode)")
                        return
                    }
                }
                
                guard let data = data else {
                    print("[SHARE EXTENSION] ✗ No data received")
                    self?.showError("No response from server")
                    return
                }
                
                // Parse the result
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        print("[SHARE EXTENSION] JSON keys: \(json.keys)")
                        
                        // Check for both 'response' and 'result' fields
                        let responseText = (json["response"] as? String) ?? (json["result"] as? String) ?? ""
                        if !responseText.isEmpty {
                            print("[SHARE EXTENSION] ✓ Analysis complete (\(responseText.count) chars)")
                            self?.displayResponseWithTypewriter(responseText)
                        } else {
                            print("[SHARE EXTENSION] ✗ No response text in JSON")
                            self?.showError("No response text received")
                        }
                    }
                } catch {
                    print("[SHARE EXTENSION] ✗ JSON parse error: \(error)")
                    self?.showError("Failed to parse response")
                }
            }
        }.resume()
    }
    
    // MARK: - UI Updates
    private func showLoadingState() {
        // Hide options, show response container with loading
        optionsStackView.isHidden = true
        responseContainerView.isHidden = false
        loadingLabel.isHidden = false
        responseTextView.isHidden = true
        
        // Update title
        titleLabel.text = "Analyzing..."
        
        // Start dot animation
        startDotAnimation()
    }
    
    private func startDotAnimation() {
        dotCount = 0
        dotAnimationTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.dotCount = (self.dotCount + 1) % 4
            let dots = String(repeating: "•", count: max(1, self.dotCount))
            let spaces = String(repeating: " ", count: 3 - self.dotCount)
            self.loadingLabel.text = dots + spaces
        }
    }
    
    private func stopDotAnimation() {
        dotAnimationTimer?.invalidate()
        dotAnimationTimer = nil
    }
    
    private func displayResponseWithTypewriter(_ text: String) {
        // Stop loading animation
        stopDotAnimation()
        loadingLabel.isHidden = true
        responseTextView.isHidden = false
        
        // Update title
        titleLabel.text = "Analysis Result"
        
        // Parse markdown and create attributed string
        fullAttributedText = parseMarkdown(text)
        fullResponseText = text
        currentTypewriterIndex = 0
        responseTextView.attributedText = NSAttributedString(string: "")
        
        // Start typewriter animation
        startTypewriterAnimation()
    }
    
    private func startTypewriterAnimation() {
        guard let fullAttributed = fullAttributedText else { return }
        
        // Type faster at the beginning, then slow down
        let baseInterval: TimeInterval = 0.02
        
        typewriterTimer = Timer.scheduledTimer(withTimeInterval: baseInterval, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            if self.currentTypewriterIndex < fullAttributed.length {
                // Get substring up to current index
                let range = NSRange(location: 0, length: self.currentTypewriterIndex + 1)
                let partialAttributed = fullAttributed.attributedSubstring(from: range)
                self.responseTextView.attributedText = partialAttributed
                self.currentTypewriterIndex += 1
                
                // Auto-scroll to bottom
                let bottom = NSRange(location: max(0, partialAttributed.length - 1), length: 1)
                self.responseTextView.scrollRangeToVisible(bottom)
            } else {
                // Animation complete
                timer.invalidate()
                self.typewriterTimer = nil
            }
        }
    }
    
    private func stopTypewriterAnimation() {
        typewriterTimer?.invalidate()
        typewriterTimer = nil
        // Show full text immediately
        if let fullAttributed = fullAttributedText, currentTypewriterIndex < fullAttributed.length {
            responseTextView.attributedText = fullAttributed
        }
    }
    
    // MARK: - Markdown Parsing
    private func parseMarkdown(_ text: String) -> NSAttributedString {
        let baseFont = UIFont.systemFont(ofSize: 16, weight: .regular)
        let baseColor = UIColor.white
        let grayColor = UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1.0) // #8E8E93
        let linkColor = UIColor.systemBlue
        
        let result = NSMutableAttributedString()
        var currentIndex = text.startIndex
        let lines = text.components(separatedBy: .newlines)
        
        for (lineIndex, line) in lines.enumerated() {
            if lineIndex > 0 {
                result.append(NSAttributedString(string: "\n"))
            }
            
            var processedLine = line
            var attributes: [NSAttributedString.Key: Any] = [
                .font: baseFont,
                .foregroundColor: baseColor
            ]
            
            // Headers
            if processedLine.hasPrefix("# ") {
                attributes[.font] = UIFont.systemFont(ofSize: 24, weight: .bold)
                attributes[.foregroundColor] = baseColor
                processedLine = String(processedLine.dropFirst(2))
            } else if processedLine.hasPrefix("## ") {
                attributes[.font] = UIFont.systemFont(ofSize: 20, weight: .bold)
                attributes[.foregroundColor] = baseColor
                processedLine = String(processedLine.dropFirst(3))
            } else if processedLine.hasPrefix("### ") {
                attributes[.font] = UIFont.systemFont(ofSize: 18, weight: .semibold)
                attributes[.foregroundColor] = baseColor
                processedLine = String(processedLine.dropFirst(4))
            }
            
            // Lists
            if processedLine.hasPrefix("- ") || processedLine.hasPrefix("* ") {
                processedLine = "• " + String(processedLine.dropFirst(2))
            } else if processedLine.hasPrefix("  - ") || processedLine.hasPrefix("  * ") {
                processedLine = "  • " + String(processedLine.dropFirst(4))
                attributes[.foregroundColor] = grayColor
            }
            
            // Process inline markdown
            let lineAttributed = parseInlineMarkdown(processedLine, baseAttributes: attributes)
            result.append(lineAttributed)
        }
        
        return result
    }
    
    private func parseInlineMarkdown(_ text: String, baseAttributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let result = NSMutableAttributedString()
        var currentIndex = text.startIndex
        let baseFont = baseAttributes[.font] as? UIFont ?? UIFont.systemFont(ofSize: 16)
        let baseColor = baseAttributes[.foregroundColor] as? UIColor ?? UIColor.white
        let linkColor = UIColor.systemBlue
        let codeColor = UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1.0)
        let codeBgColor = UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 0.5)
        
        while currentIndex < text.endIndex {
            // Check for code blocks (backticks)
            if let codeStart = text.range(of: "`", range: currentIndex..<text.endIndex) {
                // Add text before code
                if codeStart.lowerBound > currentIndex {
                    let beforeText = String(text[currentIndex..<codeStart.lowerBound])
                    result.append(NSAttributedString(string: beforeText, attributes: baseAttributes))
                }
                
                // Find closing backtick
                if let codeEnd = text.range(of: "`", range: codeStart.upperBound..<text.endIndex) {
                    let codeText = String(text[codeStart.upperBound..<codeEnd.lowerBound])
                    var codeAttributes = baseAttributes
                    codeAttributes[.font] = UIFont.monospacedSystemFont(ofSize: baseFont.pointSize, weight: .regular)
                    codeAttributes[.foregroundColor] = codeColor
                    codeAttributes[.backgroundColor] = codeBgColor
                    result.append(NSAttributedString(string: codeText, attributes: codeAttributes))
                    currentIndex = codeEnd.upperBound
                    continue
                }
            }
            
            // Check for bold (**text**)
            if let boldStart = text.range(of: "**", range: currentIndex..<text.endIndex) {
                // Add text before bold
                if boldStart.lowerBound > currentIndex {
                    let beforeText = String(text[currentIndex..<boldStart.lowerBound])
                    result.append(NSAttributedString(string: beforeText, attributes: baseAttributes))
                }
                
                // Find closing **
                if let boldEnd = text.range(of: "**", range: boldStart.upperBound..<text.endIndex) {
                    let boldText = String(text[boldStart.upperBound..<boldEnd.lowerBound])
                    var boldAttributes = baseAttributes
                    boldAttributes[.font] = UIFont.systemFont(ofSize: baseFont.pointSize, weight: .bold)
                    result.append(NSAttributedString(string: boldText, attributes: boldAttributes))
                    currentIndex = boldEnd.upperBound
                    continue
                }
            }
            
            // Check for italic (*text* or _text_)
            if let italicStart = text.range(of: "*", range: currentIndex..<text.endIndex) {
                // Make sure it's not part of **
                let nextChar = italicStart.upperBound < text.endIndex ? text[italicStart.upperBound] : Character(" ")
                if nextChar != "*" {
                    // Add text before italic
                    if italicStart.lowerBound > currentIndex {
                        let beforeText = String(text[currentIndex..<italicStart.lowerBound])
                        result.append(NSAttributedString(string: beforeText, attributes: baseAttributes))
                    }
                    
                    // Find closing *
                    if let italicEnd = text.range(of: "*", range: italicStart.upperBound..<text.endIndex) {
                        let italicText = String(text[italicStart.upperBound..<italicEnd.lowerBound])
                        var italicAttributes = baseAttributes
                        italicAttributes[.font] = UIFont.italicSystemFont(ofSize: baseFont.pointSize)
                        result.append(NSAttributedString(string: italicText, attributes: italicAttributes))
                        currentIndex = italicEnd.upperBound
                        continue
                    }
                }
            }
            
            // Check for links [text](url)
            if let linkStart = text.range(of: "[", range: currentIndex..<text.endIndex),
               let linkTextEnd = text.range(of: "](", range: linkStart.upperBound..<text.endIndex),
               let linkUrlEnd = text.range(of: ")", range: linkTextEnd.upperBound..<text.endIndex) {
                // Add text before link
                if linkStart.lowerBound > currentIndex {
                    let beforeText = String(text[currentIndex..<linkStart.lowerBound])
                    result.append(NSAttributedString(string: beforeText, attributes: baseAttributes))
                }
                
                let linkText = String(text[linkStart.upperBound..<linkTextEnd.lowerBound])
                let linkUrl = String(text[linkTextEnd.upperBound..<linkUrlEnd.lowerBound])
                
                var linkAttributes = baseAttributes
                linkAttributes[.foregroundColor] = linkColor
                linkAttributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
                linkAttributes[.link] = URL(string: linkUrl)
                
                result.append(NSAttributedString(string: linkText, attributes: linkAttributes))
                currentIndex = linkUrlEnd.upperBound
                continue
            }
            
            // No special formatting found, move to next character
            if currentIndex < text.endIndex {
                let char = text[currentIndex]
                result.append(NSAttributedString(string: String(char), attributes: baseAttributes))
                currentIndex = text.index(after: currentIndex)
            } else {
                break
            }
        }
        
        return result
    }
    
    private func showError(_ message: String) {
        stopDotAnimation()
        stopTypewriterAnimation()
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default) { [weak self] _ in
            self?.closeTapped()
        })
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    @objc private func hoaxCheckTapped() {
        analyzeVideo(action: "hoax_check")
    }
    
    @objc private func explainThisTapped() {
        analyzeVideo(action: "explain_this")
    }
    
    @objc private func expandIdeaTapped() {
        analyzeVideo(action: "expand_idea")
    }
    
    @objc private func closeTapped() {
        print("[SHARE EXTENSION] Closing extension")
        
        // Clean up animations
        stopDotAnimation()
        stopTypewriterAnimation()
        
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
}

