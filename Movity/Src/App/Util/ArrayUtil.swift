import Foundation

extension Array {
    /**
     Возвращает элемент массива по индексу, либо nil, если такого элемента нет.
     Позволяет избежать выхода за границы массива.
     - Parameter index: Индекс элемента в массиве
     - Returns: Элемент массива либо nil.
    */
    func getOrNil(at index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    /**
     Возвращает средний элемент массива либо nil, если массив пуст.
     - Returns: Элемент массива либо nil.
    */
    var middle: Element? {
        guard count != 0 else { return nil }
        
        let middleIndex = (count > 1 ? count - 1 : count) / 2
        return self[middleIndex]
    }
    
    /**
     Возвращает индекс среднего элемента в массиве.
     - Returns: Индекс среднего элемента.
    */
    var middleIndex: Int {
        return (self.isEmpty ? self.startIndex : self.count - 1) / 2
    }
}
