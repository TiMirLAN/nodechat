# Тестовое задание

Задача: написать приложение чат, с пользователями и комнатами.

Необходимо реализовать SPA приложения на котором будет два вида:

На первом должен выводится список всех подключенных пользователей и существующих комнат. В списке пользователей должен выделяться текущий пользователь и должна быть возможность поменять ему имя. При клике на комнату в списке комнат пользователь должен увидеть страницу комнаты.

На странице комнаты необходимо вывести список пользователей и список сообщений, также должна быть возможность добавить свое сообщение. Принятые и отправленные сообщения должны отличаться своим видом.

Все данные на клиенте (хранимые и отображаемые) должны соответствовать актуальным данным на сервере, сервер для этого будет сам уведомлять клиент о наличии изменений.


## Требования

* разрешается использовать любые javascript-фреймворки
* для верстки желательно не использовать какие-либо фреймворки
* желательно использовать для верстки препроцессоры (SASS/SCSS, LESS, Stylus)
* скрипты должны быть собраны в один файл (browserify, grunt, gulp, ...)
* При создании приложения должна использоваться система контроля версий, чтобы можно было проследить историю изменений (github.com, bitbucket.org, либо аналогичные сервисы).


# Описание сервера

Сервер написан при помощи [socket.io](http://socket.io/), на клиенте тоже его придется использовать. Сервер подключается к 3000 порту, например следующий код подключит клиентскую библиотеку и создаст подключение:

```html
<script src='http://localhost:3000/socket.io/socket.io.js'></script>
<script>
  var socket = io.connect('http://localhost:3000');
</script>
```

На сервере есть всего три модели: пользователи, комнаты и сообщения, у каждой модели есть уникальный идентификатор (`id`). У модели пользователя и комнаты еще есть имя (`name`). Модель комнаты на сервере, хранит в себе все участников, и сообщения. Сообщение имеет следующий параметры:

* `body` - текст сообщения
* `user` - идентификатор пользователя
* `room` - идентификатор комнаты
* `createdAt` - таймштамп

Все данные на сервере хранятся в памяти, в двух коллекциях, коллекция пользователей и комнат. На любые изменения в коллекция или моделях сервер шлет оповещение на клиент.

При подключении создается пользователь и высылается событие `entered`, где первым параметром придет объект пользователя, так можно узнать текущего пользователя.

Все другие сообщения от сервера будут связаны лишь с изменениями в коллекциях и моделях.

Также сервер умеет слушать некоторые события:

  * `setName` - указать пользователю имя
  * `createRoom` - создать комнату
  * `joinRoom` - войти в комнату
  * `leaveRoom` - покинуть комнату
  * `sendMessage` - отправить сообщение

При подписке на комнату, клиент начнет получать новые уведомления, связанные с изменением в комнате, а также на клиент сразу же после подписки прилетят список всех пользователей в комнате и 10 последних сообщений.


# Установка сервера

Сперва необходимо поставить `node.js` и `npm`. Далее заходим в папку с сервером и выполняем `npm install`.


# Запуск сервера

    $ npm start


# Протокол

## Входящие сообщения

Название сообщения | Формат данных | Комментарий
-------------------|---------------|------------
`rooms:added`   | массив новых комнат, либо одна комната |
`rooms:changed` | массив измененных комнат, либо одна комната |
`rooms:removed` | массив удаленных комнат, либо одна комната |
`users:added`   | массив новых пользователей, либо один пользователь |
`users:changed` | массив измененных пользователей, либо один пользователь |
`users:removed` | массив удаленных пользователей, либо один пользователь |
`room:users:added`   | массив новых пользователей в комнате, либо один пользователь, вторым параметром идет `id` комнаты |
`room:users:removed` | массив удаленных пользователей в комнате, либо один пользователь, вторым параметром идет `id` комнаты |
`room:messages:added`   | массив новых сообщений, либо одно сообщение вторым параметром идет `id` комнаты |
`entered` | модель пользователя | событие прилетает когда пользователь подключается к сокету, автоматически ему задается имя `Anonymous`, потом его можно поменять

## Исходящие сообщения

В колбек прилетает первым параметром ошибка, если первый параметр `null` значит запрос завершился успешно.

Название сообщения | Формат | Комментарий
-------------------|--------|------------
`setName` | `<имя пользователя>` | После подключения можно установить имя текущего пользователя, иначе оно будет автоматически задано как `Anonymous`
`createRoom` | `<имя группы>` | Создать группу, после чего всем прилетит событие о добавлении комнаты, пользователь создавший группу автоматически войдет в нее
`joinRoom` | `<roomId>` | Войти в группу, после входа прилетит 10 последних сообщений для данной комнаты и список пользователей в ней
`leaveRoom` | `<roomId>` | Выйти из группы, если в группы текущий пользователь был последним, то комната удалится
`sendMessage` | `<roomId>, <msg>` | Добавить сообщение в группу

# Решение

Выполнить `npm start` и открыть в браузере [http://127.0.0.1:8000/](http://127.0.0.1:8000)
