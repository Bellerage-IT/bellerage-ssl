# bellerage-ssl
Библиотека дополнительных подсистем для встраивания в другие конфигурации.

Содержит следующие подсистемы
- HTTP фреймворк (подсистема ХТТП)
- Работа с костантами (подсистема Константы)
- Модель запроса (подсистема МодельЗапроса) - авторство @KalyakinAG (https://github.com/KalyakinAG/query-model)
- Модификация форм (подсистема МодификацияФорм)
- Пагинация (подсистема Пагинация)
- Процессор коллекций (подсистема ПроцессорКоллекций) - авторство @sfaqer (https://github.com/sfaqer/onec-fluent)
- Регулярные выражения (Подсистема РегулярныеВыражения) - авторство @spr1c (https://github.com/cpr1c/RegEx1C_cfe)
- Коннектор ХТТП (подсистема КоннекторХТТП) - авторство @vbondarevsky (https://github.com/vbondarevsky/Connector)

Подробная документация по каждой из подсистем будет доступна позднее.

# Установка
Полную установку можно сделать простым сравнением и объединением с конфигурацией.
При необходимости, можно внедрять только необходимые подсистемы.
1) Сделать сравнение и объединение
2) Снять все галки
3) Выбрать "отметить по подсистемам из файла"
4) Выбрать необходимые подсистемы
5) Нажать "Объединить"

# Тестирование
Тестирование библиотек ведется с использованием фреймворка yaxunit
