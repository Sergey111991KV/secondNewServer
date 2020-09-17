# secondNewServer
Еще одна попытка реализации сервера

1. Не могу сделать fmap в монаду постгресса ни как! придется возвращать пару значений а потом конвертировать
### Просто полностью переписал все 
2. Не могу сделать полное обновление в постгресс новости  
### Если обновлять полностью все в одном запросе какая то нериально большая функция получается - сделаю по одному обновление если надо в хаскеле (ошибка в полученных данных - поэтому нужно опять все переделывать или менять что то - это ужасно)
3. В постгрессе кстати сделал композитные типы для комментов и черновиков - попробовал вместо  json - парсинг для меня еще пока немного тяжел его.
4. Есть две безусловно мной видимые вещи которые меня бесят - я не делаю имена для таких типов как Auth Admin и прочих, которые конкретно дают понять, что собой значит эта булевая или этот текст - блин просто потому-что это еще раз писать и переписывать -  проект учебный, а не в продакшене - я это все знаю и постараюсь учесть в будущем. Вторая вещь - это повторяющийся код( Буду признателен за помощь и трюки за его сокращение... Недавно читал статью, что бы хорошо сокращать код и не повторяться - для начало нужно хотя бы понять, где он повторяется и как его можно сократить.
5. Про постгресс - я сделал базу данных в графическом интерпретаторе на маке - как сохранить все таблицы (всю базу в одном файле) я не понял( поэтому я просто скинул все таблицы в один файл - а миграцию добавил лишь пару строк, так как я понимаю миграцию - это изменение в базе данных и она должна делать автоматически - не пойму только как избежать ошибки если изменять или добавлять ничего не надо, должно же быть или какое-то расширение или еще что.
6. Тестирование делаю в Spec - это первый опыт. По ходу написания кода я по факту постоянно его тестировал - теперь просто придется все что делал переписать в тестирование.
7. Проблема со скриптами - сделал приложение с использованием куки и теперь мне их нужно при постоянном отправлении запроса ---- РЕШИЛ.
8. Логирование сделал расширением - пока тестово добавил в один реализованный класс
9. Файл DraftOfCode - это просто код который мне жалко было удалять
10. Логика приложения такая: есть общие функции которые берут входные данные запакованные в Другой над тип данных, в зависимости от условия
11. Тестирование - когда делаю рандом при создании проверочных сущностей, есть шанс на возникновение повторного  id - блин это конечно не достаток логики программы - но я ее пока не знаю как решить лучше... В общем я это решил - кроме композитных типов - там придется в каждую таблицу добалять по новому id  ну или же сделать из композитных типов sequence - а это пока не получается.
Есть конечно идея таблицы прокладки так сказать - она будет содержать только id которое передается в следующую таблицу с содержанием сущности. Но ради бога - я уже настродался с проектом) поэтому можно это опустить?)
12. Не добавил уникальность для ссылки каждого автора на юзера.
13. В тестах на editing - пришлось использовать реальные данные из таблицы - ведь они там нужны, в противном случае тесты нужно создать так, что бы все действия были последовательны со всеми действиями... блин и база данных бы тогда не засорялась))) Блин нужно создать одну каскадную функцию создающую все остальные и возвращающая кортеж их содержащих - получится отличная связь.
14. Блин логики много надо переделать во всем -  нужно изменить и создание сущностей кое каких, с автоматическим созданием именно тех сущностей, что и юзеры их создающие - поэтому нужно в принципе это исключить на этапе передачи в основные функции... поэтому буду исходить из того, что эти данные приходят уже нормальные.
15. Из-за того, что в композитные типы нельзя связать со связями, а я еще не добавил id в эти таблицы - пришлось пожертвовать кое какой стабильностью в таблицах поиска по тегам - просто я повторюсь - есть способ без использования композитных типов, а реализовать принцим этого кода я понял - просто это еще писать и переделывать все... - если надо, то сделаю не вопрос, если можно пропустить - давайте пропустим)
16. Еще одно правило, которое я вынес на будущее - всегда все приводить к тем типам данных (ну или стараться по крайней мере), с которыми будешь работать, а то получается что где-то Int и String, а где-то Integer и Text
17. Curl запросы - блин ну там нужно менять будет ключи сессии... хотя

