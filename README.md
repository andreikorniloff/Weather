# Weather (clone native Weather App)
Клон нативного приложения погоды iOS с использованием Swift, MVVM+Coordinator и OpenWeatherMap API.

Цель данного проекта - показать работу с паттерном MVVM+C и UICollectionViewCompositionalLayout, а также Data Binding без использования сторонних фреймворков.

![](weather-demo.gif)

## Совместимость
Данный проект разработан с ипользованием языка Swift версии 5.4.
Для сборки и запуска требуется Xcode версии 12.5+.

## API Key
Для получения данных от OpenWeatherMap требуется ключ API. 
Данный ключ необходимо указать в `Services/OpenWeatherMapService.swift`

```swift
final class OpenWeatherMapService {
    static let shared = OpenWeatherMapService()

    private let apiKey = "YOUR API KEY"
    
    private init() {}
}
```

## Стек
- Swift
- UIKit, UICollectionViewCompositionalLayout, UICollectionViewDiffableDataSource
- URLSession, URLCache, CoreLocation
- Boxing, Delegate
- MVVM + Coordinator

## Требуемые доработки
1. Анимированный фон в зависимости от погоды
2. Анимированный переход на экран списка городов и обратно

## Контакты
Email: korniloff.a.e@gmail.com
Telegram: @andreikorniloff