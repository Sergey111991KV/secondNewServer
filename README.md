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