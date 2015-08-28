### ArtemSherbachukTask2

# Yalantis Task2. Objective-C 

### Описание
> К Вашему выполненному заданию 1 необходимо добавить следующий функционал:
Смена вида представления данных - добавить возможность переключения между UITableView и UICollectionView. В UICollectionViewCell необходимо отображать только картинку в весь размер ячейки, что-то вроде этого http://www.appcoda.com/wp-content/uploads/2013/01/RecipePhoto-App-First-Version.jpg
Хранить данные моделей в plist-файле
Добавить возможность добавлять новые элементы - пользователь может ввести текст для новой модели, этот текст не может быть короче трех символов. Картинку пока не выбыраем. Модель сохраняется в plist. После сохранения модели она должна добавиться в plist и отобразиться в таблице и collection view. 

***




***

#### Коментарий
##### Controllers

ASContainerViewController - контроллер переключения вида tableView/collectionView

ASContainerTableViewController - контроллер table

ASContainerCollectionViewController -  контроллер collection

ASAddEditEntryViewController - добавление новой записи и редактирование

***

##### Views
ASPublisherTableViewCell

ASPublisherCollectionViewCell

***
##### Model
ASPublisherData - объект управления данными ячейки

ASPublisher - объект данных ячейки
***

Реалезованы патерны - Singletone, NotificationCenter, Delegate


