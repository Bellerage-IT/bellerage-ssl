//©///////////////////////////////////////////////////////////////////////////©//
//
//  Copyright 2021-2023 BIA-Technologies Limited Liability Company
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//©///////////////////////////////////////////////////////////////////////////©//

/////////////////////////////////////////////////////////////////////////////////
// Основной модуль для запуска тестирования
/////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс

// Возвращает API формирования утверждения для проверки теста.
// 
// Параметры:
//  ПроверяемоеЗначение - Произвольный -  Проверяемое фактическое значение
//  Сообщение - Строка - Описание проверки, которое будет выведено при возникновении ошибки
// 
// Возвращаемое значение:
//  ОбщийМодуль - Утверждения, см. ЮТУтверждения
Функция ОжидаетЧто(ПроверяемоеЗначение, Сообщение = "") Экспорт
	
	Возврат ЮТУтверждения.Что(ПроверяемоеЗначение, Сообщение);
	
КонецФункции

// Возвращает API для работы с тестовыми данными.
// 
// Возвращаемое значение:
//  ОбщийМодуль - Данные, см. ЮТТестовыеДанные.
Функция Данные() Экспорт
	
	Возврат ЮТТестовыеДанные;
	
КонецФункции

// Возвращает API для формирования предикатов/утверждений, которые могут быть использованы для проверки коллекций.
// 
// Возвращаемое значение:
//  ОбщийМодуль - см. ЮТПредикаты.
Функция Предикат() Экспорт
	
	Возврат ЮТПредикаты.Инициализировать();
	
КонецФункции

// Конструктор вариантов прогона теста.
// 
// Используется для формирования набора различных параметров выполнения.
// Параметры:
//  Реквизиты - Строка - Список реквизитов варианта разделенных запятой
// 
// Возвращаемое значение:
//  ОбщийМодуль - Варианты, см. ЮТКонструкторВариантов.
Функция Варианты(Реквизиты) Экспорт
	
	Возврат ЮТКонструкторВариантов.Варианты(Реквизиты);
	
КонецФункции

Функция Контекст() Экспорт
	
	Возврат ЮТКонтекстТеста;
	
КонецФункции

// Пропустить выполнение теста.
// 
// Используется если тест выполняется в неподходящих условиях и не нужно его выполнять, но отразить в отчете требуется.
// Параметры:
//  Сообщение - Строка, Неопределено - Сообщение
Процедура Пропустить(Сообщение = Неопределено) Экспорт
	
	ЮТРегистрацияОшибок.Пропустить(Сообщение);
	
КонецПроцедуры

// Возвращает структуру, в которой можно хранить данные используемые в тесте.
//  
//  Данные живут в рамках одного теста, но доступны в обработчиках событий `ПередКаждымТестом` и `ПослеКаждогоТеста`.
//  
//  Например, в контекст можно помещать создаваемые данные, что бы освободить/удалить их в обработчике `ПослеКаждогоТеста`.
// Возвращаемое значение:
//  Структура - Контекст теста
//  Неопределено - Если метод вызывается за рамками теста
Функция КонтекстТеста() Экспорт
	
	Возврат ЮТКонтекст.КонтекстТеста();
	
КонецФункции

// Возвращает структуру, в которой можно хранить данные используемые в тестах набора.
//  
//  Данные живут в рамках одного набора тестов (данные между клиентом и сервером не синхронизируются).
//  Доступны в каждом тесте набора и в обработчиках событий:
//  	+ `ПередТестовымНабором`
//  	+ `ПослеТестовогоНабора`
//  	+ `ПередКаждымТестом`
//  	+ `ПослеКаждогоТеста`
//  
//  Например, в контекст можно помещать создаваемые данные, что бы освободить/удалить их в обработчике `ПослеКаждогоТеста`.
// Возвращаемое значение:
//  Структура - Контекст набора тестов
//  Неопределено - Если метод вызывается за рамками тестового набора
Функция КонтекстТестовогоНабора() Экспорт
	
	Возврат ЮТКонтекст.КонтекстНабора();
	
КонецФункции

// Возвращает структуру, в которой можно хранить данные используемые в тестах модуля.
// 
//  Данные живут в рамках одного тестового модуля (данные между клиентом и сервером не синхронизируются).
//  Доступны в каждом тесте модуля и в обработчиках событий.
//  
//  Например, в контекст можно помещать создаваемые данные, что бы освободить/удалить их в обработчике `ПослеВсехТестов`.
// Возвращаемое значение:
//  Структура - Контекст тестового модуля
//  Неопределено - Если метод вызывается за рамками тестового модуля
Функция КонтекстМодуля() Экспорт
	
	Возврат ЮТКонтекст.КонтекстМодуля();
	
КонецФункции

#КонецОбласти
