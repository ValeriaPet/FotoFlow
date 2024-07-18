

import XCTest

final class FotoFlowUITests: XCTestCase {
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
        print(app.debugDescription)
    }
    
    func testAuth() throws {
        
        app.buttons["Войти"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("mugi-chan@mail.ru")
        app.toolbars.buttons["Done"].tap()
        webView.swipeUp()
     
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        
        passwordTextField.typeText("qwertyqwerty")
        webView.swipeUp()
        
        let loginButton = webView.buttons["Login"]
        
        XCTAssertTrue(loginButton.waitForExistence(timeout: 10), "Кнопка логина не найдена")
            loginButton.tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.descendants(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 7))
        
    }

    
    func testFeed() throws {
        let tablesQuery = app.tables

        // Ожидание загрузки первой ячейки
        let cell = tablesQuery.descendants(matching: .cell).element(boundBy: 0)
        
        _ = cell.waitForExistence(timeout: 5)

        // Прокрутка вверх
        cell.swipeUp()
        print("Первая ячейка успешно прокручена вверх")


        let likeButton = tablesQuery.descendants(matching: .cell).element(boundBy: 1)
        
        likeButton.buttons["favoritesButton"].tap()
        sleep(3)
        
        likeButton.buttons["favoritesButton"].tap()
        
        sleep(3)
        
        likeButton.tap()

        // Работа с изображением
        let image = app.scrollViews.images.element(boundBy: 0)
        _ = image.waitForExistence(timeout: 5)
        
        image.pinch(withScale: 3, velocity: 1)
        
        image.pinch(withScale: 0.5, velocity: -1)
        print("Изображение успешно увеличено и уменьшено")

        // Возврат назад
        let backButton = app.buttons["Backward"]
        XCTAssertTrue(backButton.waitForExistence(timeout: 5), "Кнопка возврата не найдена")
        backButton.tap()
        print("Успешно возвращено на экран ленты")
    }

    func testProfile() throws {
        
        func testProfile() throws {
            sleep(3)
            app.tabBars.buttons.element(boundBy: 1).tap()
            
            XCTAssertTrue(app.staticTexts["Name Lastname"].exists)
            XCTAssertTrue(app.staticTexts["@username"].exists)
            
            app.buttons["Exit"].tap()
            
            app.alerts["Bye bye!"].scrollViews.otherElements.buttons["Yes"].tap()
        }
    }
}
