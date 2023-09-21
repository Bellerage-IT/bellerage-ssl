//@skip-check doc-comment-type,doc-comment-return-section-type

// // Работа с регулярными выражениями из 1С
//
//MIT License
//
//Copyright (c) 2021 Центр прикладных разработок
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.
//
// URL:    https://github.com/cpr1c/RegEx1C_cfe
// Модуль реализован с помощью компоненты https://github.com/alexkmbk/RegEx1CAddin
#Область ПрограммныйИнтерфейс

// Возвращает текущую версию подсистемы
// 
// Возвращаемое значение:
// 	Строка - Версия подсистемы работы с регулярными выражениями
Функция ВерсияПодсистемы() Экспорт
	Возврат "1.2";
КонецФункции

// Возвращает объект компоненты работы с регулярными выражениями. Компонента должна быть предвариательно подключена.
// При неподключенной компоненте вызовется исключение
// 
// Возвращаемое значение:
// 	ВнешняяКомпонентаОбъект - Объект внешней компоненты работы с регулярными выражениями. 
Функция ОбъектКомпоненты() Экспорт
	Возврат Новый ("AddIn." + ИдентификаторКомпоненты() + ".RegEx");
КонецФункции

#Область СинхронныеМетоды

// Используются синхронные вызовы
// Возвращает объект компоненты работы с регулярными выражениями. При необходимости происходит подключение и установка компоненты
// 
// Возвращаемое значение:
// 	ВнешняяКомпонентаОбъект - Объект внешней компоненты работы с регулярными выражениями 
//  Неопределено - если не удалось подключить компоненту
Функция КомпонентаРаботыСРегулярнымиВыражениями() Экспорт
	Попытка
		Компонента= ПроинициализироватьКомпоненту(Истина);
		Компонента.ВызыватьИсключения=Истина;

		Возврат Компонента;
	Исключение
		ТекстОшибки = НСтр("ru = 'Не удалось подключить внешнюю компоненту для работы с регулярными выражениями: '");
		Сообщить(ТекстОшибки + ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат Неопределено;
	КонецПопытки;
КонецФункции


// Возвращает версию компоненты работы с регулярными выражениями
// 
// Параметры:
// 	ОбъектКомпоненты - ВнешняяКомпонентаОбъект - Объект внешней компоненты работы с регулярными выражениями (Необязательный)
// Возвращаемое значение:
// 	Строка - Версия используемой компоненты 
Функция ВерсияКомпоненты(ОбъектКомпоненты = Неопределено) Экспорт
	ОчищатьКомпоненту=ОбъектКомпоненты = Неопределено;

	ОбъектКомпоненты=ОбъектКомпонентыРегулярныхВыражений(ОбъектКомпоненты);

	Версия=ОбъектКомпоненты.Версия();

	Если ОчищатьКомпоненту Тогда
		ОбъектКомпоненты=Неопределено;
	КонецЕсли;

	Возврат Версия;
КонецФункции


// Описание
// Метод выполняет поиск в переданном тексте по переданному регулярному выражению
// Параметры:
// 	СтрокаДляАнализа - Строка - Строка в которой необходимо выполнить поиск по регуляному выражению
// 	РегулярноеВыражение - Строка - Регулярное вырашение для выполнения поиска
// 	ИерархическийОбходРезультатов - Булево - Если установлено в Истина, то будет выполнен поиск с учетом подгрупп, в противном случае будет выведено единым списком(Необязательный)
// 	ВсеСовпадения - Булево - Если установлено в Истина, то поиск будет выполняться по всем совпадениям, а не только по первому.(Необязательный)
// 	ИгнорироватьРегистр - Булево - Если установлено в Истина, то поиск будет осуществляться без учета регистра (Необязательный)
// 	ОбъектКомпоненты - ВнешняяКомпонентаОбъект - Объект внешней компоненты работы с регулярными выражениями (Необязательный)
// Возвращаемое значение:
// 	Соответствие - 	В ключах соответствия находятся найденные совпадения. 
//    				В значениях ключей массив, содержащий найденные подгруппы, если выполняется иерархический поиск, и неопределено, если поиск неиерархический.
Функция НайтиСовпадения(СтрокаДляАнализа, РегулярноеВыражение, ИерархическийОбходРезультатов = Ложь,
	ВсеСовпадения = Ложь, ИгнорироватьРегистр = Ложь, ОбъектКомпоненты = Неопределено) Экспорт

	ОчищатьКомпоненту=ОбъектКомпоненты = Неопределено;

	ОбъектКомпоненты=ОбъектКомпонентыРегулярныхВыражений(ОбъектКомпоненты);
	ОбъектКомпоненты.ВсеСовпадения=ВсеСовпадения;
	ОбъектКомпоненты.ИгнорироватьРегистр=ИгнорироватьРегистр;

	Совпадения=Новый Соответствие;

	ОбъектКомпоненты.НайтиСовпадения(СтрокаДляАнализа, РегулярноеВыражение, ИерархическийОбходРезультатов);

	Пока ОбъектКомпоненты.Следующий() Цикл
		Подгруппы=Неопределено;
		Если ИерархическийОбходРезультатов Тогда
			Подгруппы=Новый Массив;

			КоличествоГрупп=ОбъектКомпоненты.КоличествоВложенныхГрупп();

			Для НомерГруппы = 0 По КоличествоГрупп - 1 Цикл
				Подгруппы.Добавить(ОбъектКомпоненты.ПолучитьПодгруппу(НомерГруппы));
			КонецЦикла;
		КонецЕсли;

		Совпадения.Вставить(ОбъектКомпоненты.ТекущееЗначение, Подгруппы);
	КонецЦикла;

	Если ОчищатьКомпоненту Тогда
		ОбъектКомпоненты=Неопределено;
	КонецЕсли;

	Возврат Совпадения;
КонецФункции

// Описание
// Возвращает количество результатов поиска
// Параметры:
// 	СтрокаДляАнализа - Строка - Строка в которой необходимо выполнить поиск по регуляному выражению
// 	РегулярноеВыражение - Строка - Регулярное вырашение для выполнения поиска
// 	ВсеСовпадения - Булево - Если установлено в Истина, то поиск будет выполняться по всем совпадениям, а не только по первому.(Необязательный)
// 	ИгнорироватьРегистр - Булево - сли установлено в Истина, то поиск будет осуществляться без учета регистра (Необязательный)
// 	ОбъектКомпоненты - ВнешняяКомпонентаОбъект - Объект внешней компоненты работы с регулярными выражениями (Необязательный)
// Возвращаемое значение:
// 	Число - Количество совпадений
Функция КоличествоСовпадений(СтрокаДляАнализа, РегулярноеВыражение, ВсеСовпадения = Ложь, ИгнорироватьРегистр = Ложь,
	ОбъектКомпоненты = Неопределено) Экспорт
	ОчищатьКомпоненту=ОбъектКомпоненты = Неопределено;

	ОбъектКомпоненты=ОбъектКомпонентыРегулярныхВыражений(ОбъектКомпоненты);
	ОбъектКомпоненты.ВсеСовпадения=ВсеСовпадения;
	ОбъектКомпоненты.ИгнорироватьРегистр=ИгнорироватьРегистр;

	ОбъектКомпоненты.НайтиСовпадения(СтрокаДляАнализа, РегулярноеВыражение);

	КоличествоСовпадений=ОбъектКомпоненты.Количество();

	Если ОчищатьКомпоненту Тогда
		ОбъектКомпоненты=Неопределено;
	КонецЕсли;

	Возврат КоличествоСовпадений;
КонецФункции

// Описание
// Возвращает ошибку, зафиксированную компонентой
// Параметры:
// 	ОбъектКомпоненты
// Возвращаемое значение:
// 	Строка - Описание ошибки, зафиксированной компонентой
Функция ОписаниеОшибкиКомпоненты(ОбъектКомпоненты) Экспорт
	Возврат ОбъектКомпоненты.ОписаниеОшибки;
КонецФункции

// Описание
// Делает проверку на соответствие текста регулярному выражению.
// Параметры:
// 	СтрокаДляАнализа - Строка - Строка в которой необходимо выполнить поиск по регуляному выражению
// 	РегулярноеВыражение - Строка - Регулярное вырашение для выполнения поиска
// 	ВсеСовпадения - Булево - Если установлено в Истина, то поиск будет выполняться по всем совпадениям, а не только по первому.(Необязательный)
// 	ИгнорироватьРегистр - Булево - Если установлено в Истина, то поиск будет осуществляться без учета регистра (Необязательный)
// 	ОбъектКомпоненты - ВнешняяКомпонентаОбъект - Объект внешней компоненты работы с регулярными выражениями (Необязательный)
// Возвращаемое значение:
// Булево -	Возвращает значение Истина если текст соответствует регулярному выражению.
Функция Совпадает(СтрокаДляАнализа, РегулярноеВыражение, ВсеСовпадения = Ложь, ИгнорироватьРегистр = Ложь,
	ОбъектКомпоненты = Неопределено) Экспорт
	ОчищатьКомпоненту=ОбъектКомпоненты = Неопределено;

	ОбъектКомпоненты=ОбъектКомпонентыРегулярныхВыражений(ОбъектКомпоненты);
	ОбъектКомпоненты.ВсеСовпадения=ВсеСовпадения;
	ОбъектКомпоненты.ИгнорироватьРегистр=ИгнорироватьРегистр;

	Совпадает= ОбъектКомпоненты.Совпадает(СтрокаДляАнализа, РегулярноеВыражение);

	Если ОчищатьКомпоненту Тогда
		ОбъектКомпоненты=Неопределено;
	КонецЕсли;

	Возврат Совпадает;

КонецФункции

// Описание
// 	Заменяет в переданном тексте часть, соответствующую регулярному выражению
// Параметры:
// 	СтрокаДляАнализа - Строка - Строка в которой необходимо выполнить поиск по регуляному выражению
// 	РегулярноеВыражение - Строка - Регулярное вырашение для выполнения поиска
// 	ЗначениеДляЗамены - Строка - Строка, на которую необходимо заменить найденные совпадения
// 	ВсеСовпадения - Булево - Если установлено в Истина, то поиск будет выполняться по всем совпадениям, а не только по первому.(Необязательный)
// 	ИгнорироватьРегистр - Булево - Если установлено в Истина, то поиск будет осуществляться без учета регистра (Необязательный)
// 	ОбъектКомпоненты - ВнешняяКомпонентаОбъект - Объект внешней компоненты работы с регулярными выражениями (Необязательный)
// Возвращаемое значение:
// 	Строка - результат замены.
Функция Заменить(СтрокаДляАнализа, РегулярноеВыражение, ЗначениеДляЗамены, ВсеСовпадения = Ложь,
	ИгнорироватьРегистр = Ложь, ОбъектКомпоненты = Неопределено) Экспорт
	ОчищатьКомпоненту=ОбъектКомпоненты = Неопределено;

	ОбъектКомпоненты=ОбъектКомпонентыРегулярныхВыражений(ОбъектКомпоненты);
	ОбъектКомпоненты.ВсеСовпадения=ВсеСовпадения;
	ОбъектКомпоненты.ИгнорироватьРегистр=ИгнорироватьРегистр;

	Результат= ОбъектКомпоненты.Заменить(СтрокаДляАнализа, РегулярноеВыражение, ЗначениеДляЗамены);

	Если ОчищатьКомпоненту Тогда
		ОбъектКомпоненты=Неопределено;
	КонецЕсли;

	Возврат Результат;
КонецФункции
#КонецОбласти

#Если Клиент Тогда
#Область АсинхронныеМетоды

// Начинает получение объекта внешней компоненты работы с регулярными выражениями. При необходимости будет произведено подключение и установка компоненты
// 
// Параметры:
// 	ОписаниеОповещения - ОписаниеОповещения - Содержит описание процедуры, которая будет вызвана после завершения со следующими параметрами:
//<ОбъектКомпоненты> – Объект компоненты работы с регулярными выражениями, Тип: ВнешняяКомпонентаОбъект. Неопределено- если не удалось подключить компоненту
//<ДополнительныеПараметры> - значение, которое было указано при создании объекта ОписаниеОповещения.
Процедура НачатьПолучениеКомпоненты(ОписаниеОповещения) Экспорт
	НачатьИнициализациюКомпоненты(ОписаниеОповещения, Истина);
КонецПроцедуры

// Начинает получение версии используемой компоненты работы с регулярными выражениями
// 
// Параметры:
// 	ОписаниеОповещения - ОписаниеОповещения - Содержит описание процедуры, которая будет вызвана после завершения со следующими параметрами:
//	<ВерсияКомпоненты> – Версия используемой компоненты, Тип: Строка. Неопределено- если не удалось подключить компоненту
//	<Параметры> - Параметры вызова метода компоненты.
//	<ДополнительныеПараметры> - значение, которое было указано при создании объекта ОписаниеОповещения.
// 	ОбъектКомпоненты - ВнешняяКомпонентаОбъект - Объект компоненты работы с регулярными выражениями (Необязательный)
Процедура НачатьПолучениеВерсииКомпоненты(ОписаниеОповещения, ОбъектКомпоненты = Неопределено) Экспорт
	Если ОбъектКомпоненты = Неопределено Тогда
		ДопПараметры=Новый Структура;
		ДопПараметры.Вставить("ОписаниеОповещенияОЗавершении", ОписаниеОповещения);

		НачатьПолучениеКомпоненты(
			Новый ОписаниеОповещения("НачатьПолучениеВерсииКомпонентыЗавершениеПолученияКомпоненты", ЭтотОбъект,
			ДопПараметры));
	Иначе
		ОбъектКомпоненты.НачатьВызовВерсия(ОписаниеОповещения);
	КонецЕсли;
КонецПроцедуры

// Описание
// 	начинает поиск в переданном тексте по переданному регулярному выражению
// Параметры:
// 	ОписаниеОповещения - ОписаниеОповещения - Содержит описание процедуры, которая будет вызвана после завершения со следующими параметрами:
//	<НайденныеСоответствия> – Соответствие - В ключах соответствия находятся найденные совпадения. 
//    				В значениях ключей массив, содержащий найденные подгруппы, если выполняется иерархический поиск, и неопределено, если поиск неиерархический.
//	<ДополнительныеПараметры> - значение, которое было указано при создании объекта ОписаниеОповещения.
// 	СтрокаДляАнализа - Строка - Строка в которой необходимо выполнить поиск по регуляному выражению
// 	РегулярноеВыражение - Строка - Регулярное вырашение для выполнения поиска
// 	ИерархическийОбходРезультатов - Булево - Если установлено в Истина, то будет выполнен поиск с учетом подгрупп, в противном случае будет выведено единым списком(Необязательный)
// 	ВсеСовпадения - Булево - Если установлено в Истина, то поиск будет выполняться по всем совпадениям, а не только по первому.(Необязательный)
// 	ИгнорироватьРегистр - Булево - Если установлено в Истина, то поиск будет осуществляться без учета регистра (Необязательный)
// 	ОбъектКомпоненты - ВнешняяКомпонентаОбъект - Объект внешней компоненты работы с регулярными выражениями (Необязательный)
Процедура НачатьНахождениеСовпадений(ОписаниеОповещения, СтрокаДляАнализа, РегулярноеВыражение,
	ИерархическийОбходРезультатов = Ложь, ВсеСовпадения = Ложь, ИгнорироватьРегистр = Ложь,
	ОбъектКомпоненты = Неопределено) Экспорт

	ДопПараметры=Новый Структура;
	ДопПараметры.Вставить("ОписаниеОповещенияОЗавершении", ОписаниеОповещения);
	ДопПараметры.Вставить("СтрокаДляАнализа", СтрокаДляАнализа);
	ДопПараметры.Вставить("РегулярноеВыражение", РегулярноеВыражение);
	ДопПараметры.Вставить("ИерархическийОбходРезультатов", ИерархическийОбходРезультатов);
	ДопПараметры.Вставить("ВсеСовпадения", ВсеСовпадения);
	ДопПараметры.Вставить("ИгнорироватьРегистр", ИгнорироватьРегистр);

	Если ОбъектКомпоненты = Неопределено Тогда
		НачатьПолучениеКомпоненты(
			Новый ОписаниеОповещения("НачатьНахождениеСовпаденийЗавершениеПолученияКомпоненты", ЭтотОбъект,
			ДопПараметры));
	Иначе
		НачатьУстановкуСвойствКомпоненты(ВсеСовпадения, ИгнорироватьРегистр, ОбъектКомпоненты, ОписаниеОповещения,
			Новый ОписаниеОповещения("НачатьНахождениеСовпаденийЗавершениеУстановкиСвойств", ЭтотОбъект, ДопПараметры));
	КонецЕсли;
КонецПроцедуры

// Описание
// 	Начинает получение количество совпадений в строке по регулярному выражению
// Параметры:
// 	ОписаниеОповещения - ОписаниеОповещения - Содержит описание процедуры, которая будет вызвана после завершения со следующими параметрами:
//	<Количество совпадений> – Число - Количество совпадений в строке регулярному выражению
//	<Параметры> - Массив - Массив параметров вызова метода компоненты.
//	<ДополнительныеПараметры> - значение, которое было указано при создании объекта ОписаниеОповещения.
// 	СтрокаДляАнализа - Строка - Строка в которой необходимо выполнить поиск по регуляному выражению
// 	РегулярноеВыражение - Строка - Регулярное вырашение для выполнения поиска
// 	ВсеСовпадения - Булево - Если установлено в Истина, то поиск будет выполняться по всем совпадениям, а не только по первому.(Необязательный)
// 	ИгнорироватьРегистр - Булево - Если установлено в Истина, то поиск будет осуществляться без учета регистра (Необязательный)
// 	ИерархическийОбходРезультатов - Булево - Если установлено в Истина, то будет выполнен поиск с учетом подгрупп, в противном случае будет выведено единым списком(Необязательный)
// 	ОбъектКомпоненты - ВнешняяКомпонентаОбъект - Объект внешней компоненты работы с регулярными выражениями (Необязательный)
Процедура НачатьПолучениеКоличестваСовпадений(ОписаниеОповещения, СтрокаДляАнализа, РегулярноеВыражение,
	ВсеСовпадения = Ложь, ИгнорироватьРегистр = Ложь, ИерархическийОбходРезультатов = Ложь,
	ОбъектКомпоненты = Неопределено) Экспорт

	ДопПараметры=Новый Структура;
	ДопПараметры.Вставить("ОписаниеОповещенияОЗавершении", ОписаниеОповещения);
	ДопПараметры.Вставить("СтрокаДляАнализа", СтрокаДляАнализа);
	ДопПараметры.Вставить("РегулярноеВыражение", РегулярноеВыражение);
	ДопПараметры.Вставить("ИерархическийОбходРезультатов", ИерархическийОбходРезультатов);
	ДопПараметры.Вставить("ВсеСовпадения", ВсеСовпадения);
	ДопПараметры.Вставить("ИгнорироватьРегистр", ИгнорироватьРегистр);

	Если ОбъектКомпоненты = Неопределено Тогда
		НачатьПолучениеКомпоненты(
			Новый ОписаниеОповещения("НачатьПолучениеКоличестваСовпаденийЗавершениеПолученияКомпоненты", ЭтотОбъект,
			ДопПараметры));
	Иначе
		НачатьУстановкуСвойствКомпоненты(ВсеСовпадения, ИгнорироватьРегистр, ОбъектКомпоненты, ОписаниеОповещения,
			Новый ОписаниеОповещения("НачатьПолучениеКоличестваЗавершениеУстановкиСвойств", ЭтотОбъект, ДопПараметры));
	КонецЕсли;
КонецПроцедуры

// Описание
// 	Начинает получение ошибки при выполнении метода компоненты
// Параметры:
// 	ОписаниеОповещения - ОписаниеОповещения - Содержит описание процедуры, которая будет вызвана после завершения со следующими параметрами:
//	<ОписаниеОшибки> – Строка - Ошибка зафиксированная компонентой
//	<Параметры> - Массив - Массив параметров вызова метода компоненты.
//	<ДополнительныеПараметры> - значение, которое было указано при создании объекта ОписаниеОповещения.
// 	ОбъектКомпоненты - ВнешняяКомпонентаОбъект - Объект внешней компоненты работы с регулярными выражениями (Необязательный)
Процедура НачатьПолучениеОписанияОшибкиКомпоненты(ОписаниеОповещения, ОбъектКомпоненты) Экспорт
	ОбъектКомпоненты.НачатьПолучениеОписаниеОшибки(ОписаниеОповещения);
КонецПроцедуры

// Описание
// Начинает выполнение проверки на соответствие текста регулярному выражению.
// Параметры:
// 	ОписаниеОповещения - ОписаниеОповещения - Содержит описание процедуры, которая будет вызвана после завершения со следующими параметрами:
//	<Соответствует> – Булево - Признак соответствия строки регулярному выражению
//	<Параметры> - Массив - Массив параметров вызова метода компоненты.
//	<ДополнительныеПараметры> - значение, которое было указано при создании объекта ОписаниеОповещения.
// 	СтрокаДляАнализа - Строка - Строка в которой необходимо выполнить поиск по регуляному выражению
// 	РегулярноеВыражение - Строка - Регулярное вырашение для выполнения поиска
// 	ВсеСовпадения - Булево - Если установлено в Истина, то поиск будет выполняться по всем совпадениям, а не только по первому.(Необязательный)
// 	ИгнорироватьРегистр - Булево - Если установлено в Истина, то поиск будет осуществляться без учета регистра (Необязательный)
// 	ОбъектКомпоненты - ВнешняяКомпонентаОбъект - Объект внешней компоненты работы с регулярными выражениями (Необязательный)
Процедура НачатьПолучениеПризнакаСовпадает(ОписаниеОповещения, СтрокаДляАнализа, РегулярноеВыражение,
	ВсеСовпадения = Ложь, ИгнорироватьРегистр = Ложь, ОбъектКомпоненты = Неопределено) Экспорт

	ДопПараметры=Новый Структура;
	ДопПараметры.Вставить("ОписаниеОповещенияОЗавершении", ОписаниеОповещения);
	ДопПараметры.Вставить("СтрокаДляАнализа", СтрокаДляАнализа);
	ДопПараметры.Вставить("РегулярноеВыражение", РегулярноеВыражение);
	ДопПараметры.Вставить("ВсеСовпадения", ВсеСовпадения);
	ДопПараметры.Вставить("ИгнорироватьРегистр", ИгнорироватьРегистр);

	Если ОбъектКомпоненты = Неопределено Тогда
		НачатьПолучениеКомпоненты(
			Новый ОписаниеОповещения("НачатьПолучениеПризнакаСовпадаетЗавершениеПолученияКомпоненты", ЭтотОбъект,
			ДопПараметры));
	Иначе
		НачатьУстановкуСвойствКомпоненты(ВсеСовпадения, ИгнорироватьРегистр, ОбъектКомпоненты, ОписаниеОповещения,
			Новый ОписаниеОповещения("НачатьПолучениеПризнакаСовпадаетЗавершениеУстановкиСвойств", ЭтотОбъект,
			ДопПараметры));
	КонецЕсли;
КонецПроцедуры

// Описание
// Начинает выполнение замены в переданном тексте часть, соответствующую регулярному выражению
// Параметры:
// 	ОписаниеОповещения - ОписаниеОповещения - Содержит описание процедуры, которая будет вызвана после завершения со следующими параметрами:
//	<РезультатЗамены> – Строка - Строка, получившаяся в результате замены
//	<Параметры> - Массив - Массив параметров вызова метода компоненты.
//	<ДополнительныеПараметры> - значение, которое было указано при создании объекта ОписаниеОповещения.
// 	СтрокаДляАнализа - Строка - Строка в которой необходимо выполнить поиск по регуляному выражению
// 	РегулярноеВыражение - Строка - Регулярное вырашение для выполнения поиска
// 	ЗначениеДляЗамены - Строка - Строка, на которую необходимо заменить найденные совпадения
// 	ВсеСовпадения - Булево - Если установлено в Истина, то поиск будет выполняться по всем совпадениям, а не только по первому.(Необязательный)
// 	ИгнорироватьРегистр - Булево - Если установлено в Истина, то поиск будет осуществляться без учета регистра (Необязательный)
// 	ОбъектКомпоненты - ВнешняяКомпонентаОбъект - Объект внешней компоненты работы с регулярными выражениями (Необязательный)
Процедура НачатьЗамену(ОписаниеОповещения, СтрокаДляАнализа, РегулярноеВыражение, ЗначениеДляЗамены,
	ВсеСовпадения = Ложь, ИгнорироватьРегистр = Ложь, ОбъектКомпоненты = Неопределено) Экспорт

	ДопПараметры=Новый Структура;
	ДопПараметры.Вставить("ОписаниеОповещенияОЗавершении", ОписаниеОповещения);
	ДопПараметры.Вставить("СтрокаДляАнализа", СтрокаДляАнализа);
	ДопПараметры.Вставить("РегулярноеВыражение", РегулярноеВыражение);
	ДопПараметры.Вставить("ЗначениеДляЗамены", ЗначениеДляЗамены);
	ДопПараметры.Вставить("ВсеСовпадения", ВсеСовпадения);
	ДопПараметры.Вставить("ИгнорироватьРегистр", ИгнорироватьРегистр);

	Если ОбъектКомпоненты = Неопределено Тогда
		НачатьПолучениеКомпоненты(
			Новый ОписаниеОповещения("НачатьЗаменуЗавершениеПолученияКомпоненты", ЭтотОбъект, ДопПараметры));
	Иначе
		НачатьУстановкуСвойствКомпоненты(ВсеСовпадения, ИгнорироватьРегистр, ОбъектКомпоненты, ОписаниеОповещения,
			Новый ОписаниеОповещения("НачатьЗаменуЗавершениеУстановкиСвойств", ЭтотОбъект, ДопПараметры));
	КонецЕсли;
КонецПроцедуры
#КонецОбласти
#КонецЕсли

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Если Клиент Тогда

Процедура НачатьИнициализациюКомпоненты(ОписаниеОповещения, ПопытатьсяУстановитьКомпоненту = Истина) Экспорт

	ДополнительныеПараметрыОповещения=Новый Структура;
	ДополнительныеПараметрыОповещения.Вставить("ОповещениеОЗавершении", ОписаниеОповещения);
	ДополнительныеПараметрыОповещения.Вставить("ПопытатьсяУстановитьКомпоненту", ПопытатьсяУстановитьКомпоненту);

	НачатьПодключениеВнешнейКомпоненты(
		Новый ОписаниеОповещения("НачатьПолучениеКомпонентыЗавершениеПодключенияКомпоненты", ЭтотОбъект,
		ДополнительныеПараметрыОповещения), ИмяМакетаКомпоненты(), ИдентификаторКомпоненты(),
		ТипВнешнейКомпоненты.Native);

КонецПроцедуры

Процедура НачатьПолучениеКомпонентыЗавершениеПодключенияКомпоненты(Подключено, ДополнительныеПараметры) Экспорт
	Если Подключено Тогда
		ОповещениеОЗавершении=ДополнительныеПараметры.ОповещениеОЗавершении;
		ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, ОбъектКомпоненты());
	ИначеЕсли ДополнительныеПараметры.ПопытатьсяУстановитьКомпоненту Тогда
		НачатьУстановкуВнешнейКомпоненты(
			Новый ОписаниеОповещения("НачатьПолучениеКомпонентыЗавершениеУстановкиКомпоненты", ЭтотОбъект,
			ДополнительныеПараметры), ИмяМакетаКомпоненты());
	Иначе
		ОповещениеОЗавершении=ДополнительныеПараметры.ОповещениеОЗавершении;
		ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, Неопределено);
	КонецЕсли;
КонецПроцедуры

Процедура НачатьПолучениеКомпонентыЗавершениеУстановкиКомпоненты(ДополнительныеПараметры) Экспорт
	НачатьИнициализациюКомпоненты(ДополнительныеПараметры.ОповещениеОЗавершении, Ложь);
КонецПроцедуры

Процедура НачатьПолучениеВерсииКомпонентыЗавершениеПолученияКомпоненты(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияОЗавершении, Неопределено);
	Иначе
		НачатьПолучениеВерсииКомпоненты(ДополнительныеПараметры.ОписаниеОповещенияОЗавершении, Результат);
	КонецЕсли;
КонецПроцедуры

Процедура НачатьУстановкуСвойстваВсеСовпаденияЗавершение(ДополнительныеПараметры) Экспорт
	НачатьУстановкуСвойстваИгнорироватьРегистр(ДополнительныеПараметры.ИгнорироватьРегистр,
		ДополнительныеПараметры.ОбъектКомпоненты,
		Новый ОписаниеОповещения("НачатьУстановкуСвойствКомпонентыЗавершение", ЭтотОбъект, ДополнительныеПараметры));
КонецПроцедуры

Процедура НачатьУстановкуСвойствКомпонентыЗавершение(ДополнительныеПараметры) Экспорт
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияОЗавершенииУстановкиСвойств,
		ДополнительныеПараметры.ОбъектКомпоненты);
КонецПроцедуры

Процедура НачатьНахождениеСовпаденийЗавершениеУстановкиСвойств(ОбъектКомпоненты, ДополнительныеПараметры) Экспорт
	ДополнительныеПараметры.Вставить("ОбъектКомпоненты", ОбъектКомпоненты);
	ОбъектКомпоненты.НачатьВызовНайтиСовпадения(
		Новый ОписаниеОповещения("НачатьНахождениеСовпаденийЗавершениеВызоваНайтиСовпадения", ЭтотОбъект,
		ДополнительныеПараметры), ДополнительныеПараметры.СтрокаДляАнализа, ДополнительныеПараметры.РегулярноеВыражение,
		ДополнительныеПараметры.ИерархическийОбходРезультатов);

КонецПроцедуры

Процедура НачатьНахождениеСовпаденийЗавершениеПолученияКомпоненты(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияОЗавершении, Неопределено);
	Иначе
		НачатьНахождениеСовпадений(ДополнительныеПараметры.ОписаниеОповещенияОЗавершении,
			ДополнительныеПараметры.СтрокаДляАнализа, ДополнительныеПараметры.РегулярноеВыражение,
			ДополнительныеПараметры.ИерархическийОбходРезультатов, ДополнительныеПараметры.ВсеСовпадения,
			ДополнительныеПараметры.ИгнорироватьРегистр, Результат);
	КонецЕсли;
КонецПроцедуры

Процедура НачатьНахождениеСовпаденийЗавершениеВызоваНайтиСовпадения(РезультатВызова, Параметры,
	ДополнительныеПараметры) Экспорт

	ДополнительныеПараметры.Вставить("Совпадения", Новый Соответствие);
	НачатьНахождениеСовпаденийВызовСледующейЗаписи(ДополнительныеПараметры);
КонецПроцедуры

Процедура НачатьНахождениеСовпаденийВызовСледующейЗаписи(ДополнительныеПараметры)
	ДополнительныеПараметры.ОбъектКомпоненты.НачатьВызовСледующий(
		Новый ОписаниеОповещения("НачатьНахождениеСовпаденийЗавершениеВызоваСледующейЗаписи", ЭтотОбъект,
		ДополнительныеПараметры));
КонецПроцедуры

Процедура НачатьНахождениеСовпаденийЗавершениеВызоваСледующейЗаписи(Результат, Параметры, ДополнительныеПараметры) Экспорт
	Если Не Результат Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияОЗавершении,
			ДополнительныеПараметры.Совпадения);
		Возврат;
	КонецЕсли;

	ДополнительныеПараметры.ОбъектКомпоненты.НачатьПолучениеТекущееЗначение(
		Новый ОписаниеОповещения("НачатьНахождениеСовпаденийЗавершениеПолученияТекущегоЗначения", ЭтотОбъект,
		ДополнительныеПараметры));
КонецПроцедуры

Процедура НачатьНахождениеСовпаденийЗавершениеПолученияТекущегоЗначения(Результат, ДополнительныеПараметры) Экспорт
	Если ДополнительныеПараметры.ИерархическийОбходРезультатов Тогда
		Подгруппы=Новый Массив;
		ДополнительныеПараметры.Совпадения.Вставить(Результат, Подгруппы);
		НачатьНахождениеСовпаденийНачалоПолученияПодгрупп(Подгруппы, ДополнительныеПараметры);
	Иначе
		ДополнительныеПараметры.Совпадения.Вставить(Результат, Неопределено);
		НачатьНахождениеСовпаденийВызовСледующейЗаписи(ДополнительныеПараметры);
	КонецЕсли;
КонецПроцедуры

Процедура НачатьНахождениеСовпаденийНачалоПолученияПодгрупп(Подгруппы, ДополнительныеПараметры)

	ДопПараметры=Новый Структура;
	ДопПараметры.Вставить("Подгруппы", Подгруппы);
	ДопПараметры.Вставить("ОбъектКомпоненты", ДополнительныеПараметры.ОбъектКомпоненты);
	ДопПараметры.Вставить("ОписаниеОповещенияОЗавершении",
		Новый ОписаниеОповещения("НачатьНахождениеСовпаденийЗавершениеПолученияПодгрупп", ЭтотОбъект,
		ДополнительныеПараметры));

	ДополнительныеПараметры.ОбъектКомпоненты.НачатьВызовКоличествоВложенныхГрупп(
		Новый ОписаниеОповещения("НачатьНахождениеСовпаденийЗавершениеПолученияКоличестваПодгрупп", ЭтотОбъект,
		ДопПараметры));
КонецПроцедуры

Процедура НачатьНахождениеСовпаденийЗавершениеПолученияКоличестваПодгрупп(Результат, Параметры,
	ДополнительныеПараметры) Экспорт

	ДопПараметры=Новый Структура;
	ДопПараметры.Вставить("Подгруппы", ДополнительныеПараметры.Подгруппы);
	ДопПараметры.Вставить("КоличествоПодгрупп", Результат);
	ДопПараметры.Вставить("ТекущаяПодгруппа", 0);
	ДопПараметры.Вставить("ОбъектКомпоненты", ДополнительныеПараметры.ОбъектКомпоненты);
	ДопПараметры.Вставить("ОписаниеОповещенияОЗавершении", ДополнительныеПараметры.ОписаниеОповещенияОЗавершении);

	НачатьНахождениеСовпаденийНачатьПолучениеПодгруппы(ДопПараметры);
КонецПроцедуры

Процедура НачатьНахождениеСовпаденийНачатьПолучениеПодгруппы(ДополнительныеПараметры) Экспорт

	ДополнительныеПараметры.ОбъектКомпоненты.НачатьВызовПолучитьПодгруппу(
		Новый ОписаниеОповещения("НачатьНахождениеСовпаденийЗавершениеПолучениеПодгруппы", ЭтотОбъект,
		ДополнительныеПараметры), ДополнительныеПараметры.ТекущаяПодгруппа);

КонецПроцедуры

Процедура НачатьНахождениеСовпаденийЗавершениеПолучениеПодгруппы(Результат, Параметры, ДополнительныеПараметры) Экспорт

	ДополнительныеПараметры.ТекущаяПодгруппа=ДополнительныеПараметры.ТекущаяПодгруппа + 1;
	ДополнительныеПараметры.Подгруппы.Добавить(Результат);

	Если ДополнительныеПараметры.ТекущаяПодгруппа >= ДополнительныеПараметры.КоличествоПодгрупп Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияОЗавершении,
			ДополнительныеПараметры.Подгруппы);
	Иначе
		НачатьНахождениеСовпаденийНачатьПолучениеПодгруппы(ДополнительныеПараметры);
	КонецЕсли;
КонецПроцедуры

Процедура НачатьНахождениеСовпаденийЗавершениеПолученияПодгрупп(Результат, ДополнительныеПараметры) Экспорт
	НачатьНахождениеСовпаденийВызовСледующейЗаписи(ДополнительныеПараметры);
КонецПроцедуры

Процедура НачатьПолучениеКоличестваСовпаденийЗавершениеПолученияКомпоненты(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияОЗавершении, Неопределено);
	Иначе
		НачатьПолучениеКоличестваСовпадений(ДополнительныеПараметры.ОписаниеОповещенияОЗавершении,
			ДополнительныеПараметры.СтрокаДляАнализа, ДополнительныеПараметры.РегулярноеВыражение,
			ДополнительныеПараметры.ВсеСовпадения, ДополнительныеПараметры.ИгнорироватьРегистр,
			ДополнительныеПараметры.ИерархическийОбходРезультатов, Результат);
	КонецЕсли;
КонецПроцедуры

Процедура НачатьПолучениеКоличестваЗавершениеУстановкиСвойств(ОбъектКомпоненты, ДополнительныеПараметры) Экспорт
	ДополнительныеПараметры.Вставить("ОбъектКомпоненты", ОбъектКомпоненты);

	ОбъектКомпоненты.НачатьВызовНайтиСовпадения(
		Новый ОписаниеОповещения("НачатьПолучениеКоличестваЗавершениеВызоваНайтиСовпадения", ЭтотОбъект,
		ДополнительныеПараметры), ДополнительныеПараметры.СтрокаДляАнализа, ДополнительныеПараметры.РегулярноеВыражение,
		ДополнительныеПараметры.ИерархическийОбходРезультатов);
КонецПроцедуры

Процедура НачатьПолучениеКоличестваЗавершениеВызоваНайтиСовпадения(РезультатВызова, Параметры, ДополнительныеПараметры) Экспорт

	ДополнительныеПараметры.ОбъектКомпоненты.НачатьВызовКоличество(
		ДополнительныеПараметры.ОписаниеОповещенияОЗавершении);
КонецПроцедуры

Процедура НачатьПолучениеПризнакаСовпадаетЗавершениеПолученияКомпоненты(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияОЗавершении, Неопределено);
	Иначе
		НачатьПолучениеПризнакаСовпадает(ДополнительныеПараметры.ОписаниеОповещенияОЗавершении,
			ДополнительныеПараметры.СтрокаДляАнализа, ДополнительныеПараметры.РегулярноеВыражение,
			ДополнительныеПараметры.ВсеСовпадения, ДополнительныеПараметры.ИгнорироватьРегистр, Результат);
	КонецЕсли;
КонецПроцедуры

Процедура НачатьПолучениеПризнакаСовпадаетЗавершениеУстановкиСвойств(ОбъектКомпоненты, ДополнительныеПараметры) Экспорт
	ОбъектКомпоненты.НачатьВызовСовпадает(ДополнительныеПараметры.ОписаниеОповещенияОЗавершении,
		ДополнительныеПараметры.СтрокаДляАнализа, ДополнительныеПараметры.РегулярноеВыражение);
КонецПроцедуры

Процедура НачатьЗаменуЗавершениеПолученияКомпоненты(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияОЗавершении, Неопределено);
	Иначе
		НачатьЗамену(ДополнительныеПараметры.ОписаниеОповещенияОЗавершении, ДополнительныеПараметры.СтрокаДляАнализа,
			ДополнительныеПараметры.РегулярноеВыражение, ДополнительныеПараметры.ЗначениеДляЗамены,
			ДополнительныеПараметры.ВсеСовпадения, ДополнительныеПараметры.ИгнорироватьРегистр, Результат);
	КонецЕсли;
КонецПроцедуры

Процедура НачатьЗаменуЗавершениеУстановкиСвойств(ОбъектКомпоненты, ДополнительныеПараметры) Экспорт
	ОбъектКомпоненты.НачатьВызовЗаменить(ДополнительныеПараметры.ОписаниеОповещенияОЗавершении,
		ДополнительныеПараметры.СтрокаДляАнализа, ДополнительныеПараметры.РегулярноеВыражение,
		ДополнительныеПараметры.ЗначениеДляЗамены);
КонецПроцедуры
#КонецЕсли

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИмяМакетаКомпоненты()
#Если ВебКлиент Тогда
	ИмяМакетаКомпоненты="ОбщийМакет.бф_RegExBrowsers";
#Иначе
		ИмяМакетаКомпоненты="ОбщийМакет.бф_RegEx";
#КонецЕсли

	Возврат ИмяМакетаКомпоненты;
КонецФункции

Функция ОбъектКомпонентыРегулярныхВыражений(ОбъектКомпоненты = Неопределено)
	Если ОбъектКомпоненты = Неопределено Тогда
		Возврат КомпонентаРаботыСРегулярнымиВыражениями();
	Иначе
		Возврат ОбъектКомпоненты;
	КонецЕсли;
КонецФункции

Функция ИдентификаторКомпоненты()
	Возврат "regex1c";
КонецФункции

Функция ПроинициализироватьКомпоненту(ПопытатьсяУстановитьКомпоненту = Истина)

	ИмяМакетаКомпоненты=ИмяМакетаКомпоненты();
	КодВозврата = ПодключитьВнешнююКомпоненту(ИмяМакетаКомпоненты, ИдентификаторКомпоненты(),
		ТипВнешнейКомпоненты.Native);

#Если Клиент Тогда
	Если Не КодВозврата Тогда

		Если Не ПопытатьсяУстановитьКомпоненту Тогда
			Возврат Ложь;
		КонецЕсли;

		УстановитьВнешнююКомпоненту(ИмяМакетаКомпоненты);

		Возврат ПроинициализироватьКомпоненту(Ложь); // Рекурсивно.

	КонецЕсли;
#КонецЕсли

	Возврат ОбъектКомпоненты();
КонецФункции

#Если Клиент Тогда

Процедура НачатьУстановкуСвойстваВсеСовпадения(Значение, ОбъектКомпоненты, ОписаниеОповещения)
	ОбъектКомпоненты.НачатьУстановкуВсеСовпадения(ОписаниеОповещения, Значение);
КонецПроцедуры

Процедура НачатьУстановкуСвойстваИгнорироватьРегистр(Значение, ОбъектКомпоненты, ОписаниеОповещения)
	ОбъектКомпоненты.НачатьУстановкуИгнорироватьРегистр(ОписаниеОповещения, Значение);
КонецПроцедуры

Процедура НачатьУстановкуСвойствКомпоненты(ВсеСовпадения, ИгнорироватьРегистр, ОбъектКомпоненты,
	ОписаниеОповещенияОЗавершении, ОписаниеОповещенияОЗавершенииУстановкиСвойств)
	ДополнительныеПараметры=Новый Структура;
	ДополнительныеПараметры.Вставить("ОбъектКомпоненты", ОбъектКомпоненты);
	ДополнительныеПараметры.Вставить("ОписаниеОповещенияОЗавершении", ОписаниеОповещенияОЗавершении);
	ДополнительныеПараметры.Вставить("ОписаниеОповещенияОЗавершенииУстановкиСвойств",
		ОписаниеОповещенияОЗавершенииУстановкиСвойств);
	ДополнительныеПараметры.Вставить("ИгнорироватьРегистр", ИгнорироватьРегистр);

	НачатьУстановкуСвойстваВсеСовпадения(ВсеСовпадения, ОбъектКомпоненты,
		Новый ОписаниеОповещения("НачатьУстановкуСвойстваВсеСовпаденияЗавершение", ЭтотОбъект, ДополнительныеПараметры));
КонецПроцедуры

#КонецЕсли

#КонецОбласти