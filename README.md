# secondNewServer
Еще одна попытка реализации сервера

1. Не могу сделать fmap в монаду постгресса ни как! придется возвращать пару значений а потом конвертировать
### Просто полностью переписал все 
2. Не могу сделать полное обновление в постгресс новости  
### Если обновлять полностью все в одном запросе какая то нериально большая функция получается - сделаю по одному обновление если надо в хаскеле (ошибка в полученных данных - поэтому нужно опять все переделывать или менять что то - это ужасно)
3. В постгрессе кстати сделал композитные типы для комментов и черновиков - попробовал вместо  json - парсинг для меня еще пока немного тяжел его.
