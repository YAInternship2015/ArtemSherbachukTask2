### ArtemSherbachukTask2

# Yalantis Task2.  Swift  

### Описание
> К Вашему выполненному заданию 1 необходимо добавить следующий функционал:
Смена вида представления данных - добавить возможность переключения между UITableView и UICollectionView. В UICollectionViewCell необходимо отображать только картинку в весь размер ячейки, что-то вроде этого http://www.appcoda.com/wp-content/uploads/2013/01/RecipePhoto-App-First-Version.jpg
Хранить данные моделей в plist-файле
Добавить возможность добавлять новые элементы - пользователь может ввести текст для новой модели, этот текст не может быть короче трех символов. Картинку пока не выбыраем. Модель сохраняется в plist. После сохранения модели она должна добавиться в plist и отобразиться в таблице и collection view. 

***

### Видео выполенного задания

[![Alt yalantis task2](https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcQNshbZ6U1POND3Vy-ROGbcife1NwDgB6OTrAOMKsUUDAu_1iy7)](https://www.youtube.com/watch?v=hTcwhxhfwmc&feature=youtu.be)


***

#### Коментарий
##### Controllers

ContainerViewController - контроллер переключения вида tableView/collectionView

ContentTableViewController - контроллер table

ContentCollectionViewController -  контроллер collection
AddNewEntryViewController - добавление новой записи и редактирование

***

##### Views
CustomTableViewCell
PublisherCollectionViewCell

***
##### Model
PublishersData - объект управления данными ячейки
Publisher - объект данных ячейки
***

Реалезованы патерны - Singletone, NotificationCenter, Delegate
p.s. Анимация изменeна после добавления видео
