import Foundation

extension TimeInterval {
    /**
     Форматирует TimeInterval в строку времени.
     - returns: Форматированную строку
     
     - Remark:
     1   -> 00:01
     62  -> 01:02
     */
    func formatSeconds() -> String {
        guard self.isFinite else {
            return "- : -"
        }
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        
        return String(format: "%02i:%02i",
                      minutes,
                      seconds)
    }
}
